//
//  S9Geometry.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "s9Macros.h"
#import "S9Geometry.h"

CGSize CGSizeAspectFit(CGSize fromSize, CGSize toSize)
{
	if (fromSize.width > 0.0f && fromSize.height > 0.0f) {
		CGFloat dw = toSize.width / fromSize.width;
		CGFloat dh = toSize.height / fromSize.height;
		if (dw < dh) {
			return CGSizeMake(toSize.width, fromSize.height * dw);
		} else if (dw > dh) {
			return CGSizeMake(fromSize.width * dh, toSize.height);
		} else {
			return toSize;
		}
	} else {
		return fromSize;
	}
}

CGSize CGSizeAspectFill(CGSize fromSize, CGSize toSize)
{
	if (fromSize.width > 0.0f && fromSize.height > 0.0f) {
		CGFloat dw = toSize.width / fromSize.width;
		CGFloat dh = toSize.height / fromSize.height;
		if (dw > dh) {
			return CGSizeMake(toSize.width, fromSize.height * dw);
		} else if (dw < dh) {
			return CGSizeMake(fromSize.width * dh, toSize.height);
		} else {
			return toSize;
		}
	} else {
		return fromSize;
	}
}

CGRect CGRectGetFrameFromNode(id node)
{
	if ([node isKindOfClass:[UIView class]]) {
		UIView * view = (UIView *)node;
		return view.frame;
	} else if ([node isKindOfClass:[CALayer class]]) {
		CALayer * layer = (CALayer *)node;
		return layer.frame;
	} else if ([node isKindOfClass:[UIViewController class]]) {
		UIViewController * vc = (UIViewController *)node;
		UIView * view = vc.view;
		return view.frame;
	} else {
		S9Log(@"unsupported node: %@", node);
		return CGRectZero;
	}
}

CGRect CGRectGetBoundsFromParentOfNode(id node)
{
	if ([node isKindOfClass:[UIView class]]) {
		UIView * view = (UIView *)node;
		if (view.superview) {
			return view.superview.bounds;
		} else if (view.window) {
			return view.window.bounds;
		} else {
			return [UIScreen mainScreen].bounds;
		}
	} else if ([node isKindOfClass:[CALayer class]]) {
		CALayer * layer = (CALayer *)node;
		if (layer.superlayer) {
			return layer.superlayer.bounds;
		} else {
			return [UIScreen mainScreen].bounds;
		}
	} else if ([node isKindOfClass:[UIViewController class]]) {
		UIViewController * vc = (UIViewController *)node;
		if (vc.parentViewController) {
			return vc.parentViewController.view.bounds;
		} else if (vc.view.window) {
			return vc.view.window.bounds;
		} else {
			return [UIScreen mainScreen].bounds;
		}
	} else {
		S9Log(@"unsupported node: %@", node);
		return [UIScreen mainScreen].bounds;
	}
}

void ds_assign_point(ds_type * dest, const ds_type * src, const ds_size size)
{
	CGPoint * p = (CGPoint *)dest;
	CGPoint * v = (CGPoint *)src;
	p->x = v->x;
	p->y = v->y;
}

void ds_assign_size(ds_type * dest, const ds_type * src, const ds_size size)
{
	CGSize * p = (CGSize *)dest;
	CGSize * v = (CGSize *)src;
	p->width = v->width;
	p->height = v->height;
}

void ds_assign_vector(ds_type * dest, const ds_type * src, const ds_size size)
{
	CGVector * p = (CGVector *)dest;
	CGVector * v = (CGVector *)src;
	p->dx = v->dx;
	p->dy = v->dy;
}

void ds_assign_rect(ds_type * dest, const ds_type * src, const ds_size size)
{
	CGRect * p = (CGRect *)dest;
	CGRect * v = (CGRect *)src;
	p->origin.x = v->origin.x;
	p->origin.y = v->origin.y;
	p->size.width = v->size.width;
	p->size.height = v->size.height;
}
