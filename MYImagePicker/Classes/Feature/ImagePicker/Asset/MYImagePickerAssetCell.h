//
//  MYImagePickerAssetCell.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;

@interface MYImagePickerAssetCell : UICollectionViewCell

@property (nonatomic, strong) MYAsset *model;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) BOOL showSelectBtn;
@property (nonatomic, assign) BOOL allowPreview;

@property (nonatomic, strong) UIButton *selectedButton;
@property (weak, nonatomic) UIButton *cannotSelectLayerButton;

@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL isSelected);
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

+ (CGFloat)itemSpace;
+ (CGSize)itemSize;

@end

NS_ASSUME_NONNULL_END
