//
//  CIVignetteEffectViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/3.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIVignetteEffectViewController.h"

@interface CIVignetteEffectViewController ()

@end

@implementation CIVignetteEffectViewController {
    CIImage *_image;
    CIVector *_vector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputFalloff",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.5",
                           },
                       @{
                           @"name":@"inputIntensity",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputRadius",
                           @"max":@"2000",
                           @"min":@"0",
                           @"v":@"150",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    _vector = [CIVector vectorWithX:150 Y:150];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputFalloff"];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputIntensityKey];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:kCIInputRadiusKey];
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
