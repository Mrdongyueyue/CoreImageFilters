//
//  CIColorBlendModeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/22.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorBlendModeViewController.h"

@interface CIColorBlendModeViewController ()

@end

@implementation CIColorBlendModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refilter];
}

- (void)refilter {
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    CIImage *bImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"checkerBoard"].CGImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIFilter *filter = [CIFilter filterWithName:self.filterName];
        
        
        [filter setValue:inputImage forKey:kCIInputBackgroundImageKey];
        [filter setValue:bImage forKey:kCIInputImageKey];
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outPutImage = filter.outputImage;
        
        CGImageRef image = [context createCGImage:outPutImage fromRect:inputImage.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *f_image = [UIImage imageWithCGImage:image];
            self.imageView.image = f_image;
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
