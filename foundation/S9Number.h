//
//  S9Number.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>

//--------------------------------------------------------------- CoreFoundation
CF_EXPORT CFNumberRef CFNumberCreateWithInteger(int value);
CF_EXPORT CFNumberRef CFNumberCreateWithFloat(float value);

CF_EXPORT int CFNumberGetInteger(CFNumberRef numberRef);
CF_EXPORT float CFNumberGetFloat(CFNumberRef numberRef);

#define CFNumberRetain(ref)              do { if (ref) CFRetain(ref); } while(0)
#define CFNumberRelease(ref)            do { if (ref) CFRelease(ref); } while(0)
