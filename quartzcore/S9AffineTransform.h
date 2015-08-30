//
//  S9AffineTransform.h
//  SlanissueToolkit
//
//  Created by Moky on 14-7-9.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

CA_EXTERN CATransform3D CATransform3DMakePerspective(CGPoint center, CGFloat disZ);
CA_EXTERN CATransform3D CATransform3DPerspect(const CATransform3D t, CGPoint center, CGFloat disZ);
