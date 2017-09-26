//
//  CIMaskedVariableBlurViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIMaskedVariableBlurViewController.h"

@interface CIMaskedVariableBlurViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIMaskedVariableBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputRadius",
                           @"max":@"10",
                           @"min":@"0",
                           @"v":@"5",
                           },
                       ];
    [self transitionModels:array];
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    CIImage *mask = [CIImage imageWithCGImage:[UIImage imageNamed:@"translucentMask1"].CGImage];
    [self.filter setValue:mask forKey:@"inputMask"];
    
    //遮罩
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    
    [self setOutputImage:_ci_image.extent];
}

@end
