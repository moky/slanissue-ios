//
//  FSMFunctionTransition.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "FSMTransition.h"

@interface FSMFunctionTransition : FSMTransition

@property(nonatomic, assign) id delegate;
@property(nonatomic, readwrite) SEL selector;

- (instancetype) initWithTargetStateName:(NSString *)name
								delegate:(id)delegate
								selector:(SEL)selector;

@end
