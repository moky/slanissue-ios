//
//  UIPageScrollView.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIPageScrollViewDirection) {
	UIPageScrollViewDirectionVertical,
	UIPageScrollViewDirectionHorizontal,
};

UIKIT_EXTERN UIPageScrollViewDirection UIPageScrollViewDirectionFromString(NSString * string);

@protocol UIPageScrollViewDataSource;

@interface UIPageScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic, assign) id<UIPageScrollViewDataSource> dataSource;

@property(nonatomic, readwrite) UIPageScrollViewDirection direction;
@property(nonatomic, readonly) NSUInteger pageCount;
@property(nonatomic, readwrite) NSUInteger currentPage;

@property(nonatomic, readonly) UIScrollView * scrollView; // inner scroll view
//@protected:
@property(nonatomic, retain) UIPageControl * pageControl;

@property(nonatomic, readwrite) BOOL animated; // whether animated while turning page
@property(nonatomic, readwrite) CGSize contentSize; // content size of inner scroll view

@property(nonatomic, readwrite) NSUInteger preloadedPageCount; // default is 1

- (void) reloadData;

- (void) scrollToNextPage;

//@protected:
- (UIView *) showSubviewAtIndex:(NSUInteger)index; // return the new view shown at index

@end
