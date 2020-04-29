//
//  MYImagePickerVideoCell.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYAsset;

@interface MYImagePickerVideoCell : UICollectionViewCell

+ (CGFloat)itemSpace;
+ (CGSize)itemSize;

@property (nonatomic, strong) UIButton *cannotSelectLayerButton;

@property (nonatomic, strong) MYAsset *model;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) BOOL previewVideoTimeLimit;

@property (nonatomic, copy) void (^didConnotSelectButtonClick)(void);
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@end

NS_ASSUME_NONNULL_END
