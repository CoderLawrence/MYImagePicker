//
//  MYImageFetchOperation.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

typedef void(^MYImageRequestCompletedBlock)(UIImage *photo, NSDictionary *info, BOOL isDegraded);
typedef void(^MYImageRequestProgressBlock)(double progress, NSError *error, BOOL *stop, NSDictionary *info);

@interface MYImageFetchOperation : NSOperation

@property (nonatomic, strong, nullable) PHAsset *asset;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@property (nonatomic, copy, nullable) MYImageRequestCompletedBlock completedBlock;
@property (nonatomic, copy, nullable) MYImageRequestProgressBlock progressBlock;

- (instancetype)initWithAsset:(PHAsset *)asset
                   completion:(MYImageRequestCompletedBlock)completionBlock
              progressHandler:(MYImageRequestProgressBlock)progressHandler;

- (void)done;

@end

NS_ASSUME_NONNULL_END
