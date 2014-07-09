//
//  ElongAlbumTablePicker.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ElongAlbumAsset.h"
#import "HotelUploadPhotosController.h"

@interface ElongAlbumTablePicker : DPNav<ElongAlbumAssetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *albumAssets;
@property (nonatomic, retain) HotelUploadPhotosController *uploader;

- (id)initWithAssetGroup:(ALAssetsGroup *)asGroup;

@end
