//
//  RBNomalViewController.m
//  RBPagerDemo
//
//  Created by Ran on 16/4/19.
//  Copyright © 2016年 Justice. All rights reserved.
//

#import "RBNomalViewController.h"
#import "RanTool.h"
#import "RBTableViewController.h"
#import "RBPager.h"

@interface RBNomalViewController ()<RBPagerScrollViewDelegate>

@property(nonatomic, strong)RBPagerHeaderView *headerView;
@property(nonatomic, strong)RBPagerScrollView *contentView;

@property(nonatomic, strong)NSMutableDictionary *controllers;

@end

@implementation RBNomalViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

#pragma mark - Private

- (void)setup
{
    self.view.backgroundColor = [UIColor brownColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.controllers = [NSMutableDictionary dictionary];
    
    //header
    RBPagerHeaderView *headView = [[RBPagerHeaderView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.headerView = headView;
    self.navigationItem.titleView = headView;
    
    RBPagerHeaderModel *model = [RBPagerHeaderModel new];
    
    model.showBottomLine = YES;
    model.bottomLineWidthStyle = RBPagerBottomLineWidthButtonWidth;
    model.bottomLineColor = [UIColor orangeColor];
    model.bottomLineHeight = 2.0;
    
    model.showSeperator = NO;
    
    model.buttonWidthStyle = RBPagerButtonWidthConstValue;
    model.headerButtonWidth = 50;
    
    model.headerAttributeTitlesForNormalState =
    @[
      [RanTool attributeStringMaker:^(NSMutableArray *maker) {
          [maker addAttributeStringWithFont:[UIFont systemFontOfSize:13] color:[UIColor darkGrayColor] string:@"A"];
          [maker addAttributeStringWithImage:[UIImage imageNamed:@"icon"] imageFrame:CGRectMake(2, -2, 13, 13)];
      }],
      [RanTool attributeStringMaker:^(NSMutableArray *maker) {
          [maker addAttributeStringWithFont:[UIFont systemFontOfSize:13] color:[UIColor darkGrayColor] string:@"B"];
      }],
      [RanTool attributeStringMaker:^(NSMutableArray *maker) {
          [maker addAttributeStringWithFont:[UIFont systemFontOfSize:13] color:[UIColor darkGrayColor] string:@"C"];
          [maker addAttributeStringWithImage:[UIImage imageNamed:@"hud.jpg"] imageFrame:CGRectMake(2, -2, 13, 13)];
      }],
      ];
    model.headerAttributeTitlesForSelectedState =
    @[
      [RanTool attributeStringMaker:^(NSMutableArray *maker) {
          [maker addAttributeStringWithFont:[UIFont systemFontOfSize:16] color:[UIColor orangeColor] string:@"A"];
          [maker addAttributeStringWithImage:[UIImage imageNamed:@"icon"] imageFrame:CGRectMake(2, -2, 16, 16)];
      }],
      [RanTool attributeStringMaker:^(NSMutableArray *maker) {
          [maker addAttributeStringWithFont:[UIFont systemFontOfSize:16] color:[UIColor orangeColor] string:@"B"];
      }],
      [RanTool attributeStringMaker:^(NSMutableArray *maker) {
          [maker addAttributeStringWithFont:[UIFont systemFontOfSize:16] color:[UIColor orangeColor] string:@"C"];
          [maker addAttributeStringWithImage:[UIImage imageNamed:@"hud.jpg"] imageFrame:CGRectMake(2, -2, 16, 16)];
      }],
      ];
    
    headView.model = model;
    [headView reloadData];
    __weak typeof(headView) weakHeadView = headView;
    __weak typeof(self) weakSelf = self;
    headView.btnEventBlock = ^(NSInteger index)
    {
        [weakHeadView scrollBottomLineToIndex:index];
        [weakSelf.contentView scrollToPageAtIndex:index animated:NO];
    };
    [headView scrollBottomLineToIndex:1];
    [headView setButtonSelectedAtIndex:1];
    
    //content
    CGFloat x = 5;
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height + 5;
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat h = [UIScreen mainScreen].bounds.size.height - y - 10;
    RBPagerScrollView *contentView = [[RBPagerScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    contentView.pagerDelegate = self;
    contentView.currentIndex = 1;
    [contentView reloadData];
}

#pragma mark - RBPagerScrollViewDelegate

- (NSInteger)numberOfPagesInPagerScrollView:(RBPagerScrollView *)pagerScrollView
{
    return self.headerView.model.headerAttributeTitlesForNormalState.count;
}

- (UIView *)pagerScrollView:(RBPagerScrollView *)pagerScrollView contentViewAtIndex:(NSInteger)index didEndDecelerating:(BOOL)endDecelerating didEndScrollingAnimation:(BOOL)endScrollingAnimation
{
    RBTableViewController *controller = self.controllers[@(index)];
    if (controller) return controller.view;
    if (endDecelerating | endScrollingAnimation)
    {
        controller = [RBTableViewController new];
        controller.name = [NSString stringWithFormat:@"RamonBlue_%zd", index];
        [self addChildViewController:controller];
        [self.controllers setObject:controller forKey:@(index)];
        return controller.view;
    }
    return nil;
}

- (void)pagerScrollView:(RBPagerScrollView *)pagerScrollView didScrollToIndex:(float)index
{
    if (index == roundf(index)) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.headerView scrollBottomLineToIndex:roundf(index)];
            [self.headerView setButtonSelectedAtIndex:roundf(index)];
        }];
    }
}

@end
