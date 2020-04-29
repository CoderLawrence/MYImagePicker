//
//  MYImagePickerAlbumCell.h
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYAlbum;

@interface MYImagePickerAlbumCell : UITableViewCell

@property (nonatomic, strong) MYAlbum *albumModel;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
