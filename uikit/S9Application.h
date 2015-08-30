//
//  S9Application.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SlanissueToolkit)

- (UIBackgroundTaskIdentifier) beginBackgroundTask;
- (void) endBackgroundTask;

@end
