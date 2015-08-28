//
//  ds_chain.c
//  SlanissueToolkit
//
//  Created by Moky on 15-8-25.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "ds_chain.h"

static inline void _assign(const ds_chain_table * chain, ds_type * desc, const ds_type * src)
{
	if (chain->fn.assign) {
		chain->fn.assign(desc, src, chain->data_size);
	} else if (chain->bk.assign) {
		chain->bk.assign(desc, src, chain->data_size);
	} else {
		ds_assign(desc, src, chain->data_size);
	}
}

static inline void _erase(const ds_chain_table * chain, ds_type * ptr)
{
	if (chain->fn.erase) {
		chain->fn.erase(ptr, chain->data_size);
	} else if (chain->bk.erase) {
		chain->bk.erase(ptr, chain->data_size);
	} else {
		ds_erase(ptr, chain->data_size);
	}
}

static inline ds_chain_node * _create(ds_chain_table * chain, const ds_type * data)
{
	// 1. create a buffer for the whole struct and data memory
	ds_size len = sizeof(ds_chain_node) + chain->data_size;
	ds_byte * ptr = malloc(len);
	memset(ptr, 0, len);
	
	// 2. allocate memories
	//    the first part (size = sizeof(ds_chain_node)) to store the node struct
	//    the rest part (size = chain->data_size) to store the data
	ds_chain_node * node = (ds_chain_node *)ptr;
	node->data = (ds_type *)(ptr + sizeof(ds_chain_node));
	
	// 3. assign data
	_assign(chain, node->data, data);
	return node;
}

static inline void _destroy(const ds_chain_table * chain, ds_chain_node * node)
{
	_erase(chain, node->data);
	free(node);
}

static inline void _erase_all(ds_chain_table * chain)
{
	for (ds_chain_node * next; chain->head; chain->head = next) {
		next = chain->head->next;
		_destroy(chain, chain->head);
	}
	// chain->head is NULL already, now clear chain->tail
	chain->tail = NULL;
}

#pragma mark -

ds_chain_table * ds_chain_create(ds_size data_size)
{
	ds_chain_table * chain = (ds_chain_table *)malloc(sizeof(ds_chain_table));
	memset(chain, 0, sizeof(ds_chain_table));
	chain->data_size = data_size > 0 ? data_size : sizeof(ds_type);
	return chain;
}

void ds_chain_destroy(ds_chain_table * chain)
{
	_erase_all(chain);
	free(chain);
}

void ds_chain_insert(ds_chain_table * chain, const ds_type * data, ds_chain_node * node)
{
	// 1. create new node and assign value
	ds_chain_node * guest = _create(chain, data);
	
	// 2. insert
	if (node) {
		// after the node
		guest->next = node->next;
		node->next = guest;
	} else {
		// as head node
		guest->next = chain->head;
		chain->head = guest;
	}
	
	// 3. check tail
	if (node == chain->tail) {
		chain->tail = guest;
	}
}

ds_size ds_chain_length(const ds_chain_table * chain)
{
	ds_size len = 0;
	ds_chain_node * node = chain->head;
	for (; node; node = node->next) {
		++len;
	}
	return len;
}

ds_chain_node * ds_chain_at(const ds_chain_table * chain, ds_size index)
{
	ds_chain_node * node;
	DS_FOR_EACH_CHAIN_NODE(chain, node) {
		if (index == 0) {
			break;
		}
		--index;
	}
	return node;
}

ds_chain_node * ds_chain_first(const ds_chain_table * chain, const ds_type * data)
{
	ds_chain_node * node;
	if (chain->fn.compare) {
		DS_FOR_EACH_CHAIN_NODE(chain, node) {
			if (chain->fn.compare(node->data, data) == 0) {
				return node;
			}
		}
	} else if (chain->bk.compare) {
		DS_FOR_EACH_CHAIN_NODE(chain, node) {
			if (chain->bk.compare(node->data, data) == 0) {
				return node;
			}
		}
	} else {
		DS_FOR_EACH_CHAIN_NODE(chain, node) {
			if (ds_compare(node->data, data) == 0) {
				return node;
			}
		}
	}
	return NULL;
}

void ds_chain_remove(ds_chain_table * chain, ds_chain_node * node)
{
	if (node == chain->head) {
		chain->head = node->next;
	} else {
		ds_chain_node * prev;
		DS_FOR_EACH_CHAIN_NODE(chain, prev) {
			if (prev->next == node) {
				// got it
				prev->next = node->next;
				// check tail
				if (node == chain->tail) {
					chain->tail = prev;
				}
				break;
			}
		}
		//assert(prev, "node not found");
	}
	_destroy(chain, node);
}

void ds_chain_sort(ds_chain_table * chain)
{
	if (chain->head == NULL || chain->head->next == NULL) {
		// 1. the chain is empty
		// 2. the chain has only one node
		return;
	}
	
	//
	//  Bubble Sort
	//
	ds_chain_node * pi = chain->head;
	ds_chain_node * pj;
	
	ds_type * tmp = (ds_type *)malloc(chain->data_size);
	memset(tmp, 0, chain->data_size);
	
	if (chain->fn.compare && chain->fn.assign) {
		for (; pi; pi = pi->next) {
			pj = pi->next;
			for (; pj; pj = pj->next) {
				if (chain->fn.compare(pi->data, pj->data) > 0) {
					chain->fn.assign(tmp, pi->data, chain->data_size);
					chain->fn.assign(pi->data, pj->data, chain->data_size);
					chain->fn.assign(pj->data, tmp, chain->data_size);
				}
			}
		}
	} else if (chain->bk.compare && chain->bk.assign) {
		for (; pi; pi = pi->next) {
			pj = pi->next;
			for (; pj; pj = pj->next) {
				if (chain->bk.compare(pi->data, pj->data) > 0) {
					chain->bk.assign(tmp, pi->data, chain->data_size);
					chain->bk.assign(pi->data, pj->data, chain->data_size);
					chain->bk.assign(pj->data, tmp, chain->data_size);
				}
			}
		}
	} else {
		for (; pi; pi = pi->next) {
			pj = pi->next;
			for (; pj; pj = pj->next) {
				if (ds_compare(pi->data, pj->data) > 0) {
					ds_assign(tmp, pi->data, chain->data_size);
					ds_assign(pi->data, pj->data, chain->data_size);
					ds_assign(pj->data, tmp, chain->data_size);
				}
			}
		}
	}
	
	_erase(chain, tmp);
	free(tmp);
}

void ds_chain_sort_insert(ds_chain_table * chain, const ds_type * data)
{
	// 1. seek
	ds_chain_node * node;
	if (chain->fn.compare) {
		DS_FOR_EACH_CHAIN_NODE(chain, node) {
			if (node->next && chain->fn.compare(node->next->data, data) > 0) {
				break;
			}
		}
	} else if (chain->bk.compare) {
		DS_FOR_EACH_CHAIN_NODE(chain, node) {
			if (node->next && chain->bk.compare(node->next->data, data) > 0) {
				break;
			}
		}
	} else {
		DS_FOR_EACH_CHAIN_NODE(chain, node) {
			if (node->next && ds_compare(node->next->data, data) > 0) {
				break;
			}
		}
	}
	// 2. insert
	ds_chain_insert(chain, data, node);
}

void ds_chain_reverse(ds_chain_table * chain)
{
	if (chain->head == NULL || chain->head->next == NULL) {
		// 1. the chain is empty
		// 2. the chain has only one node
		return;
	}
	ds_chain_node * prev = chain->head;
	ds_chain_node * node = prev->next;
	ds_chain_node * next;
	for (; node->next; node = next) {
		next = node->next;
		node->next = prev;
		prev = node;
	}
	
	// change head & tail node
	//assert(chain->tail = node, "error");
	chain->tail = chain->head;
	chain->head = node;
}

ds_chain_table * ds_chain_copy(const ds_chain_table * chain)
{
	ds_chain_table * new_chain = ds_chain_create(chain->data_size);
	
	new_chain->fn.assign  = chain->fn.assign;
	new_chain->fn.erase   = chain->fn.erase;
	new_chain->fn.compare = chain->fn.compare;
	new_chain->bk.assign  = chain->bk.assign;
	new_chain->bk.erase   = chain->bk.erase;
	new_chain->bk.compare = chain->bk.compare;
	
	ds_chain_node * node;
	DS_FOR_EACH_CHAIN_NODE(chain, node) {
		// insert data after the new chain's tail
		ds_chain_insert(new_chain, node->data, new_chain->tail);
	}
	
	return new_chain;
}
