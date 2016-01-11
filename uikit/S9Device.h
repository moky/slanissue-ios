//
//  S9Device.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UUID()                                                                 \
        ({                                                                     \
            CFUUIDRef __id = CFUUIDCreate(kCFAllocatorDefault);                \
            CFStringRef __ref = CFUUIDCreateString(kCFAllocatorDefault, __id); \
            NSString * __str = [[NSString alloc] initWithFormat:@"%@", __ref]; \
            CFReleaseSafe(__ref);                                              \
            CFReleaseSafe(__id);                                               \
            [__str autorelease];                                               \
        })                                                                     \
                                                                /* EOF 'UUID' */

#if TARGET_OS_WATCH

#import <WatchKit/WatchKit.h>

@interface WKInterfaceDevice (SlanissueToolkit)

// get hw.machine
- (NSString *) machine;

// a UUID that may be used to uniquely identify the device, same across apps from a single vendor.
- (NSString *) UUIDString;

@end

#else

@interface UIDevice (SlanissueToolkit)

// get hw.machine
- (NSString *) machine;

// a UUID that may be used to uniquely identify the device, same across apps from a single vendor.
- (NSString *) UUIDString;

// rotate the current device for supported interface orientations
// return YES if rotated
- (BOOL) rotateForSupportedInterfaceOrientationsOfViewController:(UIViewController *)viewController;

@end

#endif
