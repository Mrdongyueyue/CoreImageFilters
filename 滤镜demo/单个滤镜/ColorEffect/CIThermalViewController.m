//
//  CIThermalViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIThermalViewController.h"

@interface CIThermalViewController ()

@end

@implementation CIThermalViewController {
    CIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    [self setOutputImage:_image.extent];
}

@end
