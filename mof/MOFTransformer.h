//
//  MOFTransformer.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-10.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "MOFObject.h"

@interface MOFTransformer : MOFObject

- (instancetype) initWithObject:(NSObject *)root;

@end

#define MOFSave(obj, path)                                                     \
        [[[[MOFTransformer alloc] initWithObject:(obj)] autorelease] saveToFile:(path)]
                                                             /* EOF 'MOFSave' */

