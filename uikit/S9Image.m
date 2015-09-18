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

CIImage * CIImageWithQRCode(NSString * text)
{
	NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
	CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	[filter setValue:data forKey:@"inputMessage"];
	[filter setValue:@"M" forKey:@"inputCorrectionLevel"];
	return filter.outputImage;
}

UIImage * UIImageWithQRCode(NSString * text, CGFloat size)
{
	CIImage * ciImage = CIImageWithQRCode(text);
	CGRect extent = CGRectIntegral(ciImage.extent);
	CGFloat width = CGRectGetWidth(extent);
	
	CIContext * context = [CIContext contextWithOptions:nil];
	CGImageRef cgImage = [context createCGImage:ciImage fromRect:extent];
	UIImage * uiImage = [UIImage imageWithCGImage:cgImage scale:(width/size) orientation:UIImageOrientationUp];
	CGImageRelease(cgImage);
	
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

- (UIImage *) imageWithImage:(UIImage *)smallImage inRect:(CGRect)rect
{
	UIGraphicsBeginImageContext(self.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
	
	// draw
	[self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
	[smallImage drawInRect:rect];
	// got
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return image;
}

@end

@implementation UIImage (QRCode)

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGFloat)size
{
	return UIImageWithQRCode(string, size);
}

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGFloat)size small:(UIImage *)icon
{
	UIImage * image = UIImageWithQRCode(string, size);
	if (icon && image) {
		CGFloat w = icon.size.width;
		CGFloat h = icon.size.height;
		CGFloat x = (size - w) * 0.5f;
		CGFloat y = (size - h) * 0.5f;
		image = [image imageWithImage:icon inRect:CGRectMake(x, y, w, h)];
	}
	return image;
}

- (NSString *) QRCode
{
	// TODO: implement me
	return nil;
}

@end
