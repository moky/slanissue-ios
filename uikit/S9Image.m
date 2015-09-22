//
//  S9Image.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9MemoryCache.h"
#import "S9Image.h"

CGImageRef CGImageCreateCopyWithImageInRect(CGImageRef imageRef, CGRect rect)
{
	// create
	imageRef = CGImageCreateWithImageInRect(imageRef, rect);
	UIImage * image = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	// draw
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height)];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// copy
	return CGImageRetain(image.CGImage);
}

CGContextRef CGBitmapContextCreateWithCGImage(CGImageRef imageRef, CGSize size)
{
	void * data = NULL;
	size_t width = size.width > 0.0f ? size.width : CGImageGetWidth(imageRef);
	size_t height = size.height > 0.0f ? size.height : CGImageGetHeight(imageRef);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
	size_t bytesPerRow = 0;//CGImageGetBytesPerRow(imageRef);
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	
	CGContextRef ctx = CGBitmapContextCreate(data, width, height,
											 bitsPerComponent, bytesPerRow,
											 colorSpace, bitmapInfo);
	CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
	return ctx;
}

UIImage * UIImageWithCIImage(CIImage * image, CGSize size, CGFloat scale)
{
	size = CGSizeMake(size.width * scale, size.height * scale);
	CGRect extent = CGRectIntegral(image.extent);
	CGFloat width = CGRectGetWidth(extent);
	CGFloat height = CGRectGetHeight(extent);
	CGFloat sx = width > 0.0f ? size.width / width : scale;
	CGFloat sy = height > 0.0f ? size.height / height : scale;
	
	CIContext * context = [CIContext contextWithOptions:nil];
	CGImageRef imageRef = [context createCGImage:image fromRect:extent];
	
	// create bitmap
	CGContextRef ctx = CGBitmapContextCreateWithCGImage(imageRef, size);
	CGContextScaleCTM(ctx, sx, sy);
	
	// draw
	CGContextDrawImage(ctx, extent, imageRef);
	CGImageRef scaledImage = CGBitmapContextCreateImage(ctx);
	UIImage * result = [UIImage imageWithCGImage:scaledImage
										   scale:scale
									 orientation:UIImageOrientationUp];
	
	// clean up
	CGImageRelease(scaledImage);
	CGContextRelease(ctx);
	CGImageRelease(imageRef);
	return result;
}

UIImage * UIImageWithName(NSString * name)
{
	if (!name) {
		S9Log(@"image name cannot be nil");
		return nil;
	}
	
	// 1. check memory cache
	S9MemoryCache * cache = [S9MemoryCache getInstance];
	UIImage * image = [cache objectForKey:name];
	if (image) {
		// got from cache
		return image;
	}
	
	// 2. create new image
	if ([name rangeOfString:@"/"].location == NSNotFound) {
		// get image from main bundle
		image = [UIImage imageNamed:name];
	} else if ([name rangeOfString:@"://"].location == NSNotFound || [name hasPrefix:@"file://"]) {
		// get image from local file
		image = [UIImage imageWithContentsOfFile:name];
	} else {
		// get image with data from remote server
		NSURL * url = [[NSURL alloc] initWithString:name];
		if (url) {
			NSData * data = [[NSData alloc] initWithContentsOfURL:url];
			if (data) {
				image = [UIImage imageWithData:data];
				[data release];
			}
			[url release];
		}
	}
	
	// 3. cache image
	[cache setObject:image forKey:name];
	return image;
}

@implementation UIImage (SlanissueToolkit)

- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
	NSData * data = nil;
	NSString * ext = [[path pathExtension] lowercaseString];
	if ([ext isEqualToString:@"png"]) {
		data = UIImagePNGRepresentation(self);
	} else if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]) {
		data = UIImageJPEGRepresentation(self, 1.0f);
	} else {
		NSAssert(false, @"unsupportd image format: %@", path);
		return NO;
	}
	return [data writeToFile:path atomically:useAuxiliaryFile];
}

- (UIImage *) imageWithImagesAndRects:(UIImage *)image1, ... NS_REQUIRES_NIL_TERMINATION
{
	UIImage * image = self;
	CGFloat scale = image.scale;
	CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width * scale, image.size.height * scale);
	CGImageRef imageRef = image.CGImage;
	
	// create bitmap
	CGContextRef ctx = CGBitmapContextCreateWithCGImage(imageRef, rect.size);
	
	// draw self
	CGContextDrawImage(ctx, rect, imageRef);
	
	// draw images
	va_list params;
	va_start(params, image1);
	while (image1) {
		CGRect rect1 = va_arg(params, CGRect);
		// scale
		rect1 = CGRectMake(rect1.origin.x * scale,
						   rect1.origin.y * scale,
						   rect1.size.width * scale,
						   rect1.size.height * scale);
		
		// coordinate system: GL => UI
		CGFloat tx = rect1.origin.x;
		CGFloat ty = rect.size.height - rect1.origin.y - rect1.size.height;
		CGFloat sx = rect1.size.width / rect.size.width;
		CGFloat sy = rect1.size.height / rect.size.height;
		
		CGAffineTransform atm = CGAffineTransformIdentity;
		atm = CGAffineTransformTranslate(atm, tx, ty);
		atm = CGAffineTransformScale(atm, sx, sy);
		
		CGContextConcatCTM(ctx, atm);
		CGContextDrawImage(ctx, rect, image1.CGImage);
		CGContextConcatCTM(ctx, CGAffineTransformInvert(atm));
		
		image1 = va_arg(params, UIImage *);
	}
	va_end(params);
	
	imageRef = CGBitmapContextCreateImage(ctx);
	image = [UIImage imageWithCGImage:imageRef
								scale:scale
						  orientation:UIImageOrientationUp];
	
	// clean up
	CGImageRelease(imageRef);
	CGContextRelease(ctx);
	return image;
}

@end
