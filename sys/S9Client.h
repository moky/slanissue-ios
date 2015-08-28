//
//  S9Client.h
//  SlanissueToolkit
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface S9Client : NSObject

@property(nonatomic, readonly) CGSize screenSize;
@property(nonatomic, readonly) CGFloat screenScale;
@property(nonatomic, readonly) CGSize windowSize;
@property(nonatomic, readonly) CGFloat statusBarHeight;

@property(nonatomic, readonly) NSString * hardware;
@property(nonatomic, readonly) NSString * deviceIdentifier;
@property(nonatomic, readonly) NSString * deviceModel;
@property(nonatomic, readonly) NSString * systemName;
@property(nonatomic, readonly) NSString * systemVersion;

// app bundle
@property(nonatomic, readonly) NSString * name;
@property(nonatomic, readonly) NSString * version;

// DOS
@property(nonatomic, readonly) NSString * applicationDirectory;
@property(nonatomic, readonly) NSString * documentDirectory;
@property(nonatomic, readonly) NSString * cachesDirectory;
@property(nonatomic, readonly) NSString * temporaryDirectory;

+ (instancetype) getInstance;

// checkup
- (BOOL) isPad;
- (BOOL) isRetina;

@end
