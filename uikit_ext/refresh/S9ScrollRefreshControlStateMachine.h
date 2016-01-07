//
//  UIScrollRefreshControlStateMachine.h
//  SlanissueToolkit
//
//  Created by Moky on 15-5-4.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "FSMMachine.h"

#if !TARGET_OS_WATCH

@interface UIScrollRefreshControlStateMachine : FSMMachine

// the size of refresh control, minimum size to show all subviews
@property(nonatomic, readwrite) float controlDimension;
// the current offset
@property(nonatomic, readwrite) float controlOffset;

// while pulling begin, set it TRUE; after pulling end, set it FALSE
@property(nonatomic, readwrite, getter=isPulling) BOOL pulling;
// while data loaded, set it TRUE; after read, set it FALSE automactilly
@property(nonatomic, readwrite, getter=isDataLoaded) BOOL dataLoaded;
// while no more data, set it TRUE
@property(nonatomic, readwrite, getter=isTerminated) BOOL terminated;

@end

#endif
