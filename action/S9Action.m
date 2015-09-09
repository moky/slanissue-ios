//
//  S9Action.m
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ActionInterval.h"
#import "S9Action.h"

@implementation S9Action

@synthesize target = _target;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_target = nil;
	}
	return self;
}

+ (instancetype) action
{
	return [[[self alloc] init] autorelease];
}

- (BOOL) isDone
{
	return YES;
}

- (void) startWithTarget:(id)target
{
	_target = target;
}

- (void) stop
{
	_target = nil;
}

- (void) tick:(float)dt
{
	NSAssert(false, @"override me!");
}

- (void) update:(float)time
{
	NSAssert(false, @"override me!");
}

@end

@interface S9RepeatForever ()

@property(nonatomic, retain) S9ActionInterval * innerAction;

@end

@implementation S9RepeatForever

@synthesize innerAction = _innerAction;

- (void) dealloc
{
	self.innerAction = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.innerAction = nil;
	}
	return self;
}

- (instancetype) initWithAction:(S9ActionInterval *)action
{
	self = [self init];
	if (self) {
		self.innerAction = action;
	}
	return self;
}

+ (instancetype) actionWithAction:(S9ActionInterval *)action
{
	return [[[self alloc] initWithAction:action] autorelease];
}

- (void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	NSAssert([_innerAction isKindOfClass:[S9ActionInterval class]],
			 @"inner action error: %@", _innerAction);
	[_innerAction startWithTarget:_target];
}

- (void) tick:(float)dt
{
	[_innerAction tick:dt];
	
	if ([_innerAction isDone]) {
		dt += _innerAction.duration - _innerAction.elapsed;
		[_innerAction startWithTarget:_target];
		[_innerAction tick:dt];
	}
}

@end
