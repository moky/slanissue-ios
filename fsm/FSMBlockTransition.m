//
//  FSMBlockTransition.m
//  FiniteStateMachine
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "FSMBlockTransition.h"

#if NS_BLOCKS_AVAILABLE

@implementation FSMBlockTransition

@synthesize block = _block;

- (instancetype) initWithTargetStateName:(NSString *)name
{
	return [self initWithTargetStateName:name block:NULL];
}

/* designated initializer */
- (instancetype) initWithTargetStateName:(NSString *)name block:(FSMBlock)block
{
	self = [super initWithTargetStateName:name];
	if (self) {
		self.block = block;
	}
	return self;
}

- (BOOL) evaluate:(FSMMachine *)machine
{
	NSAssert(_block, @"block error");
	return _block ? _block(machine, self) : NO;
}

@end

#endif
