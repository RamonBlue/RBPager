//
//  RBPagerHeaderModel.h
//  ThusMyStyle
//
//  Created by RB on 15/9/30.
//  Copyright (c) 2015年 gintong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RBPagerBottomLineWidthStyle){
    RBPagerBottomLineWidthTitleWidth,
    RBPagerBottomLineWidthButtonWidth
};

typedef NS_ENUM(NSInteger, RBPagerButtonWidthStyle){
    RBPagerButtonWidthTitleWidthPlusPadding,
    RBPagerButtonWidthConstValue
};

@interface RBPagerHeaderModel : NSObject

/**
 *  white color by default
 */
@property(nonatomic, strong)UIColor *backgroundColor;
/**
 *  Clear color by default
 */
@property(nonatomic, strong)UIColor *buttonBackgroundColorForNormalState;
/**
 *  Clear color by default
 */
@property(nonatomic, strong)UIColor *buttonBackgroundColorForSelectedState;


//titles don't support gradient, if set, the title params below will be ignored
@property(nonatomic, strong)NSArray<NSAttributedString *> *headerAttributeTitlesForNormalState;
@property(nonatomic, strong)NSArray<NSAttributedString *> *headerAttributeTitlesForSelectedState;
//titles support gradient
@property(nonatomic, strong)NSArray<NSString *> *titles;
@property(nonatomic, strong)UIColor *titleColorForNormalState;  /**<black color by default*/
@property(nonatomic, strong)UIColor *titleColorForSelectedState;/**<orange color by default*/
@property(nonatomic, assign)CGFloat titleSizeForNormalState;    /**<15 by default*/
@property(nonatomic, assign)CGFloat titleSizeForSelectedState;  /**<15 by default*/
@property(nonatomic, copy)NSString *titleFontName;              /**<SystemFont by default*/


/**
 *  RBPagerButtonWidthTitleWidthPlusPadding by default
 */
@property(nonatomic, assign)RBPagerButtonWidthStyle buttonWidthStyle;
/**
 *  used when buttonWidthStyle == RBPagerButtonWidthConstValue
 */
@property(nonatomic, assign)CGFloat headerButtonWidth;
/**
 *  used when buttonWidthStyle == RBPagerButtonWidthTitleWidthPlusPadding
 */
@property(nonatomic, assign)CGFloat headerButtonPadding;


/**
 *  YES by default, show seperators between buttons
 */
@property(nonatomic, assign)BOOL showSeperator;
/**
 *  Lightgray color by default
 */
@property(nonatomic, strong)UIColor *seperatorColor;
/**
 * seperator frame:
 * origin.y = seperatorInsets.top
 * height = buttonHeight - y - seperatorInsets.bottom
 * width = 5 - seperatorInsets.left - seperatorInsets.right
 * UIEdgeInsetsMake(3, 2, 3, 2.5) by default
 */
@property(nonatomic, assign)UIEdgeInsets seperatorInsets;


/**
 *  Show a line under buttons, YES by default
 */
@property(nonatomic, assign)BOOL showBottomLine;
/**
 *  Orangege color by default
 */
@property(nonatomic, strong)UIColor *bottomLineColor;
/**
 *  2 by default
 */
@property(nonatomic, assign)CGFloat bottomLineHeight;
/**
 *  RBPagerBottomLineWidthTitleWidth by default
 */
@property(nonatomic, assign)RBPagerBottomLineWidthStyle bottomLineWidthStyle;

@end
