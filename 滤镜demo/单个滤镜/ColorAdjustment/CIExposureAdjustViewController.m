//
//  CIExposureAdjustViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/30.
//  Copyright © 2017年 董知樾. All rights reserved.
//  曝光调整

#import "CIExposureAdjustViewController.h"

@interface CIExposureAdjustViewController ()

@end

@implementation CIExposureAdjustViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputEV",
                           @"max":@"10",
                           @"min":@"-10",
                           @"v":@"0",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    //曝光程度
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputEVKey];
    
    [self setOutputImage:_image.extent];
}


@end
