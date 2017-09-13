//
//  YYCameraView.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/12.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#ifdef __IPHONE_10_0
#define iOS_10 (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
#else
#define iOS_10 (NO)
#endif

@interface YYCameraView : UIView

/**
 当前摄像头 default AVCaptureDevicePositionFront 前置
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

- (void)takePhotoComplete:(void (^)(UIImage *image, NSError *error))complete;

@end
