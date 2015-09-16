//
//  S9String.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "S9Math.h"

// create MD5 string
#define MD5(string) [(string) MD5String]
// calculate a string
#define CGFloatFromString(string) calculate([(string) UTF8String])

@interface NSString (SlanissueToolkit)

// convert object to JsON string
+ (NSString *) stringBySerializingObject:(NSObject *)object;

- (NSString *) MD5String;

- (NSString *) trim;
- (NSString *) trim:(NSString *)chars;

// encode/decode string for URL parameters
- (NSString *) escape;
- (NSString *) unescape;

// "/path/to/../something" => "/path/something"
- (NSString *) simplifyPath;

// get filename
- (NSString *) filename;

//  "{{1+2, 3-4}, {5*6, 7/8}}" => "{{3,-1},{30,0.875}}"
- (NSString *) calculate;

@end
