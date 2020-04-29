//
//  MYImagePickerAssetLayout.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAssetLayout.h"

#import "MYImagePickerAssetCell.h"

@implementation MYImagePickerAssetLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = [MYImagePickerAssetCell itemSize];
        self.minimumInteritemSpacing = [MYImagePickerAssetCell itemSpace];
        self.minimumLineSpacing = [MYImagePickerAssetCell itemSpace];
    }
    
    return self;
}

@end
