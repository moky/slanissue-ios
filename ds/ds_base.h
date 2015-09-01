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

//
//  default functions
//
void ds_assign(ds_type * dest, const ds_type * src, const ds_size size);
void ds_erase(ds_type * ptr, const ds_size size);
int ds_compare(const ds_type * ptr1, const ds_type * ptr2);

// int
void ds_assign_int(ds_type * dest, const ds_type * src, const ds_size size);
int ds_compare_int(const ds_type * ptr1, const ds_type * ptr2);

// float
void ds_assign_float(ds_type * dest, const ds_type * src, const ds_size size);
int ds_compare_float(const ds_type * ptr1, const ds_type * ptr2);

//
//  default blocks
//
#define ds_assign_b ^void(ds_type * dest, const ds_type * src, const ds_size size) { \
            memcpy(dest, src, size);                                           \
        }
#define ds_erase_b ^void(ds_type * ptr, const ds_size size) {                  \
            memset(ptr, 0, size);                                              \
        }
#define ds_compare_b ^int(const ds_type * ptr1, const ds_type * ptr2) {        \
            if (*ptr1 > *ptr2) {                                               \
                return 1;                                                      \
            } else if (*ptr1 < *ptr2) {                                        \
                return -1;                                                     \
            } else {                                                           \
                return 0;                                                      \
            }                                                                  \
        }

// int
#define ds_assign_int_b ^void(ds_type * dest, const ds_type * src, const ds_size size) { \
            int * p = (int *)dest;                                             \
            int * v = (int *)src;                                              \
            *p = *v;                                                           \
        }
#define ds_compare_int_b ^int(const ds_type * ptr1, const ds_type * ptr2) {    \
            int * p1 = (int *)ptr1;                                            \
            int * p2 = (int *)ptr2;                                            \
            if (*p1 > *p2) {                                                   \
                return 1;                                                      \
            } else if (*p1 < *p2) {                                            \
                return -1;                                                     \
            } else {                                                           \
                return 0;                                                      \
            }                                                                  \
        }

// float
#define ds_assign_float_b ^void(ds_type * dest, const ds_type * src, const ds_size size) { \
            float * p = (float *)dest;                                         \
            float * v = (float *)src;                                          \
            *p = *v;                                                           \
        }
#define ds_compare_float_b ^int(const ds_type * ptr1, const ds_type * ptr2) {  \
            float * p1 = (float *)ptr1;                                        \
            float * p2 = (float *)ptr2;                                        \
            if (*p1 > *p2) {                                                   \
                return 1;                                                      \
            } else if (*p1 < *p2) {                                            \
                return -1;                                                     \
            } else {                                                           \
                return 0;                                                      \
            }                                                                  \
        }

#pragma mark -


//
//  Sort
//

#pragma mark Quick Sort

void ds_qsort(ds_byte * array, const ds_size item_size,
			  const ds_size first, const ds_size last,
			  ds_compare_func compare);

void ds_qsort_b(ds_byte * array, const ds_size item_size,
				const ds_size first, const ds_size last,
				ds_compare_block compare);

#endif /* defined(__ds_base__) */
