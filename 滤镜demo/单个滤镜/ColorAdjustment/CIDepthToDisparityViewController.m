//
//  CIDepthToDisparityViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIDepthToDisparityViewController.h"
@import GLKit;

@interface CIDepthToDisparityViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIDepthToDisparityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    //need GLKit AVFoundation ??
    [self refilter];
}

- (void)refilter {
    [self setOutputImage:_ci_image.extent];
}


@end
