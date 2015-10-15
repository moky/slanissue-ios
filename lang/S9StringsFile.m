//
//  S9StringsFile.m
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9Array.h"
#import "S9Dictionary.h"
#import "S9StringsFile.h"

#define StringsFilePath(filename, language, dir)                               \
        [NSString stringWithFormat:@"%@/%@.lproj/%@.strings", (dir), (language), (filename)]

NS_INLINE NSText * remove_block_comments(NSText * text)
{
	NSUInteger len = [text length];
	NSMutableString * plain = [[NSMutableString alloc] initWithCapacity:len];
	NSUInteger pos = 0;
	NSRange range;
	
	do {
		// 1. search block comment's head
		range = [text rangeOfString:@"/*"
							options:NSLiteralSearch
							  range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			[plain appendString:[text substringFromIndex:pos]];
			// no more comments
			break;
		}
		
		// 2. copy text before the block comment's head
		[plain appendString:[text substringWithRange:NSMakeRange(pos, range.location - pos)]];
		pos = range.location + range.length;
		
		// 3. search block comment's tail
		range = [text rangeOfString:@"*/"
							options:NSLiteralSearch
							  range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			// comment to end
			break;
		}
		
		// 4. skip the block comment
		pos = range.location + range.length;
	} while (true);
	
	return [plain autorelease];
}

NS_INLINE NSText * remove_line_comments(NSText * text)
{
	NSUInteger len = [text length];
	NSMutableString * plain = [[NSMutableString alloc] initWithCapacity:len];
	NSUInteger pos = 0;
	NSRange range;
	
	do {
		// 1. search the line comment's head
		range = [text rangeOfString:@"//"
							options:NSLiteralSearch
							  range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			[plain appendString:[text substringFromIndex:pos]];
			// no more comments
			break;
		}
		
		// 2. copy text before the line comment's head
		[plain appendString:[text substringWithRange:NSMakeRange(pos, range.location - pos)]];
		pos = range.location + range.length;
		
		// 3. search line comment's tail
		range = [text rangeOfString:@"\n"
							options:NSLiteralSearch
							  range:NSMakeRange(pos, len - pos)];
		if (range.location == NSNotFound) {
			// comment to end
			break;
		}
		
		// 4. skip the line comment (no include the '\n' charactor)
		pos = range.location;
	} while (true);
	
	return [plain autorelease];
}

NSText * NSTextByRemovingComments(NSText * text)
{
	text = remove_block_comments(text);
	text = remove_line_comments(text);
	return text;
}

NS_INLINE NSDictionary * load_strings_file(NSString * path)
{
	// 1. load strings file
	//    'plist' format ?
	NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
	if (dict) {
		return dict;
	}
	
	//    'text' format?
	NSError * error = nil;
	NSString * text = [NSString stringWithContentsOfFile:path
												encoding:NSUTF8StringEncoding
												   error:&error];
	if (error) {
		S9Log(@"failed to load strings file: %@", path);
		return nil;
	}
	
	// 2. remove comments
	NSString * plain = NSTextByRemovingComments(text);
	
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
		
		[mDict setObject:value forKey:key];
		
		[pool release];
	}
	
	return [mDict autorelease];
}

NS_INLINE BOOL save_strings_file(NSString * path, NSDictionary * data)
{
	NSMutableString * text = [[NSMutableString alloc] init];
	
	NSString * key;
	NSString * value;
	S9_FOR_EACH_KEY_VALUE(data, key, value) {
		[text appendFormat:@"\"%@\" = \"%@\";\n", key, value];
	}
	
	NSError * error = nil;
	BOOL succ = [text writeToFile:path
					   atomically:YES
						 encoding:NSUTF8StringEncoding
							error:&error];
	
	[text release];
	return succ;
}

@interface S9StringsFile ()

@property(nonatomic, retain) NSDictionary * dictionary;

@end

@implementation S9StringsFile

@synthesize dictionary = _dictionary;

- (void) dealloc
{
	[_dictionary release];
	[super dealloc];
}

- (instancetype) init
{
	return [self initWithDictionary:nil];
}

/* designated initializer */
- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		self.dictionary = dict;
	}
	return self;
}

- (instancetype) initWithFile:(NSString *)path
{
	NSDictionary * dict = load_strings_file(path);
	NSAssert([dict isKindOfClass:[NSDictionary class]],
			 @"error loading strings file: %@", path);
	return [self initWithDictionary:dict];
}

- (BOOL) saveToFile:(NSString *)path
{
	NSAssert([path hasSuffix:@".strings"], @"error path: %@", path);
	NSAssert([_dictionary isKindOfClass:[NSDictionary class]],
			 @"error data: %@", _dictionary);
	return save_strings_file(path, _dictionary);
}

#pragma mark - Localization

- (instancetype) initWithFile:(NSString *)filename language:(NSString *)language bundlePath:(NSString *)dir
{
	NSString * path = StringsFilePath(filename, language, dir);
	return [self initWithFile:path];
}

- (BOOL) saveToFile:(NSString *)filename language:(NSString *)language bundlePath:(NSString *)dir
{
	NSString * path = StringsFilePath(filename, language, dir);
	return [self saveToFile:path];
}

@end
