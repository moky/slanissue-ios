//
//  S9WebView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9MemoryCache.h"
#import "S9Data.h"
#import "S9WebView.h"

@implementation UIWebView (SlanissueToolkit)

- (NSString *) title
{
	return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSURL *) URL
{
	NSString * href = [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
	return [NSURL URLWithString:href];
}

- (NSString *) inject:(NSString *)jsFile
{
	S9MemoryCache * cache = [S9MemoryCache getInstance];
	S9Log(@"injecting %@", jsFile);
	
	NSString * javascript = [cache objectForKey:jsFile];
	if (!javascript) {
		// load data from file
		NSStringEncoding encoding = NSUTF8StringEncoding;
		NSError * error;
		javascript = [NSString stringWithContentsOfFile:jsFile encoding:encoding error:&error];
		NSAssert(javascript && !error, @"decode error: %@,", error);
		
		// cache it
		[cache setObject:javascript forKey:jsFile];
	}
	
	// inject
	return javascript ? [self stringByEvaluatingJavaScriptFromString:javascript] : nil;
}

@end
