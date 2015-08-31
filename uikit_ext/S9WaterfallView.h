//
//  UIWaterfallView.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIWaterfallViewDirection) {
	UIWaterfallViewDirectionTopLeft,     // TOP first, and then LEFT (place each subview as TOP as possible)
	UIWaterfallViewDirectionTopRight,    // TOP first, and then RIGHT
	
	UIWaterfallViewDirectionBottomLeft,  // BOTTOM first, and then LEFT
	UIWaterfallViewDirectionBottomRight, // BOTTOM first, and then RIGHT
	
	UIWaterfallViewDirectionLeftTop,     // LEFT first, and then TOP
	UIWaterfallViewDirectionLeftBottom,  // LEFT first, and then BOTTOM
	
	UIWaterfallViewDirectionRightTop,    // RIGHT first, and then TOP
	UIWaterfallViewDirectionRightBottom, // RIGHT first, and then BOTTOM
};

// convenient method for checking direction
typedef NS_OPTIONS(NSUInteger, UIWaterfallViewDirectionMask) {
	// top
	UIWaterfallViewDirectionMaskTopLeft     = 1 << UIWaterfallViewDirectionTopLeft,
	UIWaterfallViewDirectionMaskTopRight    = 1 << UIWaterfallViewDirectionTopRight,
	// bottom
	UIWaterfallViewDirectionMaskBottomLeft  = 1 << UIWaterfallViewDirectionBottomLeft,
	UIWaterfallViewDirectionMaskBottomRight = 1 << UIWaterfallViewDirectionBottomRight,
	// left
	UIWaterfallViewDirectionMaskLeftTop     = 1 << UIWaterfallViewDirectionLeftTop,
	UIWaterfallViewDirectionMaskLeftBottom  = 1 << UIWaterfallViewDirectionLeftBottom,
	// right
	UIWaterfallViewDirectionMaskRightTop    = 1 << UIWaterfallViewDirectionRightTop,
	UIWaterfallViewDirectionMaskRightBottom = 1 << UIWaterfallViewDirectionRightBottom,
	
	// virtical
	UIWaterfallViewDirectionMaskTop         = UIWaterfallViewDirectionMaskTopLeft | UIWaterfallViewDirectionMaskTopRight,
	UIWaterfallViewDirectionMaskBottom      = UIWaterfallViewDirectionMaskBottomLeft | UIWaterfallViewDirectionMaskBottomRight,
	UIWaterfallViewDirectionMaskVertical    = UIWaterfallViewDirectionMaskTop | UIWaterfallViewDirectionMaskBottom,
	// horizontal
	UIWaterfallViewDirectionMaskLeft        = UIWaterfallViewDirectionMaskLeftTop | UIWaterfallViewDirectionMaskLeftBottom,
	UIWaterfallViewDirectionMaskRight       = UIWaterfallViewDirectionMaskRightTop | UIWaterfallViewDirectionMaskRightBottom,
	UIWaterfallViewDirectionMaskHorizontal  = UIWaterfallViewDirectionMaskLeft | UIWaterfallViewDirectionMaskRight,
};

#define UIWaterfallViewDirectionMatch(mask, direction) ((mask) & (1 << (direction)))

@protocol UIWaterfallViewDelegate;

//
//  Description:
//      All subviews in it will layout as waterfall automatically
//
@interface UIWaterfallView : UIView

@property(nonatomic, readwrite) UIWaterfallViewDirection direction;

@property(nonatomic, readwrite) CGFloat space; // setting 'space' will effect horizontal & vertical at the same time
@property(nonatomic, readwrite) CGFloat spaceHorizontal;
@property(nonatomic, readwrite) CGFloat spaceVertical;

@property(nonatomic, assign) id<UIWaterfallViewDelegate> delegate;

@end

@protocol UIWaterfallViewDelegate <NSObject>

@required
- (void) didResizeWaterfallView:(UIWaterfallView *)waterfallView;

@end
