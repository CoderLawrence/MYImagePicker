//
//  MYImagePickerAssetPreviewCell.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/27.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;
@class MYImagePickerProgressView;
@class MYImagePickerPhotoPreviewView;

@interface MYImagePickerAssetPreviewCell : UICollectionViewCell

@property (nonatomic, strong) MYImagePickerPhotoPreviewView *previewView;
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL isSelected);

@property (nonatomic, strong) MYAsset *model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) BOOL scaleAspectFillCrop;

- (void)updateSelectedStatus;

@end

@interface MYImagePickerPhotoPreviewView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) MYImagePickerProgressView *progressView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) BOOL scaleAspectFillCrop;
@property (nonatomic, strong) MYAsset *model;
@property (nonatomic, strong) id asset;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL isSelected);

@property (nonatomic, assign) int32_t imageRequestID;

- (void)recoverSubviews;
- (void)updateSelectedStatus;

@end

NS_ASSUME_NONNULL_END
