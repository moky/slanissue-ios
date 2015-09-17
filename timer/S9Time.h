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
     ((timeval2).tv_usec - (timeval1).tv_usec) / 1000000.0f)                   \
                                                         /* EOF 's9_difftime' */

#define s9_sleep(seconds) [S9Time sleep:(seconds)]

@interface S9Time : NSObject

@property(nonatomic, readonly) time_t second;
@property(nonatomic, readonly) suseconds_t microsecond; // excludes second part

+ (instancetype) now;

+ (void) sleep:(float)seconds;

@end

@interface S9Time (Convenient)

+ (time_t) seconds;
+ (clock_t) milliseconds; // 0.001 second (10 ^ -3)
+ (clock_t) microseconds; // 0.000001 second (10 ^ -6)
+ (clock_t) nanoseconds;  // 0.000000001 second (10 ^ -9)

@end
