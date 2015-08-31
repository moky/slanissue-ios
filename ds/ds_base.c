//
//  ds_base.c
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <string.h>

#include "ds_base.h"

// void
void ds_assign(ds_type * desc, const ds_type * src, const ds_size size)
{
	memcpy(desc, src, size);
}

void ds_erase(ds_type * ptr, const ds_size size)
{
	memset(ptr, 0, size);
}

int ds_compare(const ds_type * ptr1, const ds_type * ptr2)
{
	if (*ptr1 > *ptr2) {
		return 1;
	} else if (*ptr1 < *ptr2) {
		return -1;
	} else {
		return 0;
	}
}

#pragma mark - Quick Sort

#define DS_ITEM(index)     (ds_type *)(array + (index) * item_size)

void ds_qsort(ds_byte * array, const ds_size item_size,
			  const ds_size left, const ds_size right,
			  ds_compare_func cmp, ds_assign_func assign, ds_type * swap_space)
{
	ds_size first = left;
	ds_size last = right;
	
	// 1. take the first item as key item
	assign(swap_space, DS_ITEM(first), item_size);
	
	// 2. sort in range
	while (first < last) {
		while (first < last && cmp(DS_ITEM(last), swap_space) >= 0) {
			--last;
		}
		assign(DS_ITEM(first), DS_ITEM(last), item_size); // move the smaller item to left
		
		while (first < last && cmp(DS_ITEM(first), swap_space) <= 0) {
			++first;
		}
		assign(DS_ITEM(last), DS_ITEM(first), item_size); // move the bigger item to right
	}
	
	// 3. put back the key item
	assign(DS_ITEM(first), swap_space, item_size);
	
	// 4. sort left part
	if (left + 1 < first) {
		ds_qsort(array, item_size, left, first - 1, cmp, assign, swap_space);
	}
	// 5. sort right part
	if (first + 1 < right) {
		ds_qsort(array, item_size, first + 1, right, cmp, assign, swap_space);
	}
}

void ds_qsort_b(ds_byte * array, const ds_size item_size,
				const ds_size left, const ds_size right,
				ds_compare_block cmp, ds_assign_block assign, ds_type * swap_space)
{
	ds_size first = left;
	ds_size last = right;
	
	// 1. take the first item as key item
	assign(swap_space, DS_ITEM(first), item_size);
	
	// 2. sort in range
	while (first < last) {
		while (first < last && cmp(DS_ITEM(last), swap_space) >= 0) {
			--last;
		}
		assign(DS_ITEM(first), DS_ITEM(last), item_size); // move the smaller to left
		
		while (first < last && cmp(DS_ITEM(first), swap_space) <= 0) {
			++first;
		}
		assign(DS_ITEM(last), DS_ITEM(first), item_size); // move the bigger to right
	}
	
	// 3. put back the key item
	assign(DS_ITEM(first), swap_space, item_size);
	
	// 4. sort left part
	if (left + 1 < first) {
		ds_qsort_b(array, item_size, left, first - 1, cmp, assign, swap_space);
	}
	// 5. sort right part
	if (first + 1 < right) {
		ds_qsort_b(array, item_size, first + 1, right, cmp, assign, swap_space);
	}
}
