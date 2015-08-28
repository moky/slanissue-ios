//
//  fsm_chain_table.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_chain_table__
#define __fsm_chain_table__

#include "fsm_protocol.h"

fsm_chain_table * fsm_chain_create();
void fsm_chain_destroy(fsm_chain_table * chain);

void fsm_chain_add(fsm_chain_table * chain, const void * element);
fsm_chain_node * fsm_chain_at(fsm_chain_table * chain, unsigned int index);
void * fsm_chain_get(const fsm_chain_node * node);

#endif /* defined(__fsm_chain_table__) */
