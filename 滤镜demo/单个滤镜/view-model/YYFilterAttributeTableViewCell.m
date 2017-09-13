//
//  YYFilterAttributeTableViewCell.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYFilterAttributeTableViewCell.h"
#import "YYFilterAttributeModel.h"

@interface YYFilterAttributeTableViewCell ()
@property (copy, nonatomic) void (^sliderDidChangeBlock)(void);
@end

@implementation YYFilterAttributeTableViewCell {
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UISlider *sliderView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsZero;
    sliderView.continuous = NO;
}

- (void)setModel:(YYFilterAttributeModel *)model {
    _model = model;
    nameLabel.text = model.attributeName;
    sliderView.value = model.value;
    sliderView.maximumValue = model.maxValue;
    sliderView.minimumValue = model.minValue;
    
}

- (IBAction)sliderValueDidChange:(UISlider *)sender {
    _model.value = sender.value;
    if (_sliderDidChangeBlock) {
        _sliderDidChangeBlock();
    }
}

- (void)sliderDidChange:(void (^)(void))block {
    _sliderDidChangeBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
