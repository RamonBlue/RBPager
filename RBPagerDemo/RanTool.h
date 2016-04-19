//
//  RanTool.h
//  shakalaka
//
//  Created by Ran on 15/8/18.
//  Copyright (c) 2015年 Justice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableArray(RanAttributeString)

/**
 *  参数都可以传空
 *  默认参数: font: [UIFont systemFontOfSize: 15]; color: [UIColor blackColor]; string: @""
 */
- (void)addAttributeStringWithFont: (UIFont *)font color: (UIColor *)color string: (NSString *)string;

- (void)addAttributeStringWithImage: (UIImage *)image imageFrame: (CGRect)frame;

@end

@interface RanTool : NSObject
/**
 *  快捷生成attributeString的方法
 *  示例:
 *  label.attributedText = [PLTool attributeStringMaker:^(NSMutableArray *maker) {
 *  [maker addAttributeStringWithFont:[UIFont systemFontOfSize:20] color:[UIColor redColor] string:@"red"];
 *  [maker addAttributeStringWithFont:nil color:[UIColor greenColor] string:@"green"];
 *  [maker addAttributeStringWithFont:nil color:nil string:@"black"];
 *   }];
 */

+ (NSAttributedString *)attributeStringMaker: (void(^)(NSMutableArray *maker))block;

@end
