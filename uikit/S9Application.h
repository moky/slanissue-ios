//
//  S9Application.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

@interface UIApplication (SlanissueToolkit)

/**
 *  call me in '-[UIApplicationDelegate applicationDidEnterBackground:]'
 */
- (UIBackgroundTaskIdentifier) beginBackgroundTask;

/**
 *  call me in '-[UIApplicationDelegate applicationWillEnterForeground:]'
 */
- (void) endBackgroundTask;

@end

#endif
