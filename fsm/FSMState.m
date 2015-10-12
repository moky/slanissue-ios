//
//  FSMState.m
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "fsm_state.h"

#import "FSMMachine.h"
#import "FSMTransition.h"
#import "FSMState.h"

extern fsm_transition * inner_transition(const FSMTransition * transition);

@interface FSMState ()

@property(nonatomic, readwrite) fsm_state * innerState;

@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSMutableArray * transitions;

@end

@implementation FSMState

@synthesize innerState = _innerState;

@synthesize name = _name;
@synthesize transitions = _transitions;

- (void) dealloc
{
	[_name release];
	[_transitions release];
	
	if (_innerState) {
		fsm_state_destroy(_innerState);
	}
	
	[super dealloc];
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
	id object = [super allocWithZone:zone];
	fsm_state * s = fsm_state_create(NULL);
	if (s) {
		s->object = object;
	}
	[object setInnerState:s];
	return object;
}

- (instancetype) init
{
	return [self initWithName:nil capacity:4];
}

/* designated initializer */
- (instancetype) initWithName:(NSString *)name capacity:(NSUInteger)capacity
{
	self = [super init];
	if (self) {
		self.name = name;
		self.transitions = [NSMutableArray arrayWithCapacity:capacity];
	}
	return self;
}

- (instancetype) initWithName:(NSString *)name
{
	return [self initWithName:name capacity:4];
}

- (void) setName:(NSString *)name
{
	if (![_name isEqualToString:name]) {
		[name retain];
		[_name release];
		_name = name;
		
		fsm_state_set_name(_innerState, [name UTF8String]);
	}
}

- (void) addTransition:(FSMTransition *)transition
{
	NSAssert([transition isKindOfClass:[FSMTransition class]], @"error transition: %@", transition);
	if (!transition) {
		return;
	}
	
	fsm_state_add_transition(_innerState, inner_transition(transition));
	[_transitions addObject:transition];
}

- (void) onEnter:(FSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

- (void) onExit:(FSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

- (void) onPause:(FSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

- (void) onResume:(FSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

@end

fsm_state * inner_state(const FSMState * state)
{
	return [state innerState];
}
