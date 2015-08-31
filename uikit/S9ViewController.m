//
//  S9ViewController.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ViewController.h"

@implementation UIViewController (SlanissueToolkit)

- (NSArray *) siblings
{
	return self.parentViewController.childViewControllers;
}

@end
