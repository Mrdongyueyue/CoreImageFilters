//
//  CIColorMatrixViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorMatrixViewController.h"

@interface CIColorMatrixViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIColorMatrixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];

    [self setOptions];
    [self refilter];
}

- (void)refilter {
    
    CIVector *r = [CIVector vectorWithX:self.filterAttributeModels[0].value
                                      Y:self.filterAttributeModels[1].value
                                      Z:self.filterAttributeModels[2].value
                                      W:self.filterAttributeModels[3].value];
    CIVector *g = [CIVector vectorWithX:self.filterAttributeModels[4].value
                                      Y:self.filterAttributeModels[5].value
                                      Z:self.filterAttributeModels[6].value
                                      W:self.filterAttributeModels[7].value];
    CIVector *b = [CIVector vectorWithX:self.filterAttributeModels[8].value
                                      Y:self.filterAttributeModels[9].value
                                      Z:self.filterAttributeModels[10].value
                                      W:self.filterAttributeModels[11].value];
    CIVector *a = [CIVector vectorWithX:self.filterAttributeModels[12].value
                                      Y:self.filterAttributeModels[13].value
                                      Z:self.filterAttributeModels[14].value
                                      W:self.filterAttributeModels[15].value];
    CIVector *bias = [CIVector vectorWithX:self.filterAttributeModels[16].value
                                         Y:self.filterAttributeModels[17].value
                                         Z:self.filterAttributeModels[18].value
                                         W:self.filterAttributeModels[19].value];
    
    [self.filter setValue:r forKey:@"inputRVector"];
    [self.filter setValue:g forKey:@"inputGVector"];
    [self.filter setValue:b forKey:@"inputBVector"];
    [self.filter setValue:a forKey:@"inputAVector"];
    [self.filter setValue:bias forKey:@"inputBiasVector"];
    
    [self setOutputImage:_ci_image.extent];
}

/*
 dot(a,b) 矩阵相乘函数
 s.r = dot(s, rVector)
 s.g = dot(s, gVector)
 s.b = dot(s, bVector)
 s.a = dot(s, aVector)
 s = s + bias
 */

- (void)setOptions {
    
    NSArray *array = @[
                       //R
                       @{
                           @"name":@"R_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"R_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"R_2",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"R_3",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       //G
                       @{
                           @"name":@"G_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"G_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"G_2",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"G_3",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       //B
                       @{
                           @"name":@"B_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"B_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"B_2",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"G_3",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       //A
                       @{
                           @"name":@"A_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"A_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"A_2",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"A_3",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       //Bias
                       @{
                           @"name":@"Bias_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Bias_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Bias_2",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Bias_3",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       ];
    
    [self transitionModels:array];
}

@end
