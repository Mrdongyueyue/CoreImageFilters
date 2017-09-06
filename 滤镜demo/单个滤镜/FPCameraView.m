//
//  FPCameraView.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "FPCameraView.h"
#import <AVFoundation/AVFoundation.h>

#ifdef __IPHONE_11_0
#define iOS_11 (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
#else
#define iOS_11 (NO)
#endif

@interface FPCameraView ()
#if iOS_11
<AVCapturePhotoCaptureDelegate>
#else
#endif
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;


#if iOS_11
//输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;

#else

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

#endif
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (copy, nonatomic) void (^takePhotoBlock)(AVCapturePhoto *, NSError *);

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;

@end

@implementation FPCameraView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAV];
    }
    return self;
}

- (void)setupAV {
//        AVCaptureDevicePositionBack  后置摄像头
//        AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
#if iOS_11
    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
#else
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
#endif
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    //预览层的生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.previewLayer];
    //设备取景开始
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        //自动闪光灯，
#if iOS_11
        
#else
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
#endif
        //自动白平衡,但是好像一直都进不去
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
#if iOS_11
    AVCaptureDeviceDiscoverySession *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    for ( AVCaptureDevice *device in devices.devices ) {
        if ( device.position == position ){
            return device;
        }
    }
#else
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ){
            return device;
        }
    }
#endif
    return nil;
}

- (void)takePhotoComplete:(void (^)(AVCapturePhoto *, NSError *))complete {
#if iOS_11
    AVCapturePhotoSettings *setting = [[AVCapturePhotoSettings alloc] init];
    
    //    NSDictionary *format = @{ (__bridge id)kCVPixelBufferPixelFormatTypeKey:setting.availablePreviewPhotoPixelFormatTypes.firstObject,
    //                              (__bridge id)kCVPixelBufferWidthKey :@(160),
    //                              (__bridge id)kCVPixelBufferHeightKey :@(160)
    //                              };
    //    setting.previewPhotoFormat = format;
    if ([_imageOutput.supportedFlashModes containsObject:@(AVCaptureFlashModeAuto)]) {
        setting.flashMode = AVCaptureFlashModeAuto;
    }
    [self.imageOutput capturePhotoWithSettings:setting delegate:self];
#else
    AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        return;
    }
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self.session stopRunning];
        self.previewLayer.hidden = YES;
    }];
#endif
    
    _takePhotoBlock = complete;
}

#if iOS_11
//MARK:-- AVCapturePhotoCaptureDelegate ~~~~
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    if (_takePhotoBlock) {
        _takePhotoBlock(photo, error);
    }
    [self.session stopRunning];
    self.previewLayer.hidden = YES;
}
#endif

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = CGRectMake(0, 64, self.bounds.size.width, self.bounds.size.height - 64);
}

@end

@implementation NSData (FPCameraView)
- (UIImage *)orientationImage {
    UIImage *f_image = [UIImage imageWithData:self];
    if (f_image.imageOrientation == UIImageOrientationUp) {
    } else {
        UIGraphicsBeginImageContextWithOptions(f_image.size, NO, f_image.scale);
        CGRect rect = CGRectMake(0, 0, f_image.size.width, f_image.size.height);
        [f_image drawInRect:rect];
        f_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return f_image;
}
@end
