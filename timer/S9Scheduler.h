//
//  S9Scheduler.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Tick.h"

/** Scheduler is responsible of triggering the scheduled callbacks.
 You should not use NSTimer. Instead use this class.
 
 There are 2 different types of callbacks (selectors):
 
	- tick selector: the 'tick' selector will be called every frame. You can customize the priority.
	- custom selector: A custom selector will be called every frame, or with a custom interval of time
 
 The 'custom selectors' should be avoided when possible. It is faster, and consumes less memory to use the 'tick selector'.
 
 */
@interface S9Scheduler : NSObject<S9TickCallback>

/** Modifies the time of all scheduled callbacks.
 You can use this property to create a 'slow motion' or 'fast fordward' effect.
 Default is 1.0. To create a 'slow motion' effect, use values below 1.0.
 To create a 'fast fordward' effect, use values higher than 1.0.
 @warning It will affect EVERY scheduled selector / action.
 */
@property(nonatomic, readwrite) float timeScale;

/** returns a shared instance of the Scheduler */
+ (instancetype) getInstance;

/** purges the shared scheduler. It releases the retained instance.
 */
+ (void) purgeSharedScheduler;

/** The scheduled method will be called every 'interval' seconds.
 If paused is YES, then it won't be called until it is resumed.
 If 'interval' is 0, it will be called every frame, but if so, it recommened to use 'scheduleTickForTarget:' instead.
 If the selector is already scheduled, then only the interval parameter will be updated without re-scheduling it again.
 */
- (void) scheduleSelector:(SEL)selector forTarget:(id)target interval:(float)interval paused:(BOOL)paused;

/** Schedules the 'tick' selector for a given target with a given priority.
 The 'tick' selector will be called every frame.
 The lower the priority, the earlier it is called.
 */
- (void) scheduleTickForTarget:(id)target priority:(NSInteger)priority paused:(BOOL)paused;

/** Unshedules a selector for a given target.
 If you want to unschedule the "tick", use unscheudleTickForTarget.
 */
- (void) unscheduleSelector:(SEL)selector forTarget:(id)target;

/** Unschedules the tick selector for a given target
 */
- (void) unscheduleTickForTarget:(id)target;

/** Unschedules all selectors for a given target.
 This also includes the "tick" selector.
 */
- (void) unscheduleAllSelectorsForTarget:(id)target;

/** Unschedules all selectors from all targets.
 You should NEVER call this method, unless you know what you are doing.
 */
- (void) unscheduleAllSelectors;

/** Pauses the target.
 All scheduled selectors/tick for a given target won't be 'ticked' until the target is resumed.
 If the target is not present, nothing happens.
 */
- (void) pauseTarget:(id)target;

/** Resumes the target.
 The 'target' will be unpaused, so all schedule selectors/tick will be 'ticked' again.
 If the target is not present, nothing happens.
 */
- (void) resumeTarget:(id)target;

/** Returns whether or not the target is paused
 */
- (BOOL) isTargetPaused:(id)target;

@end
