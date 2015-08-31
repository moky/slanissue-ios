//
//  UIWaterfallView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9WaterfallView+Layout.h"
#import "S9WaterfallView.h"

@implementation UIWaterfallView

@synthesize direction = _direction;

@synthesize spaceHorizontal = _spaceHorizontal;
@synthesize spaceVertical = _spaceVertical;

@synthesize delegate = _delegate;

- (void) _initializeUIWaterfallView
{
	_direction = UIWaterfallViewDirectionTopLeft;
	
	_spaceHorizontal = 0.0f;
	_spaceVertical = 0.0f;
	
	_delegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIWaterfallView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIWaterfallView];
	}
	return self;
}

- (CGFloat) space
{
	NSAssert(_spaceHorizontal == _spaceVertical, @"space can be accessed only when horizontal equals to vertical");
	return _spaceHorizontal;
}

- (void) setSpace:(CGFloat)space
{
	self.spaceHorizontal = space;
	self.spaceVertical = space;
}

- (void) setSpaceHorizontal:(CGFloat)spaceHorizontal
{
	if (_spaceHorizontal != spaceHorizontal) {
		_spaceHorizontal = spaceHorizontal;
		[self setNeedsLayout];
	}
}

- (void) setSpaceVertical:(CGFloat)spaceVertical
{
	if (_spaceVertical != spaceVertical) {
		_spaceVertical = spaceVertical;
		[self setNeedsLayout];
	}
}

- (void) setDirection:(UIWaterfallViewDirection)direction
{
	if (_direction != direction) {
		_direction = direction;
		[self setNeedsLayout];
	}
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[[self class] layoutSubviewsInView:self
							   towards:_direction
					   spaceHorizontal:_spaceHorizontal
						 spaceVertical:_spaceVertical];
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	[self setNeedsLayout];
}

- (void) willRemoveSubview:(UIView *)subview
{
	[super willRemoveSubview:subview];
	[self setNeedsLayout];
}

@end
