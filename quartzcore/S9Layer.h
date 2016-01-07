//
//  S9Layer.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <TargetConditionals.h>

#if !TARGET_OS_WATCH

#import <QuartzCore/QuartzCore.h>

@interface CALayer (SlanissueToolkit)

// superlayer
- (CALayer *) parent;

// sublayers
- (NSArray *) children;

// get all children of parent, includes self
- (NSArray *) siblings;

@end

#endif
