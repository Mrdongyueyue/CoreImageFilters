//
//  CISunbeamsGeneratorViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CISunbeamsGeneratorViewController.h"

@interface CISunbeamsGeneratorViewController ()

@end

@implementation CISunbeamsGeneratorViewController {
    CIImage *_image;
    CIVector *_vector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputMaxStriationRadius",
                           @"max":@"10",
                           @"min":@"0",
                           @"v":@"2.58",
                           },
                       @{
                           @"name":@"inputStriationContrast",
                           @"max":@"5",
                           @"min":@"0",
                           @"v":@"1.375",
                           },
                       @{
                           @"name":@"inputStriationStrength",
                           @"max":@"3",
                           @"min":@"0",
                           @"v":@"0.5",
                           },
                       @{
                           @"name":@"inputSunRadius",
                           @"max":@"800",
                           @"min":@"0",
                           @"v":@"40",
                           },
                       @{
                           @"name":@"inputColor_R",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"inputColor_G",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.5",
                           },
                       @{
                           @"name":@"inputColor_B",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputColor_A",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    [self transitionModels:array];
    _image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
//    [self.filter setValue:_image forKey:kCIInputImageKey];
    
    [self refilter];
}

- (void)refilter {
    
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputMaxStriationRadius"];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:@"inputStriationContrast"];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:@"inputStriationStrength"];
    [self.filter setValue:@(self.filterAttributeModels[3].value) forKey:@"inputSunRadius"];
    CIColor *inputColor = [CIColor colorWithRed:self.filterAttributeModels[4].value
                                          green:self.filterAttributeModels[5].value
                                           blue:self.filterAttributeModels[6].value
                                          alpha:self.filterAttributeModels[7].value];
    [self.filter setValue:inputColor forKey:kCIInputColorKey];
    
    CIImage *outPutImage = self.filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *sourceOverCompositing = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositing setValue:outPutImage forKey:kCIInputImageKey];
    [sourceOverCompositing setValue:_image forKey:kCIInputBackgroundImageKey];
    
    CGImageRef cg_image = [context createCGImage:sourceOverCompositing.outputImage fromRect:_image.extent];
    UIImage *finalImage = [UIImage imageWithCGImage:cg_image];
    self.imageView.image = finalImage;
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

/*
推测：需要和视频结合 或者 可以做转场动画
inputTime =     {
    CIAttributeClass = NSNumber;
    CIAttributeDefault = 0;
    CIAttributeDescription = "The duration of the effect.";
    CIAttributeDisplayName = Time;
    CIAttributeIdentity = 0;
    CIAttributeMax = 1;
    CIAttributeMin = 0;
    CIAttributeSliderMax = 1;
    CIAttributeSliderMin = 0;
    CIAttributeType = CIAttributeTypeScalar;
};


*/

@end
