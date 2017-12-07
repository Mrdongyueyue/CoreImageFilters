//
//  CIHistogramDisplayFilterViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/12/6.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIHistogramDisplayFilterViewController.h"

@interface CIHistogramDisplayFilterViewController ()

@end

@implementation CIHistogramDisplayFilterViewController {
    CIImage *_ci_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:[UIImage imageNamed:@"checkerBoard"].CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputHeight",
                           @"max":@"200",
                           @"min":@"1",
                           @"v":@"100",
                           },
                       @{
                           @"name":@"inputHighLimit",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputLowLimit",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       ];
    [self transitionModels:array];
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputHeight"];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:@"inputHighLimit"];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:@"inputLowLimit"];
    [self setOutputImage:_ci_image.extent];
}

@end
