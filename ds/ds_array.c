//
//  ds_array.c
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "ds_array.h"

static inline void _expand(ds_array * array)
{
	array->capacity *= 2;
	array->items = (ds_type *)realloc(array->items, array->capacity * array->item_size);
}

static inline void _assign(const ds_array * array, ds_type * desc, const ds_type * src)
{
	if (array->fn.assign) {
		array->fn.assign(desc, src, array->item_size);
	} else if (array->bk.assign) {
		array->bk.assign(desc, src, array->item_size);
	} else {
		ds_assign(desc, src, array->item_size);
	}
}

static inline void _erase(const ds_array * array, ds_type * ptr)
{
	if (array->fn.erase) {
		array->fn.erase(ptr, array->item_size);
	} else if (array->bk.erase) {
		array->bk.erase(ptr, array->item_size);
	} else {
		ds_erase(ptr, array->item_size);
	}
}

static inline void _erase_all(ds_array * array)
{
	if (array->count == 0) {
		return;
	}
	ds_byte * ptr = (ds_byte *)array->items;
	ptr += array->count * array->item_size;
	if (array->fn.erase) {
		for (; array->count > 0; --(array->count)) {
			ptr -= array->item_size;
			array->fn.erase((ds_type *)ptr, array->item_size);
		}
	} else if (array->bk.erase) {
		for (; array->count > 0; --(array->count)) {
			ptr -= array->item_size;
			array->bk.erase((ds_type *)ptr, array->item_size);
		}
	} else {
		for (; array->count > 0; --(array->count)) {
			ptr -= array->item_size;
			ds_erase((ds_type *)ptr, array->item_size);
		}
	}
}

#pragma mark -

ds_array * ds_array_create(ds_size item_size, ds_size capacity)
{
	ds_array * array = (ds_array *)malloc(sizeof(ds_array));
	memset(array, 0, sizeof(ds_array));
	array->capacity = capacity > 0 ? capacity : 16;
	array->item_size = item_size > 0 ? item_size : sizeof(ds_type);
	array->items = (ds_type *)calloc(array->capacity, array->item_size);
	return array;
}

void ds_array_destroy(ds_array * array)
{
	_erase_all(array);
	free(array->items);
	array->items = NULL;
	free(array);
}

ds_type * ds_array_at(const ds_array * array, ds_size index)
{
	if (index >= array->count) {
		return NULL;
	}
	ds_byte * ptr = (ds_byte *)array->items;
	ptr += index * array->item_size;
	return (ds_type *)ptr;
}

void ds_array_add(ds_array * array, const ds_type * item)
{
	if (array->count >= array->capacity) {
		_expand(array);
	}
	
	// append item to tail
	ds_byte * ptr = (ds_byte *)array->items;
	ptr += array->count * array->item_size;
	_assign(array, (ds_type *)ptr, item);
	
	array->count += 1;
}

void ds_array_insert(ds_array * array, const ds_type * item, ds_size index)
{
	if (index >= array->count) {
		ds_array_add(array, item);
		return;
	}
	if (array->count >= array->capacity) {
		_expand(array);
	}
	
	ds_byte * dest = (ds_byte *)array->items;
	dest += index * array->item_size;
	
	// 1. move the rest data backwords from index
	ds_byte * rest = dest + array->item_size;
	ds_size len = (array->count - index) * array->item_size;
	memmove(rest, dest, len);
	
	// 2. insert item at index
	_assign(array, (ds_type *)dest, item);
	array->count += 1;
}

void ds_array_remove(ds_array * array, ds_size index)
{
	if (index >= array->count) {
		//S9Log(@"index out of range: %u > %u", (unsigned int)index, (unsigned int)array->count);
		return;
	}
	
	// 1. erase the item at index
	ds_byte * ptr = (ds_byte *)array->items;
	ptr += index * array->item_size;
	_erase(array, (ds_type *)ptr);
	
	// 2. move the rest data forwards to index
	if (++index < array->count) {
		ds_byte * rest = ptr + array->item_size;
		ds_size len = (array->count - index) * array->item_size;
		memmove(ptr, rest, len);
	}
	
	array->count -= 1;
}

void ds_array_sort(ds_array * array)
{
	ds_type * tmp = (ds_type *)malloc(array->item_size);
	memset(tmp, 0, array->item_size);
	
	if (array->fn.compare && array->fn.assign)
	{
		ds_qsort((ds_byte *)array->items, array->item_size,
				 0, array->count - 1,
				 array->fn.compare, array->fn.assign, tmp);
	}
	else if (array->bk.compare && array->bk.assign)
	{
		ds_qsort_b((ds_byte *)array->items, array->item_size,
				   0, array->count - 1,
				   array->bk.compare, array->bk.assign, tmp);
	}
	else
	{
		ds_qsort((ds_byte *)array->items, array->item_size,
				 0, array->count - 1,
				 ds_compare, ds_assign, tmp);
	}
	
	_erase(array, tmp);
	free(tmp);
}

void ds_array_sort_insert(ds_array * array, const ds_type * item)
{
	ds_type * data;
	ds_type index;
	
	// 1. seek for index
	if (array->fn.compare) {
		DS_FOR_EACH_ARRAY_ITEM_REVERSE(array, data, index) {
			if (array->fn.compare(data, item) <= 0) {
				break; // got it
			}
		}
	} else if (array->bk.compare) {
		DS_FOR_EACH_ARRAY_ITEM_REVERSE(array, data, index) {
			if (array->bk.compare(data, item) <= 0) {
				break; // got it
			}
		}
	} else {
		DS_FOR_EACH_ARRAY_ITEM_REVERSE(array, data, index) {
			if (ds_compare(data, item) <= 0) {
				break; // got it
			}
		}
	}
	
	// 2. the item at index is smaller(or equal), insert after it
	ds_array_insert(array, item, index + 1);
}

ds_array * ds_array_copy(const ds_array * array)
{
	ds_size capacity = array->count;
	ds_array * new_array = ds_array_create(array->item_size, capacity);
	
	new_array->fn.assign  = array->fn.assign;
	new_array->fn.erase   = array->fn.erase;
	new_array->fn.compare = array->fn.compare;
	new_array->bk.assign  = array->bk.assign;
	new_array->bk.erase   = array->bk.erase;
	new_array->bk.compare = array->bk.compare;
	
	ds_type * item;
	ds_size index;
	DS_FOR_EACH_ARRAY_ITEM(array, item, index) {
		ds_array_add(new_array, item);
	}
	
	return new_array;
}
