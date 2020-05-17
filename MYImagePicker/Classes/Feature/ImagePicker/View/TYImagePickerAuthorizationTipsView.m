//
//  MYImagePickerAuthorizationTipsView.m
//  TYImagePicker
//
//  Created by Lawrence on 2020/5/13.
//  Copyright © 2020 MYImagePicker. All rights reserved.
//

#import "MYImagePickerAuthorizationTipsView.h"

#import "UIView+MYLayout.h"
#import "UIColor+MYImagePicker.h"

@interface MYImagePickerAuthorizationTipsView ()

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation MYImagePickerAuthorizationTipsView

//MARK: - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

//MARK: - getter && setter
- (UILabel *)tipsLabel
{
    if (_tipsLabel == nil) {
        CGRect frame = CGRectMake(8, 120, self.typ_width - 16, 60);
        _tipsLabel = [[UILabel alloc] initWithFrame:frame];
        [_tipsLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipsLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        [_tipsLabel setTextColor:TYHexColor(0x999999)];
        [_tipsLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_tipsLabel setNumberOfLines:0];
        [_tipsLabel setText:@"请在iPhone的\"设置-隐私-照片\"选项中，允许访问你的手机相册"];
    }
    
    return _tipsLabel;
}

- (UIButton *)settingButton
{
    if (_settingButton == nil) {
        CGRect frame = CGRectMake(0, 180, self.typ_width, 44);
        _settingButton = [[UIButton alloc] initWithFrame:frame];
        [_settingButton addTarget:self
                           action:@selector(onSettingButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:TYHexColor(0x3333333) forState:UIControlStateNormal];
        [_settingButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
        _settingButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    return _settingButton;
}

//MARK: - 视图更新
- (void)setupUI
{
    [self addSubview:self.tipsLabel];
    [self addSubview:self.settingButton];
    [self setBackgroundColor:TYHexColor(0xffffff)];
}

//MARK: - 事件点击
- (void)onSettingButtonClick:(UIButton *)sender
{
    if (self.onSettingButtonClick) {
        self.onSettingButtonClick();
    }
}

@end
