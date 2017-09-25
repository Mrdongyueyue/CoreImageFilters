//
//  CIVibranceViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIVibranceViewController.h"

@interface CIVibranceViewController ()

@property (nonatomic, strong) CIImage *ci_image;

@end

@implementation CIVibranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    NSArray *array = @[
                       @{
                           @"name":@"Amount",
                           @"max":@"1",
                           @"min":@"-1",
                           @"v":@"0",
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
    
    //饱和度
    
    [self refilter];
    
}

- (void)refilter {
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputAmount"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
