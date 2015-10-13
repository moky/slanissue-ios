//
//  S9StringsFile.h
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * NSStringByRemovingComments(NSString * text);

@interface S9StringsFile : NSObject

@property(nonatomic, retain) NSDictionary * dictionary;

/**
 *  get dictionary<NSString *, NSString *> in .strings file, see below
 */
+ (NSDictionary *) stringsFromFile:(NSString *)filename withLanguage:(NSString *)language bundlePath:(NSString *)dir;

/**
 *  load strings file from "${dir}/${language}.lproj/${filename}.strings"
 */
- (BOOL) loadFile:(NSString *)filename withLanguage:(NSString *)language bundlePath:(NSString *)dir;

/**
 *  save dictionary to file "${dir}/${language}.lproj/${filename}.strings"
 */
//- (BOOL) saveFile:(NSString *)filename withLanguage:(NSString *)language bundlePath:(NSString *)dir;

@end
