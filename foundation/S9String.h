//
//  S9String.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "S9Math.h"

@interface NSString (SlanissueToolkit)

// convert object to JsON string
+ (NSString *) stringBySerializingObject:(NSObject *)object;

- (NSString *) MD5String;

- (NSString *) trim;
- (NSString *) trim:(NSString *)chars;

// encode/decode string for URL parameters
- (NSString *) escape;
- (NSString *) unescape;

// "/path/to/../something" => "/path/something"
- (NSString *) simplifyPath;

//  "{{1+2, 3-4}, {5*6, 7/8}}" => "{{3,-1},{30,0.875}}"
- (NSString *) calculate;

@end

#define MD5(string) [(string) MD5String]

#define CGFloatFromString(string) calculate([(string) cStringUsingEncoding:NSUTF8StringEncoding])

//{
//	char * str = path;
//	if (str) {
//		str = strrchr(path, '/');
//		if (str) {
//			str += 1;
//		} else {
//			str = strrchr(path, '\\');
//			if (str) {
//				str += 1;
//			} else {
//				str = path;
//			}
//		}
//	}
//	return str;
//}
#define S9FilenameFromString(czPath) ({                                        \
    const char * path = czPath; /* avoid multi-accessing */                    \
    const char * str = path;                                                   \
    if (str) {                                                                 \
        str = strrchr(path, '/');                                              \
        if (str) {                                                             \
            str += 1; /* skip '/' */                                           \
        } else {                                                               \
            str = strrchr(path, '\\');                                         \
            if (str) {                                                         \
                str += 1; /* skip '\' */                                       \
            } else {                                                           \
                str = path; /* the whole string */                             \
            }                                                                  \
        }                                                                      \
    }                                                                          \
    str;})                                                                     \
                                                /* EOF 'S9FilenameFromString' */
