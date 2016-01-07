//
//  S9ActionSheet.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

//__TVOS_PROHIBITED
@interface UIActionSheet (SlanissueToolkit)

// show in 'sharedApplication.keyWindow.rootViewController.view'
- (void) show;

@end

#endif
