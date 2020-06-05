//
//  MYImagePickerPhotoPreviewViewController.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/26.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;
@class MYImagePickerViewController;

@interface MYImagePickerPhotoPreviewViewController : MYImagePickerBaseViewController

@property (nonatomic, strong) MYImagePickerViewController *imagePickerVC;

/// 所有图片模型数组
@property (nonatomic, strong) NSMutableArray<MYAsset *> *models;
/// 所有图片数组
@property (nonatomic, strong) NSMutableArray *photos;
/// 用户点击的图片的索引
@property (nonatomic, assign) NSInteger currentIndex;
/// 是否返回原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

/// 返回最新的选中图片数组
@property (nonatomic, copy) void (^backButtonClickBlock)(BOOL isSelectOriginalPhoto);

@end

NS_ASSUME_NONNULL_END
