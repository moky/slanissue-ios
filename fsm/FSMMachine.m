//
//  FSMMachine.m
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "fsm_machine.h"
#import "fsm_state.h"

#import "FSMState.h"
#import "FSMMachine.h"

extern fsm_state * inner_state(const FSMState * state);

static void _on_enter(const fsm_machine * m, const fsm_state * s)
{
	FSMMachine * machine = m->object;
	FSMState * state = s->object;
	[machine.delegate machine:machine enterState:state]; // call 'enterState:' of delegate
	[state onEnter:machine]; // call 'onEnter:' of state
}

static void _on_exit(const fsm_machine * m, const fsm_state * s)
{
	FSMMachine * machine = m->object;
	FSMState * state = s->object;
	[machine.delegate machine:machine exitState:state]; // call 'exitState:' of delegate
	[state onExit:machine]; // call 'onExit:' of state
}

typedef NS_ENUM(NSUInteger, FSMStatus) {
	FSMMachineStatusStop,
	FSMMachineStatusRunning,
	FSMMachineStatusPaused,
};

@interface FSMMachine () {
	
	FSMStatus _status;
}

@property(nonatomic, readwrite) fsm_machine * innerMachine;
@property(nonatomic, retain) NSMutableArray * states;

@end

@implementation FSMMachine

@synthesize innerMachine = _innerMachine;

@synthesize defaultStateName = _defaultStateName;
@synthesize states = _states;

@synthesize delegate = _delegate;

- (void) dealloc
{
	[_defaultStateName release];
	[_states release];
	
	if (_innerMachine) {
		fsm_machine_destroy(_innerMachine);
	}
	
	[super dealloc];
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
	id object = [super allocWithZone:zone];
	fsm_machine * m = fsm_machine_create();
	if (m) {
		m->enter = _on_enter;
		m->exit = _on_exit;
		m->object = object;
	}
	[object setInnerMachine:m];
	return object;
}

- (instancetype) init
{
	return [self initWithDefaultStateName:@"default" capacity:8];
}

/* designated initializer */
- (instancetype) initWithDefaultStateName:(NSString *)name capacity:(NSUInteger)capacity
{
	self = [super init];
	if (self) {
		_status = FSMMachineStatusStop;
		
		self.defaultStateName = name;
		self.states = [NSMutableArray arrayWithCapacity:capacity];
		
		self.delegate = nil;
	}
	return self;
}

- (void) addState:(FSMState *)state
{
	NSAssert([state isKindOfClass:[FSMState class]], @"error state: %@", state);
	if (!state) {
		return;
	}
	
	fsm_machine_add_state(_innerMachine, inner_state(state));
	[_states addObject:state];
}

- (void) changeState:(NSString *)name
{
	fsm_machine_change_state(_innerMachine, [name UTF8String]);
}

- (FSMState *) currentState
{
	const fsm_state * s = fsm_machine_get_state(_innerMachine, _innerMachine->current);
	NSAssert(s, @"failed to get current state: %d", _innerMachine->current);
	FSMState * state = s->object;
	NSAssert([state isKindOfClass:[FSMState class]], @"memory error");
	return state;
}

#pragma mark -

- (void) tick
{
	@synchronized(self) {
		fsm_machine_tick(_innerMachine);
	}
}

- (void) start
{
	switch (_status) {
		case FSMMachineStatusStop: {
			[self changeState:_defaultStateName];
			_status = FSMMachineStatusRunning;
			break;
		}
			
		case FSMMachineStatusRunning: {
			// already running
			break;
		}
			
		case FSMMachineStatusPaused: {
			[self changeState:_defaultStateName];
			_status = FSMMachineStatusRunning;
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

- (void) stop
{
	switch (_status) {
		case FSMMachineStatusStop: {
			// already stop
			break;
		}
			
		case FSMMachineStatusRunning: {
			_status = FSMMachineStatusStop;
			[self changeState:nil];
			break;
		}
			
		case FSMMachineStatusPaused: {
			_status = FSMMachineStatusStop;
			[self changeState:nil];
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

- (void) pause
{
	switch (_status) {
		case FSMMachineStatusStop: {
			// error
			break;
		}
			
		case FSMMachineStatusRunning: {
			_status = FSMMachineStatusPaused;
			
			FSMState * state = [self currentState];
			if ([_delegate respondsToSelector:@selector(machine:pauseState:)]) {
				[_delegate machine:self pauseState:state];
			}
			[state onPause:self];
			break;
		}
			
		case FSMMachineStatusPaused: {
			// already paused
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

- (void) resume
{
	switch (_status) {
		case FSMMachineStatusStop: {
			// error
			break;
		}
			
		case FSMMachineStatusRunning: {
			// not paused
			break;
		}
			
		case FSMMachineStatusPaused: {
			_status = FSMMachineStatusRunning;
			
			FSMState * state = [self currentState];
			if ([_delegate respondsToSelector:@selector(machine:resumeState:)]) {
				[_delegate machine:self resumeState:state];
			}
			[state onResume:self];
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

@end
