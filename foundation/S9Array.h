//
//  S9Array.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SlanissueToolkit)

- (id) objectBeforeObject:(id)object;
- (id) objectAfterObject:(id)object;

@end

//--------------------------------------------------------------------- for each
#define S9_FOR_EACH(array, item)                                               \
    for (NSEnumerator * __e = [(array) objectEnumerator];                      \
         ((item) = [__e nextObject]); )                                        \
                                                         /* EOF 'S9_FOR_EACH' */

#define S9_FOR_EACH_SAFE(array, item)                                          \
    for (NSUInteger __i = 0;                                                   \
         (__i < [(array) count]) && ((item) = [(array) objectAtIndex:__i]);    \
         ++__i)                                                                \
                                                    /* EOF 'S9_FOR_EACH_SAFE' */

#define S9_FOR_EACH_REVERSE(array, item)                                       \
    for (NSEnumerator * __e = [(array) reverseObjectEnumerator];               \
         ((item) = [__e nextObject]); )                                        \
                                                 /* EOF 'S9_FOR_EACH_REVERSE' */

#define S9_FOR_EACH_REVERSE_SAFE(array, item)                                  \
    for (NSInteger __i = [(array) count] - 1;                                  \
         (__i>=0 && __i<[(array) count])&&((item)=[(array) objectAtIndex:__i]);\
         --__i)                                                                \
                                            /* EOF 'S9_FOR_EACH_REVERSE_SAFE' */

//------------------------------------------------------------------ safe access
#define S9ArrayObjectAtIndex(array, index)                                     \
        ((index) < [(array) count] && (index) >= 0 ?                           \
            [(array) objectAtIndex:(index)] : nil)                             \
                                                /* EOF 'S9ArrayObjectAtIndex' */

#define S9ArrayAddObject(array, object)                                        \
        if (object) {                                                          \
            [(array) addObject:(object)];                                      \
        }                                                                      \
                                                    /* EOF 'S9ArrayAddObject' */

#define S9ArrayInsertObjectAtIndex(array, object, index)                       \
        if ((object) && (index) <= [(array) count] && (index) >= 0) {          \
            [(array) insertObject:(object) atIndex:(index)];                   \
        }                                                                      \
                                          /* EOF 'S9ArrayInsertObjectAtIndex' */

#define S9ArrayRemoveObjectAtIndex(array, index)                               \
        if ((index) < [(array) count] && (index) >= 0) {                       \
            [(array) removeObjectAtIndex:(index)];                             \
        }                                                                      \
                                          /* EOF 'S9ArrayRemoveObjectAtIndex' */

#define S9ArrayReplaceObjectAtIndex(array, object, index)                      \
        if ((object) && (index) < [(array) count] && (index) >= 0) {           \
            [(array) replaceObjectAtIndex:(index) withObject:(object)];        \
        }                                                                      \
                                         /* EOF 'S9ArrayReplaceObjectAtIndex' */

#define S9ArrayRemoveObject(array, object)                                     \
        if (object) {                                                          \
            [(array) removeObject:(object)];                                   \
        }                                                                      \
                                                 /* EOF 'S9ArrayRemoveObject' */

//--------------------------------------------------------------- CoreFoundation
#define CFArrayRetain(ref)               do { if (ref) CFRetain(ref); } while(0)
#define CFArrayRelease(ref)             do { if (ref) CFRelease(ref); } while(0)
