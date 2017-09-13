//
//  FPCameraView.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <AVFoundation/AVFoundation.h>

#ifdef __IPHONE_11_0
#define iOS_11 (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
#else
#define iOS_11 (NO)
#endif

@interface FPCameraView : UIView
/**
 当前摄像头 default AVCaptureDevicePositionFront 前置
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;


/**
 闪光灯 default auto
 */
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

#if iOS_11
- (void)takePhotoComplete:(void (^)(AVCapturePhoto *photo, NSError *error))complete;
#else
- (void)takePhotoComplete:(void (^)(UIImage *image, NSError *error))complete;
#endif

/**
 转换前后置摄像头
 */
- (void)flipCamera;

- (void)stopRunning;

- (void)startRunning;

@end


@interface NSData (FPCameraView)

- (UIImage *)orientationImage;

@end
