//
//  CIColorControlsViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorControlsViewController.h"

@interface CIColorControlsViewController ()
@property (nonatomic, strong) CIImage *ci_image;
@end

@implementation CIColorControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"Brightness",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"Contrast",
                           @"max":@"4",
                           @"min":@"0.25",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"Saturation",
                           @"max":@"2",
                           @"min":@"0",
                           @"v":@"1",
                           }
                       ];
    [self transitionModels:array];
    
    [self refilter];
}

- (void)refilter {

    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputBrightnessKey];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputContrastKey];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:kCIInputSaturationKey];
    
    [self setOutputImage:_ci_image.extent];
}

@end
