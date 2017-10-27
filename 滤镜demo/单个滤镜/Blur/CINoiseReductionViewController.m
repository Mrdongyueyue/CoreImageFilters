//
//  CINoiseReductionViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/27.
//  Copyright © 2017年 董知樾. All rights reserved.
//  降噪

#import "CINoiseReductionViewController.h"

@interface CINoiseReductionViewController ()

@end

@implementation CINoiseReductionViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputNoiseLevel",
                           @"max":@"0.1",
                           @"min":@"0",
                           @"v":@"0.02",
                           },
                       @{
                           @"name":@"inputSharpness",
                           @"max":@"2",
                           @"min":@"0",
                           @"v":@"0.4",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    //杂点消除数量。值越大，消除的杂点越多。
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputNoiseLevel"];
    
    //锐度 最终图像的清晰度。值越大，结果越清晰。
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputSharpnessKey];
    
    [self setOutputImage:_image.extent];
}


@end
