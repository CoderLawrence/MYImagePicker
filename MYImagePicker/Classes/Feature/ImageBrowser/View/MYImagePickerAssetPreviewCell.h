//
//  MYImagePickerAssetPreviewCell.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/27.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYImagePickerPhotoPreviewView.h"

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;

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

NS_ASSUME_NONNULL_END
