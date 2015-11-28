//
//  S9String+RegExp.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegExp)

- (BOOL) matchesRegExp:(NSString *)regex;

- (BOOL) isMobileNumber;

- (BOOL) isEmailAddress;

@end
