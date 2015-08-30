//
//  S9Dictionary.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SlanissueToolkit)

//
//  key-value (css) format string
//
+ (NSDictionary *) dictionaryWithString:(NSString *)mapString;

@end

//--------------------------------------------------------------------- for each
#define S9_FOR_EACH_KEY_VALUE(key, value, dict)                                \
    for (NSEnumerator * __e = [(dict) keyEnumerator];                          \
         ((key)=[__e nextObject]) && ((value)=[(dict) objectForKey:(key)]); )  \
                                               /* EOF 'S9_FOR_EACH_KEY_VALUE' */

//------------------------------------------------------------------ safe access
#define S9DictionarySetObjectForKey(dict, object, key)                         \
        if ((object) && (key)) {                                               \
            [(dict) setObject:(object) forKey:(key)];                          \
        }                                                                      \
                                         /* EOF 'S9DictionarySetObjectForKey' */
