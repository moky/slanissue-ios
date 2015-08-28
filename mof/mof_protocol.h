//
//  mof_protocol.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __mof_protocol__
#define __mof_protocol__

/**
 *
 *    Major 64-Bit Changes
 *
 *
 *    Table 1-1 Size and alignment of integer data types in OS X and iOS:
 *
 *    /============+============+=================+===========+================\
 *    | Data type  | ILP32 size | ILP32 alignment | LP64 size | LP64 alignment |
 *    +============+============+=================+===========+================+
 *    | char       | 1 byte     | 1 byte          | 1 byte    | 1 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | BOOL, bool | 1 byte     | 1 byte          | 1 byte    | 1 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | short      | 2 bytes    | 2 bytes         | 2 bytes   | 2 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | int        | 4 bytes    | 4 bytes         | 4 bytes   | 4 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | long       | 4 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | long long  | 8 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | pointer    | 4 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | size_t     | 4 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | time_t     | 4 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | NSInteger  | 4 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | CFIndex    | 4 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | fpos_t     | 8 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | off_t      | 8 bytes    | 4 bytes         | 8 bytes   | 8 bytes        |
 *    \============+============+=================+===========+================/
 *
 *    Table 1-2 Size of floating-point data types in OS X and iOS
 *
 *    /============+============+===========\
 *    | Data type  | ILP32 size | LP64 size |
 *    +============+============+===========+
 *    | float      | 4 bytes    | 4 bytes   |
 *    +------------+------------+-----------+
 *    | double     | 8 bytes    | 8 bytes   |
 *    +------------+------------+-----------+
 *    | CGFloat    | 4 bytes    | 8 bytes   |
 *    \============+============+===========/
 *
 */

//
//  data type
//
typedef const char *   mof_string;
typedef char           mof_char;
typedef unsigned char  mof_uchar;

typedef char           mof_byte;
typedef unsigned char  mof_ubyte;
typedef short          mof_short;
typedef unsigned short mof_ushort;
typedef int            mof_int;
typedef unsigned int   mof_uint;
typedef float          mof_float;
typedef char           mof_bool;

//
//  constants
//
#define MOFTrue                    1
#define MOFFalse                   0

// items count for each dictionary/array
#define MOFArrayItemsCountMax      0xffff     /* 65,535 (64K) */
#define MOFDictionaryItemsCountMax 0xffff     /* 65,535 (64K) */

// items count for global item buffer
#define MOFItemsCountMax           0xffffffff /* 4,294,967,295 (4G) */

// max string length
#define MOFStringLengthMax         0xffff     /* 65,535 (64K) */
// strings count for global string buffer
#define MOFStringsCountMax         0xffffffff /* 4,294,967,295 (4G) */

#define MOFStringNotFound          MOFStringsCountMax
#define MOFKeyNotFound             MOFStringNotFound

//
//  error code
//
enum {
	MOFCorrect         = 0,
	MOFErrorFormat     = 1 << 0,
	MOFErrorVersion    = 1 << 1,
	MOFErrorFileLength = 1 << 2,
	MOFErrorBufferInfo = 1 << 3,
};

//
//  type for data item
//
typedef enum {
	MOFDataItemTypeKey,             // 0 (key for dictionary)
	MOFDataItemTypeDictionary,      // 1
	MOFDataItemTypeArray,           // 2
	
	MOFDataItemTypeString,          // 3
	MOFDataItemTypeInteger,         // 4
	MOFDataItemTypeUnsignedInteger, // 5
	MOFDataItemTypeFloat,           // 6
	MOFDataItemTypeBool,            // 7
	
	MOFDataItemTypeUnknown          // ?
} MOFDataItemType;

#pragma pack(1)

//
//  string item in strings buffer
//
typedef struct _mof_string_item {
	// NOTICE:
	// it's the size of entire item, includes 'sizeof(length)' and the last '\0' of string
	// NOT only the length of string
	mof_ushort size;
	
	mof_char   string[0]; // head of string buffer
} mof_string_item;

//
//  data item (8 bytes)
//
typedef struct _mof_data_item {
	mof_ubyte        type;        // 0 - 255
	mof_uchar        reserved[3]; // reserved for bytes alignment
	union {
		// key (for dictionary)
		mof_uint     keyId;       // 0 - 4,294,967,295 (4G)
		// string
		mof_uint     stringId;    // 0 - 4,294,967,295 (4G)
		
		// numeric
		mof_int      intValue;
		mof_uint     uintValue;
		mof_float    floatValue;
		// bool
		mof_bool     boolValue;
		
		// count (for dictionary/array)
		mof_ushort   count;       // 0 - 65,535 (64K)
	};
} mof_data_item;

//
//  data body (8 bytes)
//
typedef struct _mof_buffer_info {
	mof_uint offset; // offset of memory buffer (from data head)
	mof_uint length; // length of memory buffer (bytes)
} mof_buffer_info;

typedef struct _mof_data_body {
	mof_buffer_info itemsBuffer;
	mof_buffer_info stringsBuffer;
	
	mof_data_item items[0]; // head of item buffer
} mof_data_body;

//
//  data head (160 bytes)
//
typedef struct _mof_data_head {
	// protocol
	mof_uchar    format[4];   // "MOF"
	mof_ubyte    version;
	mof_ubyte    subVersion;
	mof_uchar    reserved[2]; // reserved for bytes alignment
	mof_uint     fileLength;
	mof_uchar    extra[20];   // reserved for extra info
	// info
	mof_uchar    description[64];
	mof_uchar    copyright[32];
	mof_uchar    author[32];
} mof_data_head;

//
//  MOF data
//
typedef struct _mof_data {
	mof_data_head head;
	mof_data_body body;
} mof_data;

#pragma pack()

#endif /* defined(__mof_protocol__) */
