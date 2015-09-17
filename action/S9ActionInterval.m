//
//  S9ActionInterval.m
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ActionInterval.h"

@implementation S9ActionInterval

- (instancetype) initWithDuration:(float)duration
{
	self = [self init];
	if (self) {
		self.duration = duration;
	}
	return self;
}

+ (instancetype) actionWithDuration:(float)duration
{
	return [[[self alloc] initWithDuration:duration] autorelease];
}

- (void) setDuration:(float)duration
{
	if (_duration != duration) {
		_duration = duration;
		
		// prevent division by 0
		// This comparison could be in tick:, but it might decrease the performance
		// by 3% in heavy based action games.
		if (_duration == 0.0f) {
			_duration = FLT_EPSILON;
		}
	}
}

- (BOOL) isDone
{
	return (_elapsed >= _duration);
}

- (void) tick:(float)dt
{
	_elapsed += dt;
	
	[self update:MIN(1.0f, _elapsed / _duration)];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_elapsed = 0.0f;
}

- (S9ActionInterval *) reverse
{
	NSAssert(false, @"reverse not implemented.");
	return nil;
}

@end

#pragma mark -

@implementation S9DelayTime

- (void) update:(float)time
{
	// do nothing
}

- (S9FiniteTimeAction *) reverse
{
	return [[self class] actionWithDuration:_duration];
}

@end

@interface S9ReverseTime ()

@property(nonatomic, retain) S9FiniteTimeAction * innerAction;

@end

@implementation S9ReverseTime

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

- (instancetype) initWithAction:(S9FiniteTimeAction *)action
{
	self = [self initWithDuration:action.duration];
	if (self) {
		self.innerAction = action;
	}
	return self;
}

+ (instancetype) actionWithAction:(S9FiniteTimeAction *)action
{
	return [[[S9ReverseTime alloc] initWithAction:action] autorelease];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	[_innerAction startWithTarget:target];
}

- (void) stop
{
	[_innerAction stop];
	[super stop];
}

- (void) update:(float)time
{
	[_innerAction update:(1.0f - time)];
}

- (S9ActionInterval *) reverse
{
	// FIXME: copy a new action
	return (S9ActionInterval *)_innerAction;
}

@end

@interface S9Repeat ()

@property(nonatomic, retain) S9FiniteTimeAction * innerAction;

@end

@implementation S9Repeat

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
		_times = 0;
		_total = 0;
	}
	return self;
}

- (instancetype) initWithAction:(S9FiniteTimeAction *)action times:(NSUInteger)times
{
	float duration = action.duration * times;
	self = [self initWithDuration:duration];
	if (self) {
		self.innerAction = action;
		_times = times;
	}
	return self;
}

+ (instancetype) actionWithAction:(S9FiniteTimeAction *)action times:(NSUInteger)times
{
	return [[[self alloc] initWithAction:action times:times] autorelease];
}

- (BOOL) isDone
{
	return _total == _times;
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	_total = 0;
	[_innerAction startWithTarget:target];
}

- (void) stop
{
	[_innerAction stop];
	[super stop];
}

- (void) tick:(float)dt
{
	float time = dt * _times;
	if (time > _total + 1) {
		[_innerAction update:1.0f];
		++_total;
		[_innerAction stop];
		// next time
		[_innerAction startWithTarget:_target];
		
		// repeat is over?
		if (_total == _times) {
			// set it in the original position
			[_innerAction update:0.0f];
		} else {
			// start next repeat with the right update
			[_innerAction update:(time - _total)];
		}
	} else {
		float r = fmodf(time, 1.0f);
		
		// fix last repeat position
		// else it could be 0.
		if (dt == 1.0f) {
			r = 1.0f;
			++_total; // this is the added line
		}
		[_innerAction update:MIN(r, 1.0f)];
	}
}

- (S9ActionInterval *) reverse
{
	return [[[self class] alloc] initWithAction:[_innerAction reverse]
										  times:_times];
}

@end

#pragma mark -

@interface S9Sequence () {
	
@protected
	S9FiniteTimeAction * _action1;
	S9FiniteTimeAction * _action2;
}

@property(nonatomic, retain) S9FiniteTimeAction * action1;
@property(nonatomic, retain) S9FiniteTimeAction * action2;

@end

@implementation S9Sequence {
	
	float _durations[2];
	NSUInteger _currentIndex;
}

@synthesize action1 = _action1;
@synthesize action2 = _action2;

- (void) dealloc
{
	self.action1 = nil;
	self.action2 = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.action1 = nil;
		self.action2 = nil;
	}
	return self;
}

- (instancetype) initWithActionOne:(S9FiniteTimeAction *)action1 two:(S9FiniteTimeAction *)action2
{
	NSAssert(action1 != nil && action2 != nil,
			 @"arguments must not be nil");
	NSAssert(action1 != _action1 && action1 != _action2,
			 @"re-init with the same arguments is not supported");
	NSAssert(action2 != _action1 && action2 != _action2,
			 @"re-init with the same arguments is not supported");
	
	float duration = action1.duration + action2.duration;
	self = [self initWithDuration:duration];
	if (self) {
		self.action1 = action1;
		self.action2 = action2;
	}
	return self;
}

+ (instancetype) actions:(S9FiniteTimeAction *)action1, ... NS_REQUIRES_NIL_TERMINATION
{
	va_list params;
	va_start(params, action1);
	
	id prev = action1;
	id next = nil;
	while ((next = va_arg(params, S9FiniteTimeAction *))) {
		prev = [self actionOne:prev two:next];
	}
	
	va_end(params);
	return prev;
}

+ (instancetype) actionsWithArray:(NSArray *)actions
{
	NSEnumerator * enumerator = [actions objectEnumerator];
	
	id prev = [enumerator nextObject];
	id next = nil;
	while (next = [enumerator nextObject]) {
		prev = [self actionOne:prev two:next];
	}
	
	return prev;
}

+ (instancetype) actionOne:(S9FiniteTimeAction *)action1 two:(S9FiniteTimeAction *)action2
{
	S9Sequence * sequence = [[S9Sequence alloc] initWithActionOne:action1
															  two:action2];
	return [sequence autorelease];
}

- (void) stop
{
	if (_currentIndex == 0) {
		[_action1 stop];
	}
	[_action2 stop];
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	
	_durations[0] = _action1.duration / _duration;
	if (_durations[0] == 0.0f) {
		_durations[0] = FLT_EPSILON;
	}
	_durations[1] = _action2.duration / _duration;
	if (_durations[1] == 0.0f) {
		_durations[1] = FLT_EPSILON;
	}
	
	_currentIndex = 0;
	[_action1 startWithTarget:target];
}

- (void) update:(float)time
{
	if (time < _durations[0]) {
		NSAssert(_currentIndex == 0, @"sequence time duration error");
		[_action1 update:(time / _durations[0])];
		return;
	}
	if (_currentIndex == 0) {
		// finish the 1st action
		[_action1 update:1.0f];
		[_action1 stop];
		
		// start the 2nd action
		[_action2 startWithTarget:_target];
		_currentIndex = 1;
	}
	[_action2 update:((time - _durations[0]) / _durations[1])];
}

- (S9ActionInterval *) reverse
{
	return [[self class] actionOne:[_action2 reverse]
							   two:[_action1 reverse]];
}

@end

@implementation S9Spawn

- (instancetype) initWithActionOne:(S9FiniteTimeAction *)action1 two:(S9FiniteTimeAction *)action2
{
	NSAssert(action1 != nil && action2 != nil,
			 @"arguments must not be nil");
	NSAssert(action1 != _action1 && action1 != _action2,
			 @"re-init with the same arguments is not supported");
	NSAssert(action2 != _action1 && action2 != _action2,
			 @"re-init with the same arguments is not supported");
	
	S9FiniteTimeAction * act1 = action1;
	S9FiniteTimeAction * act2 = action2;
	
	float d1 = action1.duration;
	float d2 = action2.duration;
	
	if (d1 > d2) {
		self = [self initWithDuration:d1];
		act2 = [S9Sequence actionOne:action2
								 two:[S9DelayTime actionWithDuration:(d1 - d2)]];
	} else {
		self = [self initWithDuration:d2];
		act1 = [S9Sequence actionOne:action1
								 two:[S9DelayTime actionWithDuration:(d2 - d1)]];
	}
	
	if (self) {
		self.action1 = act1;
		self.action2 = act2;
	}
	return self;
}

- (void) startWithTarget:(id)target
{
	[super startWithTarget:target];
	//
	// _action1 will be started in super
	//
	[_action2 startWithTarget:target];
}

- (void) update:(float)time
{
	[_action1 update:time];
	[_action2 update:time];
}

- (S9ActionInterval *) reverse
{
	return [[self class] actionOne:[_action1 reverse]
							   two:[_action2 reverse]];
}

@end
