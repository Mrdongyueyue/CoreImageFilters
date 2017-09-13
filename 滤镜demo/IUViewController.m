//
//  IUViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "IUViewController.h"
#import "YYCameraView.h"
#import <Masonry.h>


@interface IUViewController ()

@property (nonatomic, strong) YYCameraView *cameraView;

@end

@implementation IUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"new camera";
    
    _cameraView = [[YYCameraView alloc] init];
    [self.view addSubview:_cameraView];
    [_cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
