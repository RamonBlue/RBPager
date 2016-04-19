//
//  RBHeaderView.h
//  ThusMyStyle
//
//  Created by RB on 15/9/30.
//  Copyright (c) 2015年 Justice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBPagerHeaderModel.h"

@interface RBPagerHeaderView : UIView

@property(nonatomic, strong)RBPagerHeaderModel *model;
@property(nonatomic, copy)void(^btnEventBlock)(NSInteger index);

/**
 *  This method must be called after params upon are set,
 *  before methods below are called.
 */
- (void)reloadData;

/**
 *  Scroll to make the button at index visible
 */
- (void)scrollToVisibleAtIndex: (float)index;
- (void)scrollBottomLineToIndex: (float)index;
- (void)setButtonSelectedAtIndex: (float)index;
- (CGRect)buttonFrameForIndex: (float)index;
- (CGRect)bottomLineFrameForIndex: (float)index;

/**
 *  Hierarchy: buttons/bottomLineView -> scrollView -> RBPagerHeaderView
 */
@property(nonatomic, weak, readonly)UIScrollView *scrollView;
@property(nonatomic, weak, readonly)UIImageView *bottomLineView;

@end
