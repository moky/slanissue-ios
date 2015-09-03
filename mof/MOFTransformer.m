//
//  MOFTransformer.m
//  MemoryObjectFile
//
//  Created by Moky on 14-12-10.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include "mof_data.h"

#import "S9Array.h"
#import "S9Dictionary.h"

#import "MOFTransformer.h"

static NSUInteger _indexForString(NSString * string, NSMutableArray * mStringsArray)
{
	NSUInteger index = 0;
	
	NSString * str;
	S9_FOR_EACH(mStringsArray, str) {
		if ([str isEqualToString:string]) {
			break;
		}
		++index;
	}
	
	if (index >= [mStringsArray count]) {
		NSLog(@"[MOF] add new string '%@' to array, index: %u", string, (unsigned int)index);
		[mStringsArray addObject:string];
	}
	
	return index;
}

static NSUInteger _processObject(NSObject * object,
								 MOFDataItem * pItemBuffer,
								 NSUInteger iPlaceLeft,
								 NSMutableArray * mStringsArray); // pre-defined

static NSUInteger _processArray(NSArray * array,
								MOFDataItem * pItemBuffer,
								NSUInteger iPlaceLeft,
								NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	pItemBuffer->type = MOFDataItemTypeArray;
	pItemBuffer->count = [array count];
	
	// first child, starts from next item
	MOFDataItem * pChild;
	NSUInteger iCount = 1;
	
	NSObject * object;
	S9_FOR_EACH(array, object) {
		pChild = pItemBuffer + iCount;
		iCount += _processObject(object, pChild, iPlaceLeft - iCount, mStringsArray);
	}
	
	return iCount;
}

static NSUInteger _processDictionary(NSDictionary * dict,
									 MOFDataItem * pItemBuffer,
									 NSUInteger iPlaceLeft,
									 NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	pItemBuffer->type = MOFDataItemTypeDictionary;
	pItemBuffer->count = [dict count];
	
	// first child, starts from next item
	MOFDataItem * pKey;
	MOFDataItem * pObject;
	NSUInteger iCount = 1;
	
	NSUInteger keyId;
	
	NSString * key;
	NSObject * object;
	S9_FOR_EACH_KEY_VALUE(dict, key, object) {
		// key
		pKey = pItemBuffer + iCount;
		keyId = _indexForString(key, mStringsArray);
		pKey->type = MOFDataItemTypeKey;
		pKey->keyId = (MOFUInteger)keyId;
		// value
		++iCount;
		pObject = pItemBuffer + iCount;
		iCount += _processObject(object, pObject, iPlaceLeft - iCount, mStringsArray);
	}
	
	return iCount;
}

static NSUInteger _processString(NSString * string,
								 MOFDataItem * pItemBuffer,
								 NSUInteger iPlaceLeft,
								 NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	pItemBuffer->type = MOFDataItemTypeString;
	pItemBuffer->stringId = (MOFUInteger)_indexForString(string, mStringsArray);
	
	return 1;
}

static NSUInteger _processNumber(NSNumber * number,
								 MOFDataItem * pItemBuffer,
								 NSUInteger iPlaceLeft)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	const char * type = number.objCType;
	
	// bool
	if ([number isKindOfClass:[[NSNumber numberWithBool:YES] class]])
	//if (number == (void *)kCFBooleanFalse || number == (void *)kCFBooleanTrue)
	{
		pItemBuffer->type = MOFDataItemTypeBool;
		pItemBuffer->boolValue = [number boolValue] ? MOFTrue : MOFFalse;
	}
	// int
	else if (strcmp(type, @encode(int)) == 0 || strcmp(type, @encode(long)) == 0)
	{
		pItemBuffer->type = MOFDataItemTypeInteger;
		pItemBuffer->intValue = [number intValue];
	}
	// unsigned
	else if (strcmp(type, @encode(unsigned int)) == 0 || strcmp(type, @encode(unsigned long)) == 0)
	{
		pItemBuffer->type = MOFDataItemTypeUnsignedInteger;
		pItemBuffer->uintValue = [number unsignedIntValue];
	}
	// float
	else if (strcmp(type, @encode(float)) == 0 || strcmp(type, @encode(double)) == 0)
	{
		pItemBuffer->type = MOFDataItemTypeFloat;
		pItemBuffer->floatValue = [number floatValue];
	}
	// unrecognized
	else
	{
		NSString * string = [number stringValue];
		if ([string rangeOfString:@"."].location != NSNotFound) {
			pItemBuffer->type = MOFDataItemTypeFloat;
			pItemBuffer->floatValue = [number floatValue];
		} else {
			pItemBuffer->type = MOFDataItemTypeInteger;
			pItemBuffer->intValue = [number intValue];
		}
	}
	
	return 1;
}

static NSUInteger _processObject(NSObject * object,
								 MOFDataItem * pItemBuffer,
								 NSUInteger iPlaceLeft,
								 NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	NSUInteger iCount = 0;
	
	if ([object isKindOfClass:[NSArray class]])
	{
		NSArray * array = (NSArray *)object;
		iCount += _processArray(array, pItemBuffer, iPlaceLeft, mStringsArray);
	}
	else if ([object isKindOfClass:[NSDictionary class]])
	{
		NSDictionary * dict = (NSDictionary *)object;
		iCount += _processDictionary(dict, pItemBuffer, iPlaceLeft, mStringsArray);
	}
	else if ([object isKindOfClass:[NSString class]])
	{
		NSString * string = (NSString *)object;
		iCount += _processString(string, pItemBuffer, iPlaceLeft, mStringsArray);
	}
	else if ([object isKindOfClass:[NSNumber class]])
	{
		NSNumber * number = (NSNumber *)object;
		iCount += _processNumber(number, pItemBuffer, iPlaceLeft);
	}
	else
	{
		NSLog(@"[MOF] unknown object");
		pItemBuffer->type = MOFDataItemTypeUnknown;
		iCount += 1;
	}
	return iCount;
}

static unsigned char * _createItemsBuffer(NSObject * root,
										  NSUInteger * pBufferLength,
										  NSMutableArray * mStringsArray)
{
	NSUInteger iMaxItems = 65536;
	NSUInteger iBufferLength = sizeof(MOFDataItem) * iMaxItems;
	
	MOFDataItem * pItemsBuffer = (MOFDataItem *)malloc(iBufferLength);
	if (!pItemsBuffer) {
		NSLog(@"[MOF] not enough memory");
		return NULL;
	}
	memset(pItemsBuffer, 0, iBufferLength);
	
	NSUInteger iCount = _processObject(root, pItemsBuffer, iMaxItems, mStringsArray);
	
	*pBufferLength = sizeof(MOFDataItem) * iCount;
	return (unsigned char *)pItemsBuffer;
}

static unsigned char * _createStringsBuffer(NSArray * stringsArray,
											NSUInteger * pBufferLength)
{
	NSUInteger iCount = [stringsArray count];
	NSUInteger iMaxLength = 65536 * iCount;
	
	unsigned char * pBuffer = (unsigned char *)malloc(iMaxLength);
	memset(pBuffer, 0, iMaxLength);
	unsigned char * p = (unsigned char *)pBuffer;
	
	// save 'count' first
	MOFUInteger * pCount = (MOFUInteger *)p;
	p += sizeof(MOFUInteger);
	*pCount = (MOFUInteger)iCount;
	
	// save each string
	NSString * string;
	const char * str;
	NSUInteger len;
	MOFStringItem * item;
	S9_FOR_EACH(stringsArray, string) {
		//str = [string cStringUsingEncoding:NSUTF8StringEncoding];
		str = [string UTF8String];
		len = strlen(str);
		if (len > 65535) {
			// too long string
			len = 65535;
		}
		
		item = (MOFStringItem *)p;
		// entire item length, includes 'sizeof(length)' and the last '\0' of string
		item->size = sizeof(MOFStringItem) + len + 1;
		strncpy(item->string, str, len);
		item->string[len] = '\0';
		
		p += item->size;
	}
	
	*pBufferLength = p - pBuffer;
	return pBuffer;
}

static void _destroyBuffer(void * buffer)
{
	free(buffer);
}

@implementation MOFTransformer

- (instancetype) initWithObject:(NSObject *)root
{
	NSMutableArray * mStringsArray = [[NSMutableArray alloc] initWithCapacity:65535];
	
	// items buffer
	NSUInteger itemsBufferLength = 0;
	unsigned char * itemsBuffer = _createItemsBuffer(root, &itemsBufferLength, mStringsArray);
	NSAssert(itemsBuffer && itemsBufferLength > 0, @"failed to create items buffer");
	
	// string array buffer
	NSUInteger stringsBufferLength = 0;
	unsigned char * stringsBuffer = _createStringsBuffer(mStringsArray, &stringsBufferLength);
	NSAssert(stringsBuffer && stringsBufferLength > 0, @"failed to create strings buffer");
	
	// OK!
	NSLog(@"[MOF] itemsBufferLength: %u, stringsBufferLength: %u", (unsigned int)itemsBufferLength, (unsigned int)stringsBufferLength);
	
	NSUInteger bufferLength = sizeof(MOFData) + itemsBufferLength + stringsBufferLength;
	NSLog(@"[MOF] bufferLength: %u", (unsigned int)bufferLength);
	
	self = [self initWithLength:bufferLength];
	if (self) {
		MOFData * data = (MOFData *)_dataBuffer;
		MOFDataBody * body = &(data->body);
		unsigned char * p = (unsigned char *)body->items;
		
		// copy items buffer
		body->itemsBuffer.length = (MOFUInteger)itemsBufferLength;
		memcpy(p, itemsBuffer, itemsBufferLength);
		
		// copy strings buffer
		p += itemsBufferLength;
		body->stringsBuffer.offset = body->itemsBuffer.offset + body->itemsBuffer.length;
		body->stringsBuffer.length = (MOFUInteger)stringsBufferLength;
		memcpy(p, stringsBuffer, stringsBufferLength);
	}
	
	_destroyBuffer(stringsBuffer);
	_destroyBuffer(itemsBuffer);
	
	[mStringsArray release];
	
	return self;
}

@end
