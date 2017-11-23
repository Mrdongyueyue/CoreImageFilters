//
//  YYPreviewView.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/17.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYPreviewView.h"
@import AVFoundation;

@implementation YYPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (AVCaptureSession *)session
{
    return self.videoPreviewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    self.videoPreviewLayer.session = session;
}

@end

