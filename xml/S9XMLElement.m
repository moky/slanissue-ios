//
//  S9XMLElement.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"
#import "S9XMLElement.h"

@interface S9XMLElement () {
	
	NSMutableDictionary * _attributes;
	NSMutableArray * _children;
}

@end

@implementation S9XMLElement

@synthesize name = _name;
@synthesize text = _text;
@synthesize parent = _parent;

- (void) dealloc
{
	self.name = nil;
	self.text = nil;
	
	self.parent = nil;
	
	[_attributes release];
	
	[self removeAllChildren];
	[_children release];
	
	[super dealloc];
}

- (instancetype) init
{
	return [self initWithName:nil];
}

/* designated initializer */
- (instancetype) initWithName:(NSString *)name
{
	self = [super init];
	if (self) {
		self.name = name;
		self.text = nil;
		
		self.parent = nil;
		
		[_attributes release];
		_attributes = nil;
		
		[_children release];
		_children = nil;
	}
	return self;
}

- (NSString *) description
{
	return _text ? _text : [super description];
}

- (NSString *) attributeForKey:(NSString *)key
{
	NSAssert(key, @"attribute key cannot be nil");
	NSAssert(_attributes, @"no attribute found");
	return [_attributes objectForKey:key];
}

- (NSDictionary *) attributes
{
	NSAssert(_attributes, @"no attribute found");
	return _attributes;
}

- (void) setAttribute:(NSString *)value forKey:(NSString *)key
{
	NSAssert(key, @"invalid key(%@)", key);
	NSAssert(value, @"invalid value(%@)", value);
	if (!_attributes) {
		_attributes = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	[_attributes setObject:value forKey:key];
}

- (void) setAttributes:(NSDictionary *)attributes
{
	if (_attributes != attributes) {
		NSMutableDictionary * mDict = [attributes mutableCopy];
		[_attributes release];
		_attributes = mDict;
	}
}

#pragma mark -

- (NSArray *) siblings
{
	NSAssert(_parent, @"parent cannot be nil");
	return [_parent children];
}

#pragma mark Children

- (NSUInteger) countOfChildren
{
	NSAssert(_children, @"no children found");
	return [_children count];
}

- (S9XMLElement *) childAtIndex:(NSUInteger)index
{
	NSAssert(_children, @"no children found");
	if (index < [_children count]) {
		return [_children objectAtIndex:index];
	} else {
		NSAssert(false, @"invalid index: %u, count: %u",
				 (unsigned int)index, (unsigned int) [_children count]);
		return nil;
	}
}

- (S9XMLElement *) childWithName:(NSString *)tag
{
	NSAssert(_children, @"no children found");
	S9XMLElement * element;
	S9_FOR_EACH(_children, element) {
		if ([element.name isEqualToString:tag]) {
			return element;
		}
	}
	return nil;
}

- (NSArray *) children
{
	NSAssert(_children, @"no children found");
	return _children;
}

- (NSArray *) childrenWithName:(NSString *)tag
{
	NSAssert(_children, @"no children found");
	NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:[_children count]];
	S9XMLElement * element;
	S9_FOR_EACH(_children, element) {
		if ([element.name isEqualToString:tag]) {
			[mArray addObject:element];
		}
	}
	return mArray;
}

- (void) addChild:(S9XMLElement *)element
{
	NSAssert([element isKindOfClass:[S9XMLElement class]], @"invalid element: %@", element);
	if (!_children) {
		_children = [[NSMutableArray alloc] initWithCapacity:4];
	}
	[_children addObject:element];
}

- (void) removeAllChildren
{
	S9XMLElement * element;
	S9_FOR_EACH(_children, element) {
		element.parent = nil;
	}
	[_children removeAllObjects];
	
	[_children release];
	_children = nil;
}

@end
