//
//  MYAlbum.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYAlbum.h"
#import <Photos/Photos.h>
#import "MYImagePickerManager.h"

@implementation MYAlbum

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCameraRoll = NO;
    }
    
    return self;
}

//MARK: - 公开方法
- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets
{
    [self setResult:result needFetchAssets:needFetchAssets allowPickingImage:YES allowPickingVideo:NO];
}

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets allowPickingImage:(BOOL)allowPickingImage allowPickingVideo:(BOOL)allowPickingVideo
{
    if (result == nil) { return; }
    _results = result;
    if (needFetchAssets) {
        [self startFetchAssetWithAllowPickingImage:allowPickingImage allowPickingVideo:allowPickingVideo completion:nil];
    }
}

- (void)startFetchAssetWithAllowPickingImage:(BOOL)allowPickingImage allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(NSArray<MYAsset *> * _Nonnull))completion
{
    if ([self.models count] > 0) {
        if (completion) completion(self.models);
        return;
    }
    
    [[MYImagePickerManager shared] getAssetsFromFetchResult:self.results allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<MYAsset *> * _Nullable models) {
        if ([models count]) {
            self->_models = models;
        }
        
        if (completion) {
            completion(models);
        }
    }];
}

//MARK: - getter
- (NSString *)albumTitle
{
    if (_name) {
        return _name;
    }
    
    return @"";
}

@end
