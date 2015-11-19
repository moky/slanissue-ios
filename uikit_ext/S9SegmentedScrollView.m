//
//  UISegmentedScrollView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"
#import "S9SegmentedScrollView.h"

@interface UISegmentedScrollView ()

@property(nonatomic, assign) UIScrollView * currentScrollView;

@end

@implementation UISegmentedScrollView

@synthesize controlView = _controlView;
@synthesize controlPosition = _controlPosition;

@synthesize animated = _animated;
@synthesize selectedIndex = _selectedIndex;

@synthesize currentScrollView = _currentScrollView;

- (void) dealloc
{
	self.controlView = nil;
	self.currentScrollView = nil;
	
	[super dealloc];
}

- (void) _initializedUISegmentedScrollView
{
	self.controlView = nil;
	
	_controlPosition = UISegmentedScrollViewControlPositionTop;
	
	_animated = YES;
	_selectedIndex = 0;
	
	self.currentScrollView = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializedUISegmentedScrollView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializedUISegmentedScrollView];
	}
	return self;
}

- (void) setControlPosition:(UISegmentedScrollViewControlPosition)controlPosition
{
	if (controlPosition != _controlPosition) {
		_controlPosition = controlPosition;
		
		// 1. set position of control view
		if (_controlView) {
			[self _positionControlView];
		}
		
		// 2. set content edge inset for all scroll views
		UIScrollView * scrollView;
		S9_FOR_EACH(self.subviews, scrollView) {
			if ([scrollView isKindOfClass:[UIScrollView class]]) {
				[self _resetScrollView:scrollView];
			}
		}
	}
}

- (void) _resetScrollView:(UIScrollView *)scrollView
{
	UIEdgeInsets contentInset = scrollView.contentInset;
	UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	switch (_controlPosition) {
		case UISegmentedScrollViewControlPositionTop:
			contentInset.top = _controlView.frame.origin.y + _controlView.frame.size.height;
			mask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			break;
			
		case UISegmentedScrollViewControlPositionBottom:
			contentInset.bottom = _controlView.frame.size.height;
			mask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			break;
			
		case UISegmentedScrollViewControlPositionLeft:
			contentInset.left = _controlView.frame.origin.x + _controlView.frame.size.width;
			mask |= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
			break;
			
		case UISegmentedScrollViewControlPositionRight:
			contentInset.right = _controlView.frame.size.width;
			mask |= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
			break;
			
		default:
			break;
	}
	
	scrollView.contentInset = contentInset;
	scrollView.autoresizingMask = mask;
}

- (void) _positionControlView
{
	NSAssert(_controlView, @"control view not set");
	
	UIScrollView * scrollView = self.currentScrollView;
	UIEdgeInsets edges = scrollView.contentInset;
	CGPoint offset = scrollView.contentOffset;
	CGSize size = scrollView.contentSize;
	CGSize winSize = self.bounds.size;
	
	CGFloat delta;
	
	CGPoint center = CGPointMake(winSize.width * 0.5f, winSize.height * 0.5f);
	switch (_controlPosition) {
		case UISegmentedScrollViewControlPositionTop:
			center.y = _controlView.bounds.size.height * 0.5f;
			// calculate delta
			delta = edges.top + offset.y;
			if (delta > 0.0f) {
				center.y -= delta;
			}
			break;
			
		case UISegmentedScrollViewControlPositionBottom:
			center.y = winSize.height - _controlView.bounds.size.height * 0.5f;
			// calculate delta
			delta = size.height - (edges.top + offset.y) + edges.bottom - winSize.height;
			if (delta > 0.0f) {
				center.y += delta;
			}
			break;
			
		case UISegmentedScrollViewControlPositionLeft:
			center.x = _controlView.bounds.size.width * 0.5f;
			// calculate delta
			delta = edges.left + offset.x;
			if (delta > 0.0f) {
				center.x -= delta;
			}
			break;
			
		case UISegmentedScrollViewControlPositionRight:
			center.x = winSize.width - _controlView.bounds.size.width * 0.5f;
			// calculate content size
			delta = size.width - (edges.left + offset.x) + edges.right - winSize.width;
			if (delta > 0.0f) {
				center.x += delta;
			}
			break;
			
		default:
			break;
	}
	_controlView.center = center;
}

- (void) setControlView:(UIView *)controlView
{
	if (_controlView != controlView) {
		if (controlView) {
			NSAssert([self.subviews count] == 0, @"unexpected subview(s)");
			// add new one
			[super addSubview:controlView];
		}
		
		// replace old one
		[_controlView removeFromSuperview];
		_controlView = controlView;
		
		if (controlView) {
			// position
			[self _positionControlView];
		}
	}
}

- (UIScrollView *) currentScrollView
{
	if (!_currentScrollView) {
		UIScrollView * scrollView;
		NSUInteger index = 0;
		S9_FOR_EACH(self.subviews, scrollView) {
			if ([scrollView isKindOfClass:[UIScrollView class]]) {
				if (index == _selectedIndex) {
					_currentScrollView = scrollView;
					break;
				}
				++index;
			}
		}
	}
	return _currentScrollView;
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	if ([subview isKindOfClass:[UIScrollView class]]) {
		UIScrollView * scrollView = (UIScrollView *)subview;
		
		// resize and content inset
		scrollView.frame = self.bounds;
		[self _resetScrollView:scrollView];
		
		// set delegate for scrolling
		//NSAssert(scrollView.delegate == nil, @"delegate's already been set");
		if (scrollView.delegate == nil) {
			scrollView.delegate = self;
		}
	}
}

- (void) willRemoveSubview:(UIView *)subview
{
	if ([subview isKindOfClass:[UIScrollView class]]) {
		UIScrollView * scrollView = (UIScrollView *)subview;
		
		// set delegate for scrolling
		//NSAssert(scrollView.delegate == self, @"delegate error");
		if (scrollView.delegate == self) {
			scrollView.delegate = nil;
		}
	}
	
	[super willRemoveSubview:subview];
}

- (void) addSubview:(UIView *)view
{
	NSAssert([_controlView isKindOfClass:[UIView class]], @"cannot add subview before controlView init");
	NSAssert([view isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
	
	[self insertSubview:view belowSubview:_controlView];
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
	NSArray * subviews = self.subviews;
	NSAssert([subviews count] > 2, @"subviews error: %@", subviews);
	NSUInteger count = [subviews count] - 1;
	selectedIndex = selectedIndex % count;
	
	if (_animated) {
		[UIView beginAnimations:nil context:NULL];
	}
	
	NSEnumerator * enumerator = [subviews objectEnumerator];
	CGSize size = self.bounds.size;
	NSUInteger index = 0;
	UIScrollView * child;
	CGPoint center;
	
	// left/top
	if (_controlPosition == UISegmentedScrollViewControlPositionTop ||
		_controlPosition == UISegmentedScrollViewControlPositionBottom) {
		center = CGPointMake(-size.width * 0.5f, size.height * 0.5f);
	} else {
		center = CGPointMake(size.width * 0.5f, -size.height * 0.5f);
	}
	for (; index < selectedIndex; ++index) {
		child = [enumerator nextObject];
		NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
		child.center = center;
	}
	
	// center/middle (selected)
	if (_controlPosition == UISegmentedScrollViewControlPositionTop ||
		_controlPosition == UISegmentedScrollViewControlPositionBottom) {
		center.x += size.width;
	} else {
		center.y += size.height;
	}
	child = [enumerator nextObject];
	NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
	if ([child isKindOfClass:[UIScrollView class]]) {
		[self scrollViewDidScroll:child];
	}
	child.center = center;
	++index;
	
	// right/bottom
	if (_controlPosition == UISegmentedScrollViewControlPositionTop ||
		_controlPosition == UISegmentedScrollViewControlPositionBottom) {
		center.x += size.width;
	} else {
		center.y += size.height;
	}
	for (; index < count; ++index) {
		child = [enumerator nextObject];
		NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
		child.center = center;
	}
	
	if (_animated) {
		[UIView commitAnimations];
	}
	
	_selectedIndex = selectedIndex;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSAssert(scrollView.superview == self, @"must be subview");
	self.currentScrollView = scrollView;
	[self _positionControlView];
}

@end
