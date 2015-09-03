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
#define ds_assign_point_b                                                      \
        ^void(ds_type * dest, const ds_type * src) {                           \
            CGPoint * p = (CGPoint *)dest;                                     \
            CGPoint * v = (CGPoint *)src;                                      \
            p->x = v->x;                                                       \
            p->y = v->y;                                                       \
        }                                                                      \
                                                   /* EOF 'ds_assign_point_b' */

void    ds_assign_size(ds_type * dest, const ds_type * src);
#define ds_assign_size_b                                                       \
        ^void(ds_type * dest, const ds_type * src) {                           \
            CGSize * p = (CGSize *)dest;                                       \
            CGSize * v = (CGSize *)src;                                        \
            p->width = v->width;                                               \
            p->height = v->height;                                             \
        }                                                                      \
                                                    /* EOF 'ds_assign_size_b' */

void    ds_assign_vector(ds_type * dest, const ds_type * src);
#define ds_assign_vector_b                                                     \
        ^void(ds_type * dest, const ds_type * src) {                           \
            CGVector * p = (CGVector *)dest;                                   \
            CGVector * v = (CGVector *)src;                                    \
            p->dx = v->dx;                                                     \
            p->dy = v->dy;                                                     \
        }                                                                      \
                                                  /* EOF 'ds_assign_vector_b' */

void    ds_assign_rect(ds_type * dest, const ds_type * src);
#define ds_assign_rect_b                                                       \
        ^void(ds_type * dest, const ds_type * src) {                           \
            CGRect * p = (CGRect *)dest;                                       \
            CGRect * v = (CGRect *)src;                                        \
            p->origin.x = v->origin.x;                                         \
            p->origin.y = v->origin.y;                                         \
            p->size.width = v->size.width;                                     \
            p->size.height = v->size.height;                                   \
        }                                                                      \
                                                    /* EOF 'ds_assign_rect_b' */
