//
//  UIParticleView.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

@class CAEmitterLayer;

@interface UIParticleView : UIView

@property(nonatomic, readonly) CAEmitterLayer * emitter;
@property(nonatomic, readwrite) CGPoint emitterPosition;

@end

#endif
