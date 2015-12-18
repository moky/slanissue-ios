//
//  S9WebView.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !TARGET_OS_TV

@interface UIWebView (SlanissueToolkit)

@property(nonatomic, readonly) NSString * title;
@property(nonatomic, readonly) NSURL * URL;

// inject a 'Javascript' file into the current web
- (NSString *) inject:(NSString *)jsFile;

+ (NSString *) inject:(NSString *)jsFile webview:(UIWebView *)wv;

@end

#endif
