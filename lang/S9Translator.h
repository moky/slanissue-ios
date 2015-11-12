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

//
//  Language names
//

FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageEnglish; // @"en"
// @"en-GB"

FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageChineseSimplified; // @"zh-Hans"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageChineseTraditional; // @"zh-Hant"

// @"zh-CN"
// @"zh-TW"
// @"zh-HK"
// @"zh-MO"

FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageFrench;    // @"fr"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageGerman;    // @"de"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageJapanese;  // @"ja"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageDutch;     // @"nl"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageItalian;   // @"it"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageSpanish;   // @"es"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguagePortuguese;// @"pt"
// @"pt-PT"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageDanish;    // @"da"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageFinnish;   // @"fi"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageNorwegian; // @"nb"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageSwedish;   // @"sv"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageKorean;    // @"ko"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageRussian;   // @"ru"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguagePolish;    // @"pl"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageTurkish;   // @"tr"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageUkrainian; // @"uk"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageArabic;    // @"ar"
// @"hr"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageCzech;     // @"cs"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageGreek;     // @"el"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageHebrew;    // @"he"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageRomanian;  // @"ro"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageSlovak;    // @"sk"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageThai;      // @"th"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageIndonesian;// @"id"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageMalay;     // @"ms"
// @"ca"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageHungarian; // @"hu"
FOUNDATION_EXPORT NSString * const NSStringTranslatorLanguageVietnamese;// @"vi"
