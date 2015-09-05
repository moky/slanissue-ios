//
//  S9ViewController.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ViewController.h"

@implementation UIViewController (SlanissueToolkit)

- (CGRect) frame
{
	return self.view.frame;
}

- (CGRect) bounds
{
	return self.view.bounds;
}

- (CGPoint) center
{
	return self.view.center;
}

- (UIViewController *) parent
{
	return self.parentViewController;
}

- (NSArray *) children
{
	return self.childViewControllers;
}

- (NSArray *) siblings
{
	return self.parentViewController.childViewControllers;
}

@end
