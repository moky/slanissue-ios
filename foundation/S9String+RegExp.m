//
//  S9String+RegExp.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9String+RegExp.h"

@implementation NSString (RegExp)

- (BOOL) matchesRegExp:(NSString *)regex
{
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [pred evaluateWithObject:self];
}

- (BOOL) isMobileNumber
{
	/**
	 * China Mobile : 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
	 * China Unicom : 130,131,132,152,155,156,185,186,1709
	 * China Telecom: 133,1349,153,180,189,1700
	 */
	
//	// China Mobile
//	static NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
//	if ([self matchesRegExp:CM]) {
//		return YES;
//	}
//	
//	// China Unicom
//	static NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
//	if ([self matchesRegExp:CU]) {
//		return YES;
//	}
//	
//	// China Telecom
//	static NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
//	if ([self matchesRegExp:CT]) {
//		return YES;
//	}
//	
//	return NO;
	
	// @"13800138000"
	static NSString * mobileRegExp = @"^1[3578][0-9]{9}$";
	return [self matchesRegExp:mobileRegExp];
}

- (BOOL) isEmailAddress
{
	// @"albert.moky@gmail.com"
	static NSString * emailRegExp = @"^[a-z0-9]+([.-_][a-z0-9]+)*" // account
	                                 "@[a-z0-9]+([.-][a-z0-9]+)+$"; // domain
	return [self matchesRegExp:emailRegExp];
}

@end
