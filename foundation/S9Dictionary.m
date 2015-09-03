//
//  S9Dictionary.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9String.h"
#import "S9Array.h"
#import "S9Dictionary.h"

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

@end
