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

- (time_t) second
{
	return _time.tv_sec;
}

- (suseconds_t) microsecond
{
	return _time.tv_usec;
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%ld.%06d sec", _time.tv_sec, _time.tv_usec];
}

+ (instancetype) now
{
	return [[self alloc] init];
}

+ (void) sleep:(float)seconds
{
	useconds_t microsecond = seconds * 1000000;
	usleep(microsecond);
}

@end

@implementation S9Time (Convenient)

+ (time_t) seconds
{
	return time(NULL);
}

+ (clock_t) milliseconds
{
	struct timeb time;
	ftime(&time);
	time_t tv = time.time;
	return tv * 1000 + time.millitm;
}

+ (clock_t) microseconds
{
	struct timeval time;
	gettimeofday(&time, NULL);
	time_t tv = time.tv_sec;
	return tv * 1000000 + time.tv_usec;
}

+ (clock_t) nanoseconds
{
//	struct timespec time;
//	gethrestime();
//	return time.tv_sec * 1000000000 + time.tv_nsec;
	return [self microseconds] * 1000;
}

@end
