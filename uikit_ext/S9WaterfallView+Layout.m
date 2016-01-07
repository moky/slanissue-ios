//
//  UIWaterfallView+Layout.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "ds_array.h"
#import "S9Array.h"
#import "S9Geometry.h"
#import "S9WaterfallView+Layout.h"

#if !TARGET_OS_WATCH

NS_INLINE void add_first_joining_point(ds_array * pointPool,
									   UIWaterfallViewDirection direction,
									   CGFloat spaceHorizontal, CGFloat spaceVertical,
									   CGRect bounds)
{
	ds_compare_block compare = NULL;
	CGPoint point = CGPointZero;
	switch (direction) {
			/* {left, top} */
		case UIWaterfallViewDirectionTopLeft:
			compare = UIWaterfallViewJoiningPointCompareBlockTopLeft();
			point.x = spaceHorizontal;
			point.y = spaceVertical;
			break;
		case UIWaterfallViewDirectionLeftTop:
			compare = UIWaterfallViewJoiningPointCompareBlockLeftTop();
			point.x = spaceHorizontal;
			point.y = spaceVertical;
			break;
			
			/* {right, top} */
		case UIWaterfallViewDirectionTopRight:
			compare = UIWaterfallViewJoiningPointCompareBlockTopRight();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = spaceVertical;
			break;
		case UIWaterfallViewDirectionRightTop:
			compare = UIWaterfallViewJoiningPointCompareBlockRightTop();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = spaceVertical;
			break;
			
			/* {left, bottom} */
		case UIWaterfallViewDirectionBottomLeft:
			compare = UIWaterfallViewJoiningPointCompareBlockBottomLeft();
			point.x = spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
		case UIWaterfallViewDirectionLeftBottom:
			compare = UIWaterfallViewJoiningPointCompareBlockLeftBottom();
			point.x = spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
			
			/* {right, bottom} */
		case UIWaterfallViewDirectionBottomRight:
			compare = UIWaterfallViewJoiningPointCompareBlockBottomRight();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
		case UIWaterfallViewDirectionRightBottom:
			compare = UIWaterfallViewJoiningPointCompareBlockRightBottom();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
			
		default:
			break; // error
	}
	pointPool->bk.compare = compare;
	ds_array_add(pointPool, (const ds_type *)&point);
}

NS_INLINE BOOL place_on_joining_point(CGRect *frame, CGPoint point,
									  UIWaterfallViewDirection direction,
									  CGFloat spaceHorizontal, CGFloat spaceVertical,
									  CGRect bounds)
{
	switch (direction) {
			/* top first */
		case UIWaterfallViewDirectionTopLeft:
			frame->origin.x = point.x;
			frame->origin.y = point.y;
			if (frame->origin.x + frame->size.width + spaceHorizontal > bounds.size.width) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionTopRight:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y;
			if (frame->origin.x - spaceHorizontal < 0.0f) {
				return NO;
			}
			break;
			
			/* bottom first */
		case UIWaterfallViewDirectionBottomLeft:
			frame->origin.x = point.x;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.x + frame->size.width + spaceHorizontal > bounds.size.width) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionBottomRight:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.x - spaceHorizontal < 0.0f) {
				return NO;
			}
			break;
			
			/* left first */
		case UIWaterfallViewDirectionLeftTop:
			frame->origin.x = point.x;
			frame->origin.y = point.y;
			if (frame->origin.y + frame->size.height + spaceVertical > bounds.size.height) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionLeftBottom:
			frame->origin.x = point.x;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.y - spaceVertical < 0.0f) {
				return NO;
			}
			break;
			
			/* right first */
		case UIWaterfallViewDirectionRightTop:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y;
			if (frame->origin.y + frame->size.height + spaceVertical > bounds.size.height) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionRightBottom:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.y - spaceVertical < 0.0f) {
				return NO;
			}
			break;
			
		default:
			return NO; // error
			break;
	}
	return YES;
}

NS_INLINE void add_two_joining_points(ds_array * pointPool, CGRect frame,
									  UIWaterfallViewDirection direction,
									  CGFloat spaceHorizontal, CGFloat spaceVertical,
									  CGRect bounds)
{
	CGPoint point = CGPointZero;
	ds_type * bt = (ds_type *)&point;
	switch (direction) {
			/* top first */
		case UIWaterfallViewDirectionTopLeft:
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y;
			if (point.x < bounds.size.width) {
				ds_array_sort_insert(pointPool, bt); /* right */
			}
			point.x = frame.origin.x;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			ds_array_sort_insert(pointPool, bt); /* bottom */
			break;
		case UIWaterfallViewDirectionTopRight:
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y;
			if (point.x > 0.0f) {
				ds_array_sort_insert(pointPool, bt); /* left */
			}
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			ds_array_sort_insert(pointPool, bt); /* bottom */
			break;
			
			/* bottom first */
		case UIWaterfallViewDirectionBottomLeft:
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			if (point.x < bounds.size.width) {
				ds_array_sort_insert(pointPool, bt); /* right */
			}
			point.x = frame.origin.x;
			point.y = frame.origin.y - spaceVertical;
			ds_array_sort_insert(pointPool, bt); /* top */
			break;
		case UIWaterfallViewDirectionBottomRight:
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			if (point.x > 0.0f) {
				ds_array_sort_insert(pointPool, bt); /* left */
			}
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y - spaceVertical;
			ds_array_sort_insert(pointPool, bt); /* top */
			break;
			
			/* left first */
		case UIWaterfallViewDirectionLeftTop:
			point.x = frame.origin.x;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			if (point.y < bounds.size.height) {
				ds_array_sort_insert(pointPool, bt); /* bottom */
			}
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y;
			ds_array_sort_insert(pointPool, bt); /* right */
			break;
		case UIWaterfallViewDirectionLeftBottom:
			point.x = frame.origin.x;
			point.y = frame.origin.y - spaceVertical;
			if (point.y > 0.0f) {
				ds_array_sort_insert(pointPool, bt); /* top */
			}
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			ds_array_sort_insert(pointPool, bt); /* right */
			break;
			
			/* right first */
		case UIWaterfallViewDirectionRightTop:
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			if (point.y < bounds.size.height) {
				ds_array_sort_insert(pointPool, bt); /* bottom */
			}
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y;
			ds_array_sort_insert(pointPool, bt); /* left */
			break;
		case UIWaterfallViewDirectionRightBottom:
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y - spaceVertical;
			if (point.y > 0.0f) {
				ds_array_sort_insert(pointPool, bt); /* top */
			}
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			ds_array_sort_insert(pointPool, bt); /* left */
			break;
			
		default:
			break; // error
	}
}

NS_INLINE void expand_waterfall_view(UIWaterfallView * view,
									 UIWaterfallViewDirection direction,
									 CGFloat spaceHorizontal, CGFloat spaceVertical,
									 CGRect bounds)
{
	CGFloat delta = 0.0f;
	BOOL expanded = NO;
	
	// 1. measuring the minimum size
	CGSize size = bounds.size;
	// expand bounds to include all subviews
	UIView * v;
	CGRect frame;
	
	S9_FOR_EACH(view.subviews, v) {
		frame = v.frame;
		switch (direction) {
				/* top */
			case UIWaterfallViewDirectionTopLeft:
			case UIWaterfallViewDirectionTopRight:
				delta = frame.origin.y + frame.size.height + spaceVertical - size.height;
				if (delta > 0.0f) {
					size.height += delta;
					expanded = YES;
				}
				break;
				
				/* bottom */
			case UIWaterfallViewDirectionBottomLeft:
			case UIWaterfallViewDirectionBottomRight:
				delta = frame.origin.y - spaceVertical + (size.height - bounds.size.height);
				if (delta < 0.0f) {
					size.height -= delta;
					expanded = YES;
				}
				break;
				
				/* left */
			case UIWaterfallViewDirectionLeftTop:
			case UIWaterfallViewDirectionLeftBottom:
				delta = frame.origin.x + frame.size.width + spaceHorizontal - size.width;
				if (delta > 0.0f) {
					size.width += delta;
					expanded = YES;
				}
				break;
				
				/* right */
			case UIWaterfallViewDirectionRightTop:
			case UIWaterfallViewDirectionRightBottom:
				delta = frame.origin.x - spaceHorizontal + (size.width - bounds.size.width);
				if (delta < 0.0f) {
					size.width -= delta;
					expanded = YES;
				}
				break;
				
			default:
				break;
		}
	}
	
	if (!expanded) {
		// no need to resize, return
		return;
	}
	
	// 2. expand size
	view.bounds = CGRectMake(bounds.origin.x, bounds.origin.y, size.width, size.height);
	
	// move to new position
	CGFloat dx = size.width - bounds.size.width;
	CGFloat dy = size.height - bounds.size.height;
	CGPoint center = view.center;
	center.x += dx * 0.5f;
	center.y += dy * 0.5f;
	view.center = center;
	
	// move subviews if needs
	if (UIWaterfallViewDirectionMatch(UIWaterfallViewDirectionMaskBottom, direction)) {
		S9_FOR_EACH(view.subviews, v) {
			center = v.center;
			center.y += dy;
			v.center = center;
		}
	} else if (UIWaterfallViewDirectionMatch(UIWaterfallViewDirectionMaskRight, direction)) {
		S9_FOR_EACH(view.subviews, v) {
			center = v.center;
			center.x += dx;
			v.center = center;
		}
	}
	
	// 3. call delegate
	if (view.delegate) {
		[view.delegate didResizeWaterfallView:view];
	} else if ([view.superview isKindOfClass:[UIScrollView class]]) {
		UIScrollView * scrollView = (UIScrollView *)view.superview;
		// minimum size
		frame = view.frame;
		CGSize s1 = CGSizeMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
		// current size
		CGSize s2 = scrollView.contentSize;
		scrollView.contentSize = CGSizeMake(s1.width < s2.width ? s2.width : s1.width,
											s1.height < s2.height ? s2.height : s1.height);
	}
}

#pragma mark -

@implementation UIWaterfallView (Layout)

+ (CGSize) layoutSubviewsInView:(UIView *)view
{
	return [self layoutSubviewsInView:view towards:UIWaterfallViewDirectionTopLeft spaceHorizontal:0.0f spaceVertical:0.0f];
}

+ (CGSize) layoutSubviewsInView:(UIView *)view towards:(UIWaterfallViewDirection)direction
{
	return [self layoutSubviewsInView:view towards:direction spaceHorizontal:0.0f spaceVertical:0.0f];
}

+ (CGSize) layoutSubviewsInView:(UIView *)view towards:(UIWaterfallViewDirection)direction spaceHorizontal:(CGFloat)spaceHorizontal spaceVertical:(CGFloat)spaceVertical
{
	CGRect bounds = view.bounds;
	NSArray * subviews = view.subviews;
	NSUInteger count = [subviews count];
	
	// 1. create a pool for joining points
	//    each subview may offers two new joining point,
	//    create a pool to save all available joining point(s)
	ds_array * pointPool = ds_array_create(sizeof(CGPoint), count * 2);
	pointPool->bk.assign = ds_assign_point_b;
	add_first_joining_point(pointPool, direction, spaceHorizontal, spaceVertical, bounds);
	NSAssert(pointPool->bk.compare, @"init failed");
	
	UIView * child;
	CGRect frame;
	
	NSInteger index;
	NSInteger offset;
	
	UIView * v;
	BOOL conflicts;
	
	CGPoint * point;
	
	// 2. layout each subview
	index = -1;
	S9_FOR_EACH(subviews, child) {
		++index;
		NSAssert(pointPool->count > 0, @"no available joining point");
		frame = child.frame;
		
		// 2.1. trying each joining points
		DS_FOR_EACH_ARRAY_ITEM(pointPool, point, offset) {
			// 2.1.1. place it on the joing point
			//        if the frame outside the bounds, continue
			if (!place_on_joining_point(&frame, *point, direction, spaceHorizontal, spaceVertical, bounds)) {
				continue;
			}
			
			// 2.1.2. check each elder sibling whether conflict
			conflicts = NO;
			S9_FOR_EACH_REVERSE(subviews, v) {
				if (CGRectIntersectsRect(frame, v.frame)) {
					conflicts = YES;
					// TODO: check whether the space is too small, if YES, remove it
					break;
				}
			}
			
			if (!conflicts) {
				break; // got a joining point with enough space
			}
		}
		
		// 2.2. check joining point
		if (offset < pointPool->count) {
			// delete the joining point
			ds_array_remove(pointPool, offset);
		} else {
			NSAssert(false, @"no joining point match?");
			// FIXME: place it anywhere that has enough space
			continue;
		}
		
		// 2.3. place it
		child.frame = frame;
		
		// 2.4. add two new joing points
		add_two_joining_points(pointPool, frame, direction, spaceVertical, spaceVertical, bounds);
	}
	
	// 3. destroy the pool for joining points
	ds_array_destroy(pointPool);
	
	// 4. handle frame
	if ([view isKindOfClass:[UIWaterfallView class]]) {
		expand_waterfall_view((UIWaterfallView *)view, direction, spaceHorizontal, spaceVertical, bounds);
	}
	
	return view.bounds.size;
}

@end

#endif
