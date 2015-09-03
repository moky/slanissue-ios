//
//  ds_base.c
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <string.h>

#include "ds_base.h"

#define DS_ITEM(index)     (ds_type *)(array + (index) * item_size)
#define DS_COPY(dest, src) memcpy((dest), (src), item_size)

// Quick Sort

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

// Bubble Sort

void ds_bsort(ds_byte * array, const ds_size item_size, const ds_size count,
			  ds_compare_func compare)
{
	ds_compare_block block = ^int(const ds_type * ptr1, const ds_type * ptr2) {
		return compare(ptr1, ptr2);
	};
	ds_bsort_b(array, item_size, count, block);
}

void ds_bsort_b(ds_byte * array, const ds_size item_size, const ds_size count,
				ds_compare_block compare)
{
	ds_size i, j;
	ds_byte *pi, *pj;
	
	ds_type * tmp = (ds_type *)malloc(item_size);
	
	for (i = 0, pi = array; i < count; ++i, pi += item_size) {
		for (j = i + 1, pj = pi + item_size; j < count; ++j, pj += item_size) {
			if (compare((ds_type *)pi, (ds_type *)pj) > 0) {
				// swap pi & pj
				memcpy(tmp, pi, item_size);
				memcpy(pi, pj, item_size);
				memcpy(pj, tmp, item_size);
			}
		}
	}
	
	free(tmp);
}
