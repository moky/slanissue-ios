//
//  ds_base.h
//  DataStructure
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef __ds_base__
#define __ds_base__

#include <stdlib.h>

typedef unsigned char ds_byte;
// base data type
typedef unsigned long ds_type;
// index/count/length
typedef unsigned long ds_size;

//
//  functions
//
typedef void (*ds_assign_func)(ds_type * dest, const ds_type * src, const ds_size size);
typedef void (*ds_erase_func)(ds_type * ptr, const ds_size size);
typedef int (*ds_compare_func)(const ds_type * ptr1, const ds_type * ptr2);

//
//  blocks
//
typedef void (^ds_assign_block)(ds_type * dest, const ds_type * src, const ds_size size);
typedef void (^ds_erase_block)(ds_type * ptr, const ds_size size);
typedef int (^ds_compare_block)(const ds_type * ptr1, const ds_type * ptr2);


// default functions
void ds_assign(ds_type * desc, const ds_type * src, const ds_size size);
void ds_erase(ds_type * ptr, const ds_size size);
int ds_compare(const ds_type * ptr1, const ds_type * ptr2);

//
//  Quick Sort
//
void ds_qsort(ds_byte * array, const ds_size item_size,
			  const ds_size first, const ds_size last,
			  ds_compare_func compare);

void ds_qsort_b(ds_byte * array, const ds_size item_size,
				const ds_size first, const ds_size last,
				ds_compare_block compare);

#endif /* defined(__ds_base__) */
