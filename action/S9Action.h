//
//  S9Action.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Tick.h"

/** Base class for Action objects.
 */
@interface S9Action : NSObject<S9TickCallback> {
	
	id _target;
}

/** The "target". The action will modify the target properties.
 The target will be set with the 'startWithTarget' method.
 When the 'stop' method is called, target will be set to nil.
 The target is 'assigned', it is not 'retained'.
 */
@property(nonatomic, readonly, assign) id target;

/** Allocates and initializes the action */
+ (instancetype) action;

//! return YES if the action has finished
- (BOOL) isDone;

//! called before the action start. It will also set the target.
- (void) startWithTarget:(id)target;

//! called after the action has finished. It will set the 'target' to nil.
//! IMPORTANT: You should never call "[action stop]" manually. Instead, use: "[target stopAction:action];"
- (void) stop;

//! called once per frame. time a value between 0 and 1
//! For example:
//! * 0 means that the action just started
//! * 0.5 means that the action is in the middle
//! * 1 means that the action is over
- (void) update:(float)time;

@end

@class S9ActionInterval;
/** Repeats an action for ever.
 To repeat the an action for a limited number of times use the Repeat action.
 @warning This action can't be Sequenceable because it is not an IntervalAction
 */
@interface S9RepeatForever : S9Action {
	
	S9ActionInterval * _innerAction; // retain
}

@property(nonatomic, readonly) S9ActionInterval * innerAction;

- (instancetype) initWithAction:(S9ActionInterval *)action;

+ (instancetype) actionWithAction:(S9ActionInterval *)action;

@end
