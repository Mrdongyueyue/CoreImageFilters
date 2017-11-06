//
//  UIViewController+Extension.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/6.
//  Copyright © 2017年 董知樾. All rights reserved.
//
#import <UIKit/UIKit.h>


/**
 快速处理非UITableViewController的键盘遮挡问题
 */
@interface UIViewController (Extension)

@property (strong, nonatomic) UITapGestureRecognizer * keyboardHideTapGesture;
@property (strong, nonatomic) UIView * objectView;

/**
 在viewDidLoad中调用
 */
- (void)addKeyboardCorverNotification;

/**
 在dealloc中调用
 */
- (void)clearKeyboardCorverNotificationAndGesture;
- (void)tapGestureHandel;

@end


@interface UIView (Extension)

@property (strong, nonatomic) UITapGestureRecognizer * keyboardHideTapGesture;
@property (strong, nonatomic) UIView * objectView;

/**
 在initWithFrame中调用
 */
- (void)addKeyboardCorverNotification;

/**
 在dealloc中调用
 */
- (void)clearKeyboardCorverNotificationAndGesture;
- (void)tapGestureHandel;

@end

@interface UIResponder (FastMethod)

@property (nonatomic, readonly) UIViewController *yy_viewController;

@end
