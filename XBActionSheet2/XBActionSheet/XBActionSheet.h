//
//  XBActionSheet.h
//  XBActionSheet
//
//  Created by aimee on 16/8/29.
//  Copyright © 2016年 libing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBActionSheet : UIView
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelBtn
       destructiveButtonTitle:(NSString *)destructiveBtn
            otherButtonTitles:(NSArray *)otherButtonTitles
               clickIndexBack:(void (^)(NSUInteger index))clickIndex;

/** 开始展示 **/
- (void)show;
/** 获取取消按钮可以对按钮任意设置操作 **/
- (UIButton *)getCancelBtn;
/** 设置标题(不可以点)字体大小 字体颜色 背景颜色 **/
- (void)setTitleStringFont:(UIFont *)font color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;
/** 设置毁灭性按钮字体大小 字体颜色 背景颜色 **/
- (void)setDestructiveStringFont:(UIFont *)font color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;
/** 设置其余按钮字体大小 字体颜色 背景颜色 **/
- (void)setOtherButtonTitlesStringFont:(UIFont *)font color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;

@end

