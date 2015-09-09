//
//  S9ActionInstant.m
//  SlanissueToolkit
//
//  Created by Moky on 15-7-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ActionInstant.h"

@implementation S9ActionInstant

- (instancetype) init
{
	self = [super init];
	if (self) {
		_duration = 0.0f;
	}
	return self;
}

- (BOOL) isDone
{
	return YES;
}

- (void) tick:(float)dt
{
	[self update:1.0f];
}

- (void) update:(float)time
{
	// do nothing
}

- (S9FiniteTimeAction *) reverse
{
	return [[[[self class] alloc] init] autorelease];
}

@end

#pragma mark - Callback

typedef void (*S9ActionCallbackImpMethod)(id, SEL);

@interface S9CallFunc () {
	
	S9ActionCallbackImpMethod _impMethod;
}

@property(nonatomic, retain) id targetCallback;
@property(nonatomic, readwrite) SEL selector;

@end

@implementation S9CallFunc

@synthesize targetCallback = _targetCallback;
@synthesize selector = _selector;

- (void) dealloc
{
	self.targetCallback = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.targetCallback = nil;
		self.selector = NULL;
		_impMethod = NULL;
	}
	return self;
}

- (instancetype) initWithTarget:(id)target selector:(SEL)selector
{
	self = [self init];
	if (self) {
		self.targetCallback = target;
		self.selector = selector;
		
		NSAssert([_targetCallback respondsToSelector:_selector], @"error target & selector");
		if ([_targetCallback respondsToSelector:_selector]) {
			_impMethod = (S9ActionCallbackImpMethod)[_target methodForSelector:_selector];
		}
	}
	return self;
}

+ (instancetype) actionWithTarget:(id)target selector:(SEL)selector
{
	return [[self alloc] initWithTarget:target selector:selector];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	// execute
	//[_targetCallback performSelector:_selector];
	if (_impMethod) {
		_impMethod(_targetCallback, _selector);
	}
}

@end

#pragma mark Blocks Support

#if NS_BLOCKS_AVAILABLE

@implementation S9CallBlock

- (void) dealloc
{
	[_block release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_block release];
		_block = NULL;
	}
	return self;
}

- (instancetype) initWithBlock:(void (^)())block
{
	self = [self init];
	if (self) {
		[_block release];
		_block = [block copy];
	}
	return self;
}

+ (instancetype) actionWithBlock:(void (^)())block
{
	return [[[self alloc] initWithBlock:block] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	// execute
	_block();
}

@end

#endif
