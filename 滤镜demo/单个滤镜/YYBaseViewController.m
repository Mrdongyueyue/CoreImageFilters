//
//  YYBaseViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYBaseViewController.h"

@interface YYBaseViewController ()

@end

@implementation YYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IU1"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *bottom = [imageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    NSLayoutConstraint *leading = [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *trailing = [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
    
    self.title = _filterName;
}




@end
