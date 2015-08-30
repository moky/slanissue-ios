//
//  UIScrollRefreshControlState.h
//  SlanissueToolkit
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSMState.h"

typedef NS_ENUM(NSUInteger, UIScrollRefreshControlStateType) {
	UIScrollRefreshControlStateDefault,     // default state is hidden
	UIScrollRefreshControlStateVisible,     // pull to visible but cannot refresh yet
	UIScrollRefreshControlStateWillRefresh, // dragging distance enough to refresh, but still dragging
	UIScrollRefreshControlStateRefreshing,  // refreshing after drag end
	UIScrollRefreshControlStateTerminated,  // no more data
};

@interface UIScrollRefreshControlState : FSMState

@property(nonatomic, readonly) UIScrollRefreshControlStateType state;

- (instancetype) initWithState:(UIScrollRefreshControlStateType)state;

@end

#pragma mark -

// state names
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameDefault;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameVisible;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameWillRefresh;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameRefreshing;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameTerminated;
