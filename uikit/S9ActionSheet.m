//
//  S9ActionSheet.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9ActionSheet.h"

#if !TARGET_OS_WATCH
#if !TARGET_OS_TV

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation UIActionSheet (SlanissueToolkit)

- (void) show
{
	UIApplication * application = [UIApplication sharedApplication];
	UIWindow * window = [application keyWindow];
	UIViewController * rootViewController = [window rootViewController];
	UIView * view = rootViewController.view;
	[self showInView:view];
}

@end
#pragma clang diagnostic pop

#endif
#endif
