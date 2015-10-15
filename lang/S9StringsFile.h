//
//  S9StringsFile.h
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9String.h"

FOUNDATION_EXTERN NSText * NSTextByRemovingComments(NSText * text);

@interface S9StringsFile : NSObject

@property(nonatomic, readonly) NSDictionary * dictionary;

- (instancetype) initWithDictionary:(NSDictionary *)dict NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithFile:(NSString *)path;

- (BOOL) saveToFile:(NSString *)path;

#pragma mark - Localization

/**
 *  load strings file from "${dir}/${lang}.lproj/${name}.strings"
 */
- (instancetype) initWithFile:(NSString *)name language:(NSString *)lang bundlePath:(NSString *)dir;

/**
 *  save dictionary to file "${dir}/${lang}.lproj/${name}.strings"
 */
- (BOOL) saveToFile:(NSString *)name language:(NSString *)lang bundlePath:(NSString *)dir;

@end

#define S9StringsFileLoad(path)                                                \
        [[[[S9StringsFile alloc] initWithFile:(path)] autorelease] dictionary] \
                                                   /* EOF 'S9StringsFileLoad' */

#define S9LocalizedStringsFileLoad(name, lang, dir)                            \
        [[[[S9StringsFile alloc] initWithFile:(name) language:(lang) bundlePath:(dir)] autorelease] dictionary]
                                          /* EOF 'S9LocalizedStringsFileLoad' */

#define S9StringsFileSave(dict, path)                                          \
        [[[[S9StringsFile alloc] initWithDictionary:(dict)] autorelease] saveToFile:(path)]
                                                   /* EOF 'S9StringsFileSave' */

#define S9LocalizedStringsFileSave(dict, name, lang, dir)                      \
        [[[[S9StringsFile alloc] initWithDictionary:(dict)] autorelease] saveToFile:(name) language:(lang) bundlePath:(dir)]
                                          /* EOF 'S9LocalizedStringsFileSave' */
