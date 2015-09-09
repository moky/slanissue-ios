//
//  S9FiniteTimeAction.m
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9FiniteTimeAction.h"

@implementation S9FiniteTimeAction

@synthesize duration = _duration;

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.duration = 0.0f;
	}
	return self;
}

- (S9FiniteTimeAction *) reverse
{
	NSAssert(false, @"implement me");
	return nil;
}

@end
