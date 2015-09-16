//
//  S9Device.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <sys/sysctl.h>

#import "s9Macros.h"
#import "S9Device.h"

static NSString * _machine(void)
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char * machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	assert(machine != NULL);
	NSString * string = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return [string autorelease];
}

#define kApplicationUUIDKey @"uuid"
static NSString * _uuid(void)
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * string = [defaults objectForKey:kApplicationUUIDKey];
	if (string) {
		return string;
	}
	
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	assert(uuid != NULL);
	CFStringRef str = CFUUIDCreateString(kCFAllocatorDefault, uuid);
	assert(str != NULL);
	string = [[NSString alloc] initWithFormat:@"%@", str];
	CFReleaseSafe(str);
	CFReleaseSafe(uuid);
	
	[defaults setObject:string forKey:kApplicationUUIDKey];
	[defaults synchronize];
	
	return [string autorelease];
}

@implementation UIDevice (SlanissueToolkit)

- (NSString *) machine
{
	return _machine();
}

- (NSString *) UUIDString
{
	if ([[self systemVersion] floatValue] < 6.0f) {
		return _uuid();
	} else {
		return [[self identifierForVendor] UUIDString];
	}
}

- (BOOL) rotateForSupportedInterfaceOrientationsOfViewController:(UIViewController *)viewController
{
	NSUInteger supportedInterfaceOrientations = [viewController supportedInterfaceOrientations];
	UIDeviceOrientation currentOrientation = [self orientation];
	if (supportedInterfaceOrientations & (1 << currentOrientation)) {
		// current orientation is supported by the view controller
		return NO;
	}
	
	UIInterfaceOrientation orientation = [viewController preferredInterfaceOrientationForPresentation];
	S9Log(@"force device orientation from %d to %d", (int)currentOrientation, (int)orientation);
	
	// try to present the preferred interface orientation
	if ([self respondsToSelector:@selector(setOrientation:)]) {
		[self performSelector:@selector(setOrientation:) withObject:(id)orientation];
	}
	
	return YES;
}

@end
