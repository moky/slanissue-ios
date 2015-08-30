//
//  S9Date.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SlanissueToolkit)

- (NSString *) stringWithFormat:(NSString *)format; // "yyyy-MM-dd HH:mm:ss"

- (NSString *) humanReadableString;

@end