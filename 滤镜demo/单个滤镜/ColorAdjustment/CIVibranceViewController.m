//
//  CIVibranceViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIVibranceViewController.h"

@interface CIVibranceViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIVibranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"Amount",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       ];
    [self transitionModels:array];
    
    //饱和度
    
    [self refilter];
    
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputAmount"];
    
    [self setOutputImage:_ci_image.extent];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
