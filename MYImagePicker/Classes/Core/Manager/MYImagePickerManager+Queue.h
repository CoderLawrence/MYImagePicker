//
//  MYImagePickerManager+Queue.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYImagePickerManager (Queue)

///.从其他线程回到主线程
+ (void)performMainThread:(void (^)(void))block;
/// 切换到全局并发队列
+ (void)pefromAsynQueue:(void (^)(void))block;
/// 自定义队列
+ (void)pefromSingleAsynQueue:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
