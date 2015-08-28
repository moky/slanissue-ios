//
//  fsm_transition.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_transition.h"

fsm_transition * fsm_transition_create(const char * target)
{
	fsm_transition * t = (fsm_transition *)malloc(sizeof(fsm_transition));
	memset(t, 0, sizeof(fsm_transition));
	if (target) {
		fsm_transition_set_target(t, target);
	}
	return t;
}

void fsm_transition_destroy(fsm_transition * t)
{
//	t->evaluate = NULL;
//	t->object = NULL;
	
	free(t);
}

void fsm_transition_set_target(fsm_transition * t, const char * target)
{
	unsigned long len = strlen(target);
	if (len > 0) {
		if (len >= sizeof(t->target)) {
			len = sizeof(t->target) - 1;
		}
		strncpy(t->target, target, len);
	}
}
