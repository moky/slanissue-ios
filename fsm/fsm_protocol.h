//
//  fsm_protocol.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_protocol__
#define __fsm_protocol__

/**
 *
 *  Description:
 *
 *      Finite State Machine, which has finitely several states in it, only one
 *  of them will be set as the current state in the same time.
 *
 *      When the machine started up, we should build up all states and their own
 *  transitions for changing from self to another, adding all states with their
 *  transitions one by one into the machine.
 *
 *      In each time period, the function "tick" of machine will be call, this
 *  function will enumerate all transtions of the current state, try to evaluate
 *  each of them, while one transtion's function "evaluate" return YES, then
 *  the machine will change to the new state by the transtion's target name.
 *
 *      When the machine stopped, it will run out from the current state, and
 *  here we should remove all states.
 *
 *
 *      If current state changed, the delegate function "fsm_machine_exit_state"
 *  will be call with the old state, after that, "fsm_machine_enter_state" will
 *  be call with the new state. This mechanism can let you do something in the
 *  two opportune moments.
 *
 */

#include "ds_chain.h"


typedef int            fsm_bool;

typedef ds_chain_table fsm_chain_table;
typedef ds_chain_node  fsm_chain_node;


#define FSMTrue             1
#define FSMFalse            0

#define FSMNotFound         0xffffffff

#define FSM_MAX_NAME_LENGTH 32

//
//  interfaces
//

struct _fsm_machine;
struct _fsm_state;
struct _fsm_transition;

typedef void     (*fsm_machine_enter_state)(const struct _fsm_machine * m, const struct _fsm_state * s);
typedef void     (*fsm_machine_exit_state) (const struct _fsm_machine * m, const struct _fsm_state * s);
typedef fsm_bool (*fsm_transition_evaluate)(const struct _fsm_machine * m, const struct _fsm_state * s, const struct _fsm_transition * t);

//
// machine
//
typedef struct _fsm_machine {
	// states
	fsm_chain_table * states;             // finite array for states
	unsigned int current;          // index of current state
	// functions
	fsm_machine_enter_state enter; // enter a state
	fsm_machine_exit_state  exit;  // exit a state
	
	void * object; // delegate for machine
} fsm_machine;

//
// state
//
typedef struct _fsm_state {
	char name[FSM_MAX_NAME_LENGTH]; // name of state
	fsm_chain_table * transitions;    // transitions of state
	
	void * object; // delegate for state
} fsm_state;

//
// transition
//
typedef struct _fsm_transition {
	char target[FSM_MAX_NAME_LENGTH]; // name of target state
	fsm_transition_evaluate evaluate; // evaluate function
	
	void * object; // delegate for transition
} fsm_transition;

#endif /* defined(__fsm_protocol__) */
