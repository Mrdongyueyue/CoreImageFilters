//
//  CIWhitePointAdjustViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/30.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIWhitePointAdjustViewController.h"

@interface CIWhitePointAdjustViewController ()

@end

@implementation CIWhitePointAdjustViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputColor_R",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputColor_G",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputColor_B",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputColor_A",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    CIColor *inputColor = [CIColor colorWithRed:self.filterAttributeModels[0].value
                                          green:self.filterAttributeModels[1].value
                                           blue:self.filterAttributeModels[2].value
                                          alpha:self.filterAttributeModels[3].value];
    [self.filter setValue:inputColor forKey:kCIInputColorKey];
    
    [self setOutputImage:_image.extent];
}
@end
