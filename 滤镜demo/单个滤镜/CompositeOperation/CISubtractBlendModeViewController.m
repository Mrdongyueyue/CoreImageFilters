//
//  CISubtractBlendModeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/23.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CISubtractBlendModeViewController.h"

@interface CISubtractBlendModeViewController ()

@end

@implementation CISubtractBlendModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refilter];
}

- (void)refilter {
    CIImage *image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    CIImage *backgroundImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"gradient01"].CGImage];
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:backgroundImage forKey:kCIInputBackgroundImageKey];
    [self setOutputImage:image.extent];
}

@end
