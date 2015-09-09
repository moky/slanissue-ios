//
//  S9ActionInterval.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9FiniteTimeAction.h"

/** An interval action is an action that takes place within a certain period of time.
 It has an start time, and a finish time. The finish time is the parameter
 duration plus the start time.
 
 These ActionInterval actions have some interesting properties, like:
 - They can run normally (default)
 - They can run reversed with the reverse method
 - They can run with the time altered with the Accelerate, AccelDeccel and Speed actions.
 
 For example, you can simulate a Ping Pong effect running the action normally and
 then running it again in Reverse mode.
 
 Example:
 
	S9Action * pingPongAction = [S9Sequence actions: action, [action reverse], nil];
 */
@interface S9ActionInterval : S9FiniteTimeAction {
	
	//! elapsed time in seconds
	float _elapsed;
}

/** how many seconds had elapsed since the actions started to run. */
@property(nonatomic, readonly) float elapsed;

- (instancetype) initWithDuration:(float)duration;

+ (instancetype) actionWithDuration:(float)duration;

/** returns a reversed action */
- (S9ActionInterval *) reverse;

@end

#pragma mark -

/** Delays the action a certain amount of seconds
 */
@interface S9DelayTime : S9ActionInterval

@end

/** Executes an action in reverse order, from time=duration to time=0
 
 @warning Use this action carefully. This action is not
 sequenceable. Use it as the default "reversed" method
 of your own actions, but using it outside the "reversed"
 scope is not recommended.
 */
@interface S9ReverseTime : S9ActionInterval {
	
	S9FiniteTimeAction * _innerAction;
}

- (instancetype) initWithAction:(S9FiniteTimeAction *)action;
+ (instancetype) actionWithAction:(S9FiniteTimeAction *)action;

@end

/** Repeats an action a number of times.
 * To repeat an action forever use the S9RepeatForever action.
 */
@interface S9Repeat : S9ActionInterval {
	
	S9FiniteTimeAction * _innerAction;
	NSUInteger _times;
	NSUInteger _total;
}

- (instancetype) initWithAction:(S9FiniteTimeAction *)action times:(NSUInteger)times;

+ (instancetype) actionWithAction:(S9FiniteTimeAction *)action times:(NSUInteger)times;

@end

/** Runs actions sequentially, one after another
 */
@interface S9Sequence : S9ActionInterval

/** initializes the action */
- (instancetype) initWithActionOne:(S9FiniteTimeAction *)action1 two:(S9FiniteTimeAction *)action2;

/** helper contructor to create an array of sequenceable actions */
+ (instancetype) actions:(S9FiniteTimeAction *)action1, ... NS_REQUIRES_NIL_TERMINATION;

/** helper contructor to create an array of sequenceable actions given an array */
+ (instancetype) actionsWithArray:(NSArray *)actions;

/** creates the action */
+ (instancetype) actionOne:(S9FiniteTimeAction *)action1 two:(S9FiniteTimeAction *)action2;

@end

/** Spawn a new action immediately
 */
@interface S9Spawn : S9Sequence

@end
