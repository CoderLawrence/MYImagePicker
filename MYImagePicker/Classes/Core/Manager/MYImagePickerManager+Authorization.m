//
//  MYImagePickerManager+Authorization.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager+Authorization.h"
#import "MYImagePickerManager+Queue.h"
#import <Photos/Photos.h>

@implementation MYImagePickerManager (Authorization)

- (MYAlbumAuthorizationStatus)albumAuthorizationStatus
{
    return (MYAlbumAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

- (BOOL)authorizationStatusAuthorized
{
    if (self.isPreviewNetworkImage) {
        return YES;
    }
    NSInteger status = [PHPhotoLibrary authorizationStatus];
    if (status == 0) {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        [self requestAlbumAuthorizationStatus:nil];
    }
    
    return status == MYAlbumAuthorizationStatusAuthorized;
}

- (void)requestAlbumAuthorizationStatus:(MYAlbumAuthorizationStatusBlock)completionHandler
{
    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([self albumAuthorizationStatus]);
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callCompletionBlock();
        }];
    });
}

@end
