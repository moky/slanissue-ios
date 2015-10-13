//
//  S9StringsFile.m
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9String.h"
#import "S9Array.h"
#import "S9Dictionary.h"
#import "S9StringsFile.h"

#define StringsFilePath(filename, language, dir)                               \
        [NSString stringWithFormat:@"%@/%@.lproj/%@.strings", (dir), (language), (filename)]

NSString * NSStringByRemovingBlockComments(NSString * text)
{
	NSUInteger len = [text length];
	NSMutableString * plain = [[NSMutableString alloc] initWithCapacity:len];
	NSUInteger pos = 0;
	NSRange range;
	
	do {
		range = [text rangeOfString:@"/*" options:NSLiteralSearch range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			[plain appendString:[text substringFromIndex:pos]];
			// no more comments
			break;
		}
		[plain appendString:[text substringWithRange:NSMakeRange(pos, range.location - pos)]];
		pos = range.location + range.length;
		
		range = [text rangeOfString:@"*/" options:NSLiteralSearch range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			// comment to end
			break;
		}
		pos = range.location + range.length;
	} while (true);
	
	return [plain autorelease];
}

NSString * NSStringByRemovingLineComments(NSString * text)
{
	NSUInteger len = [text length];
	NSMutableString * plain = [[NSMutableString alloc] initWithCapacity:len];
	NSUInteger pos = 0;
	NSRange range;
	
	do {
		range = [text rangeOfString:@"//" options:NSLiteralSearch range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			[plain appendString:[text substringFromIndex:pos]];
			// no more comments
			break;
		}
		[plain appendString:[text substringWithRange:NSMakeRange(pos, range.location - pos)]];
		pos = range.location + range.length;
		
		range = [text rangeOfString:@"\n" options:NSLiteralSearch range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			// comment to end
			break;
		}
		pos = range.location + range.length;
	} while (true);
	
	return [plain autorelease];
}

NSString * NSStringByRemovingComments(NSString * text)
{
	text = NSStringByRemovingBlockComments(text);
	text = NSStringByRemovingLineComments(text);
	return text;
}

@implementation S9StringsFile

@synthesize dictionary = _dictionary;

- (void) dealloc
{
	[_dictionary release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.dictionary = nil;
	}
	return self;
}

+ (NSDictionary *) stringsFromFile:(NSString *)filename withLanguage:(NSString *)language bundlePath:(NSString *)dir
{
	NSDictionary * strings = nil;
	
	S9StringsFile * file = [[S9StringsFile alloc] init];
	if ([file loadFile:filename withLanguage:language bundlePath:dir]) {
		strings = [file dictionary];
		[[strings retain] autorelease];
	}
	[file release];
	
	return strings;
}

- (BOOL) loadFile:(NSString *)filename withLanguage:(NSString *)language bundlePath:(NSString *)dir
{
	// 1. load strings file
	NSString * path = StringsFilePath(filename, language, dir);
	
	// 'plist' format ?
	NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
	if (dict) {
		self.dictionary = dict;
		return YES;
	}
	
	// 'text' format?
	NSError * error = nil;
	NSString * text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		S9Log(@"failed to load strings file: %@", path);
		return NO;
	}
	
	// 2. remove comments
	NSString * plain = NSStringByRemovingComments(text);
	
	NSArray * lines = [plain componentsSeparatedByString:@"\n"];
	NSString * line;
	
	NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithCapacity:[lines count]];
	
	NSRange range;
	NSString * key;
	NSString * value;
	
	NSAutoreleasePool * pool;
	
	// 3. read line by line
	S9_FOR_EACH(lines, line) {
		range = [line rangeOfString:@"="];
		if (range.location == NSNotFound) {
			continue;
		}
		pool = [[NSAutoreleasePool alloc] init];
		
		key = [line substringToIndex:range.location];
		value = [line substringFromIndex:(range.location + 1)];
		
		range = [value rangeOfString:@";" options:NSBackwardsSearch];
		if (range.location != NSNotFound) {
			value = [value substringToIndex:range.location];
		}
		
		[key trim:@"\t \"'"];
		[value trim:@"\t \"'"];
		
		NSAssert([key length] > 0, @"error key");
		NSAssert([value length] > 0, @"error value");
		
		[mDict setObject:value forKey:key];
		
		[pool release];
	}
	
	self.dictionary = mDict;
	[mDict release];
	
	return YES;
}

- (BOOL) saveFile:(NSString *)filename withLanguage:(NSString *)language bundlePath:(NSString *)dir
{
	NSString * path = StringsFilePath(filename, language, dir);
	
	// 'plist' format ?
	if ([_dictionary writeToFile:path atomically:YES]) {
		return YES;
	}
	
	// 'text' format ?
	NSMutableString * text = [[NSMutableString alloc] init];
	
	NSString * key;
	NSString * value;
	S9_FOR_EACH_KEY_VALUE(_dictionary, key, value) {
		NSAssert([key rangeOfString:@"\""].location == NSNotFound, @"invalid key: %@", key);
		NSAssert([value rangeOfString:@"\""].location == NSNotFound, @"invalid value: %@", value);
		[text appendFormat:@"\"%@\" = \"%@\";\n", key, value];
	}
	
	NSError * error = nil;
	[text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
	[text release];
	
	if (error) {
		S9Log(@"error: %@", error);
		return NO;
	}
	
	return YES;
}

@end
