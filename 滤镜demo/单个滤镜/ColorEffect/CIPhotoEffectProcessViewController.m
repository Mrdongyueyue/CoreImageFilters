//
//  CIPhotoEffectProcessViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIPhotoEffectProcessViewController.h"

@interface CIPhotoEffectProcessViewController ()

@end

@implementation CIPhotoEffectProcessViewController {
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
