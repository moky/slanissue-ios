//
//  S9QRCodeImage.m
//  SlanissueToolkit
//
//  Created by Moky on 15-9-22.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Client.h"
#import "S9Image.h"
#import "S9QRCodeImage.h"

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
	CGFloat screenScale = [[S9Client getInstance] screenScale];
	CIImage * image = CIImageWithQRCode(text);
	return UIImageWithCIImage(image, CGSizeMake(size, size), screenScale);
}

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
		image = [image imageWithImagesAndRects:icon, CGRectMake(x, y, w, h), nil];
	}
	return image;
}

@end
