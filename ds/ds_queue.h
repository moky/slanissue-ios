//
//  ds_queue.h
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef __ds_queue__
#define __ds_queue__

#include "ds_base.h"

#define ds_queue_at(queue, index)                                              \
    ({                                                                         \
        ds_byte * __ptr = (ds_byte *)((queue)->items);                         \
        (ds_type *)(__ptr + (queue)->item_size *                               \
            (((queue)->head + (index)) < (queue)->capacity ?                   \
                (queue)->head + (index) :                                      \
                (queue)->head + (index) - (queue)->capacity));                 \
    })                                                                         \
                                                         /* EOF 'ds_queue_at' */

#define DS_FOR_EACH_QUEUE_ITEM(queue, item, index)                             \
    for ((index) = 0;                                                          \
         (item) = (__typeof__(item))ds_queue_at(queue, index),                 \
             (index) < ds_queue_length(queue);                                 \
         ++(index))                                                            \
                                              /* EOF 'DS_FOR_EACH_QUEUE_ITEM' */

#define DS_FOR_EACH_QUEUE_ITEM_REVERSE(array, item, index)                     \
    for ((index) = ds_queue_length(queue);                                     \
         (item) = (__typeof__(item))ds_queue_at(queue, (index) - 1),           \
             (index)-- > 0;                                                    \
         )                                                                     \
                                      /* EOF 'DS_FOR_EACH_QUEUE_ITEM_REVERSE' */

//
//  Notice:
//      1. For improving performance, the data maybe saved circularly,
//         so please don't access it as an array.
//      2. For circularly algorithm needs, there is ONE space(s) never be used
//         in the 'queue->items', so 'ds_queue_length(queue)' will always smaller
//         than the 'queue->capacity'
//
typedef struct _ds_queue {
	
	ds_size capacity; // max length of items (ONE item space never used)
	
	ds_size item_size;
	ds_type * items;
	
	ds_size head, tail; // offsets for head/tail pointer
	
	// functions
	struct {
		ds_assign_func   assign;
		ds_erase_func    erase;
	} fn;
	// blocks
	struct {
		ds_assign_block  assign;
		ds_erase_block   erase;
	} bk;
} ds_queue;

/**
 *  create a queue struct with item size and capacity
 */
ds_queue * ds_queue_create(ds_size item_size, ds_size capacity);

/**
 *  destroy a queue struct and erase all items
 */
void ds_queue_destroy(ds_queue * queue);

/**
 *  get item count
 */
ds_size ds_queue_length(const ds_queue * queue);

/**
 *  append item to tail of the queue
 */
void ds_queue_enqueue(ds_queue * queue, const ds_type * item);

/**
 *  return head item and remove it (but NOT erase)
 */
ds_type * ds_queue_dequeue(ds_queue * queue);

/**
 *  copy queue, the new_queue->capacity = ds_queue_length(queue) + 1
 *              the new_queue->head = 0
 */
ds_queue * ds_queue_copy(const ds_queue * queue);

#endif /* defined(__ds_queue__) */
