//
//  FPImageFilter.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FPImageFilterComplete)(UIImage * _Nullable image, NSError * _Nullable error);

@class AVCapturePhoto;
@interface FPImageFilter : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (void)colorMonochromeFilter:(UIImage *)image color:(UIColor *)color complete:(FPImageFilterComplete)complete;

+ (void)beautyFilter:(UIImage *)image complete:(FPImageFilterComplete)complete;

+ (void)autoFilter:(AVCapturePhoto *)photo complete:(FPImageFilterComplete)complete;

NS_ASSUME_NONNULL_END


@end
