//
//  S9Image+GIF.h
//  SlanissueToolkit
//
//  Created by Moky on 15-10-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  create an animated image with GIF data
 */
UIKIT_EXTERN UIImage * UIImageWithGIFData(NSData * data, CGFloat scale);

/**
 *  create GIF data with animated image (image.images, image.duration)
 */
UIKIT_EXTERN NSData * UIImageGIFRepresentation(UIImage * image);
