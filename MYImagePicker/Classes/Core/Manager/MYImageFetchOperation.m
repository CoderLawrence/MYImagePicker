//
//  MYImageFetchOperation.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImageFetchOperation.h"

#import <Photos/PHAsset.h>

#import "MYImagePickerManager+Queue.h"

typedef void (^MYImageResultHandler)(UIImage *_Nonnull image);

@interface MYImageFetchOperation ()

@property (nonatomic, assign) PHImageRequestID requestID;

@end

@implementation MYImageFetchOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

//MARK: - 初始化
- (instancetype)initWithAsset:(PHAsset *)asset
                   completion:(MYImageRequestCompletedBlock)completionBlock
              progressHandler:(MYImageRequestProgressBlock)progressHandler
{
    self = [super init];
    self.asset = asset;
    self.completedBlock = completionBlock;
    self.progressBlock = progressHandler;
    _executing = NO;
    _finished = NO;
    return self;
}

//MARK: 方法重载
- (void)start
{
    self.executing = YES;
    int32_t imageRequestId = [[MYImagePickerManager shared] getPhotoWithAsset:self.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isDegraded) {
                if (self.completedBlock) {
                    self.completedBlock(photo, info, isDegraded);
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self done];
                });
            }
        });
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.progressBlock) {
                self.progressBlock(progress, error, stop, info);
            }
        });
    } networkAccessAllowed:YES];
    self.requestID = imageRequestId;
}

- (void)cancel
{
    @synchronized (self) {
        if (self.isFinished) return;
        [super cancel];
        
        if (self.asset && self.requestID != PHInvalidImageRequestID) {
            [[PHCachingImageManager defaultManager] cancelImageRequest:self.requestID];
            if (self.isExecuting) self.executing = NO;
            if (!self.isFinished) self.finished = YES;
        }
        
        [self reset];
    }
}

//MARK: - 私有方法
- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.asset = nil;
    self.completedBlock = nil;
    self.progressBlock = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
