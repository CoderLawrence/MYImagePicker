//
//  MYImagePickerVideoLayout.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/24.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerVideoLayout.h"

#import "MYImagePickerVideoCell.h"

@implementation MYImagePickerVideoLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = [MYImagePickerVideoCell itemSize];
        self.minimumInteritemSpacing = [MYImagePickerVideoCell itemSpace];
        self.minimumLineSpacing = [MYImagePickerVideoCell itemSpace];
    }
    
    return self;
}

@end
