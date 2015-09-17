//
//  S9TextureCache.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-7.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9Object.h"
#import "S9Dictionary.h"
#import "S9Image.h"
#import "S9Texture.h"
#import "S9TextureCache.h"

@interface S9TextureCache ()

@property(nonatomic, retain) NSMutableDictionary * cache;

@end

@implementation S9TextureCache

@synthesize cache = _cache;

- (void) dealloc
{
	self.cache = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.cache = [NSMutableDictionary dictionaryWithCapacity:64];
	}
	return self;
}

S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

+ (void) purgeSharedTextureCache
{
	[s_singleton_instance release];
	s_singleton_instance = nil;
}

- (S9Texture *) addImage:(NSString *)filename
{
	NSAssert([filename isKindOfClass:[NSString class]], @"image filename error: %@", filename);
	S9Texture * texture = [self textureForKey:filename];
	if (!texture) {
		UIImage * image = UIImageWithName(filename);
		texture = [self addUIImage:image forKey:filename];
	}
	return texture;
}

- (S9Texture *) addUIImage:(UIImage *)image forKey:(NSString *)key
{
	NSAssert(image && [key isKindOfClass:[NSString class]], @"parameters error");
	S9Texture * texture = [S9Texture textureWithUIImage:image];
	@synchronized(_cache) {
		[_cache setObject:texture forKey:key];
	}
	return texture;
}

- (S9Texture *) addCGImage:(CGImageRef)imageRef forKey:(NSString *)key
{
	NSAssert(imageRef && [key isKindOfClass:[NSString class]], @"parameters error");
	S9Texture * texture = [S9Texture textureWithCGImage:imageRef];
	@synchronized(_cache) {
		[_cache setObject:texture forKey:key];
	}
	return texture;
}

- (S9Texture *) textureForKey:(NSString *)key
{
	NSAssert([key isKindOfClass:[NSString class]], @"texture key error: %@", key);
	S9Texture * texture = nil;
	@synchronized(_cache) {
		texture = [_cache objectForKey:key];
		[[texture retain] autorelease];
	}
	return texture;
}

- (void) removeTexture:(S9Texture *)texture
{
	NSAssert([texture isKindOfClass:[S9Texture class]], @"texture error: %@", texture);
	@synchronized(_cache) {
		NSArray * keys = [_cache allKeysForObject:texture];
		NSAssert([keys count] > 0, @"no cache found for texture: %@", texture);
		[_cache removeObjectsForKeys:keys];
	}
}

- (void) removeTextureForKey:(NSString *)key
{
	NSAssert([key isKindOfClass:[NSString class]], @"texture key error: %@", key);
	@synchronized(_cache) {
		NSAssert([_cache objectForKey:key], @"no cache found for key: %@", key);
		[_cache removeObjectForKey:key];
	}
}

- (void) removeAllTextures
{
	@synchronized(_cache) {
		[_cache removeAllObjects];
	}
}

- (void) removeUnusedTextures;
{
	@synchronized(_cache) {
		NSUInteger total = [_cache count], count = 0;
		if (total == 0) {
			S9Log(@"texture cache is empty");
			return ;
		}
		
		NSMutableArray * keysToRemove = [[NSMutableArray alloc] initWithCapacity:total];
		
		NSString * key;
		id object;
		S9_FOR_EACH_KEY_VALUE(_cache, key, object) {
			if ([object retainCount] == 1) {
				S9Log(@"removing unused texture: %@", key);
				[keysToRemove addObject:key];
				++count;
			}
		}
		[_cache removeObjectsForKeys:keysToRemove];
		
		[keysToRemove release];
		
		S9Log(@"removed %u / %u item(s) in texture cache", (unsigned int)count, (unsigned int)total);
	}
}

@end
