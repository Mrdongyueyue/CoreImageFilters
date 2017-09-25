//
//  CITemperatureAndTintViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CITemperatureAndTintViewController.h"

@interface CITemperatureAndTintViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CITemperatureAndTintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"Neutral",
                           @"max":@"10000",
                           @"min":@"1500",
                           @"v":@"6500",
                           },
                       @{
                           @"name":@"TargetNeutral",
                           @"max":@"10000",
                           @"min":@"1500",
                           @"v":@"6500",
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
    
    //色温 TargetNeutral的值大于Neutral的值，则向暖色调转换
    
    [self refilter];
}

- (void)refilter {
    CIVector *meutral = [CIVector vectorWithX:self.filterAttributeModels[0].value
                                            Y:0];
    CIVector *targetNeutral = [CIVector vectorWithX:self.filterAttributeModels[1].value
                                                  Y:0];
    
    [self.filter setValue:meutral forKey:@"inputNeutral"];
    [self.filter setValue:targetNeutral forKey:@"inputTargetNeutral"];
    
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

@end
