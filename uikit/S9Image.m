//
//  S9Image.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Image.h"

UIImage * UIImageWithName(NSString * name)
{
	UIImage * image = nil;
	if (!name) {
		// error
	} else if ([name rangeOfString:@"/"].location == NSNotFound) {
		// get image from main bundle
		image = [UIImage imageNamed:name];
	} else if ([name rangeOfString:@"://"].location == NSNotFound || [name hasPrefix:@"file://"]) {
		// get image from local file
		image = [UIImage imageWithContentsOfFile:name];
	} else {
		// get image with data from remote server
		NSURL * url = [[NSURL alloc] initWithString:name];
		if (url) {
			NSData * data = [[NSData alloc] initWithContentsOfURL:url];
			if (data) {
				image = [UIImage imageWithData:data];
				[data release];
			}
			[url release];
		}
	}
	return image;
}

@implementation UIImage (IO)

- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
	NSData * data = nil;
	NSString * ext = [[path pathExtension] lowercaseString];
	if ([ext isEqualToString:@"png"]) {
		data = UIImagePNGRepresentation(self);
	} else if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]) {
		data = UIImageJPEGRepresentation(self, 1.0f);
	} else {
		NSAssert(false, @"unsupportd image format: %@", path);
		return NO;
	}
	return [data writeToFile:path atomically:useAuxiliaryFile];
}

@end
