//
//  S9Object.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Object.h"

@implementation NSObject (SlanissueToolkit)

+ (NSObject *) objectWithJSONData:(NSData *)data options:(NSJSONReadingOptions)opt
{
	NSAssert(data, @"JSON data cannot be nil");
	NSError * error = nil;
	NSObject * obj = [NSJSONSerialization JSONObjectWithData:data options:opt error:&error];
	if (error) {
		return nil;
	}
	return obj;
}

+ (NSObject *) objectWithJSONData:(NSData *)data
{
	return [self objectWithJSONData:data options:NSJSONReadingAllowFragments];
}

+ (NSObject *) objectWithJSONString:(NSString *)string encoding:(NSStringEncoding)encoding
{
	NSData * data = [string dataUsingEncoding:encoding];
	return [self objectWithJSONData:data options:NSJSONReadingAllowFragments];
}

+ (NSObject *) objectWithJSONString:(NSString *)string
{
	NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
	return [self objectWithJSONData:data options:NSJSONReadingAllowFragments];
}

- (NSString *) JSONStringWithEncoding:(NSStringEncoding)encoding options:(NSJSONWritingOptions)opt
{
	NSError * error = nil;
	NSData * data = [NSJSONSerialization dataWithJSONObject:self options:opt error:&error];
	if (error || !data) {
		return nil;
	}
	return [[[NSString alloc] initWithData:data encoding:encoding] autorelease];
}

- (NSString *) JSONStringWithEncoding:(NSStringEncoding)encoding
{
	return [self JSONStringWithEncoding:encoding options:0];
}

- (NSString *) JSONString
{
	return [self JSONStringWithEncoding:NSUTF8StringEncoding options:0];
}

@end
