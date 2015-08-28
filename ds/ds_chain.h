//
//  ds_chain.h
//  DataStructure
//
//  Created by Moky on 15-8-25.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef __ds_chain__
#define __ds_chain__

#include "ds_base.h"

#define DS_FOR_EACH_CHAIN_NODE(chain, node)                                    \
    for ((node) = (chain)->head; (node); (node) = (node)->next)                \
                                              /* EOF 'DS_FOR_EACH_CHAIN_NODE' */

typedef struct _ds_chain_node {
	ds_type * data;
	struct _ds_chain_node * next;
} ds_chain_node;

typedef struct _ds_chain_table {
	
	ds_size data_size; // size of the memory 'ds_chain_node->data' pointed to
	
	ds_chain_node * head;
	ds_chain_node * tail;
	
	// functions
	struct {
		ds_assign_func   assign;
		ds_erase_func    erase;
		ds_compare_func  compare;
	} fn;
	// blocks
	struct {
		ds_assign_block  assign;
		ds_erase_block   erase;
		ds_compare_block compare;
	} bk;
} ds_chain_table;

/**
 *  create a chain table
 */
ds_chain_table * ds_chain_create(ds_size data_size);

/**
 *  destroy a chain table
 */
void ds_chain_destroy(ds_chain_table * chain);

/**
 *  insert data after the node, if (node == NULL) then insert as head node
 */
void ds_chain_insert(ds_chain_table * chain, const ds_type * data, ds_chain_node * node);

/**
 *  get length of the chain
 */
ds_size ds_chain_length(const ds_chain_table * chain);

/**
 *  get node at index of the chain
 */
ds_chain_node * ds_chain_at(const ds_chain_table * chain, ds_size index);

/**
 *  get first node has the same data value
 */
ds_chain_node * ds_chain_first(const ds_chain_table * chain, const ds_type * data);

/**
 *  remove the chain node
 */
void ds_chain_remove(ds_chain_table * chain, ds_chain_node * node);

/**
 *  sort the chain
 */
void ds_chain_sort(ds_chain_table * chain);

/**
 *  insert data to the right position to keep the chain sorted
 */
void ds_chain_sort_insert(ds_chain_table * chain, const ds_type * data);

/**
 *  reverse the chain
 */
void ds_chain_reverse(ds_chain_table * chain);

/**
 *  copy chain
 */
ds_chain_table * ds_chain_copy(const ds_chain_table * chain);

#endif /* defined(__ds_chain__) */
