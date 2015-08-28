//
//  S9View.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Image.h"
#import "S9View.h"

@implementation UIView (Snapshot)

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
