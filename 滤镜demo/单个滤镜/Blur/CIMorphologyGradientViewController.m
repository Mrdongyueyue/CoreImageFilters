//
//  CIMorphologyGradientViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/27.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIMorphologyGradientViewController.h"

@interface CIMorphologyGradientViewController ()

@end

@implementation CIMorphologyGradientViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputRadius",
                           @"max":@"50",
                           @"min":@"0",
                           @"v":@"5",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    
    [self setOutputImage:_image.extent];
}

@end
