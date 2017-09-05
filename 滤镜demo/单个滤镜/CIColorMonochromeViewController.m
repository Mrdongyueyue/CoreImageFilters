//
//  CIColorMonochromeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorMonochromeViewController.h"

@interface CIColorMonochromeViewController ()

@property (nonatomic, weak) UISlider *r_slider;
@property (nonatomic, weak) UISlider *g_slider;
@property (nonatomic, weak) UISlider *b_slider;
@property (nonatomic, weak) UISlider *a_slider;

@end

@implementation CIColorMonochromeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat y = [UIScreen mainScreen].bounds.size.height - 30 * 4;
    _r_slider = [self makeSlider];
    _r_slider.value = 1.000;
    _r_slider.frame = CGRectMake(80, y, 200, 25);
    y += 30;
    
    _g_slider = [self makeSlider];
    _g_slider.frame = CGRectMake(80, y, 200, 25);
    _g_slider.value = 0.759;
    y += 30;
    
    _b_slider = [self makeSlider];
    _b_slider.frame = CGRectMake(80, y, 200, 25);
    _b_slider.value = 0.592;
    y += 30;
    
    _a_slider = [self makeSlider];
    _a_slider.frame = CGRectMake(80, y, 200, 25);
    _a_slider.value = 1.000;
    
    [self filter];
}


- (void)filter {
    CIImage *inputImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    CIColor *color = [CIColor colorWithRed:_r_slider.value green:_g_slider.value blue:_b_slider.value alpha:_a_slider.value];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //先打印NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]);进去找到需要设置的属性(查询效果分类中都有什么效果)  可以设置什么效果
        //然后通过[CIFilter filterWithName:@""];找到属性   具体效果的属性
        //然后通过KVC的方式设置属性
        NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]);
        /*
         1.查询 效果分类中 包含什么效果：filterNamesInCategory:
         2.查询 使用的效果中 可以设置什么属性（KVC） attributes
         
         使用步骤
         1.需要添加滤镜的源图
         2.初始化一个滤镜 设置滤镜（根据查询到的属性来设置）
         3.把滤镜 输出的图像 和滤镜  合并 CIContext -> 得到一个合成之后的图像
         4.展示
         */
        CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
        NSLog(@"%@",filter.attributes);
        //这个属性是必须赋值的，假如你处理的是图片的话
        [filter setValue:inputImage forKey:kCIInputImageKey];
        
        [filter setValue:color forKey:kCIInputColorKey];
        //CIContext
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outPutImage = filter.outputImage;
        
        CGImageRef image = [context createCGImage:outPutImage fromRect:outPutImage.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithCGImage:image];
            CGImageRelease(image);
        });
    });

}

- (UISlider *)makeSlider {
    UISlider *slider = [[UISlider alloc] init];
    slider.maximumValue = 1;
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(didSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    return slider;
}

- (void)didSlider:(UISlider *)slider {
    [self filter];
}

- (void)invalidSliders {
    _r_slider.userInteractionEnabled = NO;
    _g_slider.userInteractionEnabled = NO;
    _b_slider.userInteractionEnabled = NO;
    _a_slider.userInteractionEnabled = NO;
}

- (void)validSliders {
    _r_slider.userInteractionEnabled = YES;
    _g_slider.userInteractionEnabled = YES;
    _b_slider.userInteractionEnabled = YES;
    _a_slider.userInteractionEnabled = YES;
}


@end
