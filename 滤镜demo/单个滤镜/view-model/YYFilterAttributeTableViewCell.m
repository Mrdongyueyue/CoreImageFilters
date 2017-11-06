//
//  YYFilterAttributeTableViewCell.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/9.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYFilterAttributeTableViewCell.h"
#import "YYFilterAttributeModel.h"

@interface YYFilterAttributeTableViewCell ()<UITextFieldDelegate>
@property (copy, nonatomic) void (^sliderDidChangeBlock)(void);
@end

@implementation YYFilterAttributeTableViewCell {
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *minLabel;
    __weak IBOutlet UILabel *maxLabel;
    __weak IBOutlet UISlider *sliderView;
    __weak IBOutlet UITextField *valueTextField;
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
    minLabel.text = [NSString stringWithFormat:@"%d",(int)model.minValue];
    maxLabel.text = [NSString stringWithFormat:@"%d",(int)model.maxValue];
    valueTextField.text = [NSString stringWithFormat:@"%.2f",model.value];
    sliderView.value = model.value;
    sliderView.maximumValue = model.maxValue;
    sliderView.minimumValue = model.minValue;
    
}

- (IBAction)sliderValueDidChange:(UISlider *)sender {
    _model.value = sender.value;
    valueTextField.text = [NSString stringWithFormat:@"%.2f",_model.value];
    if (_sliderDidChangeBlock) {
        _sliderDidChangeBlock();
    }
}

- (void)sliderDidChange:(void (^)(void))block {
    _sliderDidChangeBlock = block;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        _model.value = textField.text.floatValue;
        [textField resignFirstResponder];
        if (_sliderDidChangeBlock) {
            _sliderDidChangeBlock();
        }
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
