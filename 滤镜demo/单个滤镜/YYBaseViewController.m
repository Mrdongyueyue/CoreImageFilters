//
//  YYBaseViewController.m
//  滤镜demo
//
//  Created by 董知樾 on 2017/9/5.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYBaseViewController.h"
#import "YYFilterAttributeTableViewCell.h"

static NSString *YYFilterAttributeTableViewCellID = @"YYFilterAttributeTableViewCellID";

@interface YYBaseViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *optionsButton;

@property (nonatomic, strong) UITableView *optionsTableView;

@property (nonatomic, weak) NSLayoutConstraint *optionsTableViewBottom;

@end

@implementation YYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IU1"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [_imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *bottom = [_imageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    NSLayoutConstraint *leading = [_imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *trailing = [_imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    [NSLayoutConstraint activateConstraints:@[top, bottom, leading, trailing]];
    
    self.title = _filterName;
    _filter = [CIFilter filterWithName:_filterName];
    _context = [CIContext contextWithOptions:nil];
    NSLog(@"%@", _filter.attributes);
    
    [self createAttributesOption];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    _imageView.frame = self.view.bounds;
}


- (void)createAttributesOption {
    _optionsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _optionsTableView.delegate = self;
    _optionsTableView.dataSource = self;
    _optionsTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_optionsTableView];
    _optionsTableView.separatorColor = [UIColor whiteColor];
    [_optionsTableView registerNib:[UINib nibWithNibName:@"YYFilterAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:YYFilterAttributeTableViewCellID];
    
    {
        _optionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _optionsTableViewBottom = [_optionsTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:300];
        NSLayoutConstraint *leading = [_optionsTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
        NSLayoutConstraint *trailing = [_optionsTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
        NSLayoutConstraint *height = [_optionsTableView.heightAnchor constraintEqualToConstant:300];
        [NSLayoutConstraint activateConstraints:@[leading, trailing, _optionsTableViewBottom, height]];
    }
    
    _optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _optionsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_optionsButton setTitle:@"open" forState:UIControlStateNormal];
    [_optionsButton setTitle:@"close" forState:UIControlStateSelected];
    [_optionsButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _optionsButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _optionsButton.layer.cornerRadius = 3;
    _optionsButton.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95].CGColor;
    _optionsButton.layer.borderWidth = 2;
    _optionsButton.layer.masksToBounds = YES;
    _optionsButton.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    [self.view addSubview:_optionsButton];
    
    {
        _optionsButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *bottom = [_optionsButton.bottomAnchor constraintEqualToAnchor:_optionsTableView.topAnchor constant:-10];
        NSLayoutConstraint *trailing = [_optionsButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
//        NSLayoutConstraint *width = [_optionsButton.widthAnchor constraintEqualToConstant:60];
//        NSLayoutConstraint *height = [_optionsButton.heightAnchor constraintEqualToConstant:30];
        [NSLayoutConstraint activateConstraints:@[bottom, trailing]];
    }
    
}

- (void)optionButtonClick:(UIButton *)button {
    button.selected = !button.isSelected;
    CGFloat t_bottom = 0;
    if (button.isSelected) {
        t_bottom = 0;
    } else {
        t_bottom = 300;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _optionsTableViewBottom.constant = t_bottom;
        [self.view layoutIfNeeded];
    }];
}

//MARK:~~~~ UITableViewDataSource, UITableViewDelegate ~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filterAttributeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYFilterAttributeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YYFilterAttributeTableViewCellID forIndexPath:indexPath];
    cell.model = _filterAttributeModels[indexPath.row];
    __weak typeof(self)wself = self;
    [cell sliderDidChange:^{
        __strong typeof(wself) self = wself;
        [self refilter];
    }];
    
    return cell;
}

- (void)refilter {
    
}

@end
