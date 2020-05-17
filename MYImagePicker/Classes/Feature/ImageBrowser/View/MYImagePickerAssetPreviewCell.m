//
//  MYImagePickerAssetPreviewCell.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/27.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAssetPreviewCell.h"

#import <Photos/Photos.h>

#import "MYAsset.h"
#import "MYImagePicker.h"
#import "UIView+MYLayout.h"
#import "UIImage+MYBundle.h"
#import "UIColor+MYImagePicker.h"

#import "MYImagePickerProgressView.h"

#import "MYImagePickerManager.h"

@interface MYImagePickerAssetPreviewCell ()

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation MYImagePickerAssetPreviewCell

//MARK: - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
    }
    
    return self;
}

//MARK: - 视图更新
- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewView.frame = self.bounds;
}

- (void)configSubviews {
    self.previewView = [[MYImagePickerPhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.singleTapGestureBlock) {
            strongSelf.singleTapGestureBlock();
        }
    }];
    
    [self.previewView setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.imageProgressUpdateBlock) {
            strongSelf.imageProgressUpdateBlock(progress);
        }
    }];
    
    [self.previewView setDidSelectPhotoBlock:^(BOOL isSelected) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.didSelectPhotoBlock) {
            strongSelf.didSelectPhotoBlock(isSelected);
        }
    }];
    
    [self addSubview:self.previewView];
}

- (void)setModel:(MYAsset *)model {
    _previewView.model = model;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}

- (void)setScaleAspectFillCrop:(BOOL)scaleAspectFillCrop {
    _scaleAspectFillCrop = scaleAspectFillCrop;
    _previewView.scaleAspectFillCrop = scaleAspectFillCrop;
}

- (void)setCropRect:(CGRect)cropRect {
    _cropRect = cropRect;
    _previewView.cropRect = cropRect;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    [_previewView setIndex:index];
}

- (void)updateSelectedStatus
{
    [_previewView updateSelectedStatus];
}

@end

@interface MYImagePickerPhotoPreviewView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL isRequestingGIF;

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIImage *photoSelBtnImage;
@property (nonatomic, strong) UIImage *photoDefBtnImage;

@end

@implementation MYImagePickerPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        self.photoDefBtnImage = [UIImage myp_imageNamedFromBundle:@"MY_Photo_Sel_Icon"];
        self.photoSelBtnImage = [UIImage myp_imageWithColor:MYHexColor(0xDB8CFD)];
        [self addSubview:self.selectedButton];
        [self addSubview:self.selectImageView];
        [self addSubview:self.indexLabel];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [tap1 setDelegate:self];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        [tap2 setDelegate:self];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        [self configProgressView];
    }
    return self;
}

//MARK: - setter && getter
- (UIButton *)selectedButton
{
    if (_selectedButton == nil) {
        _selectedButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectedButton addTarget:self
                            action:@selector(onSelectedButtonClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectedButton;
}

- (UIImageView *)selectImageView
{
    if (_selectImageView == nil) {
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_selectImageView.layer setMasksToBounds:YES];
        [_selectImageView.layer setCornerRadius:21/2];
        [_selectImageView setUserInteractionEnabled:NO];
    }
    
    return _selectImageView;
}

- (UILabel *)indexLabel
{
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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

- (void)configProgressView {
    _progressView = [[MYImagePickerProgressView alloc] init];
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)setModel:(MYAsset *)model {
    _model = model;
    self.selectedButton.selected = model.isSelected;
    self.selectImageView.image = self.selectedButton.isSelected ? self.photoSelBtnImage : self.photoDefBtnImage;
    self.indexLabel.hidden = !self.selectedButton.isSelected;
    
    self.isRequestingGIF = NO;
    [_scrollView setZoomScale:1.0 animated:NO];
    if (model.mediaType == MYAssetModelMediaTypePhotoGif) {
        // 先显示缩略图
        [[MYImagePickerManager shared] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            self.imageView.image = photo;
            [self resizeSubviews];
            if (self.isRequestingGIF) {
                return;
            }
            // 再显示gif动图
            self.isRequestingGIF = YES;
            //TODO: 暂时不处理GIF图片
        } progressHandler:nil networkAccessAllowed:NO];
    } else {
        self.asset = model.asset;
    }
}

- (void)setAsset:(PHAsset *)asset {
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    _asset = asset;
    self.imageRequestID = [[MYImagePickerManager shared] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (![asset isEqual:self->_asset]) return;
        self.imageView.image = photo;
        [self resizeSubviews];
        
        if (self.imageView.myp_height && self.allowCrop) {
            CGFloat scale = MAX(self.cropRect.size.width / self.imageView.myp_width, self.cropRect.size.height / self.imageView.myp_height);
            if (self.scaleAspectFillCrop && scale > 1) { // 如果设置图片缩放裁剪并且图片需要缩放
                CGFloat multiple = self.scrollView.maximumZoomScale / self.scrollView.minimumZoomScale;
                self.scrollView.minimumZoomScale = scale;
                self.scrollView.maximumZoomScale = scale * MAX(multiple, 2);
                [self.scrollView setZoomScale:scale animated:YES];
            }
        }
        
        self->_progressView.hidden = YES;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (![asset isEqual:self->_asset]) return;
        self->_progressView.hidden = NO;
        [self bringSubviewToFront:self->_progressView];
        progress = progress > 0.02 ? progress : 0.02;
        self->_progressView.progress = progress;
        if (self.imageProgressUpdateBlock && progress < 1) {
            self.imageProgressUpdateBlock(progress);
        }
        
        if (progress >= 1) {
            self->_progressView.hidden = YES;
            self.imageRequestID = 0;
        }
    } networkAccessAllowed:YES];
    
    [self configMaximumZoomScale];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%zd", index];
    [self bringSubviewToFront:self.indexLabel];
}

- (void)setAllowCrop:(BOOL)allowCrop
{
    _allowCrop = allowCrop;
    [_selectedButton setHidden:allowCrop];
    [_selectImageView setHidden:allowCrop];
}

- (void)updateSelectedStatus
{
    self.indexLabel.hidden = !self.selectedButton.isSelected;
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.myp_origin = CGPointZero;
    _imageContainerView.myp_width = self.scrollView.myp_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.myp_height / self.scrollView.myp_width) {
        _imageContainerView.myp_height = floor(image.size.height / (image.size.width / self.scrollView.myp_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.myp_width;
        if (height < 1 || isnan(height)) height = self.myp_height;
        height = floor(height);
        _imageContainerView.myp_height = height;
        _imageContainerView.myp_centerY = self.myp_height / 2;
    }
    if (_imageContainerView.myp_height > self.myp_height && _imageContainerView.myp_height - self.myp_height <= 1) {
        _imageContainerView.myp_height = self.myp_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.myp_height, self.myp_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.myp_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.myp_height <= self.myp_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
    [self refreshScrollViewContentSize];
}

- (void)configMaximumZoomScale {
    _scrollView.maximumZoomScale = _allowCrop ? 4.0 : 2.5;
    
    if ([self.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)self.asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        // 优化超宽图片的显示
        if (aspectRatio > 1.5) {
            self.scrollView.maximumZoomScale *= aspectRatio / 1.5;
        }
    }
}

- (void)refreshScrollViewContentSize {
    if (_allowCrop) {
        // 1.7.2 如果允许裁剪,需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
        // 1.让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.myp_width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.myp_height, self.myp_height) - self.cropRect.size.height) / 2;
        CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.myp_height) + contentHeightAdd;
        _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
        _scrollView.alwaysBounceVertical = YES;
        // 2.让scrollView新增滑动区域（裁剪框左上角的图片部分）
        if (contentHeightAdd > 0 || contentWidthAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(10, 0, self.myp_width - 20, self.myp_height);
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.myp_width - progressWH) / 2;
    CGFloat progressY = (self.myp_height - progressWH) / 2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    
    CGRect frame = CGRectMake(self.myp_width - (15 + 21) - 10, 15, 21, 21);
    [_indexLabel setFrame:frame];
    [_selectImageView setFrame:frame];
    
    CGRect selBtnFrame = CGRectMake(self.myp_width - 50 - 10, 0, 50, 50);
    [_selectedButton setFrame:selBtnFrame];
    
    [self recoverSubviews];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}

//MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}

//MARK: - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.myp_width > _scrollView.contentSize.width) ? ((_scrollView.myp_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.myp_height > _scrollView.contentSize.height) ? ((_scrollView.myp_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

//MARK: - 事件响应
- (void)onSelectedButtonClick:(UIButton *)sender
{
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }

    self.selectImageView.image = sender.isSelected ? self.photoSelBtnImage : self.photoDefBtnImage;
    if (sender.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:self.selectImageView.layer type:MYOscillatoryAnimationToBigger];
    }
}

@end
