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
 *  create a Non-Interpolation bitmap context with parameters from imageRef
 */
//CG_EXTERN CGContextRef CGBitmapContextCreateWithCGImage(CGImageRef imageRef, CGSize size);

/**
 *  create a non-interpolation scaled UIImage from CIImage, with size & scale
 */
UIKIT_EXTERN UIImage * UIImageWithCIImage(CIImage * image, CGSize size, CGFloat scale);

/**
 *  load image, with memory cache
 *
 *    1. 'name' is a filename, load from main bundle
 *    2. 'name' is a file path, load from local
 *    3. 'name' is a URL, download from remote
 */
UIKIT_EXTERN UIImage * UIImageWithName(NSString * name);

typedef NS_ENUM(NSUInteger, UIImageFileType) {
	UIImageFileTypeUnknown,
	UIImageFileTypePNG,
	UIImageFileTypeJPEG,
	UIImageFileTypeGIF,
	UIImageFileTypeBMP,
};

/**
 *  get file type from filename (or url string)
 */
UIKIT_EXTERN UIImageFileType UIImageFileTypeFromName(NSString * filename);

/**
 *  get image scale from filename (e.g.: "Icon@2x.png" => 2.0f, "Icon@3x.png" =>3.0f, ...)
 */
UIKIT_EXTERN CGFloat UIImageScaleFromName(NSString * filename);

@interface UIImage (SlanissueToolkit)

/**
 *  write the image to file (*.png, *.jpg, *.jpeg)
 */
- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

/**
 *  create a new image with self as canvas, and draw the each images on it in rects
 *
 *  @return autoreleased UIImage, won't modify self
 */
- (UIImage *) imageWithImagesAndRects:(UIImage *)image1, /* (CGRect)rect1,
                                      (UIImage *)image2, (CGRect)rect2, */ ... NS_REQUIRES_NIL_TERMINATION;

@end
