//
//  S9Object.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//-------------------------------------------------------------------- singleton
#define S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)                          \
    static id s_singleton_instance = nil;                                      \
    + (instancetype) getInstance                                               \
    {                                                                          \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                [self new]; /* alloc & init */                                 \
            }                                                                  \
        }                                                                      \
        return s_singleton_instance;                                           \
    }                                                                          \
    + (instancetype) allocWithZone:(NSZone *)zone                              \
    {                                                                          \
        NSAssert(s_singleton_instance == nil, @"Singleton!");                  \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                s_singleton_instance = [super allocWithZone:zone];             \
            }                                                                  \
        }                                                                      \
        return s_singleton_instance;                                           \
    }                                                                          \
    - (id) copy { return self; }                                               \
    - (id) mutableCopy { return self; }                                        \
    - (instancetype) retain { return self; }                                   \
    - (oneway void) release { /* do nothing */ }                               \
    - (instancetype) autorelease { return self; }                              \
    - (NSUInteger) retainCount { return NSUIntegerMax; }                       \
                                    /* EOF 'S9_IMPLEMENT_SINGLETON_FUNCTIONS' */
