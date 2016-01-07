//
//  UISegmentedButton.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

enum {
	UISegmentedButtonNoSegment = -1   // segment index for no selected segment
};

typedef NS_ENUM(NSUInteger, UISegmentedButtonAutoLayoutDirection) {
	UISegmentedButtonAutoLayoutNone,
	UISegmentedButtonAutoLayoutDirectionVertical,
	UISegmentedButtonAutoLayoutDirectionHorizontal,
};

//
//  Description:
//      A group of buttons as segmented control
//
@interface UISegmentedButton : UIControl

@property(nonatomic, readonly) NSUInteger numberOfSegments;

// returns last segment pressed. default is UISegmentedButtonNoSegment until a segment is pressed
// the UIControlEventValueChanged action is invoked when the segment changes via a user event. set to UISegmentedButtonNoSegment to turn off selection
@property(nonatomic, readwrite) NSInteger selectedSegmentIndex;

- (void) insertSegmentWithButton:(UIButton *)button atIndex:(NSUInteger)segment animated:(BOOL)animated; // insert before segment number. 0..#segments. value pinned
- (void) removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void) removeAllSegments;

- (void) setButton:(UIButton *)button forSegmentAtIndex:(NSUInteger)segment; // must be 0..#segments - 1 (or ignored). default is nil
- (UIButton *) buttonForSegmentAtIndex:(NSUInteger)segment;

- (void) setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment; // default is YES
- (BOOL) isEnabledForSegmentAtIndex:(NSUInteger)segment;

@property(nonatomic, readwrite) UISegmentedButtonAutoLayoutDirection direction; // default is None

@end

#endif
