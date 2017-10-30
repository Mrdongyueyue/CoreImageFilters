//
//  CIHueAdjustViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/30.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIHueAdjustViewController.h"

@interface CIHueAdjustViewController ()

@end

@implementation CIHueAdjustViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputPower",
                           @"max":@"3.14159",
                           @"min":@"-3.14159",
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
    
    [self setOutputImage:_image.extent];
}

@end
