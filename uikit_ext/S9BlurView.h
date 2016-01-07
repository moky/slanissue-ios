//
//  S9BlurView.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-19.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

typedef NS_ENUM(NSInteger, UIBlurViewStyle) {
	UIBlurViewStyleExtraLight = UIBlurEffectStyleExtraLight,
	UIBlurViewStyleLight      = UIBlurEffectStyleLight,
	UIBlurViewStyleDark       = UIBlurEffectStyleDark,
};

@interface UIBlurView : UIView

@property(nonatomic, readwrite) UIBlurViewStyle style;

@end

#endif
