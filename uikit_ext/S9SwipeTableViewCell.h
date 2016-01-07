//
//  UISwipeTableViewCell.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

@interface UISwipeTableViewCell : UITableViewCell

@property(nonatomic, readwrite) CGFloat indentationLeft; // default is 0.0, means no indent
@property(nonatomic, readwrite) CGFloat indentationRight; // default is 0.0, means no indent

@end

#endif
