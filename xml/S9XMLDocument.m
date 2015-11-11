//
//  S9XMLDocument.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Data.h"
#import "S9String.h"
#import "S9XMLDocument.h"

@interface S9XMLDocument () {
	
	NSMutableArray * _stack; // stack for element chain
}

@end

@implementation S9XMLDocument

- (void) dealloc
{
	[_stack release];
	
	[super dealloc];
}

/* designated initializer */
- (instancetype) initWithName:(NSString *)name
{
	self = [super initWithName:name];
	if (self) {
		[_stack release];
		_stack = nil;
	}
	return self;
}

- (instancetype) initWithParser:(NSXMLParser *)parser
{
	self = [self initWithName:nil];
	if (self) {
		[parser setDelegate:self];
		[parser parse];
	}
	return self;
}

- (instancetype) initWithContentsOfFile:(NSString *)file
{
	NSURL * url = [NSURL fileURLWithPath:file isDirectory:NO];
	self = [self initWithContentsOfURL:url];
	[url release];
	return self;
}

- (instancetype) initWithContentsOfURL:(NSURL *)url
{
	NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	self = [self initWithParser:parser];
	[parser release];
	return self;
}

- (instancetype) initWithData:(NSData *)data
{
	NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
	self = [self initWithParser:parser];
	[parser release];
	return self;
}

- (instancetype) initWithStream:(NSInputStream *)stream
{
	NSXMLParser * parser = [[NSXMLParser alloc] initWithStream:stream];
	self = [self initWithParser:parser];
	[parser release];
	return self;
}

#pragma mark - NSXMLParserDelegate

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
	NSAssert([_stack count] == 0, @"stack not clean");
	[self cleanup];
	
	[_stack release];
	_stack = [[NSMutableArray alloc] initWithCapacity:32];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
	NSAssert([_stack count] == 0, @"stack not clean");
	[_stack release];
	_stack = nil;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	S9XMLElement * parent = [_stack lastObject];
	S9XMLElement * element = nil;
	if (parent) {
		element = [[S9XMLElement alloc] initWithName:elementName];
		[parent addChild:element];
		[element autorelease];
	} else {
		// document root element
		element = self;
		element.name = elementName;
	}
	[_stack addObject:element];
	
	// set attributes
	[element setAttributes:attributeDict];
	
	// set parent
	element.parent = parent;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSAssert([_stack count] > 0, @"current element not found");
	S9XMLElement * element = [_stack lastObject];
	string = [string trim];
	if ([string length] > 0) {
		element.text = string;
	}
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	NSAssert([_stack count] > 0, @"current element not found");
	NSString * string = [CDATABlock stringWithEncoding:NSUTF8StringEncoding];
	S9XMLElement * element = [_stack lastObject];
	element.text = string;
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSAssert([_stack count] > 0, @"current element not found");
	[_stack removeLastObject];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSAssert(!parseError, @"parse XML error: %@", parseError);
}

@end
