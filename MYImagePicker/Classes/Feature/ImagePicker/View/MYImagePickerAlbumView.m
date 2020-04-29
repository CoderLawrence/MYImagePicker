//
//  MYImagePickerAlbumView.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAlbumView.h"

#import "MYAlbum.h"

#import "MYImagePickerMacro.h"
#import "UIColor+MYImagePicker.h"

#import "MYImagePickerAlbumCell.h"

static NSString *const MYImagePIckerAllbumCellIdentifier = @"MYImagePIckerAllbumCellIdentifier";

@interface MYImagePickerAlbumView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation MYImagePickerAlbumView

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
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, 0, MY_IMG_SCREEN_W, 365);
        _tableView = [[UITableView alloc] initWithFrame:frame];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[MYImagePickerAlbumCell class] forCellReuseIdentifier:MYImagePIckerAllbumCellIdentifier];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    
    return _tableView;
}

- (UIView *)containerView
{
    if (_containerView == nil) {
        CGRect frame = CGRectMake(0, -365, MY_IMG_SCREEN_W, 365);
        _containerView = [[UIView alloc] initWithFrame:frame];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _containerView;
}

//MARK: - 视图更新
- (void)setupUI
{
    [self setupBackground];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.tableView];
    [self addContainerCornerMask];
    [self addTapGestureRecognizer];
}

- (void)setupBackground
{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
}

- (void)addContainerCornerMask
{
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds
                                                            byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                                  cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setBounds:self.containerView.bounds];
    [maskLayer setAnchorPoint:CGPointMake(0, 0)];
    [maskLayer setPath:[cornerPath CGPath]];
    [self.containerView.layer setMask:maskLayer];
}

- (void)addTapGestureRecognizer
{
    [self addTarget:self action:@selector(onMaskTapClick) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: - 公开方法
- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)show:(BOOL)isPackup animation:(BOOL)animation
{
    if (animation == NO) {
        [self setHidden:isPackup];
        return;
    }
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveEaseOut animations:^{
        CGRect frame = self.containerView.frame;
        if (isPackup) {
            frame.origin.y = -365;
        } else {
            frame.origin.y = 0;
        }
        
        [self.containerView setFrame:frame];
        CGFloat alpha = isPackup ? 0 : 0.2;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
    } completion:^(BOOL finished) {
        if (finished) {
            [self setHidden:isPackup];
        }
    }];
}

//MARK: - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MYImagePickerAlbumCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYImagePickerAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:MYImagePIckerAllbumCellIdentifier];
    MYAlbum *model = [self.albums objectAtIndex:indexPath.row];
    [cell setAlbumModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self show:YES animation:YES];
    MYAlbum *model = [self.albums objectAtIndex:indexPath.row];
    if (self.onClickAlbumItem) {
        self.onClickAlbumItem(model);
    }
}

//MARK: - 事件响应
- (void)onMaskTapClick
{
    [self show:YES animation:YES];
    if (self.onClickMaskDismiss) {
        self.onClickMaskDismiss();
    }
}

@end
