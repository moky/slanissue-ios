//
//  S9Dictionary.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "MOFReader.h"
#import "MOFTransformer.h"
#import "S9StringsFile.h"
#import "S9MemoryCache.h"
#import "S9Object.h"
#import "S9String.h"
#import "S9Array.h"
#import "S9Dictionary.h"

typedef NS_ENUM(NSUInteger, NSDictionaryFileType) {
	NSDictionaryFileTypeUnknown,
	NSDictionaryFileTypePlist,   // *.plist
	NSDictionaryFileTypeJs,      // *.js
	NSDictionaryFileTypeJsON,    // *.json
	NSDictionaryFileTypeStrings, // *.strings
	NSDictionaryFileTypeMOF,     // *.mof
};

static NSDictionaryFileType NSDictionaryFileTypeFromPath(NSString * path)
{
	NSString * ext = [path pathExtension];
	ext = [ext lowercaseString];
	
	if ([ext isEqualToString:@"plist"]) {
		return NSDictionaryFileTypePlist;
	} else if ([ext isEqualToString:@"js"]) {
		return NSDictionaryFileTypeJs;
	} else if ([ext isEqualToString:@"json"]) {
		return NSDictionaryFileTypeJsON;
	} else if ([ext isEqualToString:@"strings"]) {
		return NSDictionaryFileTypeStrings;
	} else if ([ext isEqualToString:@"mof"]) {
		return NSDictionaryFileTypeMOF;
	}
	
	return NSDictionaryFileTypeUnknown;
}

@implementation NSDictionary (SlanissueToolkit)

+ (NSDictionary *) dictionaryWithString:(NSString *)mapString
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSArray * pairs = [mapString componentsSeparatedByString:@";"];
	NSAssert([pairs count] > 0, @"no key-value found");
	
	NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithCapacity:[pairs count]];
	
	NSString * pair;
	S9_FOR_EACH(pairs, pair) {
		NSRange range = [pair rangeOfString:@":"];
		if (range.location == NSNotFound) {
			continue;
		}
		
		// key
		NSString * key = [pair substringToIndex:range.location];
		key = [key trim];
		NSAssert([key length] > 0, @"key cannot be empty");
		
		// value
		NSString * value = [pair substringFromIndex:range.location + 1];
		value = [value trim];
		value = [value trim:@"'"];
		
		[mDict setObject:value forKey:key];
	}
	
	[pool release];
	return [mDict autorelease];
}

+ (NSDictionary *) loadFromFile:(NSString *)path
{
	NSAssert(path, @"file path cannot be nil");
	S9MemoryCache * cache = [S9MemoryCache getInstance];
	NSDictionary * dict = [cache objectForKey:path];
	if (dict) {
		return dict; // get from cache
	}
	
	NSDictionaryFileType type = NSDictionaryFileTypeFromPath(path);
	switch (type) {
		case NSDictionaryFileTypePlist:
			dict = [NSDictionary dictionaryWithContentsOfFile:path];
			break;
			
		case NSDictionaryFileTypeJs:
		case NSDictionaryFileTypeJsON:
			dict = (NSDictionary *)JSONFileLoad(path);
			break;
			
		case NSDictionaryFileTypeStrings:
			dict = S9StringsFileLoad(path);
			break;
			
		case NSDictionaryFileTypeMOF:
			dict = (NSDictionary *)MOFLoad(path);
			break;
			
		default:
			NSAssert(false, @"unsupported data format: %@", path);
			break;
	}
	
	[cache setObject:dict forKey:path]; // cache it
	return dict;
}

- (BOOL) saveToFile:(NSString *)path
{
	NSAssert(path, @"file path cannot be nil");
	BOOL succ = NO;
	
	NSDictionaryFileType type = NSDictionaryFileTypeFromPath(path);
	switch (type) {
		case NSDictionaryFileTypePlist:
			succ = [self writeToFile:path atomically:YES];
			break;
			
		case NSDictionaryFileTypeJs:
		case NSDictionaryFileTypeJsON:
			succ = JSONFileSave(self, path);
			break;
			
		case NSDictionaryFileTypeStrings:
			S9StringsFileSave(self, path);
			break;
			
		case NSDictionaryFileTypeMOF:
			succ = MOFSave(self, path);
			break;
			
		default:
			NSAssert(false, @"unsupported data format: %@", path);
			break;
	}
	
	NSAssert(succ, @"failed to save data: %@", path);
	return succ;
}

@end
