
//
//  CIColorClampViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIColorClampViewController.h"

@interface CIColorClampViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIColorClampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"MinComponents_R",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"MinComponents_G",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"MinComponents_B",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"MinComponents_A",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"MaxComponents_R",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"MaxComponents_G",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"MaxComponents_B",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       @{
                           @"name":@"MaxComponents_A",
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
    
    //颜色RGBA元素低于min值的增至min值，高于max值的降至max值
    
    [self refilter];
}

- (void)refilter {
    CIVector *min = [CIVector vectorWithX:self.filterAttributeModels[0].value
                                        Y:self.filterAttributeModels[1].value
                                        Z:self.filterAttributeModels[2].value
                                        W:self.filterAttributeModels[3].value];
    CIVector *max = [CIVector vectorWithX:self.filterAttributeModels[4].value
                                        Y:self.filterAttributeModels[5].value
                                        Z:self.filterAttributeModels[6].value
                                        W:self.filterAttributeModels[7].value];
    
    [self.filter setValue:min forKey:@"inputMinComponents"];
    [self.filter setValue:max forKey:@"inputMaxComponents"];
    
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
