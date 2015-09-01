//
//  ds_base.c
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <string.h>

#include "ds_base.h"

// default type: unsigned long
void ds_assign(ds_type * dest, const ds_type * src, const ds_size size)
{
	memcpy(dest, src, size);
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

// int
void ds_assign_int(ds_type * dest, const ds_type * src, const ds_size size)
{
	int * p = (int *)dest;
	int * v = (int *)src;
	*p = *v;
}

int ds_compare_int(const ds_type * ptr1, const ds_type * ptr2)
{
	int * p1 = (int *)ptr1;
	int * p2 = (int *)ptr2;
	if (*p1 > *p2) {
		return 1;
	} else if (*p1 < *p2) {
		return -1;
	} else {
		return 0;
	}
}

// float
void ds_assign_float(ds_type * dest, const ds_type * src, const ds_size size)
{
	float * p = (float *)dest;
	float * v = (float *)src;
	*p = *v;
}

int ds_compare_float(const ds_type * ptr1, const ds_type * ptr2)
{
	float * p1 = (float *)ptr1;
	float * p2 = (float *)ptr2;
	if (*p1 > *p2) {
		return 1;
	} else if (*p1 < *p2) {
		return -1;
	} else {
		return 0;
	}
}

#pragma mark - Quick Sort

#define DS_ITEM(index)     (ds_type *)(array + (index) * item_size)
#define DS_COPY(dest, src) memcpy((dest), (src), item_size)

void ds_qsort(ds_byte * array, const ds_size item_size,
			  const ds_size first, const ds_size last,
			  ds_compare_func compare)
{
	ds_compare_block block = ^int(const ds_type * ptr1, const ds_type * ptr2) {
		return compare(ptr1, ptr2);
	};
	ds_qsort_b(array, item_size, first, last, block);
}

void ds_qsort_b(ds_byte * array, const ds_size item_size,
				const ds_size first, const ds_size last,
				ds_compare_block compare)
{
	ds_size left = first;
	ds_size right = last;
	
	ds_type * key = (ds_type *)malloc(item_size);
	
	// 1. take the first item as key item
	DS_COPY(key, DS_ITEM(left));
	
	// 2. sort in range
	while (1) {
		// seeking from right
		while (left < right && compare(DS_ITEM(right), key) >= 0) {
			--right;
		}
		if (left >= right) {
			break; // finished
		}
		DS_COPY(DS_ITEM(left), DS_ITEM(right)); // move the smaller to left
		
		++left; // already compared, skip it
		
		// seeking from left
		while (left < right && compare(DS_ITEM(left), key) <= 0) {
			++left;
		}
		if (left >= right) {
			break; // finished
		}
		DS_COPY(DS_ITEM(right), DS_ITEM(left)); // move the bigger to right
		
		--right; // already compared, skip it
	}
	
	// 3. put back the key item
	if (first < left) {
		DS_COPY(DS_ITEM(left), key);
	}
	
	// 4. sort left part
	if (first + 1 < left) {
		ds_qsort_b(array, item_size, first, left - 1, compare);
	}
	// 5. sort right part
	if (left + 1 < last) {
		ds_qsort_b(array, item_size, left + 1, last, compare);
	}
	
	free(key);
}
