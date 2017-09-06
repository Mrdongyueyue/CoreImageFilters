//
//  FPCameraView.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCapturePhoto;
@interface FPCameraView : UIView

- (void)takePhotoComplete:(void (^)(AVCapturePhoto *photo, NSError *error))complete;

@end


@interface NSData (FPCameraView)
- (UIImage *)orientationImage;

@end
