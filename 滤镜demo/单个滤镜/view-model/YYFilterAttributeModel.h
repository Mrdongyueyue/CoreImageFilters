//
//  YYFilterAttributeModel.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYFilterAttributeModel : NSObject

@property (copy, nonatomic) NSString *attributeName;

@property (nonatomic, strong) Class valueClazz;

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, assign) CGFloat minValue;

@end
