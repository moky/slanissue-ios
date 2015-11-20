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

- (UIViewController *) controller
{
	UIViewController * vc = nil;//_viewDelegate;
	UIResponder * responder = self.nextResponder;
	if ([responder isKindOfClass:[UIViewController class]]) {
		vc = (UIViewController *)responder;
	}
	return vc;
}

- (UIView *) parent
{
	return self.superview;
}

- (NSArray *) children
{
	return self.subviews;
}

- (NSArray *) siblings
{
	return self.superview.subviews;
}

- (void) removeSubviews
{
	NSArray * subviews = self.subviews;
	UIView * sv;
	S9_FOR_EACH_REVERSE_SAFE(subviews, sv) {
		[sv removeFromSuperview];
	}
}

- (UIImage *) snapshot
{
	CGRect rect = self.bounds;
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
#ifdef __IPHONE_7_0
	if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
		[self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
	else
#endif
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
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
