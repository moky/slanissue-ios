//
//  FSMTransition.m
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "fsm_transition.h"

#import "FSMMachine.h"
//#import "FSMState.h"
#import "FSMTransition.h"

static fsm_bool _evaluate(const fsm_machine * m, const fsm_state * s, const fsm_transition * t)
{
	FSMMachine * machine = m->object;
	//FSMState * state = s->object;
	FSMTransition * transition = t->object;
	
	return [transition evaluate:machine] ? FSMTrue : FSMFalse;
}

@interface FSMTransition ()

@property(nonatomic, readwrite) fsm_transition * innerTransition;

@property(nonatomic, retain) NSString * targetStateName;

@end

@implementation FSMTransition

@synthesize innerTransition = _innerTransition;

@synthesize targetStateName = _targetStateName;

- (void) dealloc
{
	[_targetStateName release];
	
	if (_innerTransition) {
		fsm_transition_destroy(_innerTransition);
	}
	
	[super dealloc];
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
	id object = [super allocWithZone:zone];
	fsm_transition * t = fsm_transition_create(NULL);
	if (t) {
		t->evaluate = _evaluate;
		t->object = object;
	}
	[object setInnerTransition:t];
	return object;
}

- (instancetype) init
{
	return [self initWithTargetStateName:nil];
}

/* designated initializer */
- (instancetype) initWithTargetStateName:(NSString *)name
{
	self = [super init];
	if (self) {
		self.targetStateName = name;
	}
	return self;
}

- (void) setTargetStateName:(NSString *)targetStateName
{
	if (![_targetStateName isEqualToString:targetStateName]) {
		[targetStateName retain];
		[_targetStateName release];
		_targetStateName = targetStateName;
		
		fsm_transition_set_target(_innerTransition, [targetStateName UTF8String]);
	}
}

- (BOOL) evaluate:(FSMMachine *)machine
{
	NSAssert(false, @"override me!");
	return YES;
}

@end

fsm_transition * inner_transition(const FSMTransition * transition)
{
	return [transition innerTransition];
}
