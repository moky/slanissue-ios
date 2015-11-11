//
//  S9XMLPath.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9String.h"
#import "S9XMLPath.h"

@implementation S9XMLElement (XPath)

#define S9_XPATH_REPLACE(string, substr, value)                                \
    while ((range = [(string) rangeOfString:(substr)]).location != NSNotFound){\
        (string) = [NSString stringWithFormat:@"%@%d%@",                       \
                    [(string) substringToIndex:range.location],                \
                    (value),                                                   \
                    [(string) substringFromIndex:range.location+range.length]];\
    }                                                                          \
                                                    /* EOF 'S9_XPATH_REPLACE' */

- (S9XMLElement *) elementWithPath:(NSString *)path
{
	// processing "aaa/bbb/ccc"
	NSRange range = [path rangeOfString:@"/"];
	if (range.location != NSNotFound) {
		NSString * str1 = [path substringToIndex:range.location];
		NSString * str2 = [path substringFromIndex:range.location + 1];
		// handle left
		S9XMLElement * element = [self elementWithPath:str1];
		// handle right
		return [element elementWithPath:str2];
	}
	
	// processing "ccc[111]"
	NSRange range1 = [path rangeOfString:@"["];
	NSRange range2 = [path rangeOfString:@"]" options:NSBackwardsSearch];
	if (range1.location != NSNotFound && range2.location != NSNotFound) {
		NSAssert(range1.location + range1.length < range2.location, @"error");
		NSString * str1 = [path substringToIndex:range1.location];
		range = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
		NSString * str2 = [path substringWithRange:range];
		// handle left
		NSArray * elements = [self elementsWithPath:str1];
		// handle right
		NSUInteger count = [elements count];
		S9_XPATH_REPLACE(str2, @"last()", (int)count - 1);
		NSUInteger index = CGFloatFromString(str2);
		return index < count ? [elements objectAtIndex:index] : nil;
	}
	
	// special name
	if ([path isEqualToString:@"."]) {
		return self;
	} else if ([path isEqualToString:@".."]) {
		return [self parent];
	}
	
	// get child with name
	return [self childWithName:path];
}

- (NSArray *) elementsWithPath:(NSString *)path
{
	// processing "aaabbb/ccc"
	NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
	if (range.location != NSNotFound) {
		NSString * str1 = [path substringToIndex:range.location];
		NSString * str2 = [path substringFromIndex:range.location + 1];
		// handle left
		S9XMLElement * element = [self elementWithPath:str1];
		// handle right
		return [element elementsWithPath:str2];
	}
	
	// special name
	if ([path isEqualToString:@"*"]) {
		return [self children];
	}
	
	return [self childrenWithName:path];
}

@end
