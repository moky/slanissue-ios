//
//  S9MemoryCache.h
//  SlanissueToolkit
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S9MemoryCache : NSObject

+ (instancetype) getInstance;

- (void) setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (id) objectForKey:(id)aKey;

//- (id) retainObjectForKey:(id<NSCopying>)aKey; // reference ++
//- (void) releaseObjectForKey:(id<NSCopying>)aKey; // reference --

- (void) removeObjectForKey:(id)aKey;

// note that this method won't increase the reference,
// if you wan't the file data retain in the cache,
// you must call retainObjectForKey:filename
- (NSData *) getFileData:(NSString *)filename;

// remove all data that have no reference
- (float) purgeDataCache;

@end
