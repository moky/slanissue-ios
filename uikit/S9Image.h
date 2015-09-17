//
//  S9Image.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

CG_EXTERN CGImageRef CGImageCreateCopyWithImageInRect(CGImageRef imageRef, CGRect rect);

CG_EXTERN CIImage * CIImageWithQRCode(NSString * string);
UIKIT_EXTERN UIImage * UIImageWithQRCode(NSString * string, CGSize size);

UIKIT_EXTERN UIImage * UIImageWithCIImage(CIImage * ciImage, CGSize size);
UIKIT_EXTERN UIImage * UIImageWithSmallImage(UIImage * background, UIImage * icon, CGRect rect);

UIKIT_EXTERN UIImage * UIImageWithName(NSString * name);

@interface UIImage (SlanissueToolkit)

- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end

@interface UIImage (QRCode)

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGSize)size;
+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGSize)size small:(UIImage *)icon;

- (NSString *) QRCode;

@end
