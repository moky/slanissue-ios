//
//  S9XMLDocument.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9XMLElement.h"

@interface S9XMLDocument : S9XMLElement<NSXMLParserDelegate>

- (instancetype) initWithContentsOfFile:(NSString *)file;
- (instancetype) initWithContentsOfURL:(NSURL *)url;
- (instancetype) initWithData:(NSData *)data;
- (instancetype) initWithStream:(NSInputStream *)stream NS_AVAILABLE(10_7, 5_0);

@end
