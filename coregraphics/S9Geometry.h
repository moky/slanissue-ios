//
//  S9Geometry.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "ds_base.h"

CG_EXTERN CGSize CGSizeAspectFit(CGSize fromSize, CGSize toSize);
CG_EXTERN CGSize CGSizeAspectFill(CGSize fromSize, CGSize toSize);

CG_EXTERN CGRect CGRectGetFrameFromNode(id node);
CG_EXTERN CGRect CGRectGetBoundsFromParentOfNode(id node);

//
//  functions & blocks for DataStructure
//
void    ds_assign_point(ds_type * dest, const ds_type * src);
#define ds_assign_point_b ^void(ds_type * dest, const ds_type * src) {         \
            ds_assign_point(dest, src);                                        \
        }                                                                      \
                                                   /* EOF 'ds_assign_point_b' */

void    ds_assign_size(ds_type * dest, const ds_type * src);
#define ds_assign_size_b ^void(ds_type * dest, const ds_type * src) {          \
            ds_assign_size(dest, src);                                         \
        }                                                                      \
                                                    /* EOF 'ds_assign_size_b' */

void    ds_assign_vector(ds_type * dest, const ds_type * src);
#define ds_assign_vector_b ^void(ds_type * dest, const ds_type * src) {        \
            ds_assign_vector(dest, src);                                       \
        }                                                                      \
                                                  /* EOF 'ds_assign_vector_b' */

void    ds_assign_rect(ds_type * dest, const ds_type * src);
#define ds_assign_rect_b ^void(ds_type * dest, const ds_type * src) {          \
            ds_assign_rect(dest, src);                                         \
        }                                                                      \
                                                    /* EOF 'ds_assign_rect_b' */
