//
//  UICoverFlowView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"
#import "S9View+Transform.h"
#import "S9CoverFlowView.h"

#if !TARGET_OS_WATCH

@implementation UICoverFlowView

- (void) performEffectOnScrollView:(UIScrollView *)scrollView
{
	[self _performCoverFlowEffectOnScrollView:scrollView];
}

//
//  <Formulas>
//
//      1. rotate   : r = f(x) = atan(x)
//
//      2. scale    : s = g(x) = e^(-|x|)
//
//      3. position : l = h(x) = f(x) / (PI / 2)
//

// perform cover flow effect
- (void) _performCoverFlowEffectOnScrollView:(UIScrollView *)scrollView
{
	CGSize size = scrollView.bounds.size;
	CGPoint offset = scrollView.contentOffset;
	CGPoint center = CGPointMake(offset.x + size.width * 0.5, offset.y + size.height * 0.5);
	
	CGFloat distance;
	CGFloat rotate;
	CGFloat scale;
	CGFloat position;
	
	CGFloat SCALE_MIN   = self.scale;
	CGFloat SCALE_RANGE = 1.0f - SCALE_MIN;
	
	UIView * subview;
	if (self.direction == UIPageScrollViewDirectionHorizontal) {
		// distance between each item and the center item
		distance = - offset.x / size.width;
		
		S9_FOR_EACH(scrollView.subviews, subview) {
			// 0. reset
			[subview resetTransform];
			
			// 1. rotate
			rotate = atanf(distance);
			[subview rollWithRotation:-rotate]; // rotating around axis Y
			
			// 2. scale
			scale = expf(-fabs(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = rotate / M_PI_2 * subview.bounds.size.width;
			subview.center = CGPointMake(center.x + position, center.y);
			
			distance += 1.0f;
		}
	} else {
		// distance between each item and the center item
		distance = - offset.y / size.height;
		
		S9_FOR_EACH(scrollView.subviews, subview) {
			// 0. reset
			[subview resetTransform];
			
			// 1. rotate
			rotate = atanf(distance);
			[subview pitchWithRotation:rotate]; // rotating around axis X
			
			// 2. scale
			scale = expf(-fabs(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = rotate / M_PI_2 * subview.bounds.size.height;
			subview.center = CGPointMake(center.x, center.y + position);
			
			distance += 1.0f;
		}
	}
}

@end

#endif
