//
//  fsm_transition.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_transition__
#define __fsm_transition__

#include "fsm_protocol.h"

fsm_transition * fsm_transition_create(const char * target);
void fsm_transition_destroy(fsm_transition * t);

void fsm_transition_set_target(fsm_transition * t, const char * target);

#endif /* defined(__fsm_transition__) */
