//
//  S9Image.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 *  create a copy of CGImageRef in rect
 */
CG_EXTERN CGImageRef CGImageCreateCopyWithImageInRect(CGImageRef imageRef, CGRect rect);

/**
 *  create a QRCode image with text
 */
CG_EXTERN CIImage * CIImageWithQRCode(NSString * text);

/**
 *  create a QRCode image with text, and {size, size}
 */
UIKIT_EXTERN UIImage * UIImageWithQRCode(NSString * text, CGFloat size);

/**
 *  load image, with memory cache
 *
 *    1. 'name' is a filename, load from main bundle
 *    2. 'name' is a file path, load from local
 *    3. 'name' is a URL, download from remote
 */
UIKIT_EXTERN UIImage * UIImageWithName(NSString * name);

@interface UIImage (SlanissueToolkit)

/**
 *  write the image to file (*.png, *.jpg, *.jpeg)
 */
- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

/**
 *  create an image with self as canvas, and draw the smallImage in rect
 */
- (UIImage *) imageWithImage:(UIImage *)smallImage inRect:(CGRect)rect;

@end

@interface UIImage (QRCode)

/**
 *  create a QRCode image with text, and {size, size}
 */
+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGFloat)size;
/**
 *  create a QRCode image with text, and {size, size}, and a small icon in center
 */
+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGFloat)size small:(UIImage *)icon;

/**
 *  try to recognize the QRCode string in the image
 */
- (NSString *) QRCode;

@end
