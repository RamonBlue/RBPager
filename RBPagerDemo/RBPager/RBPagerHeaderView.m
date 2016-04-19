//
//  RBHeaderView.m
//  ThusMyStyle
//
//  Created by RB on 15/9/30.
//  Copyright (c) 2015年 Justice. All rights reserved.
//

#import "RBPagerHeaderView.h"

@interface RBPagerHeaderView()

@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, weak)UIImageView *bottomLineView;

@property(nonatomic, strong)NSMutableArray *btnArrayM;
@property(nonatomic, strong)NSMutableArray *bottomLineFramesArrayM;

@end

@implementation RBPagerHeaderView

#pragma mark - Public

- (void)reloadData
{
    //clear
    [self.btnArrayM removeAllObjects];
    [self.bottomLineFramesArrayM removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.backgroundColor = self.model.backgroundColor;
    self.scrollView.backgroundColor = self.model.backgroundColor;
    self.scrollView.frame = self.bounds;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 0;
    CGFloat btnH = self.model.showBottomLine? self.scrollView.frame.size.height - self.model.bottomLineHeight: self.scrollView.frame.size.height;
    
    CGFloat seperatorY = self.model.seperatorInsets.top;
    CGFloat seperatorW = 5 - self.model.seperatorInsets.left - self.model.seperatorInsets.right;
    CGFloat seperatorH = btnH - self.model.seperatorInsets.bottom - seperatorY;
    if(seperatorH < 0) seperatorH = 0;
    if(seperatorW < 0) seperatorW = 0;
    
    NSInteger count = MAX(self.model.headerAttributeTitlesForNormalState.count, self.model.titles.count);
    for (NSInteger i = 0; i < count; i++)
    {
        CGFloat titleW;
        if (self.model.headerAttributeTitlesForNormalState.count)
        {
            titleW = [self.model.headerAttributeTitlesForNormalState[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size.width;
        }
        else if(self.model.titles.count)
        {
            CGFloat fontSize = MAX(self.model.titleSizeForNormalState, self.model.titleSizeForSelectedState);
            titleW = [self.model.titles[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [self titleFontWithSize:fontSize]} context:NULL].size.width;
        }
        else
        {
            return;
        }

        
        if (self.model.buttonWidthStyle == RBPagerButtonWidthConstValue)
        {
            btnW = self.model.headerButtonWidth;
        }
        else if(self.model.buttonWidthStyle == RBPagerButtonWidthTitleWidthPlusPadding)
        {
            btnW = titleW + 2 * self.model.headerButtonPadding;
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnX += btnW;
        if (self.model.headerAttributeTitlesForNormalState.count)
        {
            [btn setAttributedTitle:self.model.headerAttributeTitlesForNormalState[i] forState:UIControlStateNormal];
            [btn setAttributedTitle:self.model.headerAttributeTitlesForSelectedState[i] forState:UIControlStateSelected];
        }
        else
        {
            [btn setTitle:self.model.titles[i] forState:UIControlStateNormal];
            [btn setTitle:self.model.titles[i] forState:UIControlStateSelected];
        }
        [self.scrollView addSubview:btn];
        [self.scrollView sendSubviewToBack:btn];
        [self.btnArrayM addObject:btn];
        
        if (self.model.showBottomLine)
        {
            CGFloat bottomLineHeight = self.model.bottomLineHeight;
            CGFloat bottomLineY = self.frame.size.height - bottomLineHeight;
            CGFloat bottomLineWidth = self.model.bottomLineWidthStyle == RBPagerBottomLineWidthTitleWidth? titleW: btnW;
            CGFloat bottomLineX = btnW / 2 - bottomLineWidth / 2 + btn.frame.origin.x;
            CGRect bottomLineFrame = CGRectMake(bottomLineX, bottomLineY, bottomLineWidth, bottomLineHeight);
            [self.bottomLineFramesArrayM addObject:[NSValue valueWithCGRect:bottomLineFrame]];
        }
        
        if (i == count - 1)
        {
            self.scrollView.contentSize = CGSizeMake(btnX, self.scrollView.frame.size.height);
        }
        
        if (i != count - 1 && self.model.showSeperator)
        {
            UIImageView *seperator = [[UIImageView alloc] init];
            seperator.backgroundColor = self.model.seperatorColor;
            seperator.frame = CGRectMake(btnX - seperatorW / 2, seperatorY, seperatorW, seperatorH);
            [self.scrollView addSubview:seperator];
        }
    }
    
    if (self.model.showBottomLine)
    {
        self.bottomLineView.backgroundColor = self.model.bottomLineColor;
    }
}

- (void)scrollToVisibleAtIndex:(float)index
{
    if (self.scrollView.contentSize.width <= self.scrollView.frame.size.width) {
        return;
    }
    CGRect frame = [self buttonFrameForIndex:index];
    
    CGFloat centerX = frame.origin.x + frame.size.width / 2;
    CGPoint contentOffset = self.scrollView.contentOffset;
    if(centerX - self.scrollView.frame.size.width / 2 < 0)
    {
        contentOffset.x = 0;
    }
    else if(centerX + self.scrollView.frame.size.width / 2 > self.scrollView.contentSize.width)
    {
        contentOffset.x = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    }
    else
    {
        contentOffset.x = centerX - self.scrollView.frame.size.width / 2;
    }
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

- (void)scrollBottomLineToIndex:(float)index
{
    if (!self.model.showBottomLine) return;
    CGRect frame = [self bottomLineFrameForIndex:index];
    self.bottomLineView.frame = frame;
}

- (void)setButtonSelectedAtIndex: (float)index
{
    NSInteger roundIndex = [self indexAfterChecking:round(index)];
    for (UIButton *button in self.btnArrayM)
    {
        button.backgroundColor = self.model.buttonBackgroundColorForNormalState;
        button.selected = NO;
        [button setTitleColor:self.model.titleColorForNormalState forState:UIControlStateNormal];
        button.titleLabel.font = [self titleFontWithSize:self.model.titleSizeForNormalState];
    }
    UIButton *button = self.btnArrayM[roundIndex];
    button.backgroundColor = self.model.buttonBackgroundColorForSelectedState;
    [button setTitleColor:self.model.titleColorForSelectedState forState:UIControlStateSelected];
    button.titleLabel.font = [self titleFontWithSize:self.model.titleSizeForSelectedState];
    button.selected = YES;

    if (self.model.headerAttributeTitlesForNormalState.count <= 0)
    {
        NSInteger min = [self indexAfterChecking:floorf(index)];
        NSInteger max = [self indexAfterChecking:ceilf(index)];
        if (min >= max) {
            return;
        }
        CGFloat factor = index - min;
        UIColor *minTitleColor = [self colorFrom:self.model.titleColorForNormalState to:self.model.titleColorForSelectedState factor:1 - factor];
        UIColor *maxTitleColor = [self colorFrom:self.model.titleColorForNormalState to:self.model.titleColorForSelectedState factor:factor];
        UIColor *minBgColor = [self colorFrom:self.model.buttonBackgroundColorForNormalState to:self.model.buttonBackgroundColorForSelectedState factor:1 - factor];
        UIColor *maxBgColor = [self colorFrom:self.model.buttonBackgroundColorForNormalState to:self.model.buttonBackgroundColorForSelectedState factor:factor];
        UIFont *minFont = [self titleFontWithSize:self.model.titleSizeForNormalState + (1 - factor) * (self.model.titleSizeForSelectedState - self.model.titleSizeForNormalState)];
        UIFont *maxFont = [self titleFontWithSize:self.model.titleSizeForNormalState + factor * (self.model.titleSizeForSelectedState - self.model.titleSizeForNormalState)];
        UIButton *minButton = self.btnArrayM[min];
        UIButton *maxButton = self.btnArrayM[max];
        
        [minButton setTitleColor:minTitleColor forState:UIControlStateNormal];
        minButton.backgroundColor = minBgColor;
        minButton.titleLabel.font = minFont;
        
        [maxButton setTitleColor:maxTitleColor forState:UIControlStateNormal];
        maxButton.backgroundColor = maxBgColor;
        maxButton.titleLabel.font = maxFont;
    }
}

- (CGRect)buttonFrameForIndex:(float)index
{
    NSInteger min = [self indexAfterChecking:floorf(index)];
    NSInteger max = [self indexAfterChecking:ceilf(index)];
    CGRect frame = [self.btnArrayM[min] frame];
    if (max != min)
    {
        CGRect maxFrame = [self.btnArrayM[max] frame];
        float factor = index - min;
        frame.size.width = frame.size.width + (maxFrame.size.width - frame.size.width) * factor;
        frame.size.height = frame.size.height + (maxFrame.size.height - frame.size.height) * factor;
        frame.origin.x = frame.origin.x + (maxFrame.origin.x - frame.origin.x) * factor;
        frame.origin.y = frame.origin.y + (maxFrame.origin.y - frame.origin.y) * factor;
    }
    return frame;
}

- (CGRect)bottomLineFrameForIndex:(float)index
{
    NSInteger min = [self indexAfterChecking:floorf(index)];
    NSInteger max = [self indexAfterChecking:ceilf(index)];
    CGRect frame = [self.bottomLineFramesArrayM[min] CGRectValue];
    if (max != min)
    {
        CGRect maxFrame = [self.bottomLineFramesArrayM[max] CGRectValue];
        float factor = index - min;
        frame.size.width = frame.size.width + (maxFrame.size.width - frame.size.width) * factor;
        frame.size.height = frame.size.height + (maxFrame.size.height - frame.size.height) * factor;
        frame.origin.x = frame.origin.x + (maxFrame.origin.x - frame.origin.x) * factor;
        frame.origin.y = frame.origin.y + (maxFrame.origin.y - frame.origin.y) * factor;
    }
    return frame;
}

#pragma mark - Private

- (UIColor *)colorFrom: (UIColor *)fromColor to: (UIColor *)toColor factor: (CGFloat)factor
{
    CGFloat redFrom;
    CGFloat greenFrom;
    CGFloat blueFrom;
    CGFloat alphaFrom;
    [fromColor getRed:&redFrom green:&greenFrom blue:&blueFrom alpha:&alphaFrom];
    CGFloat redTo;
    CGFloat greenTo;
    CGFloat blueTo;
    CGFloat alphaTo;
    [toColor getRed:&redTo green:&greenTo blue:&blueTo alpha:&alphaTo];
    return [UIColor colorWithRed:redFrom + (redTo - redFrom) * factor green:greenFrom + (greenTo - greenFrom) * factor blue:blueFrom + (blueTo - blueFrom) * factor alpha:alphaFrom + (alphaTo - alphaFrom) * factor];
}

- (NSInteger)indexAfterChecking: (NSInteger)index
{
    return MIN(MAX(0, index), MAX(self.model.headerAttributeTitlesForNormalState.count - 1, self.model.titles.count - 1));
}

- (UIFont *)titleFontWithSize: (CGFloat)fontSize
{
    return self.model.titleFontName? [UIFont fontWithName:self.model.titleFontName size:fontSize]: [UIFont systemFontOfSize:fontSize];
}

#pragma mark - Event

- (void)btnClicked: (UIButton *)btn
{
    if (!btn.selected) {
        if (self.btnEventBlock) {
            self.btnEventBlock(btn.tag);
        }
        [self setButtonSelectedAtIndex:btn.tag];
    }
}

#pragma mark - Getter & Setter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }
    return _scrollView;
}

- (UIImageView *)bottomLineView
{
    if (!_bottomLineView) {
        UIImageView *bottomLineView = [[UIImageView alloc] init];
        bottomLineView.backgroundColor = [UIColor orangeColor];
        [self.scrollView addSubview:bottomLineView];
        self.bottomLineView = bottomLineView;
    }
    return _bottomLineView;
}

- (NSMutableArray *)btnArrayM
{
    if (!_btnArrayM) {
        self.btnArrayM = [NSMutableArray array];
    }
    return _btnArrayM;
}

- (NSMutableArray *)bottomLineFramesArrayM
{
    if (!_bottomLineFramesArrayM) {
        self.bottomLineFramesArrayM = [NSMutableArray array];
    }
    return _bottomLineFramesArrayM;
}

@end
