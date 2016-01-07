//
//  S9Application.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Application.h"

#if !TARGET_OS_WATCH

static UIBackgroundTaskIdentifier _bgTask = NSUIntegerMax;

static void replace_background_task(UIApplication * app, UIBackgroundTaskIdentifier newTaskId)
{
	if (_bgTask != NSUIntegerMax && _bgTask != UIBackgroundTaskInvalid) {
		[app endBackgroundTask:_bgTask];
	}
	_bgTask = newTaskId;
}

@implementation UIApplication (SlanissueToolkit)

- (UIBackgroundTaskIdentifier) beginBackgroundTask
{
	__block UIApplication * app = self;
	if (app.applicationState != UIApplicationStateBackground) {
		// not in background state yet
		return UIBackgroundTaskInvalid;
	}
	
	UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:^{
		// when expired, kill the current background task and set it invalid
		replace_background_task(app, UIBackgroundTaskInvalid);
	}];
	
	// switch background task with new id
	replace_background_task(app, newTask);
	return _bgTask;
}

- (void) endBackgroundTask
{
	// kill the current background task and set it invalid
	replace_background_task(self, UIBackgroundTaskInvalid);
}

@end

#endif
