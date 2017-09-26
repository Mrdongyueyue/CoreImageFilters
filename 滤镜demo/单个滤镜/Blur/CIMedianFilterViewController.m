//
//  CIMedianFilterViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIMedianFilterViewController.h"

@interface CIMedianFilterViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIMedianFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:[UIImage imageNamed:@"blackWhite"].CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    //图片降噪
    //Computes the median value for a group of neighboring pixels and replaces each pixel value with the median.
    //应该是使用了中值滤波器 : 它是一种常用的非线性平滑滤波器,其基本原理是把数字图像或数字序列中一点的值用该点的一个领域中各点值的中值代换其主要功能是让周围象素灰度值的差比较大的像素改取与周围的像素值接近的值,从而可以消除孤立的噪声点,所以中值滤波对于滤除图像的椒盐噪声非常有效。中值滤波器可以做到既去除噪声又能保护图像的边缘,从而获得较满意的复原效果,而且,在实际运算过程中不需要图象的统计特性,这也带来不少方便,但对一些细节多,特别是点、线、尖顶细节较多的图象不宜采用中值滤波的方法。（from:百度百科）
    [self refilter];
}

- (void)refilter {
    
    [self setOutputImage:_ci_image.extent];
}

@end
