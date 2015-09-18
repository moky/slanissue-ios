//
//  S9URL.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SlanissueToolkit)

// "....?a=1&b=2&c=3#fragment" => {a: 1, b: 2, c: 3}
- (NSDictionary *) parameters;

@end
