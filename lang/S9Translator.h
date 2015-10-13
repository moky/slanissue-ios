//
//  S9Translator.h
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define S9TranslatorSetCurrentLanguage(language)                               \
        [[S9Translator getInstance] setCurrentLanguage:(language)]
#define S9TranslatorAddLanguagePack(tableName, bundlePath)                     \
        [[S9Translator getInstance] addTable:(tableName) bundlePath:(bundlePath)]
#define S9TranslatorScanLanguagePacks(bundlePath)                              \
        [[S9Translator getInstance] addAllTablesWithBundlePath:(bundlePath)]

#define S9LocalizedString(key, comment) \
        [[S9Translator getInstance] localizedStringForKey:(key) value:@"" table:nil]
#define S9LocalizedStringFromTable(key, tbl, comment) \
        [[S9Translator getInstance] localizedStringForKey:(key) value:@"" table:(tbl)]

@interface S9Translator : NSObject

@property(nonatomic, retain) NSString * currentLanguage;

+ (instancetype) getInstance;

// path: "${dir}/${currentLanguage}.lproj/${tableName}.strings"
- (void) addTable:(NSString *)name bundlePath:(NSString *)dir;

// add all "*.strings" file in bundle with current language
- (void) addAllTablesWithBundlePath:(NSString *)path;
- (void) addAllTablesWithBundlePath:(NSString *)path language:(NSString *)language;

// reload all tables
- (void) reload;

// translate the 'key' string to current language
- (NSString *) localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

@end
