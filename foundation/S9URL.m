//
//  S9URL.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9String.h"
#import "S9Array.h"
#import "S9Dictionary.h"
#import "S9URL.h"

@implementation NSURL (SlanissueToolkit)

- (NSDictionary *) parameters
{
	NSString * queryString = self.query;
	NSArray * array = [queryString componentsSeparatedByString:@"&"];
	NSUInteger count = [array count];
	if (count == 0) {
		return nil;
	}
	
	NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:count];
	
	NSRange range;
	NSString * key;
	NSString * value;
	
	NSString * item;
	S9_FOR_EACH(array, item) {
		range = [item rangeOfString:@"="];
		if (range.location == NSNotFound) {
			S9Log(@"invalid item: %@", item);
			continue;
		}
		
		key = [item substringToIndex:range.location];
		value = [item substringFromIndex:range.location + range.length];
		
		key = [key unescape];
		value = [value unescape];
		
		S9DictionarySetObjectForKey(parameters, value, key);
	}
	
	return parameters;
}

@end
