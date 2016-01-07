//
//  UIScrollRefreshView+State.m
//  SlanissueToolkit
//
//  Created by Moky on 15-1-19.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Date.h"
#import "S9ScrollRefreshControlState.h"
#import "S9ScrollRefreshView.h"

#if !TARGET_OS_WATCH

@implementation UIScrollRefreshView (State)

- (void) machine:(FSMMachine *)machine enterState:(FSMState *)state
{
	[super machine:machine enterState:state];
	
	UIScrollRefreshControlState * srcs = (UIScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[UIScrollRefreshControlState class]], @"error state: %@", state);
	
	switch (srcs.state) {
		case UIScrollRefreshControlStateDefault:
			// DON'T set text lable here, set in 'exitState'
			// because the state machine will enter default state immediately when start,
			// but we don't hope to create subviews in that moment
			break;
			
		case UIScrollRefreshControlStateVisible:
			self.textLabel.text = self.visibleText;
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			self.textLabel.text = self.willRefreshText;
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			self.textLabel.text = self.refreshingText;
			self.loading = YES;
			break;
			
		case UIScrollRefreshControlStateTerminated:
			self.textLabel.text = self.terminatedText;
			break;
			
		default:
			NSAssert(false, @"error");
			break;
	}
	
	[self setNeedsLayout];
}

- (void) machine:(FSMMachine *)machine exitState:(FSMState *)state
{
	UIScrollRefreshControlState * srcs = (UIScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[UIScrollRefreshControlState class]], @"error state: %@", state);
	
	switch (srcs.state) {
		case UIScrollRefreshControlStateDefault:
		{
			NSDate * time = self.updatedTime;
			if (time) {
				NSString * format = self.updatedTimeFormat;
				NSString * str = format ? [time stringWithFormat:format] : [time humanReadableString];
				self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", self.updatedText, str];
			}
		}
			break;
			
		case UIScrollRefreshControlStateVisible:
			self.textLabel.text = nil;
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			self.textLabel.text = nil;
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			self.textLabel.text = nil;
			self.loading = NO;
			break;
			
		case UIScrollRefreshControlStateTerminated:
			self.textLabel.text = nil;
			break;
			
		default:
			NSAssert(false, @"error");
			break;
	}
	
	[super machine:machine exitState:state];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[self _layoutSubviews];
}

- (void) _layoutSubviews
{
	UIView * tray = [self trayView];
	CGRect bounds = tray.bounds;
	
	UIActivityIndicatorView * indicator = [self loadingIndicator];
	UILabel * textLabel = [self textLabel];
	UILabel * timeLabel = [self timeLabel];
	
	[textLabel sizeToFit];
	[timeLabel sizeToFit];
	
	CGRect frame1 = indicator.frame;
	CGRect frame2 = textLabel.frame;
	CGRect frame3 = timeLabel.frame;
	
	switch (self.direction) {
		case UIScrollRefreshControlDirectionTop:
		{
			CGFloat right = MAX(frame2.size.width, frame3.size.width);
			
			indicator.center = CGPointMake((bounds.size.width - right) * 0.5f,
										   bounds.size.height * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame2.size.width) * 0.5f,
										   indicator.center.y + frame2.size.height * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame3.size.width) * 0.5f,
										   indicator.center.y - frame3.size.height * 0.5f);
		}
			break;
			
		case UIScrollRefreshControlDirectionBottom:
		{
			CGFloat right = MAX(frame2.size.width, frame3.size.width);
			
			indicator.center = CGPointMake((bounds.size.width - right) * 0.5f,
										   bounds.size.height * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame2.size.width) * 0.5f,
										   indicator.center.y - frame2.size.height * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame3.size.width) * 0.5f,
										   indicator.center.y + frame3.size.height * 0.5f);
		}
			break;
			
		case UIScrollRefreshControlDirectionLeft:
		{
			CGFloat down = MAX(frame2.size.height, frame3.size.height);
			
			indicator.center = CGPointMake(bounds.size.width * 0.5f,
										   (bounds.size.height - down) * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x + frame2.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame2.size.height) * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x - frame3.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame3.size.height) * 0.5f);
		}
			break;
			
		case UIScrollRefreshControlDirectionRight:
		{
			CGFloat down = MAX(frame2.size.height, frame3.size.height);
			
			indicator.center = CGPointMake(bounds.size.width * 0.5f,
										   (bounds.size.height - down) * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x - frame2.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame2.size.height) * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x + frame3.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame3.size.height) * 0.5f);
		}
			break;
			
		default:
			break;
	}
}

@end

#endif
