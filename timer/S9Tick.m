//
//  S9Tick.m
//  SlanissueToolkit
//
//  Created by Moky on 15-7-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Tick.h"

@implementation S9TickCallback

@synthesize target = _target;
@synthesize selector = _selector;

@synthesize paused = _paused;

- (void) dealloc
{
	self.target = nil;
	self.selector = NULL;
	_impMethod = NULL;
	
	[super dealloc];
}

- (instancetype) init
{
	return [self initWithTarget:nil selector:NULL];
}

/* designated initializer */
- (instancetype) initWithTarget:(id)target selector:(SEL)selector
{
	self = [super init];
	if (self) {
		self.target = target;
		self.selector = selector;
		_impMethod = (S9TickImp)[_target methodForSelector:_selector];
		_paused = NO;
	}
	return self;
}

- (void) tick:(float)dt
{
	NSAssert(_target != nil && _selector != NULL && _impMethod != NULL, @"error");
	if (!_paused) {
		_impMethod(_target, _selector, dt);
	}
}

@end

#pragma mark -

@implementation S9Timer

@synthesize interval = _interval;

- (void) dealloc
{
	[super dealloc];
}

- (instancetype) initWithTarget:(id)target selector:(SEL)sel
{
	self = [super initWithTarget:target selector:sel];
	if (self) {
		_elapsed = 0.0f;
		_interval = 0.0f;
	}
	return self;
}

- (void) tick:(float)dt
{
	_elapsed += dt;
	
	if (_elapsed >= _interval) {
		[super tick:_elapsed];
		_elapsed = 0.0f;
	}
}

@end
