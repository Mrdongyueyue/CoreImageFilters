//
//  CITwelvefoldReflectedTileViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CITwelvefoldReflectedTileViewController.h"

@interface CITwelvefoldReflectedTileViewController ()

@end

@implementation CITwelvefoldReflectedTileViewController {
    CIImage *_image;
    CIVector *_vector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputAngle",
                           @"max":@"3.14159",
                           @"min":@"-3.14159",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputWidth",
                           @"max":@"200",
                           @"min":@"1",
                           @"v":@"100",
                           }
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:[UIImage imageNamed:@"gradient"].CGImage];
    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputAngleKey];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputWidthKey];
    
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
