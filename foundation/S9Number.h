//
//  S9Number.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//--------------------------------------------------------------- CoreFoundation
FOUNDATION_EXPORT CFNumberRef CFNumberCreateWithInteger(int value);
FOUNDATION_EXPORT CFNumberRef CFNumberCreateWithFloat(float value);

FOUNDATION_EXPORT int CFNumberGetInteger(CFNumberRef numberRef);
FOUNDATION_EXPORT float CFNumberGetFloat(CFNumberRef numberRef);

#define CFNumberRetain(ref)              do { if (ref) CFRetain(ref); } while(0)
#define CFNumberRelease(ref)            do { if (ref) CFRelease(ref); } while(0)
