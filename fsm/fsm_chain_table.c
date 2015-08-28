//
//  fsm_chain_table.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_chain_table.h"

fsm_chain_table * fsm_chain_create()
{
	return ds_chain_create(sizeof(void *));
}

void fsm_chain_destroy(fsm_chain_table * chain)
{
	ds_chain_destroy(chain);
}

void fsm_chain_add(fsm_chain_table * chain, const void * element)
{
	// save the element's address, no need to copy the element
	ds_chain_insert(chain, (ds_type *)&element, chain->tail);
}

fsm_chain_node * fsm_chain_at(fsm_chain_table * chain, unsigned int index)
{
	if (index == FSMNotFound) {
		return NULL;
	}
	ds_chain_node * node = ds_chain_at(chain, index);
	return node;
}

void * fsm_chain_get(const fsm_chain_node * node)
{
	if (!node) {
		return NULL;
	}
	// the data saved is the element's address,
	// here return the element
	void ** ptr = (void **)node->data;
	return ptr ? *ptr : NULL;
}
