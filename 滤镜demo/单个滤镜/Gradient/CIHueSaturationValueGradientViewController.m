//
//  CIHueSaturationValueGradientViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/12/6.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIHueSaturationValueGradientViewController.h"

@interface CIHueSaturationValueGradientViewController ()

@end

@implementation CIHueSaturationValueGradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputDither",
                           @"max":@"3",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputRadius",
                           @"max":@"800",
                           @"min":@"0",
                           @"v":@"300",
                           },
                       @{
                           @"name":@"inputSoftness",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputValue",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    [self transitionModels:array];
//    ColorSpace must be an RGB CGColorSpaceRef.
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputDither"];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:@"inputRadius"];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:@"inputSoftness"];
    [self.filter setValue:@(self.filterAttributeModels[3].value) forKey:@"inputValue"];
    
    [self setOutputImage:CGRectMake(0, 0, self.filterAttributeModels[1].value * 2, self.filterAttributeModels[1].value * 2)];
}

@end
