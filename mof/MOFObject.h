//
//  MOFObject.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-9.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "mof_protocol.h"

typedef mof_string      MOFCString;
typedef mof_uint        MOFUInteger;

typedef mof_string_item MOFStringItem;
typedef mof_data_item   MOFDataItem;
typedef mof_data_body   MOFDataBody;
typedef mof_data        MOFData;


@interface MOFObject : NSObject {
	
@protected
	unsigned char * _dataBuffer;
}

- (instancetype) initWithDataBuffer:(const MOFData *)data NS_DESIGNATED_INITIALIZER;

// create an initialized buffer with length
- (instancetype) initWithLength:(NSUInteger)bufferLength;

// load from file
- (instancetype) initWithFile:(NSString *)filename;

- (BOOL) saveToFile:(NSString *)filename;

- (BOOL) checkDataFormat;

@end
