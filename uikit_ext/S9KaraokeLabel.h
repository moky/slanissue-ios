//
//  UIKaraokeLabel.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-12.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

@interface UIKaraokeLabel : UILabel

@property(nonatomic, readwrite) CGFloat progress; // 0.0 - 1.0

@end

@interface UIKaraokeLabel (Animate)

- (void) runWithDuration:(NSTimeInterval)duration; // run once
- (void) runWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count;

@end

#endif
