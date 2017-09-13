//
//  YYFilterAttributeTableViewCell.h
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYFilterAttributeModel;
@interface YYFilterAttributeTableViewCell : UITableViewCell

@property (nonatomic, strong) YYFilterAttributeModel *model;

- (void)sliderDidChange:(void (^)(void))block;

@end
