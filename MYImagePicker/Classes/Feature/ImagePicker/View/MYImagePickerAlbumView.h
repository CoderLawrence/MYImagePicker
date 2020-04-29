//
//  MYImagePickerAlbumView.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYAlbum;

@interface MYImagePickerAlbumView : UIControl

/// 相册数据
@property (nonatomic, strong) NSArray<MYAlbum *> *albums;
@property (nonatomic, copy) void (^onClickAlbumItem)(MYAlbum *albumTtem);
@property (nonatomic, copy) void (^onClickMaskDismiss)(void);

/// 刷新数据
- (void)reloadData;
- (void)show:(BOOL)isPackup animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
