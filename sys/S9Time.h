//
//  S9Time.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define s9_difftime(timeval2, timeval1)                                        \
    (((timeval2).tv_sec  - (timeval1).tv_sec) +                                \
     ((timeval2).tv_usec - (timeval1).tv_usec) / 1000000.0f)


typedef long long S9TimeValue;

@interface S9Time : NSObject

@property(nonatomic, readonly) unsigned int second;

@property(nonatomic, readonly) unsigned int microseconds; // excludes second part
@property(nonatomic, readonly) unsigned int nanosecond;   // excludes second part

+ (instancetype) now;

@end

@interface S9Time (Convenient)

+ (S9TimeValue) second;
+ (S9TimeValue) millisecond; // 0.001 second (10 ^ -3)
+ (S9TimeValue) microsecond; // 0.000001 second (10 ^ -6)
+ (S9TimeValue) nanosecond;  // 0.000000001 second (10 ^ -9)

+ (void) sleep:(S9TimeValue)seconds;

@end
