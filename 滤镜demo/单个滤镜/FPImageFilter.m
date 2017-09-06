//
//  FPImageFilter.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "FPImageFilter.h"
#import "GPUImageBeautifyFilter.h"
#import <CoreImage/CoreImage.h>

@implementation FPImageFilter

+ (void)colorMonochromeFilter:(UIImage *)image color:(UIColor *)color complete:(FPImageFilterComplete)complete {
    if (!image) {
        
        return;
    }
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIColor *ci_color = [CIColor colorWithCGColor:color.CGColor];
    
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
        
        [filter setValue:ci_color forKey:kCIInputColorKey];
        //CIContext
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outPutImage = filter.outputImage;
        
        CGImageRef image = [context createCGImage:outPutImage fromRect:outPutImage.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *f_image = [UIImage imageWithCGImage:image];
            if (complete) {
                complete(f_image, nil);
            }
            CGImageRelease(image);
        });
    });
    
}

+ (void)beautyFilter:(UIImage *)image complete:(FPImageFilterComplete)complete {
    GPUImageBeautifyFilter *filter = [[GPUImageBeautifyFilter alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:image];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [imagePicture addTarget:filter];
        [imagePicture processImage];
        UIImage *f_image = [filter imageFromCurrentFramebuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(f_image, nil);
            }
        });
    });
}

+ (void)autoFilter:(AVCapturePhoto *)photo complete:(FPImageFilterComplete)complete {
    CIImage *image = [CIImage imageWithCVPixelBuffer:photo.pixelBuffer];
//    CIRedEyeCorrection：修复因相机的闪光灯导致的各种红眼
//    CIFaceBalance：调整肤色
//    CIVibrance：在不影响肤色的情况下，改善图像的饱和度
//    CIToneCurve：改善图像的对比度
//    CIHighlightShadowAdjust：改善阴影细节
    CIFilter *filter = [CIFilter filterWithName:@"CIFaceBalance"];
    [filter setValue:image forKey:@"inputImage"];
    complete([UIImage imageWithCIImage:filter.outputImage], nil);
}

@end
