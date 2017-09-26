//
//  CIBumpDistortionViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/22.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIBumpDistortionViewController.h"

@interface CIBumpDistortionViewController ()

@property (nonatomic, strong) CIVector *vector;

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIBumpDistortionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[//0.76 0.6
                       @{
                           @"name":@"inputRadius",
                           @"max":@"600",
                           @"min":@"0",
                           @"v":@"20",
                           },
                       @{
                           @"name":@"inputScale",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0.3",
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
    self.imageView.image = [UIImage imageNamed:@"IU4"];
    self.context = [CIContext contextWithOptions:nil];
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    self.filter = [CIFilter filterWithName:self.filterName];
    [self refilter];
}

- (void)refilter {
    if (!_vector) {
        return;
    }
    CIImage *inputImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputScaleKey];
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
