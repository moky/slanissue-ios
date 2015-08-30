//
//  UIScrollRefreshControlStateMachine.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-4.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "FSMBlockTransition.h"
#import "S9ScrollRefreshControlState.h"
#import "S9ScrollRefreshControlStateMachine.h"

@implementation UIScrollRefreshControlStateMachine

@synthesize controlDimension = _controlDimension;
@synthesize controlOffset = _controlOffset;
@synthesize pulling = _pulling;
@synthesize dataLoaded = _dataLoaded;
@synthesize terminated = _terminated;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_controlDimension = 80.0f;
		_controlOffset = 0.0f;
		_pulling = NO;
		_dataLoaded = NO;
		_terminated = NO;
	}
	return self;
}

// after read, set it FALSE automactilly
- (BOOL) isDataLoaded
{
	if (_dataLoaded) {
		_dataLoaded = NO;
		return YES;
	} else {
		return NO;
	}
}

- (void) start
{
	self.defaultStateName = kUIScrollRefreshControlStateNameDefault;
	
	[self addState:[self _defaultState]];
	[self addState:[self _visibleState]];
	[self addState:[self _willRefreshState]];
	[self addState:[self _refreshingState]];
	[self addState:[self _terminatedState]];
	
	[super start];
}

#pragma mark - States

- (FSMState *) _defaultState
{
	UIScrollRefreshControlState * state;
	state = [[UIScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateDefault];
	
	// transitions
	FSMBlockTransition * trans;
	
	// 1. 'default' -> 'visible'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameVisible
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 if (![(UIScrollRefreshControlStateMachine *)machine isPulling]) {
											 // if not pulling, don't change
											 return NO;
										 }
										 CGFloat offset = [(UIScrollRefreshControlStateMachine *)machine controlOffset];
										 // if offset is not zero, change
										 return offset > 0.0f;
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (FSMState *) _visibleState
{
	UIScrollRefreshControlState * state;
	state = [[UIScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateVisible];
	
	// transitions
	FSMBlockTransition * trans;
	
	// 1. 'visible' -> 'default'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameDefault
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 CGFloat offset = [(UIScrollRefreshControlStateMachine *)machine controlOffset];
										 // if offset is zero, change
										 return offset <= 0.0f;
									 }];
	[state addTransition:trans];
	[trans release];
	
	// 2. 'visible' -> 'will_refresh'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameWillRefresh
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 if (![(UIScrollRefreshControlStateMachine *)machine isPulling]) {
											 // if not pulling, don't change
											 return NO;
										 }
										 CGFloat offset = [(UIScrollRefreshControlStateMachine *)machine controlOffset];
										 CGFloat dimension = [(UIScrollRefreshControlStateMachine *)machine controlDimension];
										 // if offset is larger than dimension, change
										 return offset > dimension;
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (FSMState *) _willRefreshState
{
	UIScrollRefreshControlState * state;
	state = [[UIScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateWillRefresh];
	
	// transitions
	FSMBlockTransition * trans;
	
	// 1. 'will_refresh' -> 'refreshing'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameRefreshing
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 if ([(UIScrollRefreshControlStateMachine *)machine isPulling]) {
											 // if pulling, don't change
											 return NO;
										 }
										 // set data not loaded before change
										 [(UIScrollRefreshControlStateMachine *)machine setDataLoaded:NO];
										 return YES;
									 }];
	[state addTransition:trans];
	[trans release];
	
	// 2. 'will_refresh' -> 'visible'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameVisible
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 CGFloat offset = [(UIScrollRefreshControlStateMachine *)machine controlOffset];
										 CGFloat dimension = [(UIScrollRefreshControlStateMachine *)machine controlDimension];
										 // if offset is smaller than dimension, change
										 return offset < dimension;
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (FSMState *) _refreshingState
{
	UIScrollRefreshControlState * state;
	state = [[UIScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateRefreshing];
	
	// transitions
	FSMBlockTransition * trans;
	
	// 1. 'refreshing' -> 'default'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameDefault
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 // if data loaded, change
										 return [(UIScrollRefreshControlStateMachine *)machine isDataLoaded];
									 }];
	[state addTransition:trans];
	[trans release];
	
	// 2. 'refreshing' -> 'terminated'
	trans = [FSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameTerminated
									 block:^BOOL(FSMMachine *machine, FSMTransition *transition) {
										 // if data end, change
										 return [(UIScrollRefreshControlStateMachine *)machine isTerminated];
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (FSMState *) _terminatedState
{
	UIScrollRefreshControlState * state;
	state = [[UIScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateTerminated];
	
	// transitions
	
	// no transtion out
	
	return [state autorelease];
}

@end
