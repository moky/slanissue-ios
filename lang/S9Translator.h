//
//  S9Translator.h
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S9Translator : NSObject

@property(nonatomic, retain) NSString * currentLanguage;

+ (instancetype) getInstance;

// path: "${dir}/${currentLanguage}.lproj/${tbl}.strings"
- (void) addTable:(NSString *)tbl bundlePath:(NSString *)dir;

// add all "*.strings" file in bundle with current language
- (void) addAllTablesWithBundlePath:(NSString *)dir;
- (void) addAllTablesWithBundlePath:(NSString *)dir language:(NSString *)lang;

// reload all tables
- (void) reload;

// translate the 'key' string to current language
- (NSString *) localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tbl;

@end

#define S9SharedTranslator()                          [S9Translator getInstance]

#define S9TranslatorSetCurrentLanguage(lang)                                   \
        [S9SharedTranslator() setCurrentLanguage:(lang)]                       \
                                      /* EOF 'S9TranslatorSetCurrentLanguage' */
#define S9TranslatorAddLanguagePack(tbl, dir)                                  \
        [S9SharedTranslator() addTable:(tbl) bundlePath:(dir)]                 \
                                         /* EOF 'S9TranslatorAddLanguagePack' */
#define S9TranslatorScanLanguagePacks(dir)                                     \
        [S9SharedTranslator() addAllTablesWithBundlePath:(dir)]                \
                                       /* EOF 'S9TranslatorScanLanguagePacks' */

#define S9LocalizedString(key, comment)                                        \
        [S9SharedTranslator() localizedStringForKey:(key) value:@"" table:nil] \
                                                   /* EOF 'S9LocalizedString' */
#define S9LocalizedStringFromTable(key, tbl, comment)                          \
        [S9SharedTranslator() localizedStringForKey:(key) value:@"" table:(tbl)]
                                          /* EOF 'S9LocalizedStringFromTable' */
