//
//  S9Time.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <unistd.h>
#include <sys/time.h>
#include <sys/timeb.h>
//#include <sys/_types/_timespec.h>

#import "S9Time.h"

@interface S9Time () {
	
	struct timeval _time;
}

@end

@implementation S9Time

- (instancetype) init
{
	self = [super init];
	if (self) {
		gettimeofday(&_time, NULL);
	}
	return self;
}

+ (instancetype) now
{
	return [[self alloc] init];
}

- (unsigned int) second
{
	return (unsigned int)_time.tv_sec;
}

- (unsigned int) microseconds
{
	return _time.tv_usec;
}

- (unsigned int) nanosecond
{
	return _time.tv_usec * 1000;
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%ld.%06d sec", _time.tv_sec, _time.tv_usec];
}

@end

@implementation S9Time (Convenient)

+ (S9TimeValue) second
{
	return time(NULL);
}

+ (S9TimeValue) millisecond
{
	struct timeb time;
	ftime(&time);
	S9TimeValue tv = time.time;
	return tv * 1000 + time.millitm;
}

+ (S9TimeValue) microsecond
{
	struct timeval time;
	gettimeofday(&time, NULL);
	S9TimeValue tv = time.tv_sec;
	return tv * 1000000 + time.tv_usec;
}

+ (S9TimeValue) nanosecond
{
//	struct timespec time;
//	gethrestime();
//	return time.tv_sec * 1000000000 + time.tv_nsec;
	return [self microsecond] * 1000;
}

+ (void) sleep:(S9TimeValue)seconds
{
	useconds_t microsecond = (useconds_t)seconds * 1000000;
	usleep(microsecond);
}

@end
