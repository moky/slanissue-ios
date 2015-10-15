//
//  MOFReader.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-9.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "MOFObject.h"

@interface MOFReader : MOFObject

@property(nonatomic, readonly) NSObject * root;

- (instancetype) initWithFile:(NSString *)filename;

@end

#define MOFLoad(path)                                                          \
        [[[[MOFReader alloc] initWithFile:(path)] autorelease] root]           \
                                                             /* EOF 'MOFLoad' */
