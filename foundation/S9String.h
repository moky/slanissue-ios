//
//  S9String.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

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
