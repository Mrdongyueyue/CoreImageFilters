//
//  YYDescriptionView.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/6.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYDescriptionView : UIView

@property (nonatomic, weak) UIViewController *viewController;
@property (copy, nonatomic) NSString *text;

- (void)show;
- (void)dismiss;

@end
