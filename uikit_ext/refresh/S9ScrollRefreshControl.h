//
//  UIScrollRefreshControl.h
//  SlanissueToolkit
//
//  Created by Moky on 15-1-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSMMachine.h"

typedef NS_ENUM(NSUInteger, UIScrollRefreshControlDirection) {
	UIScrollRefreshControlDirectionTop,
	UIScrollRefreshControlDirectionBottom,
	UIScrollRefreshControlDirectionLeft,
	UIScrollRefreshControlDirectionRight,
};

@interface UIScrollRefreshControl : UIView<FSMDelegate>

@property(nonatomic, readwrite) UIScrollRefreshControlDirection direction; // direction to pull out from
@property(nonatomic, readwrite) CGFloat dimension; // default is 80, the dimension for showing contents(subviews)

// called on start of dragging (may require some time and or distance to move)
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView;
// any offset changes
- (void) scrollViewDidScroll:(UIScrollView *)scrollView;
// called on finger up if the user dragged
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView;

// called on data reloaded
- (void) reloadData:(UIScrollView *)scrollView;

@end
