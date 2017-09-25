//
//  YYBaseViewController.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

#import "YYFilterAttributeModel.h"
@interface YYBaseViewController : UIViewController

@property (copy, nonatomic) NSString *filterName;

@property (nonatomic, strong) CIFilter *filter;

@property (nonatomic, strong) CIContext *context;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSArray<YYFilterAttributeModel *> *filterAttributeModels;


/**
 用于重写
 */
- (void)refilter;

@end
