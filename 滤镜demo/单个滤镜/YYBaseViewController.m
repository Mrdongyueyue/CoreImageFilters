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
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IU1"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [_imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *bottom = [_imageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    NSLayoutConstraint *leading = [_imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *trailing = [_imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
    
    self.title = _filterName;
}




@end
