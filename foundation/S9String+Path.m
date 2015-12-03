//
//  S9String+Path.m
//  SlanissueToolkit
//
//  Created by Moky on 15-12-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9String+Path.h"

@implementation NSString (Path)

- (NSString *) simplifyPath
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * string = self;
	
	// replacing self directory
	string = [string stringByReplacingOccurrencesOfString:@"/./" withString:@"/"];
	
	// supporting '...', '....', etc
	string = [string stringByReplacingOccurrencesOfString:@"/.../" withString:@"/../../"];
	string = [string stringByReplacingOccurrencesOfString:@"/..../" withString:@"/../../../"];
	// .....
	
	NSRange range1, range2;
	NSString * left;
	NSString * right;
	unichar ch;
	
	// replacing parent directory
	while ((range1 = [string rangeOfString:@"/../"]).location != NSNotFound) {
		if (range1.location < 1) {
			NSAssert(@"error: %@", string);
			break;
		}
		ch = [string characterAtIndex:(range1.location - 1)];
		if (ch  == '/' || ch == '.') {
			NSAssert(@"error: %@", string);
			break;
		}
		
		// substring on right (without prefix '/')
		right = [string substringFromIndex:(range1.location + 4)];
		
		range2 = [string rangeOfString:@"/"
							   options:NSBackwardsSearch
								 range:NSMakeRange(0, range1.location)];
		
		if (range2.location == NSNotFound) {
			// reach head, take right string only
			string = right;
		} else {
			// append to left string (with suffix '/')
			left = [string substringWithRange:NSMakeRange(0, range2.location + 1)];
			string = [left stringByAppendingString:right];
		}
	}
	
	[string retain];
	[pool release];
	
	return [string autorelease];
}

- (NSString *) filename
{
	NSString * string = self;
	NSUInteger index = [string length];
	
	// search query_string
	NSRange range = [string rangeOfString:@"?"];
	if (range.location != NSNotFound) {
		index = range.location;
	}
	
	// search fragment
	range = [string rangeOfString:@"#"];
	if (range.location != NSNotFound) {
		index = MIN(range.location, index);
	}
	
	// cut string
	if (index < [string length]) {
		string = [string substringToIndex:index];
	}
	
	return [string lastPathComponent];
}

@end
