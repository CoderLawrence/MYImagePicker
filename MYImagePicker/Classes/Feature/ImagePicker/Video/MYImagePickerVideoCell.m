//
//  MYImagePickerVideoCell.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerVideoCell.h"

#import <Photos/Photos.h>

#import "MYAsset.h"
#import "Masonry.h"

#import "MYImagePickerMacro.h"

#import "UIView+MYLayout.h"
#import "UIImage+MYBundle.h"
#import "UIColor+MYImagePicker.h"

#import "MYImagePickerManager.h"

@interface MYImagePickerVideoCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *playIcon;
@property (nonatomic, strong) UIView *alphaMaskView;

@end

@implementation MYImagePickerVideoCell

//MARK: - 类方法
+ (CGFloat)itemSpace
{
    return 4;
}

+ (CGSize)itemSize
{
    CGFloat itemWidth = (MY_IMG_SCREEN_W - 4 * [self itemSpace])/3;
    return CGSizeMake(itemWidth, itemWidth);
}

//MARK: - 生命周期
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
    if (_previewVideoTimeLimit) {
        [_cannotSelectLayerButton setFrame:self.bounds];
    }
    
    [self.contentView bringSubviewToFront:_alphaMaskView];
    [self.contentView bringSubviewToFront:_cannotSelectLayerButton];
    [self.contentView bringSubviewToFront:_timeLabel];
    [self.contentView bringSubviewToFront:_playIcon];
}

//MARK: - geeter && setter
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        CGRect frame = CGRectMake(0, 0, self.myp_width, self.myp_height);
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        [_imageView setBackgroundColor:[UIColor whiteColor]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setUserInteractionEnabled:NO];
    }
    
    return _timeLabel;
}

- (UIImageView *)playIcon
{
    if (_playIcon == nil) {
        _playIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_playIcon setImage:[UIImage myp_imageNamedFromBundle:@"MY_Video_Play_Icon"]];
        [_playIcon setUserInteractionEnabled:NO];
    }
    
    return _playIcon;
}

- (UIView *)alphaMaskView
{
    if (_alphaMaskView == nil) {
        CGRect frame = CGRectMake(0, 0, self.myp_width, self.myp_height);
        _alphaMaskView = [[UIView alloc] initWithFrame:frame];
        [_alphaMaskView setBackgroundColor:[UIColor blackColor]];
        [_alphaMaskView setAlpha:0.3f];
    }
    
    return _alphaMaskView;
}

- (UIButton *)cannotSelectLayerButton
{
    if (_cannotSelectLayerButton == nil) {
        CGRect frame = CGRectMake(0, 0, self.myp_width, self.myp_height);
        UIButton *cannotSelectLayerButton = [[UIButton alloc] initWithFrame:frame];
        [cannotSelectLayerButton addTarget:self
                                    action:@selector(onCannotSelectedButtonClick:)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cannotSelectLayerButton];
        _cannotSelectLayerButton = cannotSelectLayerButton;
    }
    
    return _cannotSelectLayerButton;
}

- (void)setPreviewVideoTimeLimit:(BOOL)previewVideoTimeLimit
{
    if (previewVideoTimeLimit) {
        self.cannotSelectLayerButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        self.cannotSelectLayerButton.hidden = NO;
    } else {
        self.cannotSelectLayerButton.hidden = YES;
    }
}

- (void)setModel:(MYAsset *)model
{
    _model = model;
    self.representedAssetIdentifier = model.asset.localIdentifier;
    int32_t imageRequestID = [[MYImagePickerManager shared] getPhotoWithAsset:model.asset photoWidth:self.myp_width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        // Set the cell's thumbnail image if it's still showing the same asset.
        if ([self.representedAssetIdentifier isEqualToString:model.asset.localIdentifier]) {
            self.imageView.image = photo;
        } else {
            // NSLog(@"this cell is showing other asset");
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
        //     [self hideProgressView];
            self.imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];
           
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    [self.timeLabel setText:self.model.timeLength];
}

//MARK: - 视图更新
- (void)setupUI
{
    [self setupBackground];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.alphaMaskView];
    [self.contentView addSubview:self.playIcon];
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-2);
        make.height.mas_equalTo(@18.0f);
    }];
    
    [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-3);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.height.mas_equalTo(CGSizeMake(10, 13));
    }];
}

- (void)setupBackground
{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.contentView.layer.cornerRadius = 4.0f;
    self.contentView.layer.masksToBounds = YES;
}

//MARK: - 事件响应
- (void)onCannotSelectedButtonClick:(UIButton *)sender
{
    if (self.didConnotSelectButtonClick) {
        self.didConnotSelectButtonClick();
    }
}

@end
