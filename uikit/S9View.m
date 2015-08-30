//
//  S9View.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9Array.h"
#import "S9Image.h"
#import "S9View.h"

@implementation UIView (SlanissueToolkit)

- (void) removeSubviews
{
	NSArray * subviews = self.subviews;
	UIView * sv;
	S9_FOR_EACH_REVERSE_SAFE(sv, subviews) {
		[sv removeFromSuperview];
	}
}

- (UIImage *) snapshot
{
	CGRect rect = self.bounds;
	UIGraphicsBeginImageContext(rect.size);
	[self drawViewHierarchyInRect:rect afterScreenUpdates:YES];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage *) snapshot:(NSString *)filename
{
	NSAssert(filename, @"filename cannot be nil");
	UIImage * image = [self snapshot];
	if (image) {
		[image writeToFile:filename atomically:YES];
	}
	return image;
}

@end

#pragma mark - Siblings

NSArray * S9SiblingsOfNode(id node)
{
	if ([node isKindOfClass:[UIView class]]) {
		UIView * view = (UIView *)node;
		return view.superview.subviews;
	} else if ([node isKindOfClass:[CALayer class]]) {
		CALayer * layer = (CALayer *)node;
		return layer.superlayer.sublayers;
	} else if ([node isKindOfClass:[UIViewController class]]) {
		UIViewController * vc = (UIViewController *)node;
		return vc.parentViewController.childViewControllers;
	} else {
		S9Log(@"unsupported node: %@", node);
		return nil;
	}
}

id S9PreviousSiblingOfNode(id node)
{
	NSArray * siblings = S9SiblingsOfNode(node);
	NSUInteger index = [siblings indexOfObject:node];
	if (index == NSNotFound || index == 0) {
		return nil;
	} else {
		return [siblings objectAtIndex:index - 1];
	}
}

id S9NextSiblingOfNode(id node)
{
	NSArray * siblings = S9SiblingsOfNode(node);
	NSUInteger index = [siblings indexOfObject:node];
	if (index == NSNotFound || index + 1 >= [siblings count]) {
		return nil;
	} else {
		return [siblings objectAtIndex:index + 1];
	}
}
