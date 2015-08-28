//
//  S9View.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Snapshot)

// take snapshot of current view
- (UIImage *) snapshot;

// take snapshot of current view and save it into file
- (UIImage *) snapshot:(NSString *)filename;

@end
