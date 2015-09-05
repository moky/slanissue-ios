//
//  UIPageScrollViewDataSource.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPageScrollView;

@protocol UIPageScrollViewDataSource <NSObject>

- (void) reloadData:(UIPageScrollView *)pageScrollView;

@required

- (NSUInteger) presentationCountForPageScrollView:(UIPageScrollView *)pageScrollView;

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewAtIndex:(NSUInteger)index;

@optional

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewBeforeView:(UIView *)view;
- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewAfterView:(UIView *)view;

@end
