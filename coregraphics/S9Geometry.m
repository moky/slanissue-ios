//
//  S9Geometry.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "s9Macros.h"
#import "S9Layer.h"
#import "S9View.h"
#import "S9ViewController.h"
#import "S9Geometry.h"

CGSize CGSizeAspectFit(CGSize fromSize, CGSize toSize)
{
	if (fromSize.width <= 0.0f || fromSize.height <= 0.0f) {
		// error
		return fromSize;
	}
	
	CGFloat dw = toSize.width / fromSize.width;
	CGFloat dh = toSize.height / fromSize.height;
	// use the smaller factor to fit the frame
	if (dw < dh) {
		return CGSizeMake(toSize.width, fromSize.height * dw);
	} else if (dw > dh) {
		return CGSizeMake(fromSize.width * dh, toSize.height);
	} else {
		return toSize;
	}
}

CGSize CGSizeAspectFill(CGSize fromSize, CGSize toSize)
{
	if (fromSize.width <= 0.0f || fromSize.height <= 0.0f) {
		// error
		return fromSize;
	}
	
	CGFloat dw = toSize.width / fromSize.width;
	CGFloat dh = toSize.height / fromSize.height;
	// use the bigger factor to fill the frame
	if (dw > dh) {
		return CGSizeMake(toSize.width, fromSize.height * dw);
	} else if (dw < dh) {
		return CGSizeMake(fromSize.width * dh, toSize.height);
	} else {
		return toSize;
	}
}

CGRect CGRectGetFrameFromNode(id node)
{
#if !TARGET_OS_WATCH
	if ([node isKindOfClass:[UIView class]] ||
		[node isKindOfClass:[UIViewController class]] ||
		[node isKindOfClass:[CALayer class]]) {
		return [node frame];
	}
#endif
	S9Log(@"unsupported node: %@", node);
	return CGRectZero;
}

CGRect CGRectGetBoundsFromParentOfNode(id node)
{
#if !TARGET_OS_WATCH
	if ([node isKindOfClass:[UIView class]] ||
		[node isKindOfClass:[UIViewController class]] ||
		[node isKindOfClass:[CALayer class]]) {
		id parent = [node parent];
		return parent ? [parent bounds] : [[UIScreen mainScreen] bounds];
	}
#endif
	S9Log(@"unsupported node: %@", node);
	return CGRectZero;
}

#pragma mark -

void ds_assign_point(ds_type * dest, const ds_type * src)
{
	CGPoint * p = (CGPoint *)dest;
	CGPoint * v = (CGPoint *)src;
	p->x = v->x;
	p->y = v->y;
}

void ds_assign_size(ds_type * dest, const ds_type * src)
{
	CGSize * p = (CGSize *)dest;
	CGSize * v = (CGSize *)src;
	p->width = v->width;
	p->height = v->height;
}

void ds_assign_vector(ds_type * dest, const ds_type * src)
{
	CGVector * p = (CGVector *)dest;
	CGVector * v = (CGVector *)src;
	p->dx = v->dx;
	p->dy = v->dy;
}

void ds_assign_rect(ds_type * dest, const ds_type * src)
{
	CGRect * p = (CGRect *)dest;
	CGRect * v = (CGRect *)src;
	p->origin.x = v->origin.x;
	p->origin.y = v->origin.y;
	p->size.width = v->size.width;
	p->size.height = v->size.height;
}
