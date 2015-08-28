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
	self = [super init];
	if (self) {
		[self setDataBuffer:NULL];
	}
	return self;
}

- (instancetype) initWithLength:(NSUInteger)bufferLength
{
	self = [self init];
	if (self) {
		const MOFData * data = mof_create((MOFUInteger)bufferLength);
		[self setDataBuffer:data];
	}
	return self;
}

- (instancetype) initWithFile:(NSString *)filename
{
	self = [self init];
	if (self) {
		[self loadFromFile:filename];
	}
	return self;
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

- (BOOL) loadFromFile:(NSString *)filename
{
	const MOFData * data = mof_load([filename UTF8String]);
	[self setDataBuffer:data];
	if (_dataBuffer == NULL) {
		NSLog(@"[MOF] failed to load data from file: %@", filename);
		return NO;
	}
	return YES;
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
