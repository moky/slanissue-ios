//
//  S9Data.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Data.h"

@implementation NSData (SlanissueToolkit)

- (NSString *) stringWithEncoding:(NSStringEncoding)encoding
{
	return [[[NSString alloc] initWithData:self encoding:encoding] autorelease];
}

@end
