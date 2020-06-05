//
//  MYImagePickerAssetPreviewCell.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/27.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAssetPreviewCell.h"

#import "MYImagePickerPhotoPreviewView.h"

@interface MYImagePickerAssetPreviewCell ()

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation MYImagePickerAssetPreviewCell

//MARK: - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
    }
    
    return self;
}

//MARK: - 视图更新
- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewView.frame = self.bounds;
}

- (void)configSubviews {
    self.previewView = [[MYImagePickerPhotoPreviewView alloc] initWithFrame:CGRectZero];
    self.previewView.allowCrop = NO;
    [self.previewView setShowSelectBtn:YES];
    __weak typeof(self) weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.singleTapGestureBlock) {
            strongSelf.singleTapGestureBlock();
        }
    }];
    
    [self.previewView setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.imageProgressUpdateBlock) {
            strongSelf.imageProgressUpdateBlock(progress);
        }
    }];
    
    [self.previewView setDidSelectPhotoBlock:^(BOOL isSelected) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.didSelectPhotoBlock) {
            strongSelf.didSelectPhotoBlock(isSelected);
        }
    }];
    
    [self addSubview:self.previewView];
}

- (void)setModel:(MYAsset *)model {
    _previewView.model = model;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    [_previewView setIndex:index];
}

- (void)updateSelectedStatus
{
    [_previewView updateSelectedStatus];
}

@end
