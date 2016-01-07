//
//  UIKaraokeLabel.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-12.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9KaraokeLabel.h"

#if !TARGET_OS_WATCH

@interface UIKaraokeLabel () {
	
	UILabel * _frontLabel;
	CAGradientLayer * _frontMask;
	
	UILabel * _backLabel;
	CAGradientLayer * _backMask;
}

@end

@implementation UIKaraokeLabel

@synthesize progress = _progress;

- (void) dealloc
{
	[_frontLabel release];
	[_frontMask release];
	
	[_backLabel release];
	[_backMask release];
	
	[super dealloc];
}

- (void) _createFrontLabel
{
	UIColor * color = [[_frontLabel.textColor retain] autorelease];
	
	// create front label
	[_frontLabel removeFromSuperview];
	[_frontLabel release];
	_frontLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_frontLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_frontLabel.font = self.font;
	_frontLabel.textAlignment = self.textAlignment;
	_frontLabel.text = self.text;
	_frontLabel.textColor = color ? color : [UIColor redColor];
	
	// create front mask layer
	[_frontMask removeFromSuperlayer];
	[_frontMask release];
	_frontMask = [[CAGradientLayer alloc] init];
	_frontMask.frame = self.bounds;
	_frontMask.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor];
	_frontMask.locations = @[@(0.99f), @(1.0f)];
	_frontMask.startPoint = CGPointMake(0.0f, 0.0f);
	_frontMask.endPoint = CGPointMake(1.0f, 0.0f);
	
	_frontLabel.layer.mask = _frontMask;
	[self addSubview:_frontLabel];
}

- (void) _createBackLabel
{
	UIColor * color = [[_backLabel.textColor retain] autorelease];
	
	// create back label
	[_backLabel removeFromSuperview];
	[_backLabel release];
	_backLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_backLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_backLabel.font = self.font;
	_backLabel.textAlignment = self.textAlignment;
	_backLabel.text = self.text;
	_backLabel.textColor = color;
	
	// create back mask layer
	[_backMask removeFromSuperlayer];
	[_backMask release];
	_backMask = [[CAGradientLayer alloc] init];
	_backMask.frame = self.bounds;
	_backMask.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor];
	_backMask.locations = @[@(0.0f), @(0.01f)];
	_backMask.startPoint = CGPointMake(0.0f, 0.0f);
	_backMask.endPoint = CGPointMake(1.0f, 0.0f);
	
	_backLabel.layer.mask = _backMask;
	[self addSubview:_backLabel];
}

- (void) _initializeUIKaraokeLabel
{
	[super setTextColor:[UIColor clearColor]];
	
	[self _createBackLabel];
	[self _createFrontLabel];
	
	// reset progress
	_progress = 1.0f;
	self.progress = 0.0f;
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
		CGFloat width = self.bounds.size.width;
		
		CGFloat tx = width * progress;
		[_backMask setValue:@(tx) forKeyPath:@"transform.translation.x"];
		
		tx -= width;
		[_frontMask setValue:@(tx) forKeyPath:@"transform.translation.x"];
		
		_progress = progress;
	}
}

- (UIColor *) textColor
{
	return _backLabel.textColor;
}

- (void) setTextColor:(UIColor *)textColor
{
	_backLabel.textColor = textColor;
}

- (UIColor *) highlightedTextColor
{
	return _frontLabel.textColor;
}

- (void) setHighlightedTextColor:(UIColor *)highlightedTextColor
{
	_frontLabel.textColor = highlightedTextColor;
}

- (void) setHighlighted:(BOOL)highlighted
{
	// do nothing
}

- (void) setText:(NSString *)text
{
	[super setText:text];
	_frontLabel.text =
	_backLabel.text = text;
}

- (void) setFont:(UIFont *)font
{
	[super setFont:font];
	_frontLabel.font =
	_backLabel.font = font;
}

- (void) setTextAlignment:(NSTextAlignment)textAlignment
{
	[super setTextAlignment:textAlignment];
	_frontLabel.textAlignment =
	_backLabel.textAlignment = textAlignment;
}

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	if (!CGSizeEqualToSize(_backMask.frame.size, frame.size)) {
		[self _createBackLabel];
		[self _createFrontLabel];
	}
}

- (void) setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	
	if (!CGSizeEqualToSize(_backMask.bounds.size, bounds.size)) {
		[self _createBackLabel];
		[self _createFrontLabel];
	}
}

@end

@implementation UIKaraokeLabel (Animate)

- (void) runWithDuration:(NSTimeInterval)duration
{
	[self runWithDuration:duration repeatCount:1];
}

- (void) runWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count
{
	{
		CABasicAnimation * basicAnimation = [CABasicAnimation animation];
		basicAnimation.keyPath = @"transform.translation.x";
		basicAnimation.fromValue = @(-self.bounds.size.width);
		basicAnimation.toValue = @(0);
		basicAnimation.duration = duration;
		basicAnimation.repeatCount = count;
		basicAnimation.removedOnCompletion = NO;
		basicAnimation.fillMode = kCAFillModeForwards;
		[_frontMask addAnimation:basicAnimation forKey:nil];
	}
	{
		CABasicAnimation * basicAnimation = [CABasicAnimation animation];
		basicAnimation.keyPath = @"transform.translation.x";
		basicAnimation.fromValue = @(0);
		basicAnimation.toValue = @(self.bounds.size.width);
		basicAnimation.duration = duration;
		basicAnimation.repeatCount = count;
		basicAnimation.removedOnCompletion = NO;
		basicAnimation.fillMode = kCAFillModeForwards;
		[_backMask addAnimation:basicAnimation forKey:nil];
	}
}

@end

#endif
