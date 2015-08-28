//
//  fsm_machine.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_chain_table.h"
#include "fsm_state.h"
#include "fsm_machine.h"

fsm_machine * fsm_machine_create()
{
	fsm_machine * m = (fsm_machine *)malloc(sizeof(fsm_machine));
	memset(m, 0, sizeof(fsm_machine));
	m->states = fsm_chain_create();
	m->current = FSMNotFound;
	return m;
}

void fsm_machine_destroy(fsm_machine * m)
{
	// 1. destroy the chain table for states
	fsm_chain_destroy(m->states);
//	m->states = NULL;
//	m->enter = NULL;
//	m->exit = NULL;
//	m->object = NULL;
	
	// 2. free the machine
	free(m);
}

void fsm_machine_add_state(fsm_machine * m, const fsm_state * s)
{
	fsm_chain_add(m->states, s);
}

const fsm_state * fsm_machine_get_state(const fsm_machine * m, unsigned int index)
{
	fsm_chain_node * node = fsm_chain_at(m->states, index);
	return fsm_chain_get(node);
}

const fsm_state * fsm_machine_get_state_by_name(const fsm_machine * m, const char * name, unsigned int * index)
{
	const fsm_state * s = NULL;
	*index = FSMNotFound;
	if (name) {
		const fsm_chain_node * node;
		unsigned int i = 0;
		DS_FOR_EACH_CHAIN_NODE(m->states, node) {
			s = fsm_chain_get(node);
			if (strcmp(s->name, name) == 0) {
				*index = i;
				break;
			}
			++i;
			s = NULL;
		}
	}
	return s;
}

void fsm_machine_change_state(fsm_machine * m, const char * name)
{
	// get index for new state with name
	unsigned int index = FSMNotFound;
	const fsm_state * s = fsm_machine_get_state_by_name(m, name, &index);
	
	if (index == m->current) {
		// state not change
		return;
	}
	
	fsm_chain_node * node = fsm_chain_at(m->states, index);
	const fsm_state * o = fsm_chain_get(node);
	if (o && m->exit) m->exit(m, o); // exit the old state
	
	m->current = index;
	if (s && m->enter) m->enter(m, s); // enter the new state
}

void fsm_machine_tick(fsm_machine * m)
{
	fsm_chain_node * node = fsm_chain_at(m->states, m->current);
	const fsm_state * s = fsm_chain_get(node);
	if (m && s) {
		fsm_state_tick(m, s);
	}
}
