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

//
//  dictionary file reader/writer, supported type: plist|mof|js|json|strings
//
+ (NSDictionary *) loadFromFile:(NSString *)path;
- (BOOL) saveToFile:(NSString *)path;

@end

//--------------------------------------------------------------------- for each
#define S9_FOR_EACH_KEY_VALUE(dict, key, value)                                \
    for (NSEnumerator * __e = [(dict) keyEnumerator];                          \
         ((key)=[__e nextObject]) && ((value)=[(dict) objectForKey:(key)]); )  \
                                               /* EOF 'S9_FOR_EACH_KEY_VALUE' */

//------------------------------------------------------------------ safe access
#define S9DictionarySetObjectForKey(dict, object, key)                         \
        if ((object) && (key)) {                                               \
            [(dict) setObject:(object) forKey:(key)];                          \
        }                                                                      \
                                         /* EOF 'S9DictionarySetObjectForKey' */

//--------------------------------------------------------------- CoreFoundation
#define CFDictionaryCreateWithKeysAndValues(keys, values)                      \
        CFDictionaryCreate(kCFAllocatorDefault,                                \
                (const void **)(keys),                                         \
                (const void **)(values),                                       \
                sizeof(keys) / sizeof((keys)[0]),                              \
                &kCFTypeDictionaryKeyCallBacks,                                \
                &kCFTypeDictionaryValueCallBacks);                             \
                                 /* EOF 'CFDictionaryCreateWithKeysAndValues' */

#define CFDictionaryRetain(ref)          do { if (ref) CFRetain(ref); } while(0)
#define CFDictionaryRelease(ref)        do { if (ref) CFRelease(ref); } while(0)
