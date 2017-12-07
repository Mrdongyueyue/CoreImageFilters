//
//  CIAreaHistogramViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/12/6.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIAreaHistogramViewController.h"

@interface CIAreaHistogramViewController ()

@end

@implementation CIAreaHistogramViewController {
    CIImage *_ci_image;
    CIVector *_vector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
//    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:_vector forKey:kCIInputExtentKey];
    [self setOutputImage:_ci_image.extent];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self.imageView];
    CGSize imageSize = _ci_image.extent.size;
    CGSize viewSize = self.imageView.bounds.size;
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    point = CGPointApplyAffineTransform(point, transform);
    CGFloat scaleX = MAX(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    CGFloat scaleY = MIN(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    point.x = point.x * scaleX;
    point.y = (imageSize.height + point.y * scaleY);
    
    _vector = [CIVector vectorWithX:point.x Y:point.y Z:30 W:30];
    [self refilter];
}


@end
