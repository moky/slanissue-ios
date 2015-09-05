//
//  S9ViewController.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SlanissueToolkit)

// get frame/bounds/center of self.view
- (CGRect) frame;
- (CGRect) bounds;
- (CGPoint) center;

// get superlayer
- (UIViewController *) parent;

// get all sublayers
- (NSArray *) children;

// get all children of parent, includes self
- (NSArray *) siblings;

@end
