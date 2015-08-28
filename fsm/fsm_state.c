//
//  fsm_state.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_chain_table.h"
#include "fsm_machine.h"
#include "fsm_transition.h"
#include "fsm_state.h"

fsm_state * fsm_state_create(const char * name)
{
	fsm_state * s = (fsm_state *)malloc(sizeof(fsm_state));
	memset(s, 0, sizeof(fsm_state));
	if (name) {
		fsm_state_set_name(s, name);
	}
	s->transitions = fsm_chain_create();
	return s;
}

void fsm_state_destroy(fsm_state * s)
{
	// 1. destroy the chain table for transitions
	fsm_chain_destroy(s->transitions);
//	s->transitions = NULL;
//	s->object = NULL;
	
	// 2. free the state
	free(s);
}

void fsm_state_set_name(fsm_state * s, const char * name)
{
	unsigned long len = strlen(name);
	if (len > 0) {
		if (len >= sizeof(s->name)) {
			len = sizeof(s->name) - 1;
		}
		strncpy(s->name, name, len);
	}
}

void fsm_state_add_transition(fsm_state * s, const fsm_transition * t)
{
	fsm_chain_add(s->transitions, t);
}

void fsm_state_tick(fsm_machine * m, const fsm_state * s)
{
	fsm_chain_node * node;
	fsm_transition * t;
	fsm_transition_evaluate fn;
	DS_FOR_EACH_CHAIN_NODE(s->transitions, node) {
		t = fsm_chain_get(node);
		fn = t->evaluate;
		if (fn && fn(m, s, t) != FSMFalse) {
			fsm_machine_change_state(m, t->target);
			break;
		}
	}
}
