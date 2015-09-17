//
//  S9Texture.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-6.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Texture.h"

@interface S9Texture ()

@property(nonatomic, readwrite) CGImageRef imageRef;

@end

@implementation S9Texture

@synthesize imageRef = _imageRef;
@synthesize size = _size;
@synthesize scale = _scale;

- (void) dealloc
{
	self.imageRef = NULL;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.imageRef = NULL;
		_size = CGSizeZero;
		_scale = 1.0f;
	}
	return self;
}

- (instancetype) initWithCGImage:(CGImageRef)image scale:(CGFloat)scale
{
	self = [self init];
	if (self) {
		self.imageRef = image;
		_size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
		_scale = scale;
	}
	return self;
}

- (instancetype) initWithCGImage:(CGImageRef)image
{
	return [self initWithCGImage:image scale:1.0f];
}

- (instancetype) initWithUIImage:(UIImage *)image
{
	self = [self init];
	if (self) {
		self.imageRef = image.CGImage;
		_size = image.size;
		_scale = image.scale;
	}
	return self;
}

- (void) setImageRef:(CGImageRef)imageRef
{
	if (_imageRef != imageRef) {
		CGImageRetain(imageRef);
		CGImageRelease(_imageRef);
		_imageRef = imageRef;
	}
}

+ (instancetype) textureWithCGImage:(CGImageRef)image scale:(CGFloat)scale
{
	return [[[self alloc] initWithCGImage:image scale:scale] autorelease];
}

+ (instancetype) textureWithCGImage:(CGImageRef)image
{
	return [[[self alloc] initWithCGImage:image] autorelease];
}

+ (instancetype) textureWithUIImage:(UIImage *)image
{
	return [[[self alloc] initWithUIImage:image] autorelease];
}

@end
