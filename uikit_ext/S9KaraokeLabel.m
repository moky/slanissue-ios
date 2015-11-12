//
//  UIKaraokeLabel.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-12.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9KaraokeLabel.h"

@interface UIKaraokeLabel () {
	
	UILabel * _maskLabel;
	CAGradientLayer * _maskLayer;
}

@end

@implementation UIKaraokeLabel

@synthesize progress = _progress;

- (void) dealloc
{
	[_maskLayer release];
	[_maskLabel release];
	[super dealloc];
}

- (void) _initializeUIKaraokeLabel
{
	_progress = 0.0f;
	
	// create mask label
	[_maskLabel release];
	_maskLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_maskLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:_maskLabel];
	
	// create mask
	[_maskLayer release];
	_maskLayer = [[CAGradientLayer alloc] init];
	_maskLayer.frame = self.bounds;
	_maskLayer.startPoint = CGPointMake(0.0f, 0.0f);
	_maskLayer.endPoint = CGPointMake(1.0f, 0.0f);
	_maskLabel.layer.mask = _maskLayer;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIKaraokeLabel];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIKaraokeLabel];
	}
	return self;
}

- (void) setProgress:(CGFloat)progress
{
	if (progress < 0.0f) {
		progress = 0.0f;
	} else if (progress > 1.0f) {
		progress = 1.0f;
	}
	
	if (_progress != progress) {
		_maskLayer.locations = @[@(progress - 0.01f), @(progress + 0.01f)];
		_progress = progress;
	}
}

- (void) setHighlightedTextColor:(UIColor *)highlightedTextColor
{
	[_maskLabel setTextColor:highlightedTextColor];
	
	if (highlightedTextColor) {
		CGColorRef colorL = highlightedTextColor.CGColor;
		CGColorRef colorR = [UIColor clearColor].CGColor;
		_maskLayer.colors = @[(id)colorL, (id)colorR];
	}
}

- (void) setHighlighted:(BOOL)highlighted
{
	// do nothing
}

- (void) setText:(NSString *)text
{
	[super setText:text];
	[_maskLabel setText:text];
}

- (void) setFont:(UIFont *)font
{
	[super setFont:font];
	[_maskLabel setFont:font];
}

- (void) setTextAlignment:(NSTextAlignment)textAlignment
{
	[super setTextAlignment:textAlignment];
	[_maskLabel setTextAlignment:textAlignment];
}

@end
