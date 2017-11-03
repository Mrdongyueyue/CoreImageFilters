//
//  CIFalseColorViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIFalseColorViewController.h"

@interface CIFalseColorViewController ()

@end

@implementation CIFalseColorViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       //0
                       @{
                           @"name":@"inputColor0_R",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.3",
                           },
                       @{
                           @"name":@"inputColor0_G",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputColor0_B",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputColor0_A",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       //1
                       @{
                           @"name":@"inputColor1_R",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputColor1_G",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.9",
                           },
                       @{
                           @"name":@"inputColor1_B",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.8",
                           },
                       @{
                           @"name":@"inputColor1_A",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    CIColor *color0 = [CIColor colorWithRed:self.filterAttributeModels[0].value
                                      green:self.filterAttributeModels[1].value
                                       blue:self.filterAttributeModels[2].value
                                      alpha:self.filterAttributeModels[3].value];
    CIColor *color1 = [CIColor colorWithRed:self.filterAttributeModels[4].value
                                      green:self.filterAttributeModels[5].value
                                       blue:self.filterAttributeModels[6].value
                                      alpha:self.filterAttributeModels[7].value];
    
    [self.filter setValue:color0 forKey:@"inputColor0"];
    [self.filter setValue:color1 forKey:@"inputColor1"];
    [self setOutputImage:_image.extent];
}

@end
