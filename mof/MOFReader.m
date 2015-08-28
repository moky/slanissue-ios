//
//  MOFReader.m
//  MemoryObjectFile
//
//  Created by Moky on 14-12-9.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include "mof_data.h"

#import "MOFReader.h"

@interface MOFReader ()

@property(nonatomic, retain) NSArray * strings;

@property(nonatomic, retain) NSObject * root;
@property(nonatomic, assign) const MOFDataItem * nextItem;

@end

@implementation MOFReader

@synthesize strings = _strings;

@synthesize root = _root;
@synthesize nextItem = _nextItem;

- (void) dealloc
{
	[_strings release];
	[_root release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_strings release];
		_strings = nil;
		
		[_root release];
		_root = nil;
		
		_nextItem = NULL;
	}
	return self;
}

- (const MOFDataItem *) endOfItems
{
	const MOFData * data = (const MOFData *)_dataBuffer;
	return mof_items_end(data);
}

- (const MOFDataItem *) nextItem
{
	NSAssert(_nextItem && _nextItem < [self endOfItems], @"error");
	return _nextItem++;
}

- (BOOL) loadFromFile:(NSString *)filename
{
	if (![super loadFromFile:filename]) {
		return NO;
	}
	
	[self parseWithFilename:filename];
	
	return _root != nil;
}

- (void) parseWithFilename:(NSString *)mof
{
	// 1. parse strings buffer
	self.strings = [self _parseStringsBuffer];
	
	//  extension:
	//      support storing strings buffer in a separated file
	if ([_strings count] <= 1) {
		// load strings from '*.mofd' file
		NSString * mofd = [self _getMofd:mof];
		if ([[mofd pathExtension] isEqualToString:@"mofd"]) {
			self.strings = [self _parseStringsDictionaryFile:mofd];
		}
	}
	
	// 2. parse items buffer
	self.root = [self _parseRoot];
}

#pragma mark - parsers

//
//  Function:
//      get '*.mofd' filename
//
//      1. if strings buffer is empty, just change the '*.mof' filename to '*.mofd'
//      2. if strings buffer contains only one string, check whether is 'include file="*.mofd"'
//
- (NSString *) _getMofd:(NSString *)mof
{
	if ([_strings count] == 0) {
		return [[mof stringByDeletingPathExtension] stringByAppendingPathExtension:@"mofd"];
	}
	NSAssert([_strings count] == 1, @"error");
	
	NSString * string = [_strings lastObject];
	NSString * lowercaseString = [string lowercaseString];
	
	// include file
	NSRange range = [lowercaseString rangeOfString:@"include file=\""];
	if (range.location == NSNotFound) {
		NSAssert(false, @"error: %@", _strings);
		return nil; // error
	}
	
	// get include filename
	NSString * filename = [string substringFromIndex:range.location + range.length];
	range = [filename rangeOfString:@"\""];
	if (range.location == NSNotFound) {
		NSAssert(range.location != NSNotFound, @"parse error, string = %@", string);
		return nil;
	}
	
	filename = [filename substringToIndex:range.location];
	//filename = [filename trim];
	NSAssert([filename length] > 0, @"filename cannot be empty: %@", string);
	
	return filename;
}

//
//  getting strings buffer from '*.mofd' file
//
- (NSArray *) _parseStringsDictionaryFile:(NSString *)mofd
{
	NSLog(@"[MOF] parsing mofd file: %@", mofd);
	const char * filename = [mofd UTF8String];
	
	FILE * fp = fopen(filename, "rb");
	if (!fp) {
		// failed to open file for reading
		NSAssert(false, @"failed to open file for reading: %s", filename);
		return nil;
	}
	
	// get file size
	fseek(fp, 0, SEEK_END);
	long size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	// create buffer for reading
	unsigned char * buffer = (unsigned char *)malloc(size);
	if (!buffer) {
		// not enough memory
		NSAssert(false, @"not enough memory: %ld", size);
		return nil;
	}
	memset(buffer, 0, size);
	
	// read file
	fread(buffer, sizeof(unsigned char), size, fp);
	fclose(fp);
	
	NSArray * strings = [self _parseStringsBuffer:buffer end:buffer + size];
	free(buffer);
	return strings;
}

//
//  parsing strings in memory buffer (start -> end)
//
- (NSArray *) _parseStringsBuffer:(const unsigned char *)start end:(const unsigned char *)end
{
	// head of the strings buffer is the total 'count'
	MOFUInteger * count = (MOFUInteger *)start;
	const unsigned char * p = start + sizeof(MOFUInteger); // start reading after 'count'
	NSUInteger i;
	MOFStringItem * item;
	
	NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:*count];
	NSString * string;
	for (i = 0; i < *count && p < end; ++i) {
		item = (MOFStringItem *)p;
		//string = [NSString stringWithCString:item->string encoding:NSUTF8StringEncoding];
		string = [NSString stringWithUTF8String:item->string];
		NSAssert(string, @"string error: %s, offset: %u / %u", item->string, (unsigned int)i, *count);
		if (string) {
			[mArray addObject:string];
		}
		p += item->size; // move to next string item
	}
	return [mArray autorelease];
}

//
//  parsing strings buffer in '*.mof'
//
- (NSArray *) _parseStringsBuffer
{
	const MOFData * data = (const MOFData *)_dataBuffer;
	const unsigned char * start = _dataBuffer + data->body.stringsBuffer.offset;
	const unsigned char * end = start + data->body.stringsBuffer.length;
	
	return [self _parseStringsBuffer:start end:end];
}

//
//  parsing starts here
//
- (NSObject *) _parseRoot
{
	const MOFData * data = (const MOFData *)_dataBuffer;
	_nextItem = mof_root(data);
	
	const MOFDataItem * item = [self nextItem];
	return [self _parseItem:item];
}

- (NSObject *) _parseItem:(const MOFDataItem *)item
{
	NSObject * object = nil;
	switch (item->type) {
		case MOFDataItemTypeArray:
			object = [self _parseArrayItem:item];
			break;
			
		case MOFDataItemTypeDictionary:
			object = [self _parseDictionaryItem:item];
			break;
			
		case MOFDataItemTypeString:
			object = [self _parseStringItem:item];
			break;
			
		case MOFDataItemTypeInteger:
			object = [self _parseIntegerItem:item];
			break;
			
		case MOFDataItemTypeFloat:
			object = [self _parseFloatItem:item];
			break;
			
		case MOFDataItemTypeBool:
			object = [self _parseBoolItem:item];
			break;
			
		default:
			NSAssert(false, @"error type: %d", item->type);
			break;
	}
	return object;
}

- (NSArray *) _parseArrayItem:(const MOFDataItem *)item
{
	NSUInteger count = item->count;
	NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:count];
	NSObject * child;
	NSUInteger i;
	for (i = 0; i < count; ++i) {
		child = [self _parseItem:[self nextItem]];
		NSAssert(child, @"error array item: %u/%u", (unsigned int)i, (unsigned int)count);
		if (child) {
			[mArray addObject:child];
		}
	}
	return mArray;
}

- (NSDictionary *) _parseDictionaryItem:(const MOFDataItem *)item
{
	NSUInteger count = item->count;
	NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithCapacity:count];
	id<NSCopying> key;
	NSObject * value;
	NSUInteger i;
	for (i = 0; i < count; ++i) {
		key = [self _parseKeyItem:[self nextItem]];
		value = [self _parseItem:[self nextItem]];
		NSAssert(key && value, @"error dictionary item: %u/%u", (unsigned int)i, (unsigned int)count);
		if (key && value) {
			[mDict setObject:value forKey:key];
		}
	}
	return mDict;
}

- (NSString *) _parseKeyItem:(const MOFDataItem *)item
{
	// 1. get key from the strings array
	if (_strings && item->keyId < [_strings count]) {
		return [_strings objectAtIndex:item->keyId];
	}
	NSAssert(false, @"could not happen: %u, %u", (unsigned int)item->stringId, (unsigned int)[_strings count]);
	
	// 2. error? try from the origin data
	const MOFData * data = (const MOFData *)_dataBuffer;
	const char * key = mof_get_key(item, data);
	NSAssert(key != NULL, @"error key item");
	if (key) {
		return [NSString stringWithUTF8String:key];
	} else {
		return nil;
	}
}

- (NSString *) _parseStringItem:(const MOFDataItem *)item
{
	// 1. get string from the strings array
	if (_strings && item->stringId < [_strings count]) {
		return [_strings objectAtIndex:item->stringId];
	}
	NSAssert(false, @"could not happen: %u, %u", (unsigned int)item->stringId, (unsigned int)[_strings count]);
	
	// 2. error? try from the origin data
	const MOFData * data = (const MOFData *)_dataBuffer;
	MOFCString string = mof_get_str(item, data);
	NSAssert(string != NULL, @"error string item");
	if (string) {
		return [NSString stringWithUTF8String:string];
	} else {
		return nil;
	}
}

- (NSNumber *) _parseIntegerItem:(const MOFDataItem *)item
{
	return [NSNumber numberWithInteger:mof_int_value(item)];
}

- (NSNumber *) _parseFloatItem:(const MOFDataItem *)item
{
	return [NSNumber numberWithFloat:mof_float_value(item)];
}

- (NSNumber *) _parseBoolItem:(const MOFDataItem *)item
{
	return [NSNumber numberWithBool:(mof_bool_value(item) != MOFFalse)];
}

@end
