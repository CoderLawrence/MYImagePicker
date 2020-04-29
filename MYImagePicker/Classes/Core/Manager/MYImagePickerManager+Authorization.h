//
//  MYImagePickerManager+Authorization.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager.h"
#import "MYImagePickerDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^MYAlbumAuthorizationStatusBlock)(MYAlbumAuthorizationStatus status);

@interface MYImagePickerManager (Authorization)

/// 相册当前授权状态
- (MYAlbumAuthorizationStatus)albumAuthorizationStatus;
/// 判断相册是否授权
- (BOOL)authorizationStatusAuthorized;
/// 申请相册授权
- (void)requestAlbumAuthorizationStatus:(_Nullable MYAlbumAuthorizationStatusBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
