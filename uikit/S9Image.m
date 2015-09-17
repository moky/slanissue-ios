//
//  S9Image.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9MemoryCache.h"
#import "S9Client.h"
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

CIImage * CIImageWithQRCode(NSString * string)
{
	float sysVer = [[[S9Client getInstance] systemVersion] floatValue];
	if (sysVer < 7.0f) {
		return nil;
	}
	
	// Need to convert the string to a UTF-8 encoded NSData object
	NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
	// Create the filter
	CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	// Set the message content and error-correction level
	[filter setValue:data forKey:@"inputMessage"];
	[filter setValue:@"M" forKey:@"inputCorrectionLevel"];
	
	return filter.outputImage;
}

UIImage * UIImageWithQRCode(NSString * string, CGSize size)
{
	CIImage * ciImage = CIImageWithQRCode(string);
	if (!ciImage) {
		return nil;
	}
	
	CGRect extent = CGRectIntegral(ciImage.extent);
	CGFloat width = CGRectGetWidth(extent);
	CGFloat height = CGRectGetHeight(extent);
	if (width <= 0.0f || height <= 0.0f) {
		return nil;
	}
	
	CGFloat scale = MIN(size.width / width, size.height / height);
	width *= scale;
	height *= scale;
	
	// create a bitmap image that we'll draw into a bitmap context at the desired size;
	CGContextRef ctx = CGBitmapContextCreate(nil, size.width, size.height, 8, 0,
											 CGColorSpaceCreateDeviceGray(),
											 (CGBitmapInfo)kCGImageAlphaNone);
	
	CIContext * context = [CIContext contextWithOptions:nil];
	CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
	
	CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
	CGContextTranslateCTM(ctx, (size.width - width) * 0.5f, (size.height - height) * 0.5f);
	CGContextScaleCTM(ctx, scale, scale);
	CGContextDrawImage(ctx, extent, bitmapImage);
	
	// Create an image with the contents of our bitmap
	CGImageRef scaledImage = CGBitmapContextCreateImage(ctx);
	UIImage * uiImage = [UIImage imageWithCGImage:scaledImage];
	
	// Cleanup
	CGImageRelease(scaledImage);
	CGImageRelease(bitmapImage);
	CGContextRelease(ctx);
	
	return uiImage;
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

@end

@implementation UIImage (QRCode)

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGSize)size
{
	return UIImageWithQRCode(string, size);
}

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGSize)size small:(UIImage *)icon
{
	UIImage * image = UIImageWithQRCode(string, size);
	if (!icon || !image) {
		return image;
	}
	
	// TODO: draw icon in the center of QRCode image
	
	return image;
}

- (NSString *) QRCode
{
	// TODO: implement me
	return nil;
}

@end
