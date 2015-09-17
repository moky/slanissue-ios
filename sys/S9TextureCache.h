//
//  S9TextureCache.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-7.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class S9Texture;

@interface S9TextureCache : NSObject

+ (instancetype) getInstance;

/** purges the cache. It releases the retained instance.
 */
+ (void) purgeSharedTextureCache;

/** Returns a Texture object given an file image
 *  If the file image was not previously loaded, it will create a new Texture
 *  object and it will return it. It will use the filename as a key.
 *  Otherwise it will return a reference of a previosly loaded image.
 */
- (S9Texture *) addImage:(NSString *)filename;

/** Returns a Texture object given an UIImage image
 * If the image was not previously loaded, it will create a new Texture object and it will return it.
 * Otherwise it will return a reference of a previously loaded image
 * The "key" parameter will be used as the "key" for the cache.
 * If "key" is nil, then a new texture will be created each time.
 */
- (S9Texture *) addUIImage:(UIImage *)image forKey:(NSString *)key;

/** Returns a Texture object given an CGImageRef image
 * If the image was not previously loaded, it will create a new Texture object and it will return it.
 * Otherwise it will return a reference of a previously loaded image
 * The "key" parameter will be used as the "key" for the cache.
 * If "key" is nil, then a new texture will be created each time.
 */
- (S9Texture *) addCGImage:(CGImageRef)imageRef forKey:(NSString *)key;

/** Returns an already created texture. Returns nil if the texture doesn't exist.
 */
- (S9Texture *) textureForKey:(NSString *)key;

/** Purges the dictionary of loaded textures.
 * Call this method if you receive the "Memory Warning"
 * In the short term: it will free some resources preventing your app from being killed
 * In the medium term: it will allocate more resources
 * In the long term: it will be the same
 */
- (void) removeAllTextures;

/** Removes unused textures
 * Textures that have a retain count of 1 will be deleted
 * It is convinient to call this method after when starting a new Scene
 */
- (void) removeUnusedTextures;

/** Deletes a texture from the cache given a texture
 */
- (void) removeTexture:(S9Texture *)texture;

/** Deletes a texture from the cache given a its key name
 */
- (void) removeTextureForKey:(NSString *)key;

@end
