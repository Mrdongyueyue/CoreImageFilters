//
//  CIBokehBlurViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIBokehBlurViewController.h"

@interface CIBokehBlurViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIBokehBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputRadius",
                           @"max":@"500",
                           @"min":@"0",
                           @"v":@"20",
                           },
                       @{
                           @"name":@"inputRingAmount",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputRingSize",
                           @"max":@"0.2",
                           @"min":@"0",
                           @"v":@"0.1",
                           },
                       @{
                           @"name":@"inputSoftness",
                           @"max":@"10",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    [self transitionModels:array];
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:@"inputRingAmount"];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:@"inputRingSize"];
    [self.filter setValue:@(self.filterAttributeModels[3].value) forKey:@"inputSoftness"];
    
    [self setOutputImage:_ci_image.extent];
}

@end
