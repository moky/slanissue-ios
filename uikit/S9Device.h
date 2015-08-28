//
//  S9Device.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SlanissueToolkit)

// get hw.machine
- (NSString *) machine;

// generates a hash from the MAC-address
- (NSString *) globalIdentifier;

@end
