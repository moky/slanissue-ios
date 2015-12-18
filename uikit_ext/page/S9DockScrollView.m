//
//  UIDockScrollView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"
#import "S9View+Transform.h"
#import "S9View+Reflection.h"
#import "S9DockScrollView.h"

@implementation UIDockScrollView

@synthesize reflectionEnabled = _reflectionEnabled;
@synthesize scale = _scale;

- (void) _initializeUIDockScrollView
{
	_reflectionEnabled = YES;
	
	_scale = 0.2f;
	
	// pre-load TWO MORE view here
	// cause the cover flow will show part of next view in the right side
	self.preloadedPageCount = 2;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIDockScrollView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIDockScrollView];
	}
	return self;
}

- (void) addSubview:(UIView *)view
{
	if (_reflectionEnabled) {
		[view showReflection];
	}
	[super addSubview:view];
}

// if new subview comes, perform dock effect
- (UIView *) showSubviewAtIndex:(NSUInteger)index
{
	UIView * view = [super showSubviewAtIndex:index];
	[self performEffectOnScrollView:self.scrollView];
	return view;
}

- (void) performEffectOnScrollView:(UIScrollView *)scrollView
{
	[self _performDockEffectOnScrollView:scrollView];
}

//
//  <Formulas>
//
//      1. rotate   : r = f(x) = atan(x)
//
//      2. scale    : s = g(x) = e^(-|x|)
//
//      3. position : ...
//

// perform dock effect
- (void) _performDockEffectOnScrollView:(UIScrollView *)scrollView
{
	CGSize size = scrollView.bounds.size;
	CGPoint offset = scrollView.contentOffset;
	CGPoint center = CGPointMake(offset.x + size.width * 0.5, offset.y + size.height * 0.5);
	
	CGFloat distance;
	CGFloat rotate;
	CGFloat scale;
	CGFloat position;
	
	CGFloat SCALE_MIN   = _scale;
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
			//[subview rollWithRotation:-rotate]; // rotating around axis Y
			
			// 2. scale
			scale = expf(-fabs(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = (rotate / M_PI_2 * (1.0f + SCALE_RANGE) + distance * SCALE_MIN) * subview.bounds.size.width;
			subview.center = CGPointMake(center.x + position,
										 center.y + (1.0f - scale) * subview.bounds.size.height * 0.5f);
			
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
			//[subview pitchWithRotation:rotate]; // rotating around axis X
			
			// 2. scale
			scale = expf(-fabs(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = (rotate / M_PI_2 * (1.0f + SCALE_RANGE) + distance * SCALE_MIN) * subview.bounds.size.height;
			subview.center = CGPointMake(center.x + (1.0f - scale) * subview.bounds.size.width * 0.5f,
										 center.y + position);
			
			distance += 1.0f;
		}
	}
}

#pragma mark - UIScrollViewDelegate

// any offset changes, perform cover flow effect
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self performEffectOnScrollView:scrollView];
}

@end
