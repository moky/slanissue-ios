//
//  UIDockScrollView.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9PageScrollView.h"

#if !TARGET_OS_WATCH

@interface UIDockScrollView : UIPageScrollView

@property(nonatomic, readwrite) BOOL reflectionEnabled; // default is YES

@property(nonatomic, readwrite) CGFloat scale; // default is 0.2

- (void) performEffectOnScrollView:(UIScrollView *)scrollView;

@end

#endif
