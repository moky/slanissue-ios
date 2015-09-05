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
