//
//  CIConvolution3X3ViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/20.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIConvolution3X3ViewController.h"

@interface CIConvolution3X3ViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIConvolution3X3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"bias",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0.5",
                           },
                       ];
    [self transitionModels:array];
    
    _ci_image = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    const CGFloat weights[] = {
        -3.f, -2.f, -1.f,
        -2.f, 17.f, -2.f,
        -1.f, -2.f, -3.f,
    };
    CIVector *w = [CIVector vectorWithValues:weights count:9];
    [self.filter setValue:w forKey:kCIInputWeightsKey];
    [self.filter setValue:@(self.filterAttributeModels.firstObject.value) forKey:kCIInputBiasKey];
    [self setOutputImage:_ci_image.extent];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
 1 1 -1 -1
 1 1 -1 -1
 1 1 -1  1
 1 1 -1 -1
*/

@end
