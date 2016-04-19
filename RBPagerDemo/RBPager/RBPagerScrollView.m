//
//  RBPagerScrollView.m
//  RBPagerDemo
//
//  Created by Ran on 16/4/14.
//  Copyright © 2016年 Justice. All rights reserved.
//

#import "RBPagerScrollView.h"

@interface RBPagerScrollView ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSMutableSet *displayViews;

@end

@implementation RBPagerScrollView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.scrollsToTop = NO;
        self.delegate = self;
        self.currentIndex = 0;
        self.scrollDirection = RBPagerScrollViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - Private

- (float)currentIndexFloor: (BOOL)floor
{
    float index;
    if (self.scrollDirection == RBPagerScrollViewScrollDirectionHorizontal)
    {
        index = self.contentOffset.x / self.frame.size.width;
    }
    else
    {
        index = self.contentOffset.y / self.frame.size.height;
    }
    index = MIN(MAX(0, index), [self.pagerDelegate numberOfPagesInPagerScrollView:self] - 1);
    if (floor)
    {
        return (NSInteger)floorf(index);
    }
    return index;
}

- (void)showContentView: (UIView *)view atIndex: (NSInteger)index
{
    if (!view || [self.displayViews containsObject:view])
    {
        view.userInteractionEnabled = YES;
        return;
    }
    CGRect frame = self.bounds;
    if (self.scrollDirection == RBPagerScrollViewScrollDirectionHorizontal)
    {
        frame.origin.x = frame.size.width * index;
    }
    else
    {
        frame.origin.y = frame.size.height * index;
    }
    view.frame = frame;
    view.userInteractionEnabled = YES;
    [self addSubview:view];
    [self.displayViews addObject:view];
}

- (void)removeContentViewsExceptView: (UIView *)view
{
    [self.displayViews enumerateObjectsUsingBlock:^(UIView *subView, BOOL * _Nonnull stop) {
        if (subView != view)
        {
            [subView removeFromSuperview];
            [self.displayViews removeObject:subView];
        }
    }];
}

#pragma mark - Public

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= [self.pagerDelegate numberOfPagesInPagerScrollView:self])
        return;
    CGPoint contentOffset = self.contentOffset;
    if (self.scrollDirection == RBPagerScrollViewScrollDirectionHorizontal)
    {
        contentOffset.x = self.frame.size.width * index;
    }
    else
    {
        contentOffset.y = self.frame.size.height * index;
    }
    [self setContentOffset:contentOffset animated:animated];
    if (!animated)
    {
        UIView *subView = [self.pagerDelegate pagerScrollView:self contentViewAtIndex:index didEndDecelerating:YES didEndScrollingAnimation:YES];
        [self showContentView:subView atIndex:index];
        [self removeContentViewsExceptView:subView];
    }
}

- (void)reloadData
{
    NSInteger pageCount = [self.pagerDelegate numberOfPagesInPagerScrollView:self];
    CGSize contentSize = self.frame.size;
    if (self.scrollDirection == RBPagerScrollViewScrollDirectionHorizontal)
    {
        contentSize.width *= pageCount;
    }
    else
    {
        contentSize.height *= pageCount;
    }
    self.contentSize = contentSize;
    [self scrollToPageAtIndex:self.currentIndex animated:NO];
    
    [self.displayViews enumerateObjectsUsingBlock:^(UIView *subView, BOOL * _Nonnull stop) {
        [subView removeFromSuperview];
    }];
    [self.displayViews removeAllObjects];
    [self showContentView:[self.pagerDelegate pagerScrollView:self contentViewAtIndex:self.currentIndex didEndDecelerating:YES didEndScrollingAnimation:YES] atIndex:self.currentIndex];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self currentIndexFloor:YES];
    self.currentIndex = index;
    UIView *subView = [self.pagerDelegate pagerScrollView:self contentViewAtIndex:index didEndDecelerating:YES didEndScrollingAnimation:NO];
    [self showContentView: subView atIndex:index];
    [self removeContentViewsExceptView:subView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = [self currentIndexFloor:YES];
    self.currentIndex = index;
    UIView *subView = [self.pagerDelegate pagerScrollView:self contentViewAtIndex:index didEndDecelerating:NO didEndScrollingAnimation:YES];
    [self showContentView: subView atIndex:index];
    [self removeContentViewsExceptView:subView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.pagerDelegate respondsToSelector:@selector(pagerScrollView:didScrollToIndex:)])
    {
        [self.pagerDelegate pagerScrollView:self didScrollToIndex:[self currentIndexFloor:NO]];
    }
    float currentIndex = [self currentIndexFloor:NO];
    NSInteger minIndex = floorf(currentIndex);
    NSInteger maxIndex = ceilf(currentIndex);
    [self showContentView:[self.pagerDelegate pagerScrollView:self contentViewAtIndex:minIndex didEndDecelerating:NO didEndScrollingAnimation:NO] atIndex:minIndex];
    if (maxIndex > minIndex)
    {
        [self showContentView:[self.pagerDelegate pagerScrollView:self contentViewAtIndex:maxIndex didEndDecelerating:NO didEndScrollingAnimation:NO] atIndex:maxIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.displayViews enumerateObjectsUsingBlock:^(UIView *subView, BOOL * _Nonnull stop) {
        subView.userInteractionEnabled = NO;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.displayViews enumerateObjectsUsingBlock:^(UIView *subView, BOOL * _Nonnull stop) {
        subView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Getter

- (NSMutableSet *)displayViews
{
    if (!_displayViews)
        self.displayViews = [NSMutableSet set];
    return _displayViews;;
}

@end
