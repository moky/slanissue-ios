//
//  MOFObject.m
//  MemoryObjectFile
//
//  Created by Moky on 14-12-9.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include "mof_data.h"

#import "MOFObject.h"

@implementation MOFObject

- (void) dealloc
{
	[self setDataBuffer:NULL];
	
	[super dealloc];
}

- (instancetype) init
{
	return [self initWithDataBuffer:NULL];
}

/* designated initializer */
- (instancetype) initWithDataBuffer:(const MOFData *)data
{
	self = [super init];
	if (self) {
		[self setDataBuffer:data];
	}
	return self;
}

- (instancetype) initWithLength:(NSUInteger)bufferLength
{
	const MOFData * data = mof_create((MOFUInteger)bufferLength);
	NSAssert(data != NULL, @"[MOF] failed to create data buffer: %u", (unsigned int)bufferLength);
	return [self initWithDataBuffer:data];
}

- (instancetype) initWithFile:(NSString *)filename
{
	const MOFData * data = mof_load([filename UTF8String]);
	//NSAssert(data != NULL, @"[MOF] failed to load data from file: %@", filename);
	if (!_dataBuffer) {
		[self release];
		self = nil;
		return self;
	}
	return [self initWithDataBuffer:data];
}

- (void) setDataBuffer:(const MOFData *)data
{
	unsigned char * buffer = (unsigned char *)data;
	if (_dataBuffer != buffer) {
		if (_dataBuffer) {
			mof_destroy(_dataBuffer);
		}
		_dataBuffer = buffer;
	}
}

- (BOOL) checkDataFormat
{
	if (_dataBuffer) {
		const MOFData * data = (const MOFData *)_dataBuffer;
		return mof_check(data) == MOFCorrect;
	} else {
		NSLog(@"[MOF] data not load yet");
		return NO;
	}
}

- (BOOL) saveToFile:(NSString *)filename
{
	if (![self checkDataFormat]) {
		NSLog(@"[MOF] data error, filename: %@", filename);
		return NO;
	}
	const MOFData * data = (const MOFData *)_dataBuffer;
	if (mof_save([filename UTF8String], data) == 0) {
		return YES;
	} else {
		NSLog(@"[MOF] failed to save data into file: %@", filename);
		return NO;
	}
}

@end
