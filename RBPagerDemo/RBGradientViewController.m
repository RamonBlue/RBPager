//
//  RBGradientViewController.m
//  RBPagerDemo
//
//  Created by Ran on 16/4/19.
//  Copyright © 2016年 Justice. All rights reserved.
//

#import "RBGradientViewController.h"
#import "RBTableViewController.h"
#import "RBPager.h"

@interface RBGradientViewController ()<RBPagerScrollViewDelegate>

@property(nonatomic, strong)RBPagerHeaderView *headerView;
@property(nonatomic, strong)RBPagerScrollView *contentView;

@property(nonatomic, strong)NSMutableDictionary *controllers;

@end

@implementation RBGradientViewController

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
    
    NSInteger startIndex = 6;
    CGFloat startY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //header
    RBPagerHeaderView *headView = [[RBPagerHeaderView alloc] initWithFrame:CGRectMake(0, startY, screenWidth, 30)];
    self.headerView = headView;
    [self.view addSubview:headView];
    
    RBPagerHeaderModel *model = [RBPagerHeaderModel new];
    
    model.showBottomLine = YES;
    model.bottomLineWidthStyle = RBPagerBottomLineWidthTitleWidth;
    model.bottomLineColor = [UIColor redColor];
    model.bottomLineHeight = 2.0;
    
    model.showSeperator = YES;
    model.seperatorColor = [UIColor whiteColor];
    model.seperatorInsets = UIEdgeInsetsMake(3, 2.5, 3, 2);
    
    model.buttonWidthStyle = RBPagerButtonWidthTitleWidthPlusPadding;
    model.headerButtonPadding = 13;
    
    model.titles = @[@"Luffy", @"Zoro", @"Nami", @"Usop", @"Sanj", @"Choppe", @"Nico Robi", @"Franky", @"Brook"];
    model.titleColorForNormalState = [UIColor yellowColor];
    model.titleColorForSelectedState = [UIColor orangeColor];
    model.titleSizeForNormalState = 12;
    model.titleSizeForSelectedState = 17;
    model.titleFontName = @"MarkerFelt-Thin";
    model.buttonBackgroundColorForNormalState = [UIColor lightGrayColor];
    model.buttonBackgroundColorForSelectedState = [UIColor blueColor];
    
    headView.model = model;
    [headView reloadData];
    __weak typeof(headView) weakHeadView = headView;
    __weak typeof(self) weakSelf = self;
    headView.btnEventBlock = ^(NSInteger index)
    {
        [weakHeadView scrollBottomLineToIndex:index];
        [weakSelf.contentView scrollToPageAtIndex:index animated:NO];
    };
    [headView scrollBottomLineToIndex:startIndex];
    [headView setButtonSelectedAtIndex:startIndex];
    [headView scrollToVisibleAtIndex:startIndex];
    
    //content
    RBPagerScrollView *contentView = [[RBPagerScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), screenWidth, screenHeight - CGRectGetMaxY(headView.frame))];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    contentView.pagerDelegate = self;
    contentView.currentIndex = startIndex;
    [contentView reloadData];
}

#pragma mark - RBPagerScrollViewDelegate

- (NSInteger)numberOfPagesInPagerScrollView:(RBPagerScrollView *)pagerScrollView
{
    return self.headerView.model.titles.count;
}

- (UIView *)pagerScrollView:(RBPagerScrollView *)pagerScrollView contentViewAtIndex:(NSInteger)index didEndDecelerating:(BOOL)endDecelerating didEndScrollingAnimation:(BOOL)endScrollingAnimation
{
    RBTableViewController *controller = self.controllers[@(index)];
    if (controller) return controller.view;
    if (endDecelerating | endScrollingAnimation)
    {
        controller = [RBTableViewController new];
        controller.name = self.headerView.model.titles[index];
        [self addChildViewController:controller];
        [self.controllers setObject:controller forKey:@(index)];
        return controller.view;
    }
    return nil;
}

- (void)pagerScrollView:(RBPagerScrollView *)pagerScrollView didScrollToIndex:(float)index
{
    [self.headerView scrollToVisibleAtIndex:index];
    [self.headerView scrollBottomLineToIndex:index];
    [self.headerView setButtonSelectedAtIndex:index];
}

@end
