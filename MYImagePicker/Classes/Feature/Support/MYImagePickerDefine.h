//
//  MYImagePickerDefine.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/28.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#ifndef MYImagePickerDefine_h
#define MYImagePickerDefine_h

/// 相册授权状态枚举
typedef NS_ENUM(NSUInteger, MYAlbumAuthorizationStatus) {
    /// 没有获取过授权
    MYAlbumAuthorizationStatusNotDetermined = 0,
    MYAlbumAuthorizationStatusRestricted = 1,
    /// 拒绝获取相册权限
    MYAlbumAuthorizationStatusDenied = 2,
    /// 已经获取相册权限
    MYAlbumAuthorizationStatusAuthorized = 3
};

/// 图片媒体类型
typedef NS_ENUM(NSUInteger, MYAssetModelMediaType) {
    MYAssetModelMediaTypePhoto = 0,
    MYAssetModelMediaTypeLivePhoto,
    MYAssetModelMediaTypePhotoGif,
    MYAssetModelMediaTypeVideo,
    MYAssetModelMediaTypeAudio
};

/// 相册更新通知key
FOUNDATION_EXPORT NSString *const MYImagePickerPhotoLibChangedNotificationKey;
FOUNDATION_EXPORT NSString *const MYImageAssetPickeReloadNotificationKey;

#endif /* MYImagePickerDefine_h */
