//
//  MYImagePickerProgressHUD.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/29.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerProgressHUD.h"

#import "UIView+MYLayout.h"

@interface MYImagePickerProgressHUD ()

@property (nonatomic, strong) UIView *HUDContainer;
@property (nonatomic, strong) UIActivityIndicatorView *HUDIndicatorView;

@end

@implementation MYImagePickerProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _HUDContainer.frame = CGRectMake((self.myp_width - 120) / 2, (self.myp_height - 90 - self.topMargin) / 2, 120, 90);
    _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
    _HUDLabel.frame = CGRectMake(0,40, 120, 50);
}

//MARK: - 视图更新
- (void)setupUI
{
    _HUDContainer = [[UIView alloc] init];
    _HUDContainer.layer.cornerRadius = 8;
    _HUDContainer.clipsToBounds = YES;
    _HUDContainer.backgroundColor = [UIColor blackColor];
    _HUDContainer.alpha = 0.7;
    
    _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    _HUDLabel = [[UILabel alloc] init];
    _HUDLabel.textAlignment = NSTextAlignmentCenter;
    _HUDLabel.font = [UIFont systemFontOfSize:15];
    _HUDLabel.textColor = [UIColor whiteColor];
    
    [_HUDContainer addSubview:_HUDLabel];
    [_HUDContainer addSubview:_HUDIndicatorView];
    [self addSubview:_HUDContainer];
}

- (void)showProgressHUD:(UIView *)forView
{
    [_HUDIndicatorView startAnimating];
    [forView addSubview:self];
    [forView bringSubviewToFront:self];
}

- (void)showProgressHUD
{
    [_HUDIndicatorView startAnimating];
    UIWindow *applicationWindow = [UIApplication sharedApplication].windows.lastObject;
    if (applicationWindow == nil) {
        if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)]) {
            applicationWindow = [[[UIApplication sharedApplication] delegate] window];
        } else {
            applicationWindow = [[UIApplication sharedApplication] keyWindow];
        }

    }
    
    [applicationWindow addSubview:self];
    [applicationWindow bringSubviewToFront:self];
}

- (void)hidProgressHUD
{
    [_HUDIndicatorView stopAnimating];
    [self removeFromSuperview];
}

@end
