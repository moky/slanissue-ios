//
//  mof_data.c
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>

#include "mof_data.h"

#define MOF_VERSION     0x01
#define MOF_SUB_VERSION 0x01

#ifdef  NDEBUG
#	define MOF_LOG(...) do {} while(0)
#elif   DEBUG
#	define MOF_LOG(...)                                                        \
        printf("<mof_data.c:%d> %s ", __LINE__, __FUNCTION__);                 \
        printf(__VA_ARGS__);                                                   \
        printf("\n");                                                          \
                                                             /* EOF 'MOF_LOG' */
#else
#	define MOF_LOG(...) do {} while(0)
#endif

#ifndef NS_BLOCK_ASSERTIONS
#	define MOF_ASSERT(cond, ...)                                               \
        if (!(cond)) {                                                         \
            MOF_LOG(__VA_ARGS__);                                              \
            assert(cond);                                                      \
        }                                                                      \
                                                        /* EOF 'MOF_ASSERT()' */
#else
#	define MOF_ASSERT(cond, format, ...) do {} while(0)
#endif

// create initialized buffer
mof_data * mof_create(const mof_uint buf_len)
{
	if (buf_len <= sizeof(mof_data)) {
		MOF_ASSERT(MOFFalse, "buffer length error: %u", buf_len);
		return NULL;
	}
	
	unsigned char * buffer = (unsigned char *)malloc(buf_len);
	if (!buffer) {
		MOF_ASSERT(MOFFalse, "not enough memory: %u", buf_len);
		return NULL;
	}
	memset(buffer, 0, buf_len);
	
	// data
	mof_data * data = (mof_data *)buffer;
	
	// data head
	mof_data_head * head = &(data->head);
	
	//-- protocol
	head->format[0] = 'M';
	head->format[1] = 'O';
	head->format[2] = 'F';
	head->format[3] = '\0';
	
	head->version = MOF_VERSION;
	head->subVersion = MOF_SUB_VERSION;
	
	head->fileLength = buf_len;
	
	//-- info
	time_t now = time(NULL);
	struct tm * tm = gmtime(&now);
	
	snprintf((char *)head->description, sizeof(head->description),
			 "Memory Object File. Generated at %d-%d-%d %d:%d:%d",
			 tm->tm_year + 1900, tm->tm_mon, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec);
	
	snprintf((char *)head->copyright, sizeof(head->copyright),
			 "Copyright %d Slanissue Inc.",
			 tm->tm_year + 1900);
	
	snprintf((char *)head->author, sizeof(head->author),
			 "Author: Moky@Beva, %d-%d-%d", 2014, 12, 10);
	
	// data body
	mof_data_body * body = &(data->body);
	
	body->itemsBuffer.offset = sizeof(mof_data);
	//body->itemsBuffer.length = sizeof(MOFDataItem) * MOFItemsCountMax;
	//body->stringsBuffer.offset = body->itemsBuffer.offset + body->itemsBuffer.length;
	//body->stringsBuffer.length =
	
	return data;
}

// destroy buffer
void mof_destroy(void * data)
{
	free(data);
}

// check data format
mof_int mof_check(const mof_data * data)
{
	const mof_data_head * head = &(data->head);
	
	// 1. format
	if (head->format[0] != 'M' || head->format[1] != 'O' || head->format[2] != 'F' || head->format[3] != '\0') {
		return MOFErrorFormat;
	}
	
	// 2. version
	if (head->version != MOF_VERSION || head->subVersion != MOF_SUB_VERSION) {
		return MOFErrorVersion;
	}
	
	const mof_data_body * body = &(data->body);
	mof_uint buf_len = sizeof(mof_data) + body->itemsBuffer.length + body->stringsBuffer.length;
	
	// 3. file length
	if (head->fileLength != buf_len) {
		return MOFErrorFileLength;
	}
	
	// 4. buffer info
	if (body->itemsBuffer.offset != sizeof(mof_data) ||
		body->itemsBuffer.length == 0) {
		return MOFErrorBufferInfo;
	}
	if (body->stringsBuffer.offset != body->itemsBuffer.offset + body->itemsBuffer.length ||
		body->stringsBuffer.length == 0) {
		return MOFErrorBufferInfo;
	}
	
	return MOFCorrect;
}

#pragma mark - Input/Output

const mof_data * mof_load(const char * __restrict filename)
{
	FILE * fp = fopen(filename, "rb");
	if (!fp) {
		// failed to open file for reading
		MOF_LOG("failed to open file for reading: %s", filename);
		return NULL;
	}
	
	// get file size
	fseek(fp, 0, SEEK_END);
	long size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	// create buffer for reading
	unsigned char * buffer = (unsigned char *)malloc(size);
	if (!buffer) {
		// not enough memory
		MOF_ASSERT(MOFFalse, "not enough memory: %ld", size);
		return NULL;
	}
	memset(buffer, 0, size);
	
	// read file
	fread(buffer, sizeof(unsigned char), size, fp);
	fclose(fp);
	
	mof_data * data = (mof_data *)buffer;
	
	mof_int err = mof_check(data);
	if (err == MOFCorrect) {
		return data;
	} else {
		MOF_ASSERT(MOFFalse, "data file error: %s, code: %d", filename, err);
		free(buffer);
		return NULL;
	}
}

mof_int mof_save(const char * __restrict filename, const mof_data * data)
{
	mof_int err = mof_check(data);
	if (err != MOFCorrect) {
		MOF_ASSERT(MOFFalse, "data error: %d", err);
		return -1;
	}
	unsigned char * buffer = (unsigned char *)data;
	mof_uint buf_len = data->head.fileLength;
	
	// open file to write
	FILE * fp = fopen(filename, "wb");
	if (!fp) {
		MOF_ASSERT(MOFFalse, "failed to open file for writing: %s", filename);
		return -2;
	}
	
	// do writing
	size_t written = fwrite(buffer, sizeof(unsigned char), buf_len, fp);
	
	// close file
	fclose(fp);
	
	if (written == buf_len) {
		return 0; // ok
	} else {
		MOF_ASSERT(MOFFalse, "written error: %ld, buffer len: %u", written, buf_len);
		return -3; // error
	}
}

#pragma mark - getters

// get string by id (index)
static mof_string _string_by_id(const mof_uint index, const mof_data * data)
{
	const unsigned char * buffer = (const unsigned char *)data;
	const unsigned char * start = buffer + data->body.stringsBuffer.offset;
	const unsigned char * end = start + data->body.stringsBuffer.length;
	// head of the strings buffer is the total 'count'
	mof_uint * count = (mof_uint *)start;
	const unsigned char * p = start + sizeof(mof_uint); // start reading after 'count'
	mof_uint i;
	mof_string_item * item;
	for (i = 0; i < *count && p < end; ++i) {
		item = (mof_string_item *)p;
		if (i == index) {
			return item->string;
		}
		p += item->size; // move to next string item
	}
	return NULL;
}

// get root item (the first item)
const mof_data_item * mof_root(const mof_data * data)
{
	return mof_item(0, data);
}

// get first item
const mof_data_item * mof_items_start(const mof_data * data)
{
	return mof_item(0, data);
}

// get tail of items (next of the last item)
const mof_data_item * mof_items_end(const mof_data * data)
{
	const mof_data_body * body = &(data->body);
	const mof_buffer_info * buffer = &(body->itemsBuffer);
	mof_uint count = buffer->length / sizeof(mof_data_item);
	MOF_ASSERT(count > 0, "items count must > 0");
	return body->items + count;
}

// get item with global index
const mof_data_item * mof_item(const mof_uint index, const mof_data * data)
{
	const mof_data_body * body = &(data->body);
	const mof_buffer_info * buffer = &(body->itemsBuffer);
	mof_uint count = buffer->length / sizeof(mof_data_item);
	if (index >= count) {
		MOF_ASSERT(MOFFalse, "out of range: %d >= %d", index, count);
		return NULL;
	}
	return body->items + index;
}

#pragma mark values

// get key with item (for dictionary)
mof_string mof_get_key(const mof_data_item * item, const mof_data * data)
{
	MOF_ASSERT(item->type == MOFDataItemTypeKey, "not key type: %d", item->type);
	return _string_by_id(item->keyId, data);
}

// get string with item
mof_string mof_get_str(const mof_data_item * item, const mof_data * data)
{
	MOF_ASSERT(item->type == MOFDataItemTypeString, "not string type: %d", item->type);
	return _string_by_id(item->stringId, data);
}

// get integer with item
mof_int mof_int_value(const mof_data_item * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeInteger, "not int type: %d", item->type);
	return item->intValue;
}

// get unsigned integer with item
mof_uint mof_uint_value(const mof_data_item * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeInteger, "not unsigned int type: %d", item->type);
	return item->uintValue;
}

// get float with item
mof_float mof_float_value(const mof_data_item * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeFloat, "not float type: %d", item->type);
	return item->floatValue;
}

// get bool with item
mof_bool mof_bool_value(const mof_data_item * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeBool, "not bool type: %d", item->type);
	return item->boolValue;
}
