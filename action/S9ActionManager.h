//
//  S9ActionManager.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class S9Action;

/** S9ActionManager is a singleton that manages all the actions.
 Normally you won't need to use this singleton directly. 99% of the cases you will use the S9Node interface,
 which uses this singleton.
 But there are some cases where you might need to use this singleton.
 Examples:
	- When you want to run an action where the target is different from a S9Node.
	- When you want to pause / resume the actions
 */
@interface S9ActionManager : NSObject

+ (instancetype) getInstance;

/** Adds an action with a target.
 If the target is already present, then the action will be added to the existing target.
 If the target is not present, a new instance of this target will be created either paused or paused, and the action will be added to the newly created target.
 When the target is paused, the queued actions won't be 'ticked'.
 */
- (void) addAction:(S9Action *)action target:(id)target paused:(BOOL)paused;

/** Removes all actions from all the targers.
 */
- (void) removeAllActions;

/** Removes all actions from a certain target.
 All the actions that belongs to the target will be removed.
 */
- (void) removeAllActionsFromTarget:(id)target;

/** Removes an action given an action reference.
 */
- (void) removeAction:(S9Action *)action;

/** Pauses the target: all running actions and newly added actions will be paused.
 */
- (void) pauseTarget:(id)target;

/** Resumes the target. All queued actions will be resumed.
 */
- (void) resumeTarget:(id)target;

@end
