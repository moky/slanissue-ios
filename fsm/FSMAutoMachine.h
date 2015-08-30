//
//  FSMAutoMachine.h
//  FiniteStateMachine
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "FSMMachine.h"

@interface FSMAutoMachine : FSMMachine

@property(nonatomic, readwrite) NSTimeInterval interval; // default is 1.0/12.0

@end
