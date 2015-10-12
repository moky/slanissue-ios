//
//  FSMState.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSMMachine;
@class FSMTransition;

@interface FSMState : NSObject

@property(nonatomic, readonly) NSString * name;

- (instancetype) initWithName:(NSString *)name capacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithName:(NSString *)name;

- (void) addTransition:(FSMTransition *)transition;

- (void) onEnter:(FSMMachine *)machine;
- (void) onExit:(FSMMachine *)machine;

- (void) onPause:(FSMMachine *)machine;
- (void) onResume:(FSMMachine *)machine;

@end
