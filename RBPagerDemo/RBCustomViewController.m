//
//  RBCustomViewController.m
//  RBPagerDemo
//
//  Created by Ran on 16/4/19.
//  Copyright © 2016年 Justice. All rights reserved.
//

#import "RBCustomViewController.h"
#import "RBTableViewController.h"
#import "RBPager.h"
#import <objc/runtime.h>

static char Key;

@interface RBCustomViewController ()<RBPagerScrollViewDelegate>

@property(nonatomic, strong)RBPagerHeaderView *headerView;
@property(nonatomic, strong)RBPagerScrollView *contentView;

@property(nonatomic, strong)NSMutableDictionary *controllers;


@end

@implementation RBCustomViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

#pragma mark - Private

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.controllers = [NSMutableDictionary dictionary];
    
    NSInteger startIndex = 6;
    CGFloat startY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //header
    RBPagerHeaderView *headView = [[RBPagerHeaderView alloc] initWithFrame:CGRectMake(0, startY, screenWidth - 60, 30)];
    self.headerView = headView;
    [self.view addSubview:headView];
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame) + 3, CGRectGetMinY(headView.frame), 54, 28)];
    [self.view addSubview:setButton];
    setButton.layer.borderColor = [UIColor brownColor].CGColor;
    setButton.layer.borderWidth = 1.5;
    setButton.showsTouchWhenHighlighted = YES;
    [setButton setTitle:@"Adjust" forState:UIControlStateNormal];
    [setButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    setButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    RBPagerHeaderModel *model = [RBPagerHeaderModel new];
    
    model.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    model.showBottomLine = NO;
    
    model.showSeperator = NO;
    
    model.buttonWidthStyle = RBPagerButtonWidthTitleWidthPlusPadding;
    model.headerButtonPadding = 13;
    
    model.titles = @[@"Classical", @"Pop", @"Blues", @"Rock & Roll", @"Jazz", @"Orchestral", @"rap Robi", @"soul", @"punk rock", @"disco", @"electrophonic", @"r&b"];
    model.titleColorForNormalState = [UIColor blackColor];
    model.titleColorForSelectedState = [UIColor orangeColor];
    model.titleSizeForNormalState = 13;
    model.titleSizeForSelectedState = 13;
    model.buttonBackgroundColorForNormalState = [UIColor clearColor];
    model.buttonBackgroundColorForSelectedState = [UIColor clearColor];
    
    headView.model = model;
    [headView reloadData];
    __weak typeof(self) weakSelf = self;
    headView.btnEventBlock = ^(NSInteger index)
    {
        [weakSelf.contentView scrollToPageAtIndex:index animated:NO];
    };
    
    //custom view
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor greenColor];
    customView.layer.cornerRadius = headView.frame.size.height / 2;
    customView.clipsToBounds =YES;
    [headView.scrollView addSubview:customView];
    objc_setAssociatedObject(headView.scrollView, &Key, customView, OBJC_ASSOCIATION_RETAIN);
    
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
    [self.headerView setButtonSelectedAtIndex:index];
    
    UIView *customView = [self customView];
    customView.frame = [self.headerView buttonFrameForIndex:index];
    [self.headerView.scrollView sendSubviewToBack:customView];
}

#pragma mark - Getter

- (UIView *)customView
{
    return objc_getAssociatedObject(self.headerView.scrollView, &Key);
}

@end
