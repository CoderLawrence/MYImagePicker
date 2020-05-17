//
//  MYImagePickerViewController.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerBaseViewController.h"
#import "MYImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;

@interface MYImagePickerViewController : MYImagePickerBaseViewController

/// 用户选中过的图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray<MYAsset *> *selectedModels;
@property (nonatomic, strong) NSMutableArray *selectedAssetIds;

/// 相关配置
@property (nonatomic, strong) MYImagePickerConfig *config;
/// 委托
@property (nonatomic, weak) id<MYImagePickerDelegate> delegate;

/// 初始化
- (instancetype)initWithConfig:(MYImagePickerConfig *)config
                      delegate:(id<MYImagePickerDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;

/////////////////////////////////////////////////////////////////////// 模块内部使用方法 //////////////////////////////////////////////////////////////////////////////
/// 添加选择图片
- (void)addSelectedModel:(MYAsset *)model;
/// 移除图片选择
- (void)removeSelectedModel:(MYAsset *)model;

/// 更新图片选择状态
- (void)refershAssetSelectedStatus;
/// 完成下一步选择
- (BOOL)handleDoneButtonClick;

@end

NS_ASSUME_NONNULL_END
