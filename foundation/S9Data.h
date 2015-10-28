//
//  S9Data.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  encode an NSData object to a 'Base-64' string
 */
FOUNDATION_EXTERN NSString * Base64EncodeData(NSData * sourceData);

/**
 *  decode data from a 'Base-64' string
 */
FOUNDATION_EXTERN NSData * Base64DecodeData(NSString * base64EncodedString);

/**
 *  encode a plain text to a 'Base-64' string
 */
FOUNDATION_EXTERN NSString * Base64EncodeString(NSString * plainString);

/**
 *  decode text from a 'Base-64' string
 */
FOUNDATION_EXTERN NSString * Base64DecodeString(NSString * base64EncodedString);

@interface NSData (SlanissueToolkit)

- (NSString *) stringWithEncoding:(NSStringEncoding)encoding;

@end
