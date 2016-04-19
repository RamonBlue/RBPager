//
//  ViewController.m
//  RBPagerDemo
//
//  Created by RB on 16/4/14.
//  Copyright © 2016年 Justice. All rights reserved.
//

#import "ViewController.h"
#import "RBNomalViewController.h"
#import "RBGradientViewController.h"
#import "RBCustomViewController.h"

@implementation ViewController

- (IBAction)normal:(id)sender
{
    [self.navigationController pushViewController:[RBNomalViewController new] animated:YES];
}

- (IBAction)gradient:(id)sender
{
    [self.navigationController pushViewController:[RBGradientViewController new] animated:YES];
}

- (IBAction)custom:(id)sender
{
    [self.navigationController pushViewController:[RBCustomViewController new] animated:YES];
}

@end
