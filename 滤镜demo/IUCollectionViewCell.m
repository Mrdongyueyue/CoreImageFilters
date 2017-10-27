//
//  IUCollectionViewCell.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "IUCollectionViewCell.h"

@interface IUCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation IUCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95].CGColor;
    self.layer.borderWidth = 2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
}

- (void)setFilterName:(NSString *)filterName {
    _filterName = filterName;
    
    _line.hidden = YES;
    NSString *className = [NSString stringWithFormat:@"%@ViewController", filterName];
    Class vc_class = NSClassFromString(className);
    NSDictionary *attribute = nil;
    
    if (vc_class) {
        attribute = @{
                      NSForegroundColorAttributeName : [UIColor whiteColor]
                      };
    } else {
        attribute = @{
                      NSStrikethroughStyleAttributeName : @(1),
                      NSStrikethroughColorAttributeName : [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.95],
                      NSForegroundColorAttributeName : [UIColor whiteColor]
                      };
    }
    _label.attributedText = [[NSAttributedString alloc] initWithString:filterName attributes:attribute];;
    
}

@end
