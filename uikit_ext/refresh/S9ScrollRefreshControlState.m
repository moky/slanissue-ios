//
//  UIScrollRefreshControlState.m
//  SlanissueToolkit
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ScrollRefreshControlState.h"

NSString * const kUIScrollRefreshControlStateNameDefault     = @"default";
NSString * const kUIScrollRefreshControlStateNameVisible     = @"visible";
NSString * const kUIScrollRefreshControlStateNameWillRefresh = @"will_refresh";
NSString * const kUIScrollRefreshControlStateNameRefreshing  = @"refreshing";
NSString * const kUIScrollRefreshControlStateNameTerminated  = @"data_end";

@implementation UIScrollRefreshControlState

@synthesize state = _state;

- (instancetype) initWithState:(UIScrollRefreshControlStateType)state
{
	NSString * name = nil;
	switch (state) {
		case UIScrollRefreshControlStateVisible:
			name = kUIScrollRefreshControlStateNameVisible;
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			name = kUIScrollRefreshControlStateNameWillRefresh;
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			name = kUIScrollRefreshControlStateNameRefreshing;
			break;
			
		case UIScrollRefreshControlStateTerminated:
			name = kUIScrollRefreshControlStateNameTerminated;
			break;
			
		default:
			name = kUIScrollRefreshControlStateNameDefault;
			break;
	}
	
	self = [self initWithName:name];
	if (self) {
		_state = state;
	}
	return self;
}

@end
