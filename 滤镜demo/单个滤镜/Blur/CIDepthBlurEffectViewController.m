//
//  CIDepthBlurEffectViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/26.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "CIDepthBlurEffectViewController.h"
@import GLKit;
@import AVFoundation;
@import CoreMedia;

@interface CIDepthBlurEffectViewController ()

@end

@implementation CIDepthBlurEffectViewController {
    CIImage *_ci_image;
    CIDetector *_detector;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @{
                           @"name":@"inputAperture",
                           @"max":@"22",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputLumaNoiseScale",
                           @"max":@"0.1",
                           @"min":@"0",
                           @"v":@"0",
                           },
                       @{
                           @"name":@"inputScaleFactor",
                           @"max":@"1",
                           @"min":@"0",
                           @"v":@"1",
                           },
                       ];
    [self transitionModels:array];
    
    _ci_image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    [self.filter setValue:_ci_image forKey:kCIInputImageKey];
    
    _detector = [CIDetector detectorOfType:CIDetectorTypeFace context:self.context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    NSArray<CIFeature *> *features = [_detector featuresInImage:_ci_image];
    for (CIFaceFeature *ff in features) {
        
        if (ff.hasLeftEyePosition) {
            CIVector *leftEye = [CIVector vectorWithX:ff.leftEyePosition.x Y:ff.leftEyePosition.y];
            [self.filter setValue:leftEye forKey:@"inputLeftEyePositions"];
        }
        
        if (ff.hasRightEyePosition) {
            CIVector *leftEye = [CIVector vectorWithX:ff.rightEyePosition.x Y:ff.rightEyePosition.y];
            [self.filter setValue:leftEye forKey:@"inputRightEyePositions"];
        }
        
        CIVector *focusRect = [CIVector vectorWithX:ff.bounds.origin.x Y:ff.bounds.origin.y Z:ff.bounds.size.width W:ff.bounds.size.height];
        [self.filter setValue:focusRect forKey:@"inputFocusRect"];
        
    }
    
    [self refilter];
}


- (void)refilter {
    
    [self.filter setValue:@(self.filterAttributeModels[0].value) forKey:@"inputAperture"];
    [self.filter setValue:@(self.filterAttributeModels[1].value) forKey:@"inputLumaNoiseScale"];
    [self.filter setValue:@(self.filterAttributeModels[2].value) forKey:@"inputScaleFactor"];
    
    [self setOutputImage:_ci_image.extent];
}

/*
 inputAuxDataMetadata : NSDictionary 未知
 inputCalibrationData : AVCameraCalibrationData 未知
 inputChinPositions : CIVector "下巴位置" 未知
 inputDisparityImage 未知
 inputFocusRect : CIVector Identity = "[-8.98847e+307 -8.98847e+307 1.79769e+308 1.79769e+308]     "对焦框" （人脸范围？）
 inputLumaNoiseScale "亮度噪声范围"
 inputNosePositions : CIVector "鼻子位置" 未知
*/

@end
