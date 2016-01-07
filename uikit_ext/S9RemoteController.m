//
//  UIRemoteController.m
//  SlanissueToolkit
//
//  Created by Moky on 15-1-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9RemoteController.h"

#if !TARGET_OS_WATCH

@implementation UIRemoteController

@synthesize status = _status;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_status = UIRemoteControllerStatusStopped;
	}
	return self;
}

@end

@implementation UIRemoteController (Responder)

// NOTE: this function must be called after 'viewDidAppear:'
- (void) start
{
//	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//	[self becomeFirstResponder];
}

- (void) end
{
//	[self resignFirstResponder];
//	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (BOOL) canBecomeFirstResponder
{
	return YES;
}

//typedef NS_ENUM(NSInteger, UIEventSubtype) {
//	// available in iPhone OS 3.0
//	UIEventSubtypeNone                              = 0,
//	
//	// for UIEventTypeMotion, available in iPhone OS 3.0
//	UIEventSubtypeMotionShake                       = 1,
//	
//	// for UIEventTypeRemoteControl, available in iOS 4.0
//	UIEventSubtypeRemoteControlPlay                 = 100,
//	UIEventSubtypeRemoteControlPause                = 101,
//	UIEventSubtypeRemoteControlStop                 = 102,
//	UIEventSubtypeRemoteControlTogglePlayPause      = 103,
//	UIEventSubtypeRemoteControlNextTrack            = 104,
//	UIEventSubtypeRemoteControlPreviousTrack        = 105,
//	UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
//	UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
//	UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
//	UIEventSubtypeRemoteControlEndSeekingForward    = 109,
//};
- (void) remoteControlReceivedWithEvent:(UIEvent *)event
{
	S9Log(@"type: %d, subtype: %d, event: %@", (int)event.type, (int)event.subtype, event);
	if (event.type != UIEventTypeRemoteControl) {
		return;
	}
	
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlPlay:
			[self onPlay];
			break;
			
		case UIEventSubtypeRemoteControlPause:
			[self onPause];
			break;
			
		case UIEventSubtypeRemoteControlStop:
			[self onStop];
			break;
			
		case UIEventSubtypeRemoteControlTogglePlayPause:
			if ([self isPlaying]) {
				[self onPause];
			} else {
				[self onPlay];
			}
			break;
			
		case UIEventSubtypeRemoteControlNextTrack:
			[self onNext];
			break;
			
		case UIEventSubtypeRemoteControlPreviousTrack:
			[self onPrevious];
			break;
			
		default:
			break;
	}
}

@end

@implementation UIRemoteController (Player)

- (void) onPlay
{
	_status = UIRemoteControllerStatusPlaying;
}

- (void) onStop
{
	_status = UIRemoteControllerStatusStopped;
}

- (void) onPause
{
	_status = UIRemoteControllerStatusStopped;
}

- (void) onResume
{
	_status = UIRemoteControllerStatusPlaying;
}

- (void) onNext
{
	_status = UIRemoteControllerStatusPlaying;
}

- (void) onPrevious
{
	_status = UIRemoteControllerStatusPlaying;
}

- (BOOL) isPlaying
{
	S9Log(@"override me!");
	return NO;
}

@end

@implementation UIRemoteController (NowPlaying)

- (void) setNowPlayingInfo:(NSDictionary *)dict
{
	S9Log(@"override me!");
}

@end

@implementation UIRemoteController (Application)

- (void) applicationWillEnterForeground:(UIApplication *)application
{
	S9Log(@"override me!");
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
	S9Log(@"override me!");
}

@end

#endif
