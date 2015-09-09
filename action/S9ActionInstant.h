//
//  S9ActionInstant.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-31.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9FiniteTimeAction.h"

/** Instant actions are immediate actions. They don't have a duration like
 the CCIntervalAction actions.
 */
@interface S9ActionInstant : S9FiniteTimeAction

@end

#pragma mark - Callback

/** Calls a 'callback'
 */
@interface S9CallFunc : S9ActionInstant {
	
	id _targetCallback; // retain
	SEL _selector;
}

/** initializes the action with the callback */
- (instancetype) initWithTarget:(id)target selector:(SEL)selector;

/** creates the action with the callback */
+ (instancetype) actionWithTarget:(id)target selector:(SEL)selector;

@end

#pragma mark Blocks Support

#if NS_BLOCKS_AVAILABLE

/** Executes a callback using a block.
 */
@interface S9CallBlock : S9ActionInstant {
	
	void (^_block)(); // copy
}

/** initialized the action with the specified block, to be used as a callback.
 The block will be "copied".
 */
- (instancetype) initWithBlock:(void(^)())block;

/** creates the action with the specified block, to be used as a callback.
 The block will be "copied".
 */
+ (instancetype) actionWithBlock:(void(^)())block;

@end

#endif
