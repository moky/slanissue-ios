//
//  S9View.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SlanissueToolkit)

// remove all subviews
- (void) removeSubviews;

// take snapshot of current view
- (UIImage *) snapshot;

// take snapshot of current view and save it into file
- (UIImage *) snapshot:(NSString *)filename;

@end

#pragma mark - Siblings

UIKIT_EXTERN NSArray * S9SiblingsOfNode(id node);

UIKIT_EXTERN id S9PreviousSiblingOfNode(id node);
UIKIT_EXTERN id S9NextSiblingOfNode(id node);
