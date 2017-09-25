//
//  CICircleSplashDistortionViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/22.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CICircleSplashDistortionViewController.h"

@interface CICircleSplashDistortionViewController ()

@property (nonatomic, strong) CIVector *vector;

@property (nonatomic, strong) CIImage *ci_image;

@property (nonatomic, strong) CIContext *context;

@property (nonatomic, strong) CIFilter *filter;

@end

@implementation CICircleSplashDistortionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputRadius",
                           @"max":@"1000",
                           @"min":@"0",
                           @"v":@"150",
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
    
    _context = [CIContext contextWithOptions:nil];
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    _filter = [CIFilter filterWithName:self.filterName];
    [self refilter];
}

- (void)refilter {
    if (!_vector) {
        return;
    }
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    
    [_filter setValue:_vector forKey:kCIInputCenterKey];
    [_filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputRadiusKey];
    [_filter setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *outPutImage = _filter.outputImage;
    
    CGImageRef image = [_context createCGImage:outPutImage fromRect:inputImage.extent];
    
    UIImage *f_image = [UIImage imageWithCGImage:image];
    self.imageView.image = f_image;
    CGImageRelease(image);
    
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
