//
//  CIAdditionCompositingViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIAdditionCompositingViewController.h"

@interface CIAdditionCompositingViewController ()

@end

@implementation CIAdditionCompositingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refilter];
}

- (void)refilter {
    CIImage *b_inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    CIImage *a_inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"粉色购物车"].CGImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIFilter *filter = [CIFilter filterWithName:self.filterName];
        NSLog(@"%@",filter.attributes);
        
        [filter setValue:b_inputImage forKey:kCIInputBackgroundImageKey];
        [filter setValue:a_inputImage forKey:kCIInputImageKey];
        CIContext *context = [CIContext contextWithOptions:nil];
//        ;
        CIImage *outPutImage = filter.outputImage;

        [context drawImage:a_inputImage inRect:(CGRect){{100, 100}, a_inputImage.extent.size } fromRect:a_inputImage.extent];
        CGImageRef image = [context createCGImage:outPutImage fromRect:(CGRect){{0, 0}, b_inputImage.extent.size } format:kCIFormatRGBA8 colorSpace:CGColorSpaceCreateDeviceRGB()];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *f_image = [UIImage imageWithCGImage:image];
            self.imageView.image = f_image;
            CGImageRelease(image);
        });
    });
    
    
}



@end
