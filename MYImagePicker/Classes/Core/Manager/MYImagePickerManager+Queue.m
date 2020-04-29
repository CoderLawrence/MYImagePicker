//
//  MYImagePickerManager+Queue.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerManager+Queue.h"

static dispatch_queue_t ty_signleQueue(void)
{
    static dispatch_queue_t ty_queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ty_queue = dispatch_queue_create("com.lawrence.image_picker_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return ty_queue;
}

@implementation MYImagePickerManager (Queue)

+ (void)performMainThread:(void (^)(void))block
{
    if ([[NSThread currentThread] isMainThread]) {
        if (block) { block(); }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) { block(); }
        });
    }
}

+ (void)pefromAsynQueue:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

+ (void)pefromSingleAsynQueue:(void (^)(void))block
{
    dispatch_async(ty_signleQueue(), block);
}

@end
