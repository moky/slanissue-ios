//
//  FSMAutoMachine.m
//  FiniteStateMachine
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "FSMAutoMachine.h"

@interface FSMAutoMachine () {
	
	NSTimer * _timer;
}

@end

@implementation FSMAutoMachine

@synthesize interval = _interval;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_interval = 1.0f / 12.0f;
	}
	return self;
}

- (void) _startMachine
{
	// start
	_timer = [NSTimer scheduledTimerWithTimeInterval:_interval
											  target:self
											selector:@selector(tick)
											userInfo:nil
											 repeats:YES];
}

- (void) _stopMachine
{
	// stop timer and release itself and the target
	[_timer invalidate];
	_timer = nil;
}

- (void) start
{
	[super start];
	[self _startMachine];
}

- (void) stop
{
	[self _stopMachine];
	[super stop];
}

- (void) pause
{
	[self _stopMachine];
	[super pause];
}

- (void) resume
{
	[super resume];
	[self _startMachine];
}

@end
