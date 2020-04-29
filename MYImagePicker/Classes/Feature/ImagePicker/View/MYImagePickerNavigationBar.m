//
//  MYImagePickerNavigationBar.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerNavigationBar.h"

#import "MYImagePickerMacro.h"
#import "UIImage+MYBundle.h"
#import "UIColor+MYImagePicker.h"

@interface MYImagePickerNavigationBar ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation MYImagePickerNavigationBar

//MARK: - 类方法
+ (CGFloat)height
{
    return MY_IMG_IPHONE_X ? 84 : 64;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        CGFloat buttonTop = MY_IMG_Navigation_Top + (40 - 32)/2;
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIEdgeInsets insets = UIEdgeInsetsMake(0, -10, 0, 10);;
        [_backButton setImageEdgeInsets:insets];
        [_backButton setFrame:CGRectMake(16, buttonTop, 44, 32)];
        [_backButton setImage:[UIImage myp_imageNamedFromBundle:@"MY_Navi_Back"] forState:UIControlStateNormal];
    }
    
    return _backButton;
}

- (UIButton *)nextButton
{
    if (_nextButton == nil) {
        CGFloat buttonTop = MY_IMG_Navigation_Top + (40 - 25)/2;
        CGFloat buttonLeft = MY_IMG_SCREEN_W - 16 - 64;
        CGRect frame = CGRectMake(buttonLeft, buttonTop, 64, 25);
        _nextButton = [[UIButton alloc] initWithFrame:frame];
        [_nextButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:11]];
        [_nextButton setTitleColor:[UIColor myp_colorWithHexNumber:0xffffff] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage myp_imageWithColor:MYHexColor(0xDB8CFD)] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage myp_imageWithColor:MYHexColor(0xDB8CFD)] forState:UIControlStateHighlighted];
        [_nextButton setTitle:@"下一步(0)" forState:UIControlStateNormal];
        [_nextButton.layer setMasksToBounds:YES];
        [_nextButton.layer setCornerRadius:25/2];
    }
    
    return _nextButton;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        CGFloat lineTop = [[self class] height] - 0.5;
        CGRect frame = CGRectMake(0, lineTop, MY_IMG_SCREEN_W, 0.5);
        _lineView = [[UIView alloc] initWithFrame:frame];
        [_lineView setBackgroundColor:[UIColor myp_colorWithHexNumber:0xe7e7e7]];
    }
    
    return _lineView;
}

//MARK: - 视图更新
- (void)setupUI
{
    [self addSubview:self.backButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.lineView];
    [self setBackgroundColor:[UIColor whiteColor]];
}

@end
