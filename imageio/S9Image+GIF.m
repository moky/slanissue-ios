//
//  S9Image+GIF.m
//  SlanissueToolkit
//
//  Created by Moky on 15-10-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "S9Client.h"
#import "S9Image+GIF.h"

static CGFloat CGImageSourceGetFrameDuration(CGImageSourceRef source, NSUInteger index)
{
	float duration = 0.1f;
	
	CFDictionaryRef framePropertiesRef = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
	NSDictionary * frameProperties = (__bridge NSDictionary *)framePropertiesRef;
	NSDictionary * gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
	
	NSNumber * delayTime = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
	if (delayTime) {
		duration = [delayTime floatValue];
	} else {
		delayTime = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
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
	CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
	size_t count = CGImageSourceGetCount(source);
	if (count <= 1) {
		CFRelease(source);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
		CGFloat systemVersion = [[[S9Client getInstance] systemVersion] floatValue];
		if (systemVersion < 6.0f)
			return [UIImage imageWithData:data];
		else
#endif
			return [UIImage imageWithData:data scale:scale];
	}
	
	NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:count];
	NSTimeInterval duration = 0.0f;
	
	UIImage * image;
	CGImageRef imageRef;
	for (size_t index = 0; index < count; ++index) {
		duration += CGImageSourceGetFrameDuration(source, index);
		
		imageRef = CGImageSourceCreateImageAtIndex(source, index, NULL);
		image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		[array addObject:image];
		[image release];
		CGImageRelease(imageRef);
	}
	CFRelease(source);
	
	if (duration <= 0.0f) {
		duration = count / 12.0f;
	}
	
	image = [UIImage animatedImageWithImages:array duration:duration];
	[array release];
	
	return image;
}
