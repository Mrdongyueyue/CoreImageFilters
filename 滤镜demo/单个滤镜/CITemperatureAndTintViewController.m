//
//  CITemperatureAndTintViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CITemperatureAndTintViewController.h"

@interface CITemperatureAndTintViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CITemperatureAndTintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"Neutral",
                           @"max":@"10000",
                           @"min":@"1500",
                           @"v":@"6500",
                           },
                       @{
                           @"name":@"TargetNeutral",
                           @"max":@"10000",
                           @"min":@"1500",
                           @"v":@"6500",
                           },
                       ];
    [self transitionModels:array];
    
    //色温 TargetNeutral的值大于Neutral的值，则向暖色调转换
    
    [self refilter];
}

- (void)refilter {
    CIVector *meutral = [CIVector vectorWithX:self.filterAttributeModels[0].value
                                            Y:0];
    CIVector *targetNeutral = [CIVector vectorWithX:self.filterAttributeModels[1].value
                                                  Y:0];
    
    [self.filter setValue:meutral forKey:@"inputNeutral"];
    [self.filter setValue:targetNeutral forKey:@"inputTargetNeutral"];
    
    [self setOutputImage:_ci_image.extent];
}

@end
