//
//  S9Layer.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Layer.h"

@implementation CALayer (SlanissueToolkit)

- (NSArray *) siblings
{
	return self.superlayer.sublayers;
}

@end
