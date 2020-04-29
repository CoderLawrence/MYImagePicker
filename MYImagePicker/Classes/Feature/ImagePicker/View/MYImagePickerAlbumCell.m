//
//  MYImagePickerAlbumCell.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerAlbumCell.h"

#import "MYAlbum.h"
#import "MYImagePickerMacro.h"
#import "UIColor+MYImagePicker.h"
#import "MYImagePickerManager.h"

@interface MYImagePickerAlbumCell ()

@property (nonatomic, strong) UIImageView *albumView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation MYImagePickerAlbumCell

//MARK: - 类方法
+ (CGFloat)height
{
    return 75;
}

//MARK: - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

//MARK: - getter && setter
- (UIImageView *)albumView
{
    if (_albumView == nil) {
        CGRect frame = CGRectMake(15, 15, 60, 60);
        _albumView = [[UIImageView alloc] initWithFrame:frame];
        [_albumView setBackgroundColor:MYHexColor(0xe5e5e5)];
        [_albumView.layer setMasksToBounds:YES];
        [_albumView.layer setCornerRadius:2];
    }
    
    return _albumView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        CGRect frame = CGRectMake(87, 25, MY_IMG_SCREEN_W - 87 - 15, 22);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
    
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        CGRect frame = CGRectMake(87, 47, MY_IMG_SCREEN_W - 87 - 15, 18);
        _countLabel = [[UILabel alloc] initWithFrame:frame];
        [_countLabel setTextAlignment:NSTextAlignmentLeft];
        [_countLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        [_countLabel setTextColor:[UIColor blackColor]];
    }
    
    return _countLabel;
}

- (void)setAlbumModel:(MYAlbum *)albumModel
{
    _albumModel = albumModel;
    [self updateViews];
}

//MARK: - 视图更新
- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.albumView];
}

- (void)updateViews
{
    [self.titleLabel setText:self.albumModel.name];
    [self.countLabel setText:[NSString stringWithFormat:@"%ld", self.albumModel.count]];
    [[MYImagePickerManager shared] getPostImageWithAlbumModel:self.albumModel completion:^(UIImage *postImage) {
        self.albumView.image = postImage;
    }];
}

@end
