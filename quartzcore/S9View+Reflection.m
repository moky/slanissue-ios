//
//  S9View+Reflection.m
//  SlanissueToolkit
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "S9Array.h"
#import "S9View+Reflection.h"

#define S9_VIEW_REFLECTION_LAYER_NAME          @"reflection"

#define S9_VIEW_REFLECTION_LAYER_OPACITY       0.3f
#define S9_VIEW_REFLECTION_LAYER_START_POINT   0.4f
#define S9_VIEW_REFLECTION_LAYER_END_POINT     1.0f

@implementation UIView (Reflection)

- (BOOL) hasReflection
{
	CALayer * layer;
	S9_FOR_EACH(layer, self.layer.sublayers) {
		if ([layer.name isEqualToString:S9_VIEW_REFLECTION_LAYER_NAME]) {
			return YES;
		}
	}
	return NO;
}

- (void) hideReflection
{
	NSArray * subLayers = self.layer.sublayers;
	CALayer * layer;
	S9_FOR_EACH_REVERSE_SAFE(layer, subLayers) {
		if ([layer.name isEqualToString:S9_VIEW_REFLECTION_LAYER_NAME]) {
			[layer removeFromSuperlayer];
		}
	}
}

- (void) showReflection
{
	[self showReflectionWithOpacity:S9_VIEW_REFLECTION_LAYER_OPACITY
						 startPoint:S9_VIEW_REFLECTION_LAYER_START_POINT
						   endPoint:S9_VIEW_REFLECTION_LAYER_END_POINT];
}

- (void) showReflectionWithOpacity:(CGFloat)opacity
{
	[self showReflectionWithOpacity:opacity
						 startPoint:S9_VIEW_REFLECTION_LAYER_START_POINT
						   endPoint:S9_VIEW_REFLECTION_LAYER_END_POINT];
}

- (void) showReflectionWithStartPoint:(CGFloat)start endPoint:(CGFloat)end
{
	[self showReflectionWithOpacity:S9_VIEW_REFLECTION_LAYER_OPACITY
						 startPoint:start
						   endPoint:end];
}

- (void) showReflectionWithOpacity:(CGFloat)opacity startPoint:(CGFloat)start endPoint:(CGFloat)end
{
	if ([self hasReflection]) {
		// already add reflection
		return;
	}
	
	CALayer * layer = self.layer;
	
	CGRect bounds = self.bounds;
	CGSize size = bounds.size;
	CGFloat width = size.width;
	CGFloat height = size.height;
	CGPoint center = CGPointMake(width * 0.5f, height * 0.5f);
	
	// reflection
	CALayer * reflectLayer = [[CALayer alloc] init];
	reflectLayer.name = S9_VIEW_REFLECTION_LAYER_NAME;
	reflectLayer.contents = layer.contents;
	reflectLayer.bounds = bounds;
	reflectLayer.position = CGPointMake(center.x, center.y + height);
	reflectLayer.opacity = opacity;
	reflectLayer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
	
	// mask for reflection
	CGColorRef whiteColor = [UIColor whiteColor].CGColor;
	CGColorRef clearColor = [UIColor clearColor].CGColor;
	
	CAGradientLayer * mask = [[CAGradientLayer alloc] init];
	mask.bounds = bounds;
	mask.position = center;
	mask.colors = [NSArray arrayWithObjects:(id)clearColor, (id)whiteColor, nil];
	mask.startPoint = CGPointMake(0.5f, start);
	mask.endPoint = CGPointMake(0.5f, end);
	reflectLayer.mask = mask;
	[mask release];
	
	[layer addSublayer:reflectLayer];
	[reflectLayer release];
}

@end
