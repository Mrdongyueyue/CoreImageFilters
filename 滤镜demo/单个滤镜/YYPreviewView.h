//
//  YYPreviewView.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/17.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession, AVCaptureVideoPreviewLayer;
@interface YYPreviewView : UIView

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic) AVCaptureSession *session;

@end
