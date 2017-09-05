//
//  IUCollectionViewCell.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "IUCollectionViewCell.h"

@interface IUCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation IUCollectionViewCell

- (void)setFilterName:(NSString *)filterName {
    _filterName = filterName;
    
    _label.text = filterName;
}

@end
