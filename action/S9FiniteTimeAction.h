//
//  S9FiniteTimeAction.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Action.h"

/** Base class actions that do have a finite time duration.
 Possible actions:
 - An action with a duration of 0 seconds
 - An action with a duration of 35.5 seconds
 Infitite time actions are valid
 */
@interface S9FiniteTimeAction : S9Action {
	
	//! duration in seconds
	float _duration;
}

//! duration in seconds of the action
@property(nonatomic, readwrite) float duration;

/** returns a reversed action */
- (S9FiniteTimeAction *) reverse;

@end
