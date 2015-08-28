//
//  fsm_machine.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_machine__
#define __fsm_machine__

#include "fsm_protocol.h"

fsm_machine * fsm_machine_create();
void fsm_machine_destroy(fsm_machine * m);

void fsm_machine_add_state(fsm_machine * m, const fsm_state * s);

const fsm_state * fsm_machine_get_state(const fsm_machine * m, unsigned int index);
const fsm_state * fsm_machine_get_state_by_name(const fsm_machine * m, const char * name, unsigned int * index);

void fsm_machine_change_state(fsm_machine * m, const char * name);

void fsm_machine_tick(fsm_machine * m);

#endif /* defined(__fsm_machine__) */
