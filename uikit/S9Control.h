//
//  S9Control.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (SlanissueToolkit)

/**
 *  perform the event to all actions matched on all targets
 */
- (void) performControlEvent:(UIControlEvents)controlEvent;

@end
