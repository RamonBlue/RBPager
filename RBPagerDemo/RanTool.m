//
//  RanTool.m
//  shakalaka
//
//  Created by Ran on 15/8/18.
//  Copyright (c) 2015年 gintong. All rights reserved.
//

#import "RanTool.h"
static NSString *const ATT_FONT = @"attributeFont";
static NSString *const ATT_COLOR = @"attributeColor";
static NSString *const ATT_STRING = @"attributeString";

@implementation NSMutableArray(RanAttributeString)

- (void)addAttributeStringWithFont:(UIFont *)font color:(UIColor *)color string:(NSString *)string
{
    [self addObject:@{ATT_FONT: (font? font: [UIFont systemFontOfSize:15]), ATT_COLOR: (color? color: [UIColor blackColor]), ATT_STRING: (string? string: @"")}];
}

- (void)addAttributeStringWithImage:(UIImage *)image imageFrame:(CGRect)frame{
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = frame;
    [self addObject:attachment];
}

@end

@implementation RanTool

+ (NSAttributedString *)attributeStringMaker:(void (^)(NSMutableArray *))block
{
    NSMutableArray *arrayM = [NSMutableArray array];
    block(arrayM);
    return [self getAttributstringFromArray:arrayM];
}

+ (NSAttributedString *)getAttributstringFromArray:(NSArray *)attributeArray
{
    NSMutableAttributedString *attributeStringM = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dic in attributeArray) {
        if ([dic isKindOfClass:[NSTextAttachment class]]) {
            NSAttributedString *attributeString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)dic];
            [attributeStringM appendAttributedString:attributeString];
        }else{
            NSDictionary *attributeDic = @{NSForegroundColorAttributeName: dic[ATT_COLOR], NSFontAttributeName: dic[ATT_FONT]};
            NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:dic[ATT_STRING] attributes:attributeDic];
            [attributeStringM appendAttributedString:attributeString];
        }
    }
    return attributeStringM;
}

@end
