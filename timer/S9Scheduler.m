//
//  S9Scheduler.m
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Object.h"
#import "S9Array.h"
#import "S9Tick.h"
#import "S9Scheduler.h"

@interface S9SchedulerCallback : S9TickCallback

@property(nonatomic, readwrite) NSInteger priority;

- (instancetype) initWithTarget:(id)target selector:(SEL)selector priority:(NSInteger)prior;

@end

@implementation S9SchedulerCallback

@synthesize priority = _priority;

- (instancetype) initWithTarget:(id)target selector:(SEL)selector priority:(NSInteger)prior
{
	self = [self initWithTarget:target selector:selector];
	if (self) {
		self.priority = prior;
	}
	return self;
}

@end

#pragma mark -

@interface S9Scheduler ()

@property(nonatomic, retain) NSMutableArray * ticks;
@property(nonatomic, retain) NSMutableArray * timers;

@end

@implementation S9Scheduler

@synthesize ticks = _ticks;
@synthesize timers = _timers;

@synthesize timeScale = _timeScale;

- (void) dealloc
{
	[self unscheduleAllSelectors];
	
	self.ticks = nil;
	self.timers = nil;
	
	s_singleton_instance = nil;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		_timeScale = 1.0f;
		
		self.ticks = [NSMutableArray arrayWithCapacity:16];
		self.timers = [NSMutableArray arrayWithCapacity:16];
	}
	return self;
}

S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

+ (void) purgeSharedScheduler
{
	@synchronized(s_singleton_instance) {
		[s_singleton_instance release];
		s_singleton_instance = nil;
	}
}

// Main Loop
- (void) tick:(float)dt
{
	if (_timeScale != 1.0f) {
		dt *= _timeScale;
	}
	
	id<S9TickCallback> callback;
	
	// tick selector
	@synchronized(_ticks) {
		S9_FOR_EACH(_ticks, callback) {
			[callback tick:dt];
		}
	}
	
	// custom selector
	@synchronized(_timers) {
		S9_FOR_EACH(_timers, callback) {
			[callback tick:dt];
		}
	}
}

- (void) scheduleSelector:(SEL)selector forTarget:(id)target interval:(float)interval paused:(BOOL)paused
{
	@synchronized(_timers) {
		// check whether exists
		S9Timer * timer;
#ifndef NS_BLOCK_ASSERTIONS
		S9_FOR_EACH(_timers, timer) {
			if (timer.target == target && timer.selector == selector) {
				NSAssert(false, @"cannot re-schedule the same target with same selector!");
				return;
			}
		}
#endif
		// add to schedule
		timer = [[S9Timer alloc] initWithTarget:target selector:selector];
		timer.interval = interval;
		[_timers addObject:timer];
		[timer release];
	}
}

- (void) scheduleTickForTarget:(id)target priority:(NSInteger)priority paused:(BOOL)paused
{
	@synchronized(_ticks) {
		NSUInteger index = 0;
		S9SchedulerCallback * callback;
		S9_FOR_EACH(_ticks, callback) {
#ifndef NS_BLOCK_ASSERTIONS
			if (callback.target == target) {
				NSAssert(false, @"cannot re-schedule the same target for 'tick:' selector!");
				return;
			}
#endif
			if (callback.priority < priority) {
				break;
			}
			++index;
		}
		// add to schedule
		callback = [[S9SchedulerCallback alloc] initWithTarget:target
													  selector:@selector(tick:)
													  priority:priority];
		if (index >= [_ticks count]) {
			[_ticks addObject:callback];
		} else {
			[_ticks insertObject:callback atIndex:index];
		}
		[callback release];
	}
}

- (void) unscheduleSelector:(SEL)selector forTarget:(id)target
{
	@synchronized(_timers) {
		S9Timer * timer;
		S9_FOR_EACH(_timers, timer) {
			if (timer.target == target && timer.selector == selector) {
				break; // got it
			}
		}
		if (timer) {
			[_timers removeObject:timer];
		}
	}
}

- (void) unscheduleAllCustomSelectorsForTarget:(id)target
{
	@synchronized(_timers) {
		NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:8];
		
		S9Timer * timer;
		S9_FOR_EACH(_timers, timer) {
			if (timer.target == target) {
				[mArray addObject:timer];
			}
		}
		
		if ([mArray count] > 0) {
			[_timers removeObjectsInArray:mArray];
		}
		[mArray release];
	}
}

- (void) unscheduleTickForTarget:(id)target
{
	@synchronized(_ticks) {
		S9TickCallback * callback;
		S9_FOR_EACH(_ticks, callback) {
			if (callback.target == target) {
				break; // got it
			}
		}
		if (callback) {
			[_ticks removeObject:callback];
		}
	}
}

- (void) unscheduleAllSelectorsForTarget:(id)target
{
	// custom selectors
	[self unscheduleAllCustomSelectorsForTarget:target];
	// tick selectors
	[self unscheduleTickForTarget:target];
}

- (void) unscheduleAllSelectors
{
	@synchronized(_timers) {
		[_timers removeAllObjects];
	}
	@synchronized(_ticks) {
		[_ticks removeAllObjects];
	}
}

- (void) pauseTarget:(id)target
{
	// custom selectors
	@synchronized(_timers) {
		S9Timer * timer;
		S9_FOR_EACH(_timers, timer) {
			if (timer.target == target) {
				timer.paused = YES;
			}
		}
	}
	// tick selectors
	@synchronized(_ticks) {
		S9TickCallback * callback;
		S9_FOR_EACH(_ticks, callback) {
			if (callback.target == target) {
				callback.paused = YES;
				break; // only ONE target
			}
		}
	}
}

- (void) resumeTarget:(id)target
{
	// custom selectors
	@synchronized(_timers) {
		S9Timer * timer;
		S9_FOR_EACH(_timers, timer) {
			if (timer.target == target) {
				timer.paused = NO;
			}
		}
	}
	// tick selectors
	@synchronized(_ticks) {
		S9TickCallback * callback;
		S9_FOR_EACH(_ticks, callback) {
			if (callback.target == target) {
				callback.paused = NO;
				break; // only ONE target
			}
		}
	}
}

- (BOOL) isTargetPaused:(id)target
{
	// check custom selectors
	@synchronized(_timers) {
		S9Timer * timer;
		S9_FOR_EACH(_timers, timer) {
			if (timer.target == target) {
				return timer.paused;
			}
		}
	}
	// check tick selectors
	@synchronized(_ticks) {
		S9TickCallback * callback;
		S9_FOR_EACH(_ticks, callback) {
			if (callback.target == target) {
				return callback.paused;
			}
		}
	}
	NSAssert(false, @"no such target: %@", target);
	return YES;
}

@end
