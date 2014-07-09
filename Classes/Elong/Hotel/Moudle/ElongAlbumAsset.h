//
//  ElongAlbumAsset.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ElongAlbumAsset;

@protocol ElongAlbumAssetDelegate <NSObject>

@optional

- (void)assetSelected:(ElongAlbumAsset *)asset;
- (BOOL)shouldSelectAsset:(ElongAlbumAsset *)asset;

@end

@interface ElongAlbumAsset : NSObject

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id<ElongAlbumAssetDelegate> delegate;
@property (nonatomic, assign) BOOL selected;

- (id)initWithAsset:(ALAsset *)asset;

@end
