//
//  S9View+Reflection.h
//  SlanissueToolkit
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_WATCH

@interface UIView (Reflection)

// check whether the view has already shown its reflection
- (BOOL) hasReflection;

// hide reflection
- (void) hideReflection;
// show reflection
- (void) showReflection;

// show reflection with special parameters
- (void) showReflectionWithOpacity:(CGFloat)opacity;
- (void) showReflectionWithStartPoint:(CGFloat)start endPoint:(CGFloat)end;
- (void) showReflectionWithOpacity:(CGFloat)opacity startPoint:(CGFloat)start endPoint:(CGFloat)end;

@end

#endif
