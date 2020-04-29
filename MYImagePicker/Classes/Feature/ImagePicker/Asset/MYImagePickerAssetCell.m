//
//  MYImagePickerAssetCell.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAssetCell.h"

#import "MYAsset.h"

#import <Photos/Photos.h>

#import "MYImagePickerMacro.h"
#import "UIView+MYLayout.h"
#import "UIColor+MYImagePicker.h"
#import "UIImage+MYBundle.h"

#import "MYImagePickerManager.h"
#import "MYImagePickerManager+Helper.h"

#import "MYImagePickerProgressView.h"

#import "MYImagePickerConfig.h"
#import "MYImagePickerViewController.h"

@interface MYImagePickerAssetCell ()

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) MYImagePickerProgressView *progressView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIImage *photoSelBtnImage;
@property (nonatomic, strong) UIImage *photoDefBtnImage;

@property (nonatomic, assign) int32_t bigImageRequestID;

@end

@implementation MYImagePickerAssetCell

//MARK: - 类方法
+ (CGFloat)itemSpace
{
    return 2;
}

+ (CGSize)itemSize
{
    CGFloat itemWidth = (MY_IMG_SCREEN_W - 4 * [self itemSpace])/3;
    return CGSizeMake(itemWidth, itemWidth);
}

//MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:MYImageAssetPickeReloadNotificationKey object:nil];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.allowPreview) {
        self.selectedButton.frame = CGRectMake(self.myp_width - 44, 0, 44, 44);
    } else {
        self.selectedButton.frame = self.contentView.bounds;
    }
    
    [self.contentView bringSubviewToFront:_cannotSelectLayerButton];
    [self.contentView bringSubviewToFront:_selectedButton];
    [self.contentView bringSubviewToFront:_selectImageView];
    [self.contentView bringSubviewToFront:_indexLabel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: - getter && setter
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        [_imageView setBackgroundColor:MYHexColor(0xe5e5e5)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView)];
        [_imageView addGestureRecognizer:_tapGesture];
    }
    
    return _imageView;
}

- (UIButton *)selectedButton
{
    if (_selectedButton == nil) {
        CGRect frame = CGRectMake(self.myp_width - 44, 0, 44, 44);
        _selectedButton = [[UIButton alloc] initWithFrame:frame];
        [_selectedButton addTarget:self
                            action:@selector(onSelectedButtonClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectedButton;
}

- (UIImageView *)selectImageView
{
    if (_selectImageView == nil) {
        CGRect frame = CGRectMake(self.myp_width - (8 + 21), 8, 21, 21);
        _selectImageView = [[UIImageView alloc] initWithFrame:frame];
        [_selectImageView.layer setMasksToBounds:YES];
        [_selectImageView.layer setCornerRadius:21/2];
    }
    
    return _selectImageView;
}

- (UIButton *)cannotSelectLayerButton {
    if (_cannotSelectLayerButton == nil) {
        CGRect frame = CGRectMake(0, 0, self.myp_width, self.myp_height);
        UIButton *cannotSelectLayerButton = [[UIButton alloc] initWithFrame:frame];
        [self.contentView addSubview:cannotSelectLayerButton];
        _cannotSelectLayerButton = cannotSelectLayerButton;
    }
    
    return _cannotSelectLayerButton;
}

- (UILabel *)indexLabel
{
    if (_indexLabel == nil) {
        CGRect frame = CGRectMake(self.myp_width - (8 + 21), 8, 21, 21);
        _indexLabel = [[UILabel alloc] initWithFrame:frame];
        [_indexLabel setTextAlignment:NSTextAlignmentCenter];
        [_indexLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        [_indexLabel setTextColor:[UIColor whiteColor]];
        [_indexLabel setUserInteractionEnabled:NO];
        [_indexLabel.layer setMasksToBounds:YES];
        [_indexLabel.layer setCornerRadius:21/2];
        [_indexLabel setText:@"0"];
        [_indexLabel setHidden:YES];
    }
    
    return _indexLabel;
}

- (MYImagePickerProgressView *)progressView {
    if (_progressView == nil) {
        CGFloat progressXY = (self.myp_width - 20) / 2;
        _progressView = [[MYImagePickerProgressView alloc] init];
        _progressView.frame = CGRectMake(progressXY, progressXY, 20, 20);
        _progressView.hidden = YES;
        [self.contentView addSubview:_progressView];
    }
    return _progressView;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%zd", index];
    [self.contentView bringSubviewToFront:self.indexLabel];
}

- (void)setShowSelectBtn:(BOOL)showSelectBtn
{
    _showSelectBtn = showSelectBtn;
    BOOL selectable = [[MYImagePickerManager shared] isPhotoSelectableWithAsset:self.model.asset];
    if (!self.selectedButton.hidden) {
        self.selectedButton.hidden = !showSelectBtn || !selectable;
    }
    
    if (!self.selectImageView.hidden) {
        self.selectImageView.hidden = !showSelectBtn || !selectable;
    }
}

- (void)setAllowPreview:(BOOL)allowPreview {
    _allowPreview = allowPreview;
    if (allowPreview) {
        _imageView.userInteractionEnabled = NO;
        _tapGesture.enabled = NO;
    } else {
        _imageView.userInteractionEnabled = YES;
        _tapGesture.enabled = YES;
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
            [self hideProgressView];
            self.imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];
    
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    self.imageRequestID = imageRequestID;
    self.selectedButton.selected = model.isSelected;
    self.selectImageView.image = self.selectedButton.isSelected ? self.photoSelBtnImage : self.photoDefBtnImage;
    self.indexLabel.hidden = !self.selectedButton.isSelected;
    
    // 如果用户选中了该图片，提前获取一下大图
    if (model.isSelected) {
        [self requestBigImage];
    } else {
        [self cancelBigImageRequest];
    }
}

//MARK: - 视图更新
- (void)setupUI
{
    self.photoDefBtnImage = [UIImage myp_imageNamedFromBundle:@"MY_Photo_Sel_Icon"];
    self.photoSelBtnImage = [UIImage myp_imageWithColor:MYHexColor(0xDB8CFD)];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.selectImageView];
    [self.contentView addSubview:self.indexLabel];
}

//MARK: - 私有方法
- (void)requestBigImage
{
    if (_bigImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
    }
    
    _bigImageRequestID = [[MYImagePickerManager shared] requestImageDataForAsset:_model.asset completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        [self hideProgressView];
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (self.model.isSelected) {
            progress = progress > 0.02 ? progress : 0.02;;
            self.progressView.progress = progress;
            self.progressView.hidden = NO;
            self.imageView.alpha = 0.4;
            if (progress >= 1) {
                [self hideProgressView];
            }
        } else {
            // 快速连续点几次，会EXC_BAD_ACCESS...
            // *stop = YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self cancelBigImageRequest];
        }
    }];
}

- (void)cancelBigImageRequest
{
    if (_bigImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
    }
    [self hideProgressView];
}

- (void)hideProgressView
{
    if (_progressView) {
        self.progressView.hidden = YES;
        self.imageView.alpha = 1.0;
    }
}

- (void)reload:(NSNotification *)noti
{
    MYImagePickerViewController *imagePickerVC = (MYImagePickerViewController *)noti.object;
    
    if (self.model.isSelected) {
        self.index = [imagePickerVC.selectedAssetIds indexOfObject:self.model.asset.localIdentifier] + 1;
    }
    
    self.indexLabel.hidden = !self.selectedButton.isSelected;
    if (imagePickerVC.selectedModels.count >= imagePickerVC.config.maxImagesCount && !self.model.isSelected) {
        self.cannotSelectLayerButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        self.cannotSelectLayerButton.hidden = NO;
    } else {
        self.cannotSelectLayerButton.hidden = YES;
    }
}

//MARK: - 事件响应

/// 只在单选状态且allowPreview为NO时会有该事件
- (void)didTapImageView
{
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(NO);
    }
}

- (void)onSelectedButtonClick:(UIButton *)sender
{
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }
    
    self.selectImageView.image = sender.isSelected ? self.photoSelBtnImage : self.photoDefBtnImage;
    if (sender.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:self.selectImageView.layer type:MYOscillatoryAnimationToBigger];
          // 用户选中了该图片，提前获取一下大图
        [self requestBigImage];
    } else { // 取消选中，取消大图的获取
        [self cancelBigImageRequest];
    }
}

@end
