//
//  S9XMLPath.h
//  SlanissueToolkit
//
//  Created by Moky on 15-11-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9XMLElement.h"

/**
 *
 *  XPath Syntax (simplify version)
 *
 *      nodename - select all children named "nodename"
 *      .        - select self
 *      ..       - select parent node
 *      *        - select all children
 *
 *      /        - path separator
 *      []       - subscript operator
 *
 *      last()   - index of last children
 *
 */

@interface S9XMLElement (XPath)

/**
 *  get element with XPath:
 *
 *      1. "aaa/bbb"       - sub-element "bbb" of sub-element "aaa"
 *      2. "ccc[1]"        - the 2rd child of sub-element "ccc"
 *      3. "ccc[last()]"   - the last child of sub-element "ccc"
 *      4. "ccc[last()-1]" - the element before last child of sub-element "ccc"
 *      5. "../ddd"        - sibling element with name "ddd"
 */
- (S9XMLElement *) elementWithPath:(NSString *)path;

/**
 *  get elements with XPath:
 *
 *      1. "sss"           - all children with the same name "sss"
 *      2. "ddd/sss"       - all children with name "sss" of sub-element "ddd"
 *      3. "*"             - all children
 *      4. "aaa/\*"        - all children of sub-element "aaa"
 */
- (NSArray *) elementsWithPath:(NSString *)path;

@end
