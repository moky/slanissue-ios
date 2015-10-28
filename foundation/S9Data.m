//
//  S9Data.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Client.h"
#import "S9Data.h"

NSString * Base64EncodeData(NSData * sourceData)
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
	float systemVersion = [[[S9Client getInstance] systemVersion] floatValue];
	if (systemVersion < 7.0f)
		return [sourceData base64Encoding];
	else
#endif
		return [sourceData base64EncodedStringWithOptions:0];
}

NSData * Base64DecodeData(NSString * base64EncodedString)
{
	NSData * data;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
	float systemVersion = [[[S9Client getInstance] systemVersion] floatValue];
	if (systemVersion < 7.0f)
		data = [[NSData alloc] initWithBase64Encoding:base64EncodedString];
	else
#endif
		data = [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:0];
	return [data autorelease];
}

NSString * Base64EncodeString(NSString * plainString)
{
	NSData * data = [plainString dataUsingEncoding:NSUTF8StringEncoding];
	return Base64EncodeData(data);
}

NSString * Base64DecodeString(NSString * base64EncodedString)
{
	NSData * data = Base64DecodeData(base64EncodedString);
	return [data stringWithEncoding:NSUTF8StringEncoding];
}

@implementation NSData (SlanissueToolkit)

- (NSString *) stringWithEncoding:(NSStringEncoding)encoding
{
	return [[[NSString alloc] initWithData:self encoding:encoding] autorelease];
}

@end
