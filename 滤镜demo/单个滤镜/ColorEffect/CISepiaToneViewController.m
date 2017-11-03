//
//  CISepiaToneViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CISepiaToneViewController.h"

@interface CISepiaToneViewController ()

@end

@implementation CISepiaToneViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputIntensity",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:@(self.filterAttributeModels.firstObject.value) forKey:kCIInputIntensityKey];
    [self setOutputImage:_image.extent];
}

@end
