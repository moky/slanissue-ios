//
//  mof_data.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __mof_data__
#define __mof_data__

#include "mof_protocol.h"

mof_data * mof_create (const mof_uint buf_len); // create an initialized buffer
void       mof_destroy(void * data); // destroy a buffer

mof_int mof_check (const mof_data * data); // check data format, 0 means correct

#pragma mark - Input/Output

const mof_data * mof_load(const char * __restrict filename);
mof_int          mof_save(const char * __restrict filename, const mof_data * data);

#pragma mark - getters

const mof_data_item * mof_item(const mof_uint index, const mof_data * data); // get item with global index
const mof_data_item * mof_root(const mof_data * data); // get root item (the first item)

const mof_data_item * mof_items_start(const mof_data * data); // get first item
const mof_data_item * mof_items_end  (const mof_data * data); // get tail of items (next of the last item)

#pragma mark values

mof_string mof_get_key    (const mof_data_item * item, const mof_data * data); // get key with item (for dictionary)
mof_string mof_get_str    (const mof_data_item * item, const mof_data * data); // get string with item

mof_int    mof_int_value  (const mof_data_item * item); // get integer with item
mof_uint   mof_uint_value (const mof_data_item * item); // get unsigned integer with item
mof_float  mof_float_value(const mof_data_item * item); // get float with item
mof_bool   mof_bool_value (const mof_data_item * item); // get bool with item

#endif /* defined(__mof_data__) */
