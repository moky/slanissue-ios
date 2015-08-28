//
//  S9Client.m
//  SlanissueToolkit
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <sys/sysctl.h>

//#import "scMacros.h"
//#import "SCDevice.h"
#import "S9Object.h"
#import "S9Client.h"

@interface S9Client ()

@property(nonatomic, retain) NSString * hardware;
@property(nonatomic, retain) NSString * deviceIdentifier;
@property(nonatomic, retain) NSString * deviceModel;
@property(nonatomic, retain) NSString * systemName;
@property(nonatomic, retain) NSString * systemVersion;

// app bundle
@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * version;

// DOS
@property(nonatomic, retain) NSString * applicationDirectory;
@property(nonatomic, retain) NSString * documentDirectory;
@property(nonatomic, retain) NSString * cachesDirectory;
@property(nonatomic, retain) NSString * temporaryDirectory;

@end

@implementation S9Client

@synthesize screenSize = _screenSize;
@synthesize screenScale = _screenScale;
@synthesize windowSize = _windowSize;
@synthesize statusBarHeight = _statusBarHeight;

@synthesize hardware = _hardware;
@synthesize deviceIdentifier = _deviceIdentifier;
@synthesize deviceModel = _deviceModel;
@synthesize systemName = _systemName;
@synthesize systemVersion = _systemVersion;

@synthesize name = _name;
@synthesize version = _version;

// DOS
@synthesize applicationDirectory = _applicationDirectory;
@synthesize documentDirectory = _documentDirectory;
@synthesize cachesDirectory = _cachesDirectory;
@synthesize temporaryDirectory = _temporaryDirectory;

- (void) dealloc
{
	[_hardware release];
	[_deviceIdentifier release];
	[_deviceModel release];
	[_systemName release];
	[_systemVersion release];
	
	[_name release];
	[_version release];
	
	// DOS
	[_applicationDirectory release];
	[_documentDirectory release];
	[_cachesDirectory release];
	[_temporaryDirectory release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		UIScreen * screen = [UIScreen mainScreen];
		UIApplication * app = [UIApplication sharedApplication];
		
		_screenSize = screen.bounds.size;
		_screenScale = [screen respondsToSelector:@selector(scale)] ? screen.scale : 1.0f;
		_windowSize = screen.applicationFrame.size;
		_statusBarHeight = app.statusBarFrame.size.height;
		
		self.hardware = nil;
		self.deviceIdentifier = nil;
		self.deviceModel = nil;
		self.systemName = nil;
		self.systemVersion = nil;
		
		self.name = nil;
		self.version = nil;
		
		// DOS
		self.applicationDirectory = nil;
		self.documentDirectory = nil;
		self.cachesDirectory = nil;
		self.temporaryDirectory = nil;
	}
	return self;
}

// singleton implementations
S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

#pragma mark -

- (NSString *) hardware
{
	if (!_hardware) {
		size_t size;
		sysctlbyname("hw.machine", NULL, &size, NULL, 0);
		char * machine = malloc(size);
		sysctlbyname("hw.machine", machine, &size, NULL, 0);
		self.hardware = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
		free(machine);
	}
	return _hardware;
}

- (NSString *) deviceIdentifier
{
	if (!_deviceIdentifier) {
//		self.deviceIdentifier = [[UIDevice currentDevice] globalIdentifier];
	}
	return _deviceIdentifier;
}

- (NSString *) deviceModel
{
	if (!_deviceModel) {
		self.deviceModel = [[UIDevice currentDevice] model];
	}
	return _deviceModel;
}

- (NSString *) systemName
{
	if (!_systemName) {
		self.systemName = [[UIDevice currentDevice] systemName];
	}
	return _systemName;
}

- (NSString *) systemVersion
{
	if (!_systemVersion) {
		self.systemVersion = [[UIDevice currentDevice] systemVersion];
	}
	return _systemVersion;
}

- (NSString *) name
{
	if (!_name) {
		self.name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	}
	return _name;
}

- (NSString *) version
{
	if (!_version) {
		NSDictionary * dict = [[NSBundle mainBundle] infoDictionary];
		NSString * build = [dict objectForKey:@"CFBundleVersion"];
		NSString * version = [dict objectForKey:@"CFBundleShortVersionString"];
		if (version) {
			if (build && ![build isEqualToString:version]) {
				self.version = [NSString stringWithFormat:@"%@(%@)", version, build];
			} else {
				self.version = version;
			}
		} else {
			self.version = build;
		}
	}
	return _version;
}

#pragma mark DOS

- (NSString *) applicationDirectory
{
	if (!_applicationDirectory) {
		self.applicationDirectory = [[NSBundle mainBundle] resourcePath];
	}
	return _applicationDirectory;
}

- (NSString *) documentDirectory
{
	if (!_documentDirectory) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSAssert([paths count] > 0, @"failed to locate document directory");
		self.documentDirectory = [paths firstObject];
	}
	return _documentDirectory;
}

- (NSString *) cachesDirectory
{
	if (!_cachesDirectory) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSAssert([paths count] > 0, @"failed to locate caches directory");
		self.cachesDirectory = [paths firstObject];
	}
	return _cachesDirectory;
}

- (NSString *) temporaryDirectory
{
	if (!_temporaryDirectory) {
		self.temporaryDirectory = NSTemporaryDirectory();
	}
	return _temporaryDirectory;
}

#pragma mark Checkup

- (BOOL) isPad
{
	return [self.deviceModel rangeOfString:@"iPad"].location != NSNotFound;
}

- (BOOL) isRetina
{
	return self.screenScale > 1.5f;
}

@end
