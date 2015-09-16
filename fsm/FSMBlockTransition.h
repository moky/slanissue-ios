//
//  FSMBlockTransition.h
//  FiniteStateMachine
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "FSMTransition.h"

#if NS_BLOCKS_AVAILABLE

typedef BOOL (^FSMBlock)(FSMMachine * machine, FSMTransition * transition);

@interface FSMBlockTransition : FSMTransition

@property(nonatomic, readwrite) FSMBlock block;

- (instancetype) initWithTargetStateName:(NSString *)name block:(FSMBlock)block;

@end

#endif
