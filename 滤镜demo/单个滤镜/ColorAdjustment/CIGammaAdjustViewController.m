//
//  CIGammaAdjustViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/30.
//  Copyright © 2017年 董知樾. All rights reserved.
//  灰度调整

#import "CIGammaAdjustViewController.h"

@interface CIGammaAdjustViewController ()

@end

@implementation CIGammaAdjustViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputPower",
                           @"max":@"4",
                           @"min":@"0.25",
                           @"v":@"1",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    //灰度
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputPower"];
    
    [self setOutputImage:_image.extent];
}


@end
