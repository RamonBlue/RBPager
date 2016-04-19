//
//  RBPagerScrollView.h
//  RBPagerDemo
//
//  Created by Ran on 16/4/14.
//  Copyright © 2016年 Justice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RBPagerScrollViewScrollDirectionHorizontal,
    RBPagerScrollViewScrollDirectionVertical
}RBPagerScrollViewScrollDirection;

@class RBPagerScrollView;
@protocol RBPagerScrollViewDelegate <NSObject>

/**
 *  Return the num of pages
 */
- (NSInteger)numberOfPagesInPagerScrollView: (nonnull RBPagerScrollView *)pagerScrollView;

/**
 *  Called when scroll view did scroll/end deceleratin/end scrolling animation,
 */
- (nullable UIView *)pagerScrollView: (nonnull RBPagerScrollView *)pagerScrollView contentViewAtIndex: (NSInteger)index didEndDecelerating: (BOOL)endDecelerating didEndScrollingAnimation: (BOOL)endScrollingAnimation;

@optional

/**
 *  Called when scroll view did scroll
 */
- (void)pagerScrollView: (nonnull RBPagerScrollView *)pagerScrollView didScrollToIndex: (float)index;

@end

@interface RBPagerScrollView : UIScrollView

@property(nonatomic, assign)RBPagerScrollViewScrollDirection scrollDirection;
@property(nonatomic, weak)id<RBPagerScrollViewDelegate>pagerDelegate;
@property(nonatomic, assign)NSInteger currentIndex;

/**
 *  This method must be called after params upon are set,
 *  before methods below are called.
 */
- (void)reloadData;
- (void)scrollToPageAtIndex: (NSInteger)index animated: (BOOL)animated;

@end
