//
//  S9Image.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN UIImage * UIImageWithName(NSString * name);

@interface UIImage (SlanissueToolkit)

- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end
