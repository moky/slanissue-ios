//
//  S9Image+GIF.m
//  SlanissueToolkit
//
//  Created by Moky on 15-10-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "S9Array.h"
#import "S9Client.h"
#import "S9Image+GIF.h"

CG_INLINE BOOL CGImageIsGIFData(NSData * imageData)
{
	if (imageData.length < 4) {
		return NO;
	}
	
	const char * buffer = (const char *)[imageData bytes];
	// GIF87a, GIF89a
	if (buffer[0] != 'G' ||
		buffer[1] != 'I' ||
		buffer[2] != 'F' ||
		buffer[3] != '8'/* ||
		(buffer[4] != '7' && buffer[4] != '9') ||
		buffer[5] != 'a'*/) {
		return NO;
	}
	return YES;
}

CG_INLINE CGFloat CGImageSourceGetFrameDuration(CGImageSourceRef source, NSUInteger index)
{
	float duration = 0.100f;
	
	CFDictionaryRef framePropertiesRef = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
	NSDictionary * frameProperties = (__bridge NSDictionary *)framePropertiesRef;
	NSDictionary * gifProperties = frameProperties[(__bridge NSString *)kCGImagePropertyGIFDictionary];
	
	NSNumber * delayTime = gifProperties[(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
	if (delayTime) {
		duration = [delayTime floatValue];
	} else {
		delayTime = gifProperties[(__bridge NSString *)kCGImagePropertyGIFDelayTime];
		if (delayTime) {
			duration = [delayTime floatValue];
		}
	}
	CFRelease(framePropertiesRef);
	
	// Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
	// We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
	// a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
	// for more information.
	return duration < 0.011f ? 0.100f : duration;
}

UIImage * UIImageWithGIFData(NSData * data, CGFloat scale)
{
	if (!CGImageIsGIFData(data)) {
		return nil;
	}
	
	// 1. create image source
	CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
	size_t frameCount = CGImageSourceGetCount(source);
	if (frameCount <= 1) {
		CFRelease(source);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
		CGFloat systemVersion = [[[S9Client getInstance] systemVersion] floatValue];
		if (systemVersion < 6.0f)
			return [UIImage imageWithData:data];
		else
#endif
			return [UIImage imageWithData:data scale:scale];
	}
	
	// 2. get each frames
	NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:frameCount];
	NSTimeInterval duration = 0.000f;
	
	UIImage * image;
	CGImageRef imageRef;
	for (size_t index = 0; index < frameCount; ++index) {
		duration += CGImageSourceGetFrameDuration(source, index);
		
		imageRef = CGImageSourceCreateImageAtIndex(source, index, NULL);
		image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		[mArray addObject:image];
		[image release];
		CGImageRelease(imageRef);
	}
	CFRelease(source);
	
	if (duration <= 0.011f) {
		duration = frameCount / 12.0f;
	}
	
	// 3. create image with frames
	image = [UIImage animatedImageWithImages:mArray duration:duration];
	[mArray release];
	
	return image;
}

NSData * UIImageGIFRepresentation(UIImage * image)
{
	// frames
	NSArray * frames = image.images;
	NSTimeInterval duration = image.duration;
	NSUInteger frameCount = [frames count];
	if (frameCount == 0) {
		frames = [NSArray arrayWithObject:image];
		frameCount = 1;
		duration = 60.0f;
	} else if (frameCount == 1) {
		duration = 60.0f;
	} else if (duration < 0.011f) {
		duration = frameCount / 12.0f;
	}
	
	NSMutableData * data = [NSMutableData data];
	
	// 1. create image destination
	CGImageDestinationRef destination;
	destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data,
												   kUTTypeGIF,
												   frameCount,
												   NULL);
	
	// 2. set file properties
	NSDictionary * fileProperties;
	fileProperties = @{
					   (__bridge id)kCGImagePropertyGIFDictionary: @{
							   (__bridge id)kCGImagePropertyGIFLoopCount: @(0), // loop forever
							   (__bridge id)kCGImagePropertyGIFHasGlobalColorMap: @(YES),
							   (__bridge id)kCGImagePropertyColorModel: (__bridge id)kCGImagePropertyColorModelRGB,
							   (__bridge id)kCGImagePropertyHasAlpha: @(YES),
							   (__bridge id)kCGImagePropertyDepth: @(8),
							   },
					   };
	CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
	
	// 3. add each frame
	NSDictionary * frameProperties;
	frameProperties = @{
						(__bridge id)kCGImagePropertyGIFDictionary: @{
								(__bridge id)kCGImagePropertyGIFDelayTime: @(duration / frameCount),
								},
						};
	S9_FOR_EACH(frames, image) {
		CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
	}
	
	// 4. finalize
	BOOL success = CGImageDestinationFinalize(destination);
	CFRelease(destination);
	
	return success ? data : nil;
}
