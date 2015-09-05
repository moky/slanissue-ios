//
//  UIPageScrollView.m
//  SlanissueToolkit
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "s9Macros.h"
#import "S9PageScrollViewDataSource.h"
#import "S9PageScrollView.h"

//typedef NS_ENUM(NSInteger, SCPageScrollViewScrollDirection) {
//	UIPageScrollViewDirectionVertical,
//	UIPageScrollViewDirectionHorizontal,
//};
UIPageScrollViewDirection UIPageScrollViewDirectionFromString(NSString * string)
{
	S9_SWITCH_BEGIN(string)
		S9_SWITCH_CASE(string, @"Vertical")
			return UIPageScrollViewDirectionVertical;
		S9_SWITCH_DEFAULT
	S9_SWITCH_END
	
	return UIPageScrollViewDirectionHorizontal;
}

@interface UIPageScrollView ()

@property(nonatomic, retain) UIScrollView * scrollView;

@end

@implementation UIPageScrollView

@synthesize dataSource = _dataSource;

@synthesize direction = _direction;
@synthesize pageCount = _pageCount;
@synthesize currentPage = _currentPage;

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize animated = _animated;

@synthesize preloadedPageCount = _preloadedPageCount;

- (void) dealloc
{
	if (_scrollView.delegate == self) {
		// must remove the delegate here, otherwise it will cause crash
		// when the scroll view is running animation.
		_scrollView.delegate = nil;
	}
	[_scrollView release];
	
	[_pageControl release];
	
	[super dealloc];
}

- (void) _initializeUIPageScrollView
{
	self.clipsToBounds = YES; // use the container view to clips, instead of the inner scroll view
	
	self.dataSource = nil;
	
	_direction = UIPageScrollViewDirectionHorizontal;
	_pageCount = 0;
	_currentPage = 0;
	
	// page control
	self.pageControl = nil;
	
	_animated = NO;
	
	_preloadedPageCount = 1;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIPageScrollView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIPageScrollView];
	}
	return self;
}

// lazy-load
- (UIScrollView *) scrollView
{
	if (!_scrollView) {
		// create an empty scroll view
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		// default properties
		_scrollView.pagingEnabled = YES;
		_scrollView.directionalLockEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.clipsToBounds = NO; // scroll view's default value is YES, here it's always NO
		_scrollView.delegate = self; // rob the controlling from the scroll view
		[super addSubview:_scrollView];
	}
	return _scrollView;
}

// while the frame/bounds or page count change
// we should call this function to recalculate the content size
- (void) _adjustContentSize
{
	UIScrollView * scrollView = self.scrollView;
	// set content size of scroll view
	CGSize size = self.bounds.size;
	
	if (_direction == UIPageScrollViewDirectionHorizontal)
	{
		scrollView.contentSize = CGSizeMake(size.width * _pageCount, size.height);
		scrollView.contentOffset = CGPointMake(size.width * _currentPage, 0);
	}
	else // UIPageScrollViewDirectionVertical
	{
		scrollView.contentSize = CGSizeMake(size.width, size.height * _pageCount);
		scrollView.contentOffset = CGPointMake(0, size.height * _currentPage);
	}
}

// change the page count, and resize the content size
- (void) setPageCount:(NSUInteger)pageCount
{
	_pageCount = pageCount;
	_pageControl.numberOfPages = pageCount;
	
	[self _adjustContentSize];
}

// change the current page, and pre-load next page
- (void) setCurrentPage:(NSUInteger)page
{
	[self _showSubviewToIndex:page + _preloadedPageCount]; // pre-load next views
	
	UIScrollView * scrollView = self.scrollView;
	CGSize size = scrollView.bounds.size;
	
	//NSAssert(page < _pageCount, @"error page: %d, count: %d", page, _pageCount);
	CGPoint offset = (_direction == UIPageScrollViewDirectionHorizontal) ?
	CGPointMake(page * size.width, 0) :
	CGPointMake(0, page * size.height);
	
	if (_animated) {
		[scrollView setContentOffset:offset animated:YES];
	} else {
		scrollView.contentOffset = offset;
	}
	
	if (_currentPage == page) {
		// not change
		return;
	}
	
	// update
	_currentPage = page;
	_pageControl.currentPage = page;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.scrollView.frame = self.bounds;
	
	[self _adjustContentSize];
	[self setCurrentPage:_currentPage]; // for adjusting the scroll view's content offset
}

- (CGSize) contentSize
{
	return self.scrollView.contentSize;
}

- (void) setContentSize:(CGSize)contentSize
{
	self.scrollView.contentSize = contentSize;
}

- (void) addSubview:(UIView *)view
{
	NSAssert([_scrollView isKindOfClass:[UIScrollView class]], @"inner scroll view error: %@", _scrollView);
	[self.scrollView addSubview:view];
}

// lazy load subviews
- (void) _showSubviewToIndex:(NSUInteger)index
{
	NSUInteger last = [self.scrollView.subviews count];
	if (last >= _pageCount) {
		// all subviews have been shown
		return;
	}
	
	for (; last <= index; ++last) {
		S9Log(@"last: %u, index: %u, count: %u", (unsigned int)last, (unsigned int)index, (unsigned int)_pageCount);
		[self showSubviewAtIndex:last];
	}
}

- (UIView *) showSubviewAtIndex:(NSUInteger)index
{
	UIView * view = [_dataSource pageScrollView:self viewAtIndex:index];
	CGSize size = self.bounds.size;
	
	if (_direction == UIPageScrollViewDirectionHorizontal)
	{
		view.center = CGPointMake(size.width * (index + 0.5), size.height * 0.5);
	}
	else // UIPageScrollViewDirectionVertical
	{
		view.center = CGPointMake(size.width * 0.5, size.height * (index + 0.5));
	}
	
	[self addSubview:view];
	return view;
}

- (void) reloadData
{
	NSAssert(_dataSource, @"there must be a data source");
	// clear
	NSArray * subviews = self.scrollView.subviews;
	NSInteger index = [subviews count];
	while (--index >= 0) {
		[[subviews objectAtIndex:index] removeFromSuperview];
	}
	
	// refresh data source
	[_dataSource reloadData:self];
	
	// page count
	[self setPageCount:[_dataSource presentationCountForPageScrollView:self]];
	
	// show first subview
	[self setCurrentPage:0];
}

- (void) scrollToNextPage
{
	NSUInteger page = _currentPage + 1;
	if (page >= _pageCount) {
		BOOL animated = _animated;
		_animated = NO;
		self.currentPage = 0;
		_animated = animated;
	} else {
		self.currentPage = page;
	}
}

#pragma mark - UIScrollViewDelegate

// any offset changes, perform cover flow effect
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_direction == UIPageScrollViewDirectionHorizontal)
	{
		scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
	}
	else // UIPageScrollViewDirectionVertical
	{
		scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
	}
}

// called when scroll view grinds to a halt
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGSize size = scrollView.frame.size;
	CGPoint offset = scrollView.contentOffset;
	
	NSUInteger page = (_direction == UIPageScrollViewDirectionHorizontal) ?
	(size.width > 0 ? round(offset.x / size.width) : 0) :
	(size.height > 0 ? round(offset.y / size.height) : 0);
	
	[self setCurrentPage:page];
}

@end
