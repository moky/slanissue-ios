//
//  S9View+Transform.m
//  SlanissueToolkit
//
//  Created by Moky on 14-7-9.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "S9AffineTransform.h"
#import "S9View+Transform.h"

@implementation UIView (Transform2D)

- (void) scaleWithScale:(CGFloat)scale
{
	[self scaleWithScaleX:scale scaleY:scale];
}

- (void) scaleWithScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY
{
	CATransform3D transform = self.layer.transform;
	transform = CATransform3DScale(transform, scaleX, scaleY, 1.0f);
	self.layer.transform = transform;
}

- (void) rotateWithRotation:(CGFloat)rotation
{
	CATransform3D transform = self.layer.transform;
	transform = CATransform3DRotate(transform, rotation, 0.0f, 0.0f, 1.0f);
	self.layer.transform = transform;
}

@end

@implementation UIView (Transform3D)

- (void) resetTransform
{
	self.layer.transform = CATransform3DIdentity;
}

- (void) _rotateAxesWithRadians:(CGFloat)radians x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z d:(CGFloat)disZ
{
	CATransform3D transform = self.layer.transform;
	transform = CATransform3DRotate(transform, radians, x, y, z);
	transform = CATransform3DPerspect(transform, CGPointZero, disZ);
	self.layer.transform = transform;
}

// rotating around axis X
- (void) pitchWithRotation:(CGFloat)radians
{
	[self _rotateAxesWithRadians:radians x:1.0f y:0.0f z:0.0f d:self.bounds.size.height];
}

// rotating around axis Y
- (void) rollWithRotation:(CGFloat)radians
{
	[self _rotateAxesWithRadians:radians x:0.0f y:1.0f z:0.0f d:self.bounds.size.width];
}

// rotating around axis Z
- (void) yawWithRotation:(CGFloat)radians
{
	[self _rotateAxesWithRadians:radians x:0.0f y:0.0f z:1.0f d:1.0f];
}

@end
