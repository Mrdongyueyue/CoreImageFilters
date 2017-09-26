//
//  CIBloomViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/11.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIBloomViewController.h"

@interface CIBloomViewController ()

@end

@implementation CIBloomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"color_intensity",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"0.5",
                           },
                       @{
                           @"name":@"color_radius",
                           @"max":@"100",
                           @"min":@"0",
                           @"v":@"10",
                           }
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
    CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"IU1"].CGImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIFilter *filter = [CIFilter filterWithName:self.filterName];
        NSLog(@"%@",filter.attributes);
        [filter setValue:@(self.filterAttributeModels[0].value) forKey:kCIInputIntensityKey];
        [filter setValue:@(self.filterAttributeModels[1].value) forKey:kCIInputRadiusKey];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outPutImage = filter.outputImage;
        
        CGImageRef image = [context createCGImage:outPutImage fromRect:inputImage.extent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *f_image = [UIImage imageWithCGImage:image];
            self.imageView.image = f_image;
            CGImageRelease(image);
        });
    });
    
    
}

/*
 CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
 NSArray *faces = [detector featuresInImage:[CIImage imageWithCGImage:self.imageView.image.CGImage]];
 
 CGSize inputImageSize = self.imageView.image.size;
 CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
 transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
 
 for (CIFaceFeature *f in faces) {
 CALayer *layer = [CALayer layer];
 layer.borderColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.3 alpha:0.9].CGColor;
 layer.borderWidth = 1;
 layer.backgroundColor = [UIColor clearColor].CGColor;
 [self.imageView.layer addSublayer:layer];
 
 CGRect faceViewBounds = CGRectApplyAffineTransform(f.bounds, transform);
 CGSize viewSize = self.imageView.bounds.size;
 CGFloat scale = MIN(viewSize.width / inputImageSize.width,
 viewSize.height / inputImageSize.height);
 CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
 CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
 // 缩放
 CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
 // 修正
 faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
 faceViewBounds.origin.x += offsetX;
 faceViewBounds.origin.y += offsetY;
 layer.frame = faceViewBounds;
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
