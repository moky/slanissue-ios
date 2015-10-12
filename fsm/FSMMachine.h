//
//  FSMMachine.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSMMachine;
@class FSMState;

@protocol FSMDelegate <NSObject>

@required
- (void) machine:(FSMMachine *)machine enterState:(FSMState *)state;
- (void) machine:(FSMMachine *)machine exitState:(FSMState *)state;

@optional
- (void) machine:(FSMMachine *)machine pauseState:(FSMState *)state;
- (void) machine:(FSMMachine *)machine resumeState:(FSMState *)state;

@end

@interface FSMMachine : NSObject

@property(nonatomic, assign) id<FSMDelegate> delegate;

@property(nonatomic, retain) NSString * defaultStateName; // default is "default"
@property(nonatomic, readonly) FSMState * currentState;

- (instancetype) initWithDefaultStateName:(NSString *)name capacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

- (void) addState:(FSMState *)state; // add state with transition(s)

- (void) start;  // start machine from default state
- (void) stop;   // stop machine and set current state to nil

- (void) pause;  // pause machine, current state not change
- (void) resume; // resume machine with current state

//@protected:
- (void) tick;

@end
