//
//  S9ViewController.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

@interface UIViewController (SlanissueToolkit)

// frame/bounds/center of self.view
- (CGRect) frame;
- (CGRect) bounds;
- (CGPoint) center;

// parentViewController
- (UIViewController *) parent;

// childViewControllers
- (NSArray *) children;

// get all children of parent, includes self
- (NSArray *) siblings;

@end

#endif
