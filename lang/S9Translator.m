//
//  S9Translator.m
//  SlanissueToolkit
//
//  Created by Moky on 15-10-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9Object.h"
#import "S9Array.h"
#import "S9Dictionary.h"
#import "S9StringsFile.h"
#import "S9Translator.h"

#define S9TranslatorDefaultLanguage @"en"
//#define S9TranslatorDefaultTable    @"Localizable"
#define S9TranslatorAllTables       @"_ALL_"

@interface S9Translator	()

@property(nonatomic, readwrite) BOOL isDirty;

@property(nonatomic, retain) NSMutableDictionary * tables;
@property(nonatomic, retain) NSDictionary * dictionaries;

@end

@implementation S9Translator

@synthesize currentLanguage = _currentLanguage;

@synthesize isDirty = _isDirty;

@synthesize tables = _tables;
@synthesize dictionaries = _dictionaries;

- (void) dealloc
{
	[_currentLanguage release];
	[_tables release];
	[_dictionaries release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
		NSArray * languages = [ud objectForKey:@"AppleLanguages"];
		self.currentLanguage = [languages firstObject];
		
		_isDirty = NO;
		
		self.tables = [NSMutableDictionary dictionaryWithCapacity:4];
		self.dictionaries = nil;
	}
	return self;
}

S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (void) setCurrentLanguage:(NSString *)currentLanguage
{
	if (![_currentLanguage isEqualToString:currentLanguage]) {
		[currentLanguage retain];
		[_currentLanguage release];
		_currentLanguage = currentLanguage;
		
//		if (currentLanguage) {
//			NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
//			[ud setObject:currentLanguage forKey:@"user_lang_string"];
//		}
		_isDirty = [_tables count] > 0;
	}
}

- (NSString *) currentLanguage
{
	return _currentLanguage ? _currentLanguage : S9TranslatorDefaultLanguage;
}

- (void) addTable:(NSString *)tbl bundlePath:(NSString *)dir
{
	NSAssert(tbl && dir, @"failed to add table: %@, dir: %@", tbl, dir);
	S9DictionarySetObjectForKey(_tables, dir, tbl);
	_isDirty = YES;
}

- (void) addAllTablesWithBundlePath:(NSString *)dir
{
	[self addAllTablesWithBundlePath:dir language:self.currentLanguage];
}

- (void) addAllTablesWithBundlePath:(NSString *)dir language:(NSString *)lang
{
	NSString * langDir = [lang stringByAppendingPathExtension:@"lproj"];
	langDir = [dir stringByAppendingPathComponent:langDir];
	
	NSFileManager * fm = [NSFileManager defaultManager];
	NSError * error = nil;
	NSArray * array = [fm contentsOfDirectoryAtPath:langDir error:&error];
	if (error) {
		S9Log(@"error: %@", error);
		return;
	}
	
	NSString * filename;
	S9_FOR_EACH(array, filename) {
		if ([filename hasSuffix:@".strings"]) {
			[self addTable:[filename stringByDeletingPathExtension]
				bundlePath:dir];
		}
	}
}

- (void) reload
{
	if (!_isDirty) {
		// no need to reload
		return;
	}
	
	NSMutableDictionary * dictionaries = [[NSMutableDictionary alloc] initWithCapacity:([_tables count] + 1)];
	NSMutableDictionary * all = [[NSMutableDictionary alloc] initWithCapacity:64];
	
	NSString * lang = self.currentLanguage;
	NSString * name;
	NSString * dir;
	NSDictionary * dict;
	S9_FOR_EACH_KEY_VALUE(_tables, name, dir) {
		NSAssert([name length] > 0 && ![name isEqualToString:S9TranslatorAllTables],
				 @"invalid table: %@", name);
		dict = S9LocalizedStringsFileLoad(name, lang, dir);
		NSAssert([dict isKindOfClass:[NSDictionary class]],
				 @"no language file(%@.strings) for language(%@) in dir: %@",
				 name, lang, dir);
		if (dict) {
			[dictionaries setObject:dict forKey:name];
			[all addEntriesFromDictionary:dict];
		}
	}
	NSAssert([all count] > 0, @"no strings found");
	
	if ([all count] > 0) {
		[dictionaries setObject:all forKey:S9TranslatorAllTables];
		self.dictionaries = dictionaries;
	} else {
		self.dictionaries = nil; // clear
	}
	
	[all release];
	[dictionaries release];
	
	_isDirty = NO;
}

- (NSString *) localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tbl
{
	if (!key) {
		return value;
	}
	
	[self reload]; // reload if needs
	
	if (_dictionaries) {
		if (!tbl) {
			tbl = S9TranslatorAllTables;
		}
		NSDictionary * table = [_dictionaries objectForKey:tbl];
		NSString * string = [table objectForKey:key];
		if (string) {
			//S9Log(@"got localized string from table: %@", tableName);
			return string;
		}
	}
	
	return [[NSBundle mainBundle] localizedStringForKey:key value:value table:tbl];
}

@end
