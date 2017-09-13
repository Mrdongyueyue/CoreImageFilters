//
//  FPImageFilter.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FPCameraView.h"

typedef void(^FPImageFilterComplete)(UIImage * _Nullable image, NSError * _Nullable error);

@class AVCapturePhoto;
@interface FPImageFilter : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (void)colorMonochromeFilter:(UIImage *)image color:(UIColor *)color complete:(FPImageFilterComplete)complete;

+ (void)beautyFilter:(UIImage *)image complete:(FPImageFilterComplete)complete;


#if iOS_11
+ (void)autoFilter:(AVCapturePhoto *)photo complete:(FPImageFilterComplete)complete;
#else

#endif

NS_ASSUME_NONNULL_END


@end
