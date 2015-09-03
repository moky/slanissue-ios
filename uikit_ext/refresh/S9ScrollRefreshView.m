//
//  UIScrollRefreshView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-1-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Array.h"
#import "S9ScrollRefreshView.h"

@implementation UIScrollRefreshView

@synthesize visibleText = _visibleText;
@synthesize willRefreshText = _willRefreshText;
@synthesize refreshingText = _refreshingText;
@synthesize updatedText = _updatedText;
@synthesize updatedTimeFormat = _updatedTimeFormat;
@synthesize terminatedText = _terminatedText;

@synthesize updatedTime = _updatedTime;
@synthesize loading = _loading;

@synthesize loadingIndicator = _loadingIndicator;
@synthesize textLabel = _textLabel;
@synthesize timeLabel = _timeLabel;

@synthesize trayView = _trayView;

- (void) dealloc
{
	self.visibleText = nil;
	self.willRefreshText = nil;
	self.refreshingText = nil;
	self.updatedText = nil;
	self.updatedTimeFormat = nil;
	self.terminatedText = nil;
	
	self.updatedTime = nil;
	
	self.trayView = nil;
	self.loadingIndicator = nil;
	self.textLabel = nil;
	self.timeLabel = nil;
	
	[super dealloc];
}

- (void) _initializeUIScrollRefreshView
{
	self.backgroundColor = [UIColor whiteColor];
	
	self.visibleText       = NSLocalizedString(@"Pull to refresh", nil);
	self.willRefreshText   = NSLocalizedString(@"Release to refresh", nil);
	self.refreshingText    = NSLocalizedString(@"Refreshing...", nil);
	self.updatedText       = NSLocalizedString(@"Last updated", nil);
	self.updatedTimeFormat = nil; // use default format
	self.terminatedText    = NSLocalizedString(@"No more data", nil);
	
	self.updatedTime = nil;
	_loading = NO;
	
	self.loadingIndicator = nil;
	self.textLabel = nil;
	self.timeLabel = nil;
	
	self.trayView = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIScrollRefreshView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIScrollRefreshView];
	}
	return self;
}

#pragma mark -

- (void) reloadData:(UIScrollView *)scrollView
{
	[super reloadData:scrollView];
	self.updatedTime = [NSDate date];
}

- (void) setLoading:(BOOL)loading
{
	if (loading) {
		[self.loadingIndicator startAnimating];
	} else {
		[self.loadingIndicator stopAnimating];
	}
	_loading = loading;
}

- (UIView *) trayView
{
	if (!_trayView) {
		// use the last subview as tray view
		_trayView = [[self.subviews lastObject] retain];
		
		// dimension
		if (_trayView) {
			CGFloat dimension = 0.0f;
			if (self.direction == UIScrollRefreshControlDirectionTop || self.direction == UIScrollRefreshControlDirectionBottom) {
				dimension = _trayView.bounds.size.height;
			} else {
				dimension = _trayView.bounds.size.width;
			}
			NSAssert(dimension > 0.0f, @"error");
			if (dimension > 0.0f) {
				self.dimension = dimension;
			}
		}
	}
	
	if (!_trayView) {
		CGRect frame = self.bounds;
		CGFloat dimension = self.dimension;
		UIViewAutoresizing autoresizingMask = UIViewAutoresizingNone;
		
		switch (self.direction) {
			case UIScrollRefreshControlDirectionTop:
				frame.origin.y = frame.origin.y + frame.size.height - dimension;
				frame.size.height = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				frame.size.height = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleWidth;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				frame.origin.x = frame.origin.x + frame.size.width - dimension;
				frame.size.width = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				frame.origin.y = frame.size.height - dimension;
				frame.size.width = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleHeight;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		_trayView = [[UIView alloc] initWithFrame:frame];
		_trayView.autoresizingMask = autoresizingMask;
		
		[self addSubview:_trayView];
	}
	
	return _trayView;
}

- (UIActivityIndicatorView *) loadingIndicator
{
	if (!_loadingIndicator) {
		// get indicator from subviews of trayView by class
		UIActivityIndicatorView * aiv;
		S9_FOR_EACH(self.trayView.subviews, aiv) {
			if ([aiv isKindOfClass:[UIActivityIndicatorView class]]) {
				_loadingIndicator = [aiv retain];
				break;
			}
		}
	}
	
	if (!_loadingIndicator) {
		UIView * trayView = [self trayView];
		CGRect frame = trayView.bounds;
		
		_loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[trayView addSubview:_loadingIndicator];
		
		if (self.direction == UIScrollRefreshControlDirectionTop || self.direction == UIScrollRefreshControlDirectionBottom) {
			// scroll vertical
			_loadingIndicator.center = CGPointMake(frame.size.height * 0.5f, frame.size.height * 0.5f);
		} else {
			// scroll horizontal
			_loadingIndicator.center = CGPointMake(frame.size.width * 0.5f, frame.size.width * 0.5f);
		}
	}
	return _loadingIndicator;
}

- (UILabel *) textLabel
{
	if (!_textLabel) {
		// get first label from subviews of trayView
		UILabel * label;
		S9_FOR_EACH(self.trayView.subviews, label) {
			if ([label isKindOfClass:[UILabel class]]) {
				_textLabel = [label retain];
				break;
			}
		}
	}
	
	if (!_textLabel) {
		UIView * tray = [self trayView];
		CGRect frame = tray.bounds;
		
		switch (self.direction) {
			case UIScrollRefreshControlDirectionTop:
				frame.size.height *= 0.5f;
				frame.origin.y = frame.size.height;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				frame.size.height *= 0.5f;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				frame.size.width *= 0.5f;
				frame.origin.x = frame.size.width;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				frame.size.width *= 0.5f;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		_textLabel = [[UILabel alloc] initWithFrame:frame];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor grayColor];
		
		[tray addSubview:_textLabel];
	}
	return _textLabel;
}

- (UILabel *) timeLabel
{
	if (!_timeLabel) {
		// get second label from subviews of trayView
		UILabel * textLabel = nil;
		UILabel * label;
		S9_FOR_EACH(self.trayView.subviews, label) {
			if ([label isKindOfClass:[UILabel class]]) {
				if (textLabel) {
					_timeLabel = [label retain];
					break;
				}
				textLabel = label;
			}
		}
	}
	
	if (!_timeLabel) {
		UIView * tray = [self trayView];
		CGRect frame = tray.bounds;
		
		switch (self.direction) {
			case UIScrollRefreshControlDirectionTop:
				frame.size.height *= 0.5f;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				frame.size.height *= 0.5f;
				frame.origin.y = frame.size.height;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				frame.size.width *= 0.5f;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				frame.size.width *= 0.5f;
				frame.origin.x = frame.size.width;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		_timeLabel = [[UILabel alloc] initWithFrame:frame];
		_timeLabel.backgroundColor = [UIColor clearColor];
		_timeLabel.textColor = [UIColor grayColor];
		
		[tray addSubview:_timeLabel];
	}
	return _timeLabel;
}

@end
