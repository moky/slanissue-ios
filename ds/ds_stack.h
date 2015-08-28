//
//  ds_stack.h
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef __ds_stack__
#define __ds_stack__

#include "ds_array.h"

#define DS_FOR_EACH_STACK_ITEM(stack, item, index)                             \
        DS_FOR_EACH_ARRAY_ITEM(stack, item, index)                             \
                                              /* EOF 'DS_FOR_EACH_STACK_ITEM' */

#define DS_FOR_EACH_STACK_ITEM_REVERSE(stack, item, index)                     \
        DS_FOR_EACH_ARRAY_ITEM_REVERSE(stack, item, index)                     \
                                      /* EOF 'DS_FOR_EACH_ARRAY_ITEM_REVERSE' */

typedef ds_array ds_stack;

/**
 *  create a stack struct with item size and capacity
 */
ds_stack * ds_stack_create(ds_size item_size, ds_size capacity);

/**
 *  destroy the stack struct and erase all items
 */
void ds_stack_destroy(ds_stack * stack);

/**
 *  push item to top of stack
 */
void ds_stack_push(ds_stack * stack, const ds_type * item);

/**
 *  return top item and remove it (but NOT erase)
 */
ds_type * ds_stack_pop(ds_stack * stack);

/**
 *  return top item
 */
ds_type * ds_stack_top(const ds_stack * stack);

/**
 *  copy stack, the new_stack->capacity = old_stack->count
 */
ds_stack * ds_stack_copy(const ds_stack * stack);

#endif /* defined(__ds_stack__) */
