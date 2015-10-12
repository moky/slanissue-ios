//
//  FSMFunctionTransition.m
//  FiniteStateMachine
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "FSMFunctionTransition.h"

@implementation FSMFunctionTransition

@synthesize delegate = _delegate;
@synthesize selector = _selector;

- (void) dealloc
{
	self.delegate = nil;
	self.selector = NULL;
	[super dealloc];
}

- (instancetype) initWithTargetStateName:(NSString *)name
{
	return [self initWithTargetStateName:name delegate:nil selector:NULL];
}

/* designated initializer */
- (instancetype) initWithTargetStateName:(NSString *)name delegate:(id)delegate selector:(SEL)selector
{
	self = [super initWithTargetStateName:name];
	if (self) {
		self.delegate = delegate;
		self.selector = selector;
	}
	return self;
}

- (BOOL) evaluate:(FSMMachine *)machine
{
	NSAssert(_delegate && _selector, @"delegate or selector error");
	if ([_delegate respondsToSelector:_selector]) {
		IMP imp = [_delegate methodForSelector:_selector];
		BOOL (*sender)(id, SEL, id, id) = (BOOL (*)(id, SEL, id, id))imp;
		if (sender) {
			return sender(_delegate, _selector, machine, self);
		}
		NSAssert(false, @"method error: %@", NSStringFromSelector(_selector));
	}
	NSAssert(false, @"error: %@ does not respond to selector: %@", _delegate, NSStringFromSelector(_selector));
	return NO;
}

@end
