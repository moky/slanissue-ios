//
//  s9Macros.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef SlanissueToolkit_s9Macros_h
#define SlanissueToolkit_s9Macros_h

//-------------------------------------------------------------------------- Log
#ifdef S9_DEBUG
#	define S9Log(...)                                                          \
        printf("<%s:%d>%s %s\r\n", S9FilenameFromString(__FILE__), __LINE__,   \
            __FUNCTION__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#	define S9Log(...)   do {} while(0)
#endif

//------------------------------------------------------------------ switch case
//	do {
//		if (string) {
//			{
//			};
//			if ([string rangeOfString:@"Yes"].location != NSNotFound) {
//				return YES;
//			};
//			if ([string rangeOfString:@"No"].location != NSNotFound) {
//				return NO;
//			};
//		};
//		return Default;
//	} while(0);

#define S9_SWITCH_BEGIN(var)        do { if (var) { {
#define S9_SWITCH_CASE(var, value)  }; if ([(var) rangeOfString:(value)].location != NSNotFound) {
#define S9_SWITCH_DEFAULT           }; };
#define S9_SWITCH_END               } while(0);

//--------------------------------------------------------------- CoreFoundation
#define CFRetainSafe(ref)  if (ref) CFRetain(ref)
#define CFReleaseSafe(ref) if (ref) CFRelease(ref)

#define CFStringCreateWithNSString(nsString)                                   \
        CFStringCreateWithCString(NULL,                                        \
                [(nsString) UTF8String],                                       \
                kCFStringEncodingUTF8)                                         \
                                          /* EOF 'CFStringCreateWithNSString' */

#define CFDictionaryCreateWithKeysAndValues(keys, values)                      \
        CFDictionaryCreate(kCFAllocatorDefault,                                \
                (const void **)(keys),                                         \
                (const void **)(values),                                       \
                sizeof(keys) / sizeof((keys)[0]),                              \
                &kCFTypeDictionaryKeyCallBacks,                                \
                &kCFTypeDictionaryValueCallBacks);                             \
                                 /* EOF 'CFDictionaryCreateWithKeysAndValues' */

//--------------------------------------------------------------------- CoreText
#define CTLineGetBounds(line)                                                  \
    ({                                                                         \
        CGFloat __a, __d, __l;                                                 \
        double __w = CTLineGetTypographicBounds((line), &__a, &__d, &__l);     \
        CGRectMake(0.0f, __d + __l, __w, __a);                                 \
    })                                                                         \
                                                       /* EOF 'CTLineGetSize' */

#endif /* EOF 'SlanissueToolkit_s9Macros_h' */
