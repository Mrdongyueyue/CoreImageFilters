//
//  CIBarsSwipeTransitionViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIBarsSwipeTransitionViewController.h"

@interface CIBarsSwipeTransitionViewController ()

@end

@implementation CIBarsSwipeTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refilter];
    
    
    
}

- (void)refilter {
    CIImage *b_inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIFilter *filter = [CIFilter filterWithName:self.filterName];
        NSLog(@"%@",filter.attributes);
//        [filter setValue:@(2.0) forKey:kCIInputAngleKey];
        //CIAttributeClass = NSNumber;
        //CIAttributeDefault = "3.141592653589793";
        //CIAttributeDescription = "彩条的角度（以弧度为单位）。";
        //CIAttributeDisplayName = "角度";
        
//        [filter setValue:@20 forKey:@"inputBarOffset"];
//        inputBarOffset =     {
//            CIAttributeClass = NSNumber;
//            CIAttributeDefault = 10;
//            CIAttributeDescription = "一个栏相对于另一个栏的偏移量";
//            CIAttributeDisplayName = "彩条偏移";
//            CIAttributeMin = 1;
//            CIAttributeSliderMax = 100;
//            CIAttributeSliderMin = 1;
//            CIAttributeType = CIAttributeTypeScalar;
//        };
        CIImage *t_inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU3"].CGImage];
        [filter setValue:t_inputImage forKey:kCIInputTargetImageKey];
//        inputTargetImage =     {
//            CIAttributeClass = CIImage;
//            CIAttributeDescription = "过渡所使用的目标图像。";
//            CIAttributeDisplayName = "目标图像";
//            CIAttributeType = CIAttributeTypeImage;
//        };
        [filter setValue:@3 forKey:kCIInputTimeKey];
//        inputTime =     {
//            CIAttributeClass = NSNumber;
//            CIAttributeDefault = 0;
//            CIAttributeDescription = "过渡的参数时间。该值从头（在时间 0）到尾（在时间 1）驱动过渡。";
//            CIAttributeDisplayName = "时间";
//            CIAttributeIdentity = 0;
//            CIAttributeMax = 1;
//            CIAttributeMin = 0;
//            CIAttributeSliderMax = 1;
//            CIAttributeSliderMin = 0;
//            CIAttributeType = CIAttributeTypeTime;
//        };
//        inputWidth =     {
//            CIAttributeClass = NSNumber;
//            CIAttributeDefault = 30;
//            CIAttributeDescription = "每个条形图的宽度。";
//            CIAttributeDisplayName = "宽度";
//            CIAttributeMin = 2;
//            CIAttributeSliderMax = 300;
//            CIAttributeSliderMin = 2;
//            CIAttributeType = CIAttributeTypeDistance;
//        };
        
        [filter setValue:b_inputImage forKey:kCIInputImageKey];
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outPutImage = filter.outputImage;
        
        CGImageRef image = [context createCGImage:outPutImage fromRect:outPutImage.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CABasicAnimation *anima = [CABasicAnimation animation];
            anima.duration = 3;
            anima.toValue = @[filter];
            [self.imageView.layer addAnimation:anima forKey:@"filter"];
//            UIImage *f_image = [UIImage imageWithCGImage:image];
//            self.imageView.image = f_image;
            CGImageRelease(image);
        });
    });
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
