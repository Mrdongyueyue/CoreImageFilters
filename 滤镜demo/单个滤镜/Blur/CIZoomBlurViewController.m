//
//  CIZoomBlurViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/10/27.
//  Copyright © 2017年 董知樾. All rights reserved.
//  晃瞎狗眼的模糊缩放

#import "CIZoomBlurViewController.h"

@interface CIZoomBlurViewController ()

@end

@implementation CIZoomBlurViewController {
    CIImage *_image;
    CIVector *_vector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[
                       @{
                           @"name":@"inputAmount",
                           @"max":@"200",
                           @"min":@"-200",
                           @"v":@"20",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputAmount"];
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    
    [self setOutputImage:_image.extent];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self.imageView];
    CGSize imageSize = _image.extent.size;
    CGSize viewSize = self.imageView.bounds.size;
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    point = CGPointApplyAffineTransform(point, transform);
    CGFloat scaleX = MAX(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    CGFloat scaleY = MIN(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    point.x = point.x * scaleX;
    point.y = (imageSize.height + point.y * scaleY);
    
    _vector = [CIVector vectorWithX:point.x Y:point.y];
    [self refilter];
}

@end
