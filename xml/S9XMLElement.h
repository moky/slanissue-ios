//
//  S9XMLElement.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S9XMLElement : NSObject

@property(nonatomic, retain) NSString * name; // tag of the element
@property(nonatomic, retain) NSString * text; // when the element is a string

- (instancetype) initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

// get attribute by key
- (NSString *) attribute:(NSString *)key;

// get all attributes
- (NSDictionary *) attributes;

// set attribute for key
- (void) setAttribute:(NSString *)value forKey:(NSString *)key;

// reset atttibutes
- (void) setAttributes:(NSDictionary *)attributes;

#pragma mark -

@property(nonatomic, assign) S9XMLElement * parent;

@property(nonatomic, readonly) NSArray * siblings; // children of parent

#pragma mark Children

// get count of child elements
- (NSUInteger) countOfChildren;

// get child element with index
- (S9XMLElement *) childAtIndex:(NSUInteger)index;

// get first child element with name
- (S9XMLElement *) childWithName:(NSString *)tag;

// get all children
- (NSArray *) children;

// get all children with the same name
- (NSArray *) childrenWithName:(NSString *)tag;

// append child element
- (void) addChild:(S9XMLElement *)element;

@end
