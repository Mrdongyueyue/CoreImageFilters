//
//  CIMotionBlurViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/27.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIMotionBlurViewController.h"

@interface CIMotionBlurViewController ()

@end

@implementation CIMotionBlurViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputAngle",
                           @"max":@"3.14159",
                           @"min":@"-3.14159",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputRadius",
                           @"max":@"50",
                           @"min":@"0",
                           @"v":@"0",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputAngleKey];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputRadiusKey];
    
    [self setOutputImage:_image.extent];
}

@end
