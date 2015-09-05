//
//  S9Layer.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (SlanissueToolkit)

// get superlayer
- (CALayer *) parent;

// get all sublayers
- (NSArray *) children;

// get all children of parent, includes self
- (NSArray *) siblings;

@end
