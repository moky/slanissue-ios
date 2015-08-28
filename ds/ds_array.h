//
//  ds_array.h
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef __ds_array__
#define __ds_array__

#include "ds_base.h"

#define DS_FOR_EACH_ARRAY_ITEM(array, item, index)                             \
    for (ds_byte * __ptr = ((index) = 0, (ds_byte *)(array)->items);           \
         (item) = (__typeof__(item))__ptr, (index) < (array)->count;           \
         __ptr += (array)->item_size, ++(index))                               \
                                              /* EOF 'DS_FOR_EACH_ARRAY_ITEM' */

#define DS_FOR_EACH_ARRAY_ITEM_REVERSE(array, item, index)                     \
    for (ds_byte * __ptr = ((index) = (array)->count,                          \
                            (ds_byte *)((array)->items)                        \
                                  + ((index) - 1) * (array)->item_size);       \
         (item) = (__typeof__(item))__ptr, (index)-- > 0;                      \
         __ptr -= (array)->item_size)                                          \
                                      /* EOF 'DS_FOR_EACH_ARRAY_ITEM_REVERSE' */

typedef struct _ds_array {
	
	ds_size capacity; // max count of items
	ds_size count;
	
	ds_size item_size;
	ds_type * items;
	
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
} ds_array;

/**
 *  create an array struct with item size and capacity
 */
ds_array * ds_array_create(ds_size item_size, ds_size capacity);

/**
 *  destroy an array struct and erase all items
 */
void ds_array_destroy(ds_array * array);

/**
 *  get item at index of the array
 */
ds_type * ds_array_at(const ds_array * array, ds_size index);

/**
 *  append an item to the tail of the array
 */
void ds_array_add(ds_array * array, const ds_type * item);

/**
 *  insert an item into the index of the array
 */
void ds_array_insert(ds_array * array, const ds_type * item, ds_size index);

/**
 *  remove the item at index of the array
 */
void ds_array_remove(ds_array * array, ds_size index);

/**
 *  sort the array with compare function/block if given
 */
void ds_array_sort(ds_array * array);

/**
 *  insert the item at the right index of the array to keep it sorted
 */
void ds_array_sort_insert(ds_array * array, const ds_type * item);

/**
 *  copy array, the new_array->capacity == old_array->count
 */
ds_array * ds_array_copy(const ds_array * array);

#endif /* defined(__ds_array__) */
