//
//  MYImagePickerSegmentControl.m
//  MYImagePicker
//
//  Created by Lawrence on 2020/4/23.
//  Copyright © 2020 Lawrence. All rights reserved.
//

#import "MYImagePickerSegmentControl.h"

#import "Masonry.h"

#import "UIImage+MYBundle.h"
#import "UIView+MYLayout.h"
#import "UIColor+MYImagePicker.h"

@interface MYImagePickerSegmentItem ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL needArrowIcon;

@end

@implementation MYImagePickerSegmentItem

//MARK: - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                needArrowIcon:(BOOL)needArrowIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _needArrowIcon = needArrowIcon;
        [self setupUI];
    }
    
    return self;
}

//MARK: - getter && setter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        _titleLabel.textAlignment = NSTextAlignmentJustified;
        [_titleLabel setTextColor:[UIColor myp_colorWithHexNumber:0x999999]];
        [_titleLabel setUserInteractionEnabled:NO];
    }
    
    return _titleLabel;
}

- (UIImageView *)arrowIcon
{
    if (_arrowIcon == nil) {
        CGRect frame = CGRectMake(0, 0, 14, 14);
        _arrowIcon = [[UIImageView alloc] initWithFrame:frame];
        [_arrowIcon setImage:[UIImage myp_imageNamedFromBundle:@"MY_Arrow_Icon_Normal"]];
        [_arrowIcon setUserInteractionEnabled:NO];
    }
    
    return _arrowIcon;
}

//MAR: - 视图更新
- (void)setupUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.titleLabel];
    [self.titleLabel setText:self.title];
    
    if (_needArrowIcon == YES) {
        [self addSubview:self.arrowIcon];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX).offset(-8);
            make.height.mas_equalTo(@16.0f);
        }];
        
        [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(2);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(@16.0f);
        }];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    UIColor *titleColor = isSelected ? MYHexColor(0x333333) : MYHexColor(0x999999);
    [self.titleLabel setTextColor:titleColor];
    if (_needArrowIcon) {
        NSString *imageName = isSelected ? @"MY_Arrow_Icon_High" : @"MY_Arrow_Icon_Normal";
        UIImage *image = [UIImage myp_imageNamedFromBundle:imageName];
        [self.arrowIcon setImage:image];
    }
}

- (void)showArrowAnimation:(BOOL)isSelected
{
    [UIView animateWithDuration:0.25f animations:^{
        self.arrowIcon.transform = isSelected ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    }];
}

@end

@interface MYImagePickerSegmentControl ()
{
    BOOL _shouldShowAlbum;
    BOOL _needViedoItem;
}

@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) MYImagePickerSegmentItem *albumItem;
@property (nonatomic, strong) MYImagePickerSegmentItem *videoItem;

@end

@implementation MYImagePickerSegmentControl

//MARK: - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _needViedoItem = YES;
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                needVideoItem:(BOOL)needViedoItem
{
    self = [super initWithFrame:frame];
    if (self) {
        _needViedoItem = needViedoItem;
        [self setupUI];
    }
    
    return self;
}

//MARK: - getter && setter
- (MYImagePickerSegmentItem *)albumItem
{
    if (_albumItem == nil) {
        CGRect frame = CGRectMake(0, 0, 136/2, 23);
        _albumItem = [[MYImagePickerSegmentItem alloc] initWithFrame:frame
                                                               title:@"照片"
                                                       needArrowIcon:YES];
        [_albumItem addTarget:self
                       action:@selector(onAlbumItemClick)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _albumItem;
}

- (MYImagePickerSegmentItem *)videoItem
{
    if (_videoItem == nil) {
        CGRect frame = CGRectMake(0, 0, 136/2, 23);
        _videoItem = [[MYImagePickerSegmentItem alloc] initWithFrame:frame
                                                               title:@"视频"
                                                       needArrowIcon:NO];
        [_videoItem addTarget:self
                       action:@selector(onVideoItemClick)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _videoItem;
}

- (UIView *)indicator
{
    if (_indicator == nil) {
        CGFloat indicatorLeft = (CGRectGetWidth(self.frame)/2 - 10)/2;
        CGRect frame = CGRectMake(indicatorLeft, CGRectGetHeight(self.frame) - 2, 10, 2);
        _indicator = [[UIView alloc] initWithFrame:frame];
        [_indicator setBackgroundColor:[UIColor blackColor]];
        [_indicator setUserInteractionEnabled:NO];
    }
    
    return _indicator;
}

//MARK: - 视图更新
- (void)setupUI
{
    [self setBackground];
    [self addSubview:self.albumItem];
    [self addSubview:self.indicator];
    [self.albumItem setIsSelected:YES];
    
    if (self->_needViedoItem) {
        [self addSubview:self.videoItem];
        [self.albumItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(136/2, 23));
        }];
        
        [self.videoItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.albumItem.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(136/2, 23));
        }];
    } else {
        CGRect indicatorFrame = self.indicator.frame;
        indicatorFrame.origin.x = (self.myp_width - 10)/2;
        [self.indicator setFrame:indicatorFrame];
        [self.albumItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(136/2, 23));
        }];
    }
    
    [self bringSubviewToFront:self.indicator];
}

- (void)setBackground
{
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)showIndicatorAnimaton
{
    CGFloat indicatorLeft = (CGRectGetWidth(self.frame)/2 - 10)/2;
    if (self.selectedIndex == kMYImagePickerSegmentItemVideo) {
        indicatorLeft += CGRectGetWidth(self.frame)/2;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.indicator.frame;
        frame.origin.x = indicatorLeft;
        [self.indicator setFrame:frame];
    }];
}

//MARK: - 公开方法
- (void)setSelectedIndex:(MYImagePickerSegmentItemIndex)selectedIndex
{
    if (selectedIndex != _selectedIndex) {
        if ([self canChangedItem] == NO) { return; }
        _selectedIndex = selectedIndex;
        if (selectedIndex == kMYImagePickerSegmentItemAlbum) {
            [self.albumItem setIsSelected:YES];
            [self.videoItem setIsSelected:NO];
        } else {
            [self.albumItem setIsSelected:NO];
            [self.videoItem setIsSelected:YES];
        }
        
        if (self.onItmeClick) {
            self.onItmeClick(selectedIndex);
        }
        
        [self showIndicatorAnimaton];
    }
}

- (void)restShouldShowAlbum
{
    self->_shouldShowAlbum = NO;
    [self.albumItem showArrowAnimation:NO];
}

//MARK: - 私有方法
- (BOOL)canChangedItem
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(canChangedSelectedItem:)]) {
        return [self.delegate canChangedSelectedItem:self];
    }
    
    return YES;
}

- (BOOL)canShowAlbum
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(canShowAlbumPage:)]) {
        return [self.delegate canShowAlbumPage:self];
    }
    
    return NO;
}

//MARK: - 事件响应
- (void)onAlbumItemClick
{
    BOOL canShowAlbum = [self canShowAlbum];
    if (self.selectedIndex == kMYImagePickerSegmentItemAlbum && canShowAlbum) {
        self->_shouldShowAlbum = !self->_shouldShowAlbum;
        if (self.onShowAlbumClick) {
            self.onShowAlbumClick(self->_shouldShowAlbum);
        }
                   
        [self.albumItem showArrowAnimation:self->_shouldShowAlbum];
        return;
    }
    
    [self setSelectedIndex:kMYImagePickerSegmentItemAlbum];
}

- (void)onVideoItemClick
{
    if (self->_shouldShowAlbum == YES) {
        self->_shouldShowAlbum = NO;
        if (self.onShowAlbumClick) {
            self.onShowAlbumClick(self->_shouldShowAlbum);
        }
                   
        [self.albumItem showArrowAnimation:self->_shouldShowAlbum];
        return;
    }
    
    [self setSelectedIndex:kMYImagePickerSegmentItemVideo];
}

- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}

@end
