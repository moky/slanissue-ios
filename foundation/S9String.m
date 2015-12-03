//
//  S9String.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "s9Macros.h"
#import "S9Object.h"
#import "S9String.h"

@implementation NSString (SlanissueToolkit)

+ (NSString *) stringBySerializingObject:(NSObject *)object
{
	return JSONStringFromNSObject(object);
}

- (NSString *) MD5String
{
	if ([self length] == 0) {
		return nil;
	}
	
	const char * value = [self UTF8String];
	
	unsigned char buffer[CC_MD5_DIGEST_LENGTH];
	CC_MD5(value, (CC_LONG)strlen(value), buffer);
	
	NSMutableString * string = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; ++count) {
		[string appendFormat:@"%02x",buffer[count]];
	}
	
	return [string autorelease];
}

- (NSString *) pinyin
{
	NSMutableString * mString = [NSMutableString stringWithString:self];
	
	// convert to pinyin string ( with diacritical mark )
	CFStringTransform((CFMutableStringRef)mString, NULL, kCFStringTransformMandarinLatin, NO);
	
	// strip diacritics
	CFStringTransform((CFMutableStringRef)mString, NULL, kCFStringTransformStripDiacritics, NO);
	
	return mString;
}

- (NSString *) trim
{
	NSCharacterSet * charset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	return [self stringByTrimmingCharactersInSet:charset];
}

- (NSString *) trim:(NSString *)chars
{
	NSCharacterSet * charset = [NSCharacterSet characterSetWithCharactersInString:chars];
	return [self stringByTrimmingCharactersInSet:charset];
}

- (NSString *) escape
{
	NSString * string = self;
	string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	return string;
}

- (NSString *) unescape
{
	NSString * string = self;
	string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return string;
}

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
	NSString * str1;
	NSString * str2;
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
		
		range2 = [string rangeOfString:@"/"
							   options:NSBackwardsSearch
								 range:NSMakeRange(0, range1.location)];
		if (range2.location == NSNotFound) {
			range2.location = -1;
		}
		
		str1 = [string substringWithRange:NSMakeRange(0, range2.location + 1)];
		str2 = [string substringFromIndex:(range1.location + 4)];
		string = [str1 stringByAppendingString:str2];
	}
	
	[string retain];
	[pool release];
	
	return [string autorelease];
}

- (NSString *) filename
{
	NSRange range = [self rangeOfString:@"?"];
	NSString * string = range.location == NSNotFound ? self : [self substringToIndex:range.location];
	return [string lastPathComponent];
}

- (NSString *) calculate
{
	NSString * string = self;
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSRange range;
	
	NSInteger pos1, pos2;
	unichar ch;
	NSString * substr;
	
	for (pos1 = [string length] - 1; pos1 >= 0; --pos1) {
		
		for (pos2 = pos1; pos2 >= 0; --pos2) {
			ch = [string characterAtIndex:pos2];
			if (ch != '{' && ch != '}' && ch != ',') {
				break;
			}
		}
		
		for (pos1 = pos2; pos1 >= 0; --pos1) {
			ch = [string characterAtIndex:pos1];
			if (ch == '{' || ch == '}' || ch == ',') {
				break;
			}
		}
		
		range.location = pos1 + 1;
		range.length = pos2 - pos1;
		substr = [string substringWithRange:range];
		substr = [substr trim];
		if ([substr length] > 0) {
			string = [NSString stringWithFormat:@"%@%.2f%@",
					  [string substringToIndex:pos1 + 1],
					  CGFloatFromString(substr),
					  [string substringFromIndex:pos2 + 1]];
		}
	}
	
	[string retain];
	[pool release];
	
	return [string autorelease];
}

@end
