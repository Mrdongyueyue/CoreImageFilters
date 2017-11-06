//
//  YYDescriptionView.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/11/6.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYDescriptionView.h"
#import <Masonry.h>

@implementation YYDescriptionView {
    UITextView *_textView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    _textView = [[UITextView alloc] init];
    [self addSubview:_textView];
    _textView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.layer.shadowColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5].CGColor;
    _textView.layer.shadowOpacity = 0.8;
    _textView.layer.shadowOffset = CGSizeMake(2, 2);
    _textView.editable = NO;
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *bottomBarContaier = [[UIView alloc] init];
    [self addSubview:bottomBarContaier];
    [bottomBarContaier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
    }];
    
    UIView *bottomBar = [[UIView alloc] init];
    bottomBar.backgroundColor = [UIColor whiteColor];
    bottomBar.layer.cornerRadius = 2.5;
    bottomBar.layer.masksToBounds = YES;
    [bottomBarContaier addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, 5, 0));
        make.size.mas_equalTo(CGSizeMake(150, 5));
    }];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [bottomBarContaier addGestureRecognizer:swipe];
}

- (void)setText:(NSString *)text {
    _text = text;
    _textView.text = text;
}

- (void)show {
    
    if (!self.superview) {
        if (!_viewController) {
            return;
        }
        [_viewController.view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.trailing.mas_equalTo(-20);
            make.height.mas_equalTo((_viewController.view.bounds.size.width - 40) * 0.6);
            make.top.equalTo(_viewController.mas_topLayoutGuideBottom).offset(-(_viewController.view.bounds.size.width - 40) * 0.6);
        }];
        [_viewController.view layoutIfNeeded];
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewController.mas_topLayoutGuideBottom);
    }];
    
    [_viewController.view setNeedsUpdateConstraints];
    [_viewController.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.5  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_viewController.view layoutIfNeeded];
    } completion:nil ];
    
}

- (void)dismiss {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewController.mas_topLayoutGuideBottom).offset(-(_viewController.view.bounds.size.width - 40) * 0.6);
    }];
    
    [_viewController.view setNeedsUpdateConstraints];
    [_viewController.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.5  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_viewController.view layoutIfNeeded];
    } completion:nil ];
}

@end
