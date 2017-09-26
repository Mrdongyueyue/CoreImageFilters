//
//  CIColorPolynomialViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorPolynomialViewController.h"

@interface CIColorPolynomialViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIColorPolynomialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"R_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"R_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
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
                           @"v":@"1",
                           },
                       @{
                           @"name":@"B_2",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"B_3",
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
                           @"v":@"1",
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
                           @"v":@"0",
                           },
                       ];
    
    [self transitionModels:array];
    
    //加强色彩元素，根据对IU1的调色，发现：增强r3，可使面色显得红润；增强b3，可是肤色变的更白。
    
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
    
    [self.filter setValue:r forKey:@"inputRedCoefficients"];
    [self.filter setValue:g forKey:@"inputGreenCoefficients"];
    [self.filter setValue:b forKey:@"inputBlueCoefficients"];
    [self.filter setValue:a forKey:@"inputAlphaCoefficients"];
    
    [self setOutputImage:_ci_image.extent];
}

@end
