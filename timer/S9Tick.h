//
//  S9Tick.h
//  SlanissueToolkit
//
//  Created by Moky on 15-7-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol S9TickCallback <NSObject>

- (void) tick:(float)dt;

@end

typedef void (*S9TickImp)(id, SEL, float);

@interface S9TickCallback : NSObject<S9TickCallback> {
	
	id _target;
	SEL _selector;
	S9TickImp _impMethod;
	
	BOOL _paused;
}

@property(nonatomic, assign) id target;
@property(nonatomic, readwrite) SEL selector;

@property(nonatomic, readwrite, getter=isPaused) BOOL paused;

/* designated initializer */
- (instancetype) initWithTarget:(id)target selector:(SEL)selector;

@end

#pragma mark -

@interface S9Timer : S9TickCallback {
	
	float _elapsed;  // second(s)
	float _interval; // second(s)
}

@property(nonatomic, readwrite) float interval;

@end
