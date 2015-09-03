//
//  S9MemoryCache.m
//  SlanissueToolkit
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9Object.h"
#import "S9Dictionary.h"
#import "S9MemoryCache.h"

@interface S9MemoryCache ()

@property(nonatomic, retain) NSMutableDictionary * dataPool;

@end

@implementation S9MemoryCache

@synthesize dataPool = _dataPool;

- (void) dealloc
{
	[_dataPool release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.dataPool = [NSMutableDictionary dictionaryWithCapacity:256];
	}
	return self;
}

// singleton implementations
S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
	NSAssert(aKey, @"key cannot be nil");
	if (!anObject) {
		// if the object is nil, remove the old object for key
		[self removeObjectForKey:aKey];
		return;
	}
	
	@synchronized(self) {
		[_dataPool setObject:anObject forKey:aKey];
	}
}

- (id) objectForKey:(id)aKey
{
	NSAssert(aKey, @"key cannot be nil");
	@synchronized(self) {
		return [[[_dataPool objectForKey:aKey] retain] autorelease];
	}
}

- (id) retainObjectForKey:(id<NSCopying>)aKey
{
	NSAssert(aKey, @"key cannot be nil");
	@synchronized(self) {
		return [[_dataPool objectForKey:aKey] retain];
	}
}

- (void) releaseObjectForKey:(id<NSCopying>)aKey
{
	NSAssert(aKey, @"key cannot be nil");
	@synchronized(self) {
		[[_dataPool objectForKey:aKey] release];
	}
}

- (void) removeObjectForKey:(id)aKey
{
	NSAssert(aKey, @"key cannot be nil");
	@synchronized(self) {
		[_dataPool removeObjectForKey:aKey];
	}
}

- (NSData *) getFileData:(NSString *)filename
{
	// try from cache
	NSData * data = [self objectForKey:filename];
	if (data) {
		return data;
	}
	
	// try from file
	data = [[NSData alloc] initWithContentsOfFile:filename];
	NSAssert(data, @"error: failed to get data from file: %@", filename);
	S9Log(@"**** I/O **** filename: %@", filename);
	
	[self setObject:data forKey:filename];
	[data release];
	
	return data;
}

//
//  The method 'allKeysForObject:' of NSDictionary
//  sends 'isEquals:' message to determine if the two objects are equal,
//  it's not what I want, so use this method instead.
//
- (NSArray *) _allKeysForObject:(id)anObject
{
	NSAssert(anObject, @"object cannot be nil");
	NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:2];
	
	id<NSCopying> key;
	id object;
	S9_FOR_EACH_KEY_VALUE(_dataPool, key, object) {
		if (object == anObject) { // compare exactly, and faster
			[mArray addObject:key];
		}
	}
	
	return [mArray autorelease];
}

- (float) purgeDataCache
{
	NSUInteger count, total;
	
	@synchronized(self) {
		total = [_dataPool count];
		count = 0;
		if (total > 0) {
			NSMutableArray * keysToRemove = [[NSMutableArray alloc] initWithCapacity:total];
			
			NSEnumerator * objectEnumerator = [_dataPool objectEnumerator];
			NSArray * keys;
			id object;
			while (object = [objectEnumerator nextObject]) {
				keys = [self _allKeysForObject:object];
				NSAssert([keys count] > 0 && [object retainCount] >= [keys count],
						 @"retain count: %u, keys count: %u", (unsigned int)[object retainCount], (unsigned int)[keys count]);
				if ([object retainCount] == [keys count]) {
					// nobody is retaining this object excepts the memory cache
					[keysToRemove addObjectsFromArray:keys];
					count += [keys count];
				}
			}
			
			[_dataPool removeObjectsForKeys:keysToRemove];
			[keysToRemove release];
		}
	}
	
	if (total == 0) {
		S9Log(@"no cache");
		return 1.0f;
	} else {
		S9Log(@"%u/%u memory item(s) has been clean.", (unsigned int)count, (unsigned int)total);
		return (float)count / total;
	}
}

@end
