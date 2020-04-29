//
//  MYAsset.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/21.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYAsset.h"
#import <Photos/Photos.h>

@interface MYAsset ()

@property (nonatomic, strong, nullable) PHAsset *asset;

@end

@implementation MYAsset

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSelected = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarningInAssets)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (MYAsset *)assetWithPHAsset:(PHAsset *)asset
                    mediaType:(MYAssetModelMediaType)mediaType
{
    MYAsset *model = [[MYAsset alloc] init];
    if (asset == nil) {
        return model;
    }
    
    model.asset = asset;
    model.mediaType = mediaType;
    model.assetIdentifier = asset.localIdentifier;
    model.isSelected = NO;
    
    return model;
}

+ (MYAsset *)assetWithPHAsset:(PHAsset *)asset
                    mediaType:(MYAssetModelMediaType)mediaType
                   timeLength:(NSString *)timeLength
{
    MYAsset *model = [[MYAsset alloc] init];
    if (asset == nil) {
        return model;
    }
    
    model.asset = asset;
    model.mediaType = mediaType;
    model.assetIdentifier = asset.localIdentifier;
    model.timeLength = timeLength;
    model.isSelected = NO;
    
    return model;
}

- (void)didReceiveMemoryWarningInAssets
{
    self.assetImage = nil;
}

@end
