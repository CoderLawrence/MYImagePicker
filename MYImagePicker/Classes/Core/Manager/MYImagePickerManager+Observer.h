//
//  MYImagePickerManager+Observer.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/22.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerManager (Observer)<PHPhotoLibraryChangeObserver>

- (void)registerPhotoChangeObserver;
- (void)unRegisterPhotoChangeObserver;

@end

NS_ASSUME_NONNULL_END
