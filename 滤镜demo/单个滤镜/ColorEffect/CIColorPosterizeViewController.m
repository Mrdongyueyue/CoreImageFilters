//
//  CIColorPosterizeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorPosterizeViewController.h"

@interface CIColorPosterizeViewController ()

@end

@implementation CIColorPosterizeViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputLevels",
                           @"max":@"30",
                           @"min":@"2",
                           @"v":@"6",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:@(self.filterAttributeModels.firstObject.value) forKey:@"inputLevels"];
    [self setOutputImage:_image.extent];
}

@end
