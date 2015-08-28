//
//  fsm_state.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_state__
#define __fsm_state__

#include "fsm_protocol.h"

fsm_state * fsm_state_create(const char * name);
void fsm_state_destroy(fsm_state * s);

void fsm_state_set_name(fsm_state * s, const char * name);
void fsm_state_add_transition(fsm_state * s, const fsm_transition * t);

void fsm_state_tick(fsm_machine * m, const fsm_state * s);

#endif /* defined(__fsm_state__) */
