//
//  CICrystallizeViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CICrystallizeViewController.h"

@interface CICrystallizeViewController ()

@property (nonatomic, strong) CIVector *vector;

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CICrystallizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputRadius",
                           @"max":@"100",
                           @"min":@"1",
                           @"v":@"20",
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
    
    [self refilter];
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    [self.filter setValue:_vector forKey:kCIInputCenterKey];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIImage *outPutImage = self.filter.outputImage;
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cg_image = [context createCGImage:outPutImage fromRect:_ci_image.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithCGImage:cg_image];
            CGImageRelease(cg_image);
        });
    });
    
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
