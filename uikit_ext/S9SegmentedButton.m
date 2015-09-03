//
//  UISegmentedButton.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"
#import "S9Control.h"
#import "S9SegmentedButton.h"

@implementation UISegmentedButton

@synthesize selectedSegmentIndex = _selectedSegmentIndex;
@synthesize direction = _direction;

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_selectedSegmentIndex = UISegmentedButtonNoSegment;
		_direction = UISegmentedButtonAutoLayoutNone;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_selectedSegmentIndex = UISegmentedButtonNoSegment;
		_direction = UISegmentedButtonAutoLayoutNone;
	}
	return self;
}

- (NSUInteger) numberOfSegments
{
	return [self.subviews count];
}

- (void) setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
	NSAssert(selectedSegmentIndex >= -1 && selectedSegmentIndex < self.numberOfSegments, @"error segment index: %d", (int)selectedSegmentIndex);
	
	if (_selectedSegmentIndex != selectedSegmentIndex) {
		UIButton * button;
		
		// unselect the old item
		if (_selectedSegmentIndex != UISegmentedButtonNoSegment) {
			button = [self buttonForSegmentAtIndex:_selectedSegmentIndex];
			button.selected = NO;
		}
		
		// select the new item
		if (selectedSegmentIndex != UISegmentedButtonNoSegment) {
			button = [self buttonForSegmentAtIndex:selectedSegmentIndex];
			button.selected = YES;
		}
		
		// change value
		_selectedSegmentIndex = selectedSegmentIndex;
		
		if (selectedSegmentIndex != UISegmentedButtonNoSegment) {
			// send out message 'onChange:'
			[self performControlEvent:UIControlEventValueChanged];
		}
	}
}

- (void) insertSubview:(UIView *)view atIndex:(NSInteger)index
{
	NSUInteger count = [self.subviews count];
	if (index < count) {
		view.tag = index;
		[super insertSubview:view atIndex:index];
		// increase the tag of followed button(s)
		++index;
		for (; index < count; ++index) {
			view = [self buttonForSegmentAtIndex:index];
			view.tag = index; // tag++
		}
	} else if (index == count) {
		view.tag = index;
		[self addSubview:view];
	} else {
		NSAssert(false, @"error index: %d >= %u", (int)index, (unsigned int)count);
	}
}

- (void) _layoutButtons
{
	if (_direction == UISegmentedButtonAutoLayoutNone) {
		return;
	}
	NSUInteger count = [self.subviews count];
	NSAssert(count > 0, @"buttons not found");
	
	CGRect bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
	if (_direction == UISegmentedButtonAutoLayoutDirectionHorizontal) {
		bounds.size.width /= count;
	} else {
		bounds.size.height /= count;
	}
	CGPoint center = CGPointMake(bounds.size.width * 0.5f, bounds.size.height * 0.5f);
	
	UIButton * btn;
	S9_FOR_EACH(self.subviews, btn) {
		btn.bounds = bounds;
		btn.center = center;
		if (_direction == UISegmentedButtonAutoLayoutDirectionHorizontal) {
			center.x += bounds.size.width;
		} else {
			center.y += bounds.size.height;
		}
	}
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[self _layoutButtons];
}

- (void) setDirection:(UISegmentedButtonAutoLayoutDirection)direction
{
	//if (_direction != direction) {
	_direction = direction;
	if (_direction != UISegmentedButtonAutoLayoutNone) {
		[self setNeedsLayout];
	}
	//}
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	NSAssert([subview isKindOfClass:[UIButton class]], @"must be a button: %@", subview);
	UIButton * button = (UIButton *)subview;
	[button addTarget:self action:@selector(_onClickSegment:) forControlEvents:UIControlEventTouchUpInside];
	
	if (_direction != UISegmentedButtonAutoLayoutNone) {
		[self setNeedsLayout];
	}
}

- (void) willRemoveSubview:(UIView *)subview
{
	NSAssert([subview isKindOfClass:[UIButton class]], @"must be a button: %@", subview);
	UIButton * button = (UIButton *)subview;
	[button removeTarget:self action:@selector(_onClickSegment:) forControlEvents:UIControlEventTouchUpInside];
	
	[super willRemoveSubview:subview];
}

- (void) _onClickSegment:(UIButton *)button
{
	NSInteger index = button.tag;
	NSAssert(index >= 0 && index < self.numberOfSegments, @"error segment: %d", (int)index);
	self.selectedSegmentIndex = index;
}

- (void) insertSegmentWithButton:(UIButton *)button atIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
	}
	
	[self insertSubview:button atIndex:segment];
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void) removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
	}
	
	UIView * view = [self buttonForSegmentAtIndex:segment];
	[view removeFromSuperview];
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void) removeAllSegments
{
	NSUInteger count = [self numberOfSegments];
	NSInteger index;
	for (index = count - 1; index >= 0; --index) {
		[self removeSegmentAtIndex:index animated:NO];
	}
}

- (void) setButton:(UIButton *)button forSegmentAtIndex:(NSUInteger)segment
{
	UIButton * old = [self buttonForSegmentAtIndex:segment];
	if (button != old) {
		[old removeFromSuperview];
		[self insertSubview:button atIndex:segment];
	}
}

- (UIButton *) buttonForSegmentAtIndex:(NSUInteger)segment
{
	NSAssert(segment < self.numberOfSegments, @"segment error: %u >= %u", (unsigned int)segment, (unsigned int)self.numberOfSegments);
	UIView * view = [self.subviews objectAtIndex:segment];
	NSAssert([view isKindOfClass:[UIButton class]], @"error button: %@", view);
	return (UIButton *)view;
}

- (void) setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
	UIButton * button = [self buttonForSegmentAtIndex:segment];
	button.enabled = enabled;
}

- (BOOL) isEnabledForSegmentAtIndex:(NSUInteger)segment
{
	UIButton * button = [self buttonForSegmentAtIndex:segment];
	return button.enabled;
}

@end
