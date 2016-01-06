//
//  S9Object.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SlanissueToolkit)

//
//  JSON
//
+ (NSObject *) objectWithJSONData:(NSData *)data options:(NSJSONReadingOptions)opt;
+ (NSObject *) objectWithJSONData:(NSData *)data;

+ (NSObject *) objectWithJSONString:(NSString *)string encoding:(NSStringEncoding)encoding;
+ (NSObject *) objectWithJSONString:(NSString *)string;

- (NSString *) JSONStringWithEncoding:(NSStringEncoding)encoding options:(NSJSONWritingOptions)opt;
- (NSString *) JSONStringWithEncoding:(NSStringEncoding)encoding;

@end

//------------------------------------------------------------------------- json
#define NSObjectFromJSONData(data)                                             \
        [NSObject objectWithJSONData:(data) options:NSJSONReadingAllowFragments]
                                                /* EOF 'NSObjectFromJSONData' */
#define NSObjectFromJSONString(string)                                         \
        [NSObject objectWithJSONString:(string) encoding:NSUTF8StringEncoding] \
                                              /* EOF 'NSObjectFromJSONString' */
#define JSONStringFromNSObject(object)                                         \
        [(object) JSONStringWithEncoding:NSUTF8StringEncoding options:0]       \
                                              /* EOF 'JSONStringFromNSObject' */

#define JSONFileLoad(path)                                                     \
        NSObjectFromJSONData([NSData dataWithContentsOfFile:path])             \
                                                        /* EOF 'JSONFileLoad' */
#define JSONFileSave(object, path)                                             \
        [JSONStringFromNSObject(object) writeToFile:(path) atomically:YES encoding:NSUTF8StringEncoding error:nil]
                                                        /* EOF 'JSONFileSave' */

//-------------------------------------------------------------------- singleton
#define S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)                          \
    static id s_singleton_instance = nil;                                      \
    + (instancetype) getInstance                                               \
    {                                                                          \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                s_singleton_instance = [self new]; /* alloc & init */          \
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
    - (id) copy                  { return self; }                              \
    - (id) mutableCopy           { return self; }                              \
    - (instancetype) retain      { return self; }                              \
    - (oneway void) release      { /* do nothing */ }                          \
    - (instancetype) autorelease { return self; }                              \
    - (NSUInteger) retainCount   { return NSUIntegerMax; }                     \
                                    /* EOF 'S9_IMPLEMENT_SINGLETON_FUNCTIONS' */
