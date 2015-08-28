//
//  S9Device.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <sys/sysctl.h>

/**
 *  Identifier Addition for UIDevice:
 *      https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5
 */
// 'libs/IdentifierAddition'
#import "UIDevice+IdentifierAddition.h"

#import "S9Device.h"

@implementation UIDevice (SlanissueToolkit)

- (NSString *) machine
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char * machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString * hardware = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return [hardware autorelease];
}

static NSString * s_uniqueGlobalDeviceIdentifier = nil;

- (NSString *) globalIdentifier
{
	if (!s_uniqueGlobalDeviceIdentifier) {
		if ([self respondsToSelector:@selector(uniqueGlobalDeviceIdentifier)]) {
			s_uniqueGlobalDeviceIdentifier = [self uniqueGlobalDeviceIdentifier];
			[s_uniqueGlobalDeviceIdentifier retain];
		} else {
			s_uniqueGlobalDeviceIdentifier = @"0123456789abcdef0123456789abcdef";
		}
	}
	return s_uniqueGlobalDeviceIdentifier;
}

@end
