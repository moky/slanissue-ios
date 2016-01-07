//
//  UIWaterfallView+Layout.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9WaterfallView.h"

#if !TARGET_OS_WATCH

@interface UIWaterfallView (Layout)

+ (CGSize) layoutSubviewsInView:(UIView *)view;

+ (CGSize) layoutSubviewsInView:(UIView *)view
						towards:(UIWaterfallViewDirection)direction;

+ (CGSize) layoutSubviewsInView:(UIView *)view
						towards:(UIWaterfallViewDirection)direction
				spaceHorizontal:(CGFloat)spaceHorizontal
				  spaceVertical:(CGFloat)spaceVertical;

@end

#define UIWaterfallViewJoiningPointCompareBlock(cond1, cond2, cond3, cond4)    \
        ^int(const ds_type * ptr1, const ds_type * ptr2) {                     \
            CGPoint * p1 = (CGPoint *)ptr1;                                    \
            CGPoint * p2 = (CGPoint *)ptr2;                                    \
            if (cond1) {                                                       \
                return NSOrderedAscending;                                     \
            } else if (cond2) {                                                \
                if (cond3) {                                                   \
                    return NSOrderedAscending;                                 \
                } else if (cond4) {                                            \
                    return NSOrderedSame;                                      \
                }                                                              \
            }                                                                  \
            return NSOrderedDescending;                                        \
        }                                                                      \
                             /* EOF 'UIWaterfallViewJoiningPointCompareBlock' */

#define UIWaterfallViewJoiningPointCompareBlockTopLeft()                       \
        UIWaterfallViewJoiningPointCompareBlock(p1->y < p2->y, p1->y == p2->y, \
                                                p1->x < p2->x, p1->x == p2->x) \
                      /* EOF 'UIWaterfallViewJoiningPointCompareBlockTopLeft' */

#define UIWaterfallViewJoiningPointCompareBlockLeftTop()                       \
        UIWaterfallViewJoiningPointCompareBlock(p1->x < p2->x, p1->x == p2->x, \
                                                p1->y < p2->y, p1->y == p2->y) \
                      /* EOF 'UIWaterfallViewJoiningPointCompareBlockLeftTop' */

#define UIWaterfallViewJoiningPointCompareBlockTopRight()                      \
        UIWaterfallViewJoiningPointCompareBlock(p1->y < p2->y, p1->y == p2->y, \
                                                p1->x > p2->x, p1->x == p2->x) \
                     /* EOF 'UIWaterfallViewJoiningPointCompareBlockTopRight' */

#define UIWaterfallViewJoiningPointCompareBlockRightTop()                      \
        UIWaterfallViewJoiningPointCompareBlock(p1->x > p2->x, p1->x == p2->x, \
                                                p1->y < p2->y, p1->y == p2->y) \
                     /* EOF 'UIWaterfallViewJoiningPointCompareBlockRightTop' */

#define UIWaterfallViewJoiningPointCompareBlockBottomLeft()                    \
        UIWaterfallViewJoiningPointCompareBlock(p1->y > p2->y, p1->y == p2->y, \
                                                p1->x < p2->x, p1->x == p2->x) \
                   /* EOF 'UIWaterfallViewJoiningPointCompareBlockBottomLeft' */

#define UIWaterfallViewJoiningPointCompareBlockLeftBottom()                    \
        UIWaterfallViewJoiningPointCompareBlock(p1->x < p2->x, p1->x == p2->x, \
                                                p1->y > p2->y, p1->y == p2->y) \
                   /* EOF 'UIWaterfallViewJoiningPointCompareBlockLeftBottom' */

#define UIWaterfallViewJoiningPointCompareBlockBottomRight()                   \
        UIWaterfallViewJoiningPointCompareBlock(p1->y > p2->y, p1->y == p2->y, \
                                                p1->x > p2->x, p1->x == p2->x) \
                  /* EOF 'UIWaterfallViewJoiningPointCompareBlockBottomRight' */

#define UIWaterfallViewJoiningPointCompareBlockRightBottom()                   \
        UIWaterfallViewJoiningPointCompareBlock(p1->x > p2->x, p1->x == p2->x, \
                                                p1->y > p2->y, p1->y == p2->y) \
                  /* EOF 'UIWaterfallViewJoiningPointCompareBlockRightBottom' */

#endif
