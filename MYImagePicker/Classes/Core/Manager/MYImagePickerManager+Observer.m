//
//  MYImagePickerManager+Observer.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/22.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager+Observer.h"
#import "MYImagePickerDefine.h"
#import "MYImagePickerManager+Queue.h"

@implementation MYImagePickerManager (Observer)

//MARK: - 公开方法
- (void)registerPhotoChangeObserver
{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)unRegisterPhotoChangeObserver
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

//MARK: - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [[self class] performMainThread:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MYImagePickerPhotoLibChangedNotificationKey object:nil];
    }];
}

@end
