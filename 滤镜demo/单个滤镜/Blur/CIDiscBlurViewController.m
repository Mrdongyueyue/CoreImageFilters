//
//  CIDiscBlurViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIDiscBlurViewController.h"

@interface CIDiscBlurViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIDiscBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputRadius",
                           @"max":@"100",
                           @"min":@"0",
                           @"v":@"8",
                           },
                       ];
    [self transitionModels:array];
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    
    [self setOutputImage:_ci_image.extent];
}

@end
