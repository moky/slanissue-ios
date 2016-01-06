//
//  S9Date.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Date.h"

@implementation NSDate (SlanissueToolkit)

- (NSUInteger) year
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitYear fromDate:self];
	return [dc year];
}

- (NSUInteger) month
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitMonth fromDate:self];
	return [dc month];
}

- (NSUInteger) day
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitDay fromDate:self];
	return [dc day];
}

- (NSUInteger) hour
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitHour fromDate:self];
	return [dc hour];
}

- (NSUInteger) minute
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitMinute fromDate:self];
	return [dc minute];
}

- (NSUInteger) second
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitSecond fromDate:self];
	return [dc second];
}

- (NSUInteger) weekday
{
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * dc = [cal components:NSCalendarUnitWeekday fromDate:self];
	return [dc weekday] - 1;
}

#pragma mark Formated String

- (NSString *) stringWithFormat:(NSString *)format
{
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	NSString * str = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	return str;
}


- (NSString *) humanReadableString
{
	NSDate * now = [[[NSDate alloc] init] autorelease];
	NSTimeInterval ti = [now timeIntervalSinceDate:self];
	
	// now -> 15 seconds
	if (ti < 16) {
		return NSLocalizedString(@"Just now", nil);
	}
	
	// 16 seconds -> 49 seconds
	if (ti < 50) {
		return NSLocalizedString(@"Less than 1 minute", nil);
	}
	// 50 seconds -> 69 minute
	if (ti < 70) {
		return NSLocalizedString(@"About 1 minute", nil);
	}
	// 70 seconds -> 99 seconds
	if (ti < 100) {
		return NSLocalizedString(@"1 minute ago", nil);
	}
	
	// 100 seconds -> 25 minutes
	if (ti < 60 * 25) {
		NSString * format = NSLocalizedString(@"%.0f minutes ago", nil);
		return [NSString stringWithFormat:format, ti / 60.0f];
	}
	// 25 minutes -> 35 minutes
	if (ti < 60 * 35) {
		return NSLocalizedString(@"About half an hour", nil);
	}
	// 35 minutes -> 45 minutes
	if (ti < 60 * 45) {
		return NSLocalizedString(@"Half an hour ago", nil);
	}
	
	// 45 minutes -> 50 minutes
	if (ti < 60 * 50) {
		return NSLocalizedString(@"Less than 1 hour", nil);
	}
	// 50 minutes -> 70 minutes
	if (ti < 60 * 70) {
		return NSLocalizedString(@"About 1 hour", nil);
	}
	// 70 mintes -> 99 minutes
	if (ti < 60 * 100) {
		return NSLocalizedString(@"An hour ago", nil);
	}
	
	NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
	[calendar autorelease];
	NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	
	NSDateComponents * comps1 = [calendar components:unit fromDate:self];
	NSDateComponents * comps2 = [calendar components:unit fromDate:now];
	
	// today
	if (comps1.day == comps2.day &&
		comps1.month == comps2.month &&
		comps1.year == comps2.year) {
		if (comps1.hour < 12) {
			NSString * format = NSLocalizedString(@"%d:%02d AM", nil);
			return [NSString stringWithFormat:format, comps1.hour, comps1.minute];
		} else if (comps1.hour == 12) {
			return NSLocalizedString(@"Noon", nil);
		} else {
			NSString * format = NSLocalizedString(@"%d:%02d PM", nil);
			return [NSString stringWithFormat:format, comps1.hour - 12, comps1.minute];
		}
	}
	
	// yesterday
	if (ti < 3600 * 24 + comps2.hour * 3600 + comps2.minute * 60 + comps2.second) {
		NSString * pre = NSLocalizedString(@"Yesterday", nil);
		if (comps1.hour < 12) {
			NSString * format = NSLocalizedString(@"%d:%02d AM", nil);
			NSString * str = [NSString stringWithFormat:format, comps1.hour, comps1.minute];
			return [NSString stringWithFormat:@"%@ %@", pre, str];
		} else if (comps1.hour == 12) {
			NSString * str = NSLocalizedString(@"Noon", nil);
			return [NSString stringWithFormat:@"%@ %@", pre, str];
		} else {
			NSString * format = NSLocalizedString(@"%d:%02d PM", nil);
			NSString * str = [NSString stringWithFormat:format, comps1.hour, comps1.minute];
			return [NSString stringWithFormat:@"%@ %@", pre, str];
		}
	}
	
	NSString * dateFormat = nil; // @"yyyy-MM-dd HH:mm:ss"
	if (comps1.year == comps2.year) {
		dateFormat = NSLocalizedString(@"MM-dd", nil);
	} else {
		dateFormat = NSLocalizedString(@"yyyy-MM-dd", nil);
	}
	return [self stringWithFormat:dateFormat];
}

@end