//
//  S9Geometry.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

CG_EXTERN CGSize CGSizeAspectFit(CGSize fromSize, CGSize toSize);
CG_EXTERN CGSize CGSizeAspectFill(CGSize fromSize, CGSize toSize);

CG_EXTERN CGRect CGRectGetFrameFromNode(id node);
CG_EXTERN CGRect CGRectGetBoundsFromParentOfNode(id node);
