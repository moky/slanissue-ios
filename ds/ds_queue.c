//
//  ds_queue.c
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "ds_queue.h"

static inline void _expand(ds_queue * queue)
{
	ds_size middle = queue->capacity;
	queue->capacity *= 2;
	queue->items = (ds_type *)realloc(queue->items, queue->capacity * queue->item_size);
	
	// move part 2 of items
	if (queue->tail < queue ->head) {
		// cycled queue
		if (queue->tail == 0) {
			// part 2 is empty, move tail pointer
			queue->tail = middle;
		} else {
			// move the part 2 to new zone(connected to part 1)
			ds_byte * src = (ds_byte *)queue->items;
			ds_byte * dest = src + middle * queue->item_size;
			memcpy(dest, src, queue->tail * queue->item_size);
			// move tail pointer
			queue->tail += middle;
		}
	}
}

static inline void _assign(const ds_queue * queue, ds_type * desc, const ds_type * src)
{
	if (queue->fn.assign) {
		queue->fn.assign(desc, src, queue->item_size);
	} else if (queue->bk.assign) {
		queue->bk.assign(desc, src, queue->item_size);
	} else {
		ds_assign(desc, src, queue->item_size);
	}
}

static inline void _erase(const ds_queue * queue, ds_type * ptr)
{
	if (queue->fn.erase) {
		queue->fn.erase(ptr, queue->item_size);
	} else if (queue->bk.erase) {
		queue->bk.erase(ptr, queue->item_size);
	} else {
		ds_erase(ptr, queue->item_size);
	}
}

static inline void _erase_all(ds_queue * queue)
{
	ds_type * item = NULL;
	while ((item = ds_queue_dequeue(queue))) {
		_erase(queue, item);
	}
}

#pragma mark -

ds_queue * ds_queue_create(ds_size item_size, ds_size capacity)
{
	ds_queue * queue = (ds_queue *)malloc(sizeof(ds_queue));
	memset(queue, 0, sizeof(ds_queue));
	queue->capacity = capacity > 0 ? capacity : 16;
	queue->item_size = item_size > 0 ? item_size : sizeof(ds_type);
	queue->items = (ds_type *)calloc(queue->capacity, queue->item_size);
	return queue;
}

void ds_queue_destroy(ds_queue * queue)
{
	_erase_all(queue);
	free(queue->items);
	queue->items = NULL;
	free(queue);
}

ds_size ds_queue_length(const ds_queue * queue)
{
	if (queue->tail < queue->head) {
		return queue->capacity - queue->head + queue->tail;
	} else {
		return queue->tail - queue->head;
	}
}

void ds_queue_enqueue(ds_queue * queue, const ds_type * item)
{
	ds_size count = ds_queue_length(queue);
	if (count + 1 >= queue->capacity) {
		// only ONE space left, expand the queue
		_expand(queue);
	}
	
	// append item to tail
	ds_byte * ptr = (ds_byte *)queue->items;
	ptr += queue->tail * queue->item_size;
	_assign(queue, (ds_type *)ptr, item);
	
	// move the tail circularly
	queue->tail += 1;
	if (queue->tail >= queue->capacity) {
		queue->tail = 0;
	}
}

ds_type * ds_queue_dequeue(ds_queue * queue)
{
	if (queue->head == queue->tail) {
		// empty queue
		return NULL;
	}
	
	// remove the head item
	ds_byte * ptr = (ds_byte *)queue->items;
	ptr += queue->head * queue->item_size;
	//_erase(queue, (ds_type *)ptr, queue->item_size);
	
	// circularly
	queue->head += 1;
	if (queue->head >= queue->capacity) {
		queue->head = 0;
	}
	
	return (ds_type *)ptr;
}

ds_queue * ds_queue_copy(const ds_queue * queue)
{
	ds_size capacity = ds_queue_length(queue) + 1;
	ds_queue * new_queue = ds_queue_create(queue->item_size, capacity);
	
	new_queue->fn.assign = queue->fn.assign;
	new_queue->fn.erase  = queue->fn.erase;
	new_queue->bk.assign = queue->bk.assign;
	new_queue->bk.erase  = queue->bk.erase;
	
	ds_type * item;
	ds_size index;
	DS_FOR_EACH_QUEUE_ITEM(queue, item, index) {
		ds_queue_enqueue(new_queue, item);
	}
	
	return new_queue;
}
