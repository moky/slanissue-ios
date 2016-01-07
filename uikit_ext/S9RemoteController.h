//
//  UIRemoteController.h
//  SlanissueToolkit
//
//  Created by Moky on 15-1-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

typedef NS_ENUM(NSInteger, UIRemoteControllerStatus) {
	UIRemoteControllerStatusStopped,
	UIRemoteControllerStatusPlaying,
};

@interface UIRemoteController : UIResponder

// what status should be, not the real status of the current player
@property(nonatomic, readwrite) UIRemoteControllerStatus status;

@end

@interface UIRemoteController (Responder)

// call from UIViewController(UIResponder)

- (void) start; // start remote controlling
- (void) end;   // end remote controlling

- (void) remoteControlReceivedWithEvent:(UIEvent *)event;

@end

@interface UIRemoteController (Player)

// override these functions to implement audio/video player controlling

- (void) onPlay;
- (void) onStop;

- (void) onPause;
- (void) onResume;

- (void) onNext;
- (void) onPrevious;

- (BOOL) isPlaying; // check current player's real status

@end

@interface UIRemoteController (NowPlaying)

// override this function to implement showing media info in lock screen/control pannel

- (void) setNowPlayingInfo:(NSDictionary *)dict;

@end

@interface UIRemoteController (Application)

// call from UIApplicationDelegate

- (void) applicationWillEnterForeground:(UIApplication *)application;
- (void) applicationDidEnterBackground:(UIApplication *)application;

@end

#endif
