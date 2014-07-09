//
//  HotelUploadPhotosController.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "HttpUploadImage.h"
#import "HotelUploadImageCell.h"

@interface HotelUploadPhotosController : DPNav<UITableViewDelegate, UITableViewDataSource, HttpUploadImageDelegate, HotelUploadImageCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) BOOL withRoomId;

- (id)initWithAssets:(NSArray *)assetsArray;
- (NSString *)addWithAssets:(NSArray *)assetsArray;

@end
