//
//  S9Array.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"

@implementation NSArray (SlanissueToolkit)

- (id) objectBeforeObject:(id)object
{
	NSUInteger index = [self indexOfObject:object];
	if (index != NSNotFound && index > 0) {
		return [self objectAtIndex:index - 1];
	}
	return nil;
}

- (id) objectAfterObject:(id)object
{
	NSUInteger index = [self indexOfObject:object];
	if (index != NSNotFound && ++index < [self count]) {
		return [self objectAtIndex:index];
	}
	return nil;
}

@end
