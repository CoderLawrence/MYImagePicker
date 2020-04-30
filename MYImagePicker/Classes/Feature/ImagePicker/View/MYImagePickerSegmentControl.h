//
//  MYImagePickerSegmentControl.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MYImagePickerSegmentItemIndex) {
    kMYImagePickerSegmentItemAlbum = 0,
    kMYImagePickerSegmentItemVideo = 1
};

@class MYImagePickerSegmentControl;
@protocol MYImagePickerSegmentControlDelegate <NSObject>

- (BOOL)canShowAlbumPage:(MYImagePickerSegmentControl *)segmentControl;
- (BOOL)canChangedSelectedItem:(MYImagePickerSegmentControl *)segmentControl;

@end

@interface MYImagePickerSegmentItem : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;
@property (nonatomic, assign) BOOL isSelected;

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                needArrowIcon:(BOOL)needArrowIcon;

- (void)showArrowAnimation:(BOOL)isSelected;

@end

@interface MYImagePickerSegmentControl : UIView

@property (nonatomic, assign) MYImagePickerSegmentItemIndex selectedIndex;
@property (nonatomic, copy) void (^onItmeClick)(NSUInteger selectedIndex);
@property (nonatomic, copy) void (^onShowAlbumClick)(BOOL shouldShow);

@property (nonatomic, weak) id<MYImagePickerSegmentControlDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame needVideoItem:(BOOL)needViedoItem;

/// 重置相册列表相关参数
- (void)restShouldShowAlbum;
/// 设置选中项
- (void)setSelectedIndex:(MYImagePickerSegmentItemIndex)selectedIndex;

@end

NS_ASSUME_NONNULL_END
