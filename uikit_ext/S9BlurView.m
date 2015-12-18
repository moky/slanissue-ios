//
//  S9BlurView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-19.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Client.h"
#import "S9BlurView.h"

@interface UIBlurView () {
	
	UIView * _mask;
}

@end

@implementation UIBlurView

@synthesize style = _style;

- (void) dealloc
{
	[_mask release];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[_mask release];
		_mask = nil;
		
		_style = -1;
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[_mask release];
		_mask = nil;
		
		_style = -1;
	}
	return self;
}

- (void) setStyle:(UIBlurViewStyle)style
{
	if (_style != style) {
		
#ifdef __IPHONE_7_0
		CGFloat systemVersion = [[[S9Client getInstance] systemVersion] floatValue];
#ifdef __IPHONE_8_0
		if (systemVersion >= 8.0f) {
			// add blur effect
			UIVisualEffect * ve = [UIBlurEffect effectWithStyle:(UIBlurEffectStyle)style];
			NSAssert(ve, @"error effect style: %d", (int)style);
			UIVisualEffectView * vev = [[UIVisualEffectView alloc] initWithEffect:ve];
			vev.frame = self.bounds;
			[self addSubview:vev];
			
			[_mask removeFromSuperview];
			[_mask release];
			_mask = vev;
		} else
#endif // EOF '__IPHONE_8_0'
			
#if !TARGET_OS_TV
			
		if (systemVersion >= 7.0f) {
			// add tool bar
			UIToolbar * tb = [[UIToolbar alloc] initWithFrame:self.bounds];
			if (style == UIBlurViewStyleDark) {
				tb.barStyle = UIBarStyleBlack;
			}
			tb.translucent = YES;
			[self addSubview:tb];
			
			[_mask removeFromSuperview];
			[_mask release];
			_mask = tb;
		} else
			
#endif
			
#endif // EOF '__IPHONE_7_0'
		{
			// use half-translucent background color instead the effect
			switch (style) {
				case UIBlurViewStyleExtraLight:
					self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.888f];
					break;
					
				case UIBlurViewStyleLight:
					self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.618f];
					break;
					
				case UIBlurViewStyleDark:
					self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.618f];
					break;
					
				default:
					break;
			}
		}
		
		_style = style;
	}
}

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_mask.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
}

- (void) setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	_mask.frame = bounds;
}

- (void) layoutSubviews
{
	[self bringSubviewToFront:_mask];
	[super layoutSubviews];
}

@end
