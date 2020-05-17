# MYImagePicker

[![CI Status](https://img.shields.io/travis/zengqingsong/MYImagePicker.svg?style=flat)](https://travis-ci.org/zengqingsong/MYImagePicker)
[![Version](https://img.shields.io/cocoapods/v/MYImagePicker.svg?style=flat)](https://cocoapods.org/pods/MYImagePicker)
[![License](https://img.shields.io/cocoapods/l/MYImagePicker.svg?style=flat)](https://cocoapods.org/pods/MYImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/MYImagePicker.svg?style=flat)](https://cocoapods.org/pods/MYImagePicker)

## Introduce

MYImagePicker is a custom photo album component that supports the selection of images and videos.
Thanks: ![https://github.com/banchichen/TZImagePreviewController](https://github.com/banchichen/TZImagePreviewController)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objc
    MYImagePickerConfig *config = [MYImagePickerConfig defaultConfig];
    [[MYImagePicker imagePicker] showImagePicker:self config:config delegate:self];
```

## Requirements

iOS 8 or later. Requires ARC

## Installation

MYImagePicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MYImagePicker'
```

## Author

Lawrence, coderlawrence@163.com

## License

MYImagePicker is available under the MIT license. See the LICENSE file for more info.
