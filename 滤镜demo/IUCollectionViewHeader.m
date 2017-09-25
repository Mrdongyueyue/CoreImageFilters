//
//  IUCollectionViewHeader.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/25.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "IUCollectionViewHeader.h"

@implementation IUCollectionViewHeader {
    __weak IBOutlet UILabel *label;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    label.text = categoryName;
}


@end
