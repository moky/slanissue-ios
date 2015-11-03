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
        printf("<%s:%d>%s %s\n", [[[NSString stringWithUTF8String:__FILE__] filename] UTF8String], __LINE__, \
            __FUNCTION__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#	define S9Assert(cond, ...)                                                 \
        if (!(cond)) {                                                         \
            S9Log(__VA_ARGS__);                                                \
            assert(cond);                                                      \
        }
#else
#	define S9Log(...)    do {} while(0)
#	define S9Assert(...) do {} while(0)
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
#define CFRetainSafe(ref)                do { if (ref) CFRetain(ref); } while(0)
#define CFReleaseSafe(ref)              do { if (ref) CFRelease(ref); } while(0)

//--------------------------------------------------------------------- CoreText
#define CTLineGetBounds(line)                                                  \
    ({                                                                         \
        CGFloat __a, __d, __l;                                                 \
        double __w = CTLineGetTypographicBounds((line), &__a, &__d, &__l);     \
        CGRectMake(0.0f, __d + __l, __w, __a);                                 \
    })                                                                         \
                                                       /* EOF 'CTLineGetSize' */

#endif /* EOF 'SlanissueToolkit_s9Macros_h' */
