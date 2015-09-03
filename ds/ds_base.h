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
typedef void (*ds_assign_func)(ds_type * dest, const ds_type * src);
typedef void (*ds_erase_func)(ds_type * ptr);
typedef int (*ds_compare_func)(const ds_type * ptr1, const ds_type * ptr2);

//
//  blocks
//
typedef void (^ds_assign_block)(ds_type * dest, const ds_type * src);
typedef void (^ds_erase_block)(ds_type * ptr);
typedef int (^ds_compare_block)(const ds_type * ptr1, const ds_type * ptr2);


// templates
#define ds_assign_bt(T) ^void(ds_type * dest, const ds_type * src) {           \
            T * p = (T *)dest;                                                 \
            T * v = (T *)src;                                                  \
            *p = *v;                                                           \
        }                                                                      \
                                                        /* EOF 'ds_assign_bt' */
#define ds_compare_bt(T) ^int(const ds_type * ptr1, const ds_type * ptr2) {    \
            T * p1 = (T *)ptr1;                                                \
            T * p2 = (T *)ptr2;                                                \
            if (*p1 > *p2) {                                                   \
                return 1;                                                      \
            } else if (*p1 < *p2) {                                            \
                return -1;                                                     \
            } else {                                                           \
                return 0;                                                      \
            }                                                                  \
        }                                                                      \
                                                       /* EOF 'ds_compare_bt' */

// base type
#define ds_assign_b         ds_assign_bt(ds_type)
#define ds_compare_b        ds_compare_bt(ds_type)

// char
#define ds_assign_char_b    ds_assign_bt(char)
#define ds_compare_char_b   ds_compare_bt(char)
// unsigned char
#define ds_assign_uchar_b   ds_assign_bt(unsigned char)
#define ds_compare_uchar_b  ds_compare_bt(unsigned char)

// short
#define ds_assign_short_b   ds_assign_bt(short)
#define ds_compare_short_b  ds_compare_bt(short)
// unsigned short
#define ds_assign_ushort_b  ds_assign_bt(unsigned short)
#define ds_compare_ushort_b ds_compare_bt(unsigned short)

// int
#define ds_assign_int_b     ds_assign_bt(int)
#define ds_compare_int_b    ds_compare_bt(int)
// unsigned int
#define ds_assign_uint_b    ds_assign_bt(unsigned int)
#define ds_compare_uint_b   ds_compare_bt(unsigned int)

// long
#define ds_assign_long_b    ds_assign_bt(long)
#define ds_compare_long_b   ds_compare_bt(long)
// unsigned long
#define ds_assign_ulong_b   ds_assign_bt(unsigned long)
#define ds_compare_ulong_b  ds_compare_bt(unsigned long)

// float
#define ds_assign_float_b   ds_assign_bt(float)
#define ds_compare_float_b  ds_compare_bt(float)


#pragma mark - Sort


// Quick Sort

void ds_qsort(ds_byte * array, const ds_size item_size,
			  const ds_size first, const ds_size last,
			  ds_compare_func compare);

void ds_qsort_b(ds_byte * array, const ds_size item_size,
				const ds_size first, const ds_size last,
				ds_compare_block compare);

// Bubble Sort

void ds_bsort(ds_byte * array, const ds_size item_size, const ds_size count,
			  ds_compare_func compare);

void ds_bsort_b(ds_byte * array, const ds_size item_size, const ds_size count,
				ds_compare_block compare);

#endif /* defined(__ds_base__) */
