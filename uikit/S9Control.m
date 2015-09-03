//
//  S9Control.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015年 Moky. All rights reserved.
//

#import "S9Array.h"
#import "S9Control.h"

@implementation UIControl (SlanissueToolkit)

- (void) performControlEvent:(UIControlEvents)controlEvent
{
	NSObject * target;
	NSString * action;
	SEL selector;
	
	// get all targets
	S9_FOR_EACH([self allTargets], target) {
		// get all actions for target
		S9_FOR_EACH([self actionsForTarget:target forControlEvent:controlEvent], action) {
			// perform selector
			selector = NSSelectorFromString(action);
			[target performSelector:selector withObject:self];
		}
	}
}

@end
