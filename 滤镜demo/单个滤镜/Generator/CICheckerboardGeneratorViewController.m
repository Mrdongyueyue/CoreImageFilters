//
//  CICheckerboardGeneratorViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/22.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CICheckerboardGeneratorViewController.h"

@interface CICheckerboardGeneratorViewController ()

@property (nonatomic, strong) CIVector *vector;

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CICheckerboardGeneratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[//0.76 0.6
                       @{
                           @"name":@"inputWidth",
                           @"max":@"800",
                           @"min":@"0",
                           @"v":@"80",
                           },
                       @{
                           @"name":@"inputSharpness",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"color_r_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"color_g_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.76",
                           },
                       @{
                           @"name":@"color_b_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.6",
                           },
                       @{
                           @"name":@"color_a_0",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"color_r_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"color_g_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.24",
                           },
                       @{
                           @"name":@"color_b_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.4",
                           },
                       @{
                           @"name":@"color_a_1",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i ++) {
        YYFilterAttributeModel *model = [YYFilterAttributeModel new];
        NSDictionary *dict = array[i];
        model.attributeName = dict[@"name"];
        model.maxValue = [dict[@"max"] floatValue];
        model.minValue = [dict[@"min"] floatValue];
        model.value = [dict[@"v"] floatValue];
        [temp addObject:model];
    }
    
    self.filterAttributeModels = temp;
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self refilter];
}

- (void)refilter {
    if (!_vector) {
        return;
    }
    CIImage *inputImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputWidthKey];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputSharpnessKey];
//    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    
    UIColor *color0 = [UIColor colorWithRed:self.filterAttributeModels[2].value
                                     green:self.filterAttributeModels[3].value
                                      blue:self.filterAttributeModels[4].value
                                     alpha:self.filterAttributeModels[5].value];
    UIColor *color1 = [UIColor colorWithRed:self.filterAttributeModels[6].value
                                     green:self.filterAttributeModels[7].value
                                      blue:self.filterAttributeModels[8].value
                                     alpha:self.filterAttributeModels[9].value];
    CIColor *ci_color0 = [CIColor colorWithCGColor:color0.CGColor];
    CIColor *ci_color1 = [CIColor colorWithCGColor:color1.CGColor];
    [self.filter setValue:ci_color0 forKey:@"inputColor0"];
    [self.filter setValue:ci_color1 forKey:@"inputColor1"];
    
    
    CIImage *outPutImage = self.filter.outputImage;
    
    CGImageRef image = [self.context createCGImage:outPutImage fromRect:inputImage.extent];
    
    UIImage *f_image = [UIImage imageWithCGImage:image];
    self.imageView.image = f_image;
    CGImageRelease(image);
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //        });
    //    });
    
    
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self.imageView];
    NSLog(@"%@", NSStringFromCGPoint(point));
    CGSize imageSize = _ci_image.extent.size;
    CGSize viewSize = self.imageView.bounds.size;
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    point = CGPointApplyAffineTransform(point, transform);
    CGFloat scaleX = MAX(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    CGFloat scaleY = MIN(imageSize.width / viewSize.width, imageSize.height / viewSize.height);
    point.x = point.x * scaleX;
    point.y = (imageSize.height + point.y * scaleY);
    
    NSLog(@"%@", NSStringFromCGPoint(point));
    
    _vector = [CIVector vectorWithX:point.x Y:point.y];
    [self refilter];
}



@end
