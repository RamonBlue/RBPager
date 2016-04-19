//
//  RBPagerHeaderModel.m
//  ThusMyStyle
//
//  Created by RB on 15/9/30.
//  Copyright (c) 2015年 Justice. All rights reserved.
//

#import "RBPagerHeaderModel.h"

@implementation RBPagerHeaderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.buttonBackgroundColorForNormalState = [UIColor clearColor];
        self.buttonBackgroundColorForSelectedState = [UIColor clearColor];
        
        self.titleColorForNormalState = [UIColor blackColor];
        self.titleColorForSelectedState = [UIColor orangeColor];
        self.titleSizeForNormalState = 15;
        self.titleSizeForSelectedState = 15;

        self.headerButtonWidth = 80;
        
        self.showSeperator = YES;
        self.seperatorColor = [UIColor lightGrayColor];
        self.seperatorInsets = UIEdgeInsetsMake(3, 2, 3, 2.5);
        
        self.showBottomLine = YES;
        self.bottomLineColor = [UIColor orangeColor];
        self.bottomLineHeight = 2;
    }
    return self;
}

@end
