//
//  S9String+Path.h
//  SlanissueToolkit
//
//  Created by Moky on 15-12-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

// "/path/to/../filename" => "/path/filename"
- (NSString *) simplifyPath;

// get filename
- (NSString *) filename;

@end
