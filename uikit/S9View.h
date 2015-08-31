//
//  S9View.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SlanissueToolkit)

// get all children of parent, includes self
- (NSArray *) siblings;

// remove all subviews
- (void) removeSubviews;

// take snapshot of current view
- (UIImage *) snapshot;

// take snapshot of current view and save it into file
- (UIImage *) snapshot:(NSString *)filename;

@end
