//
//  HotelPhotoViewController.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureThumbnails.h"

typedef enum {
    HotelPhotoTypeNativeHotel,          // 国内酒店缩略图
    HotelPhotoTypeInterHotel            // 国际酒店缩略图
}HotelPhotoType;                        // 酒店缩略图类型

@interface HotelPhotoViewController : DPNav<PictureThumbnailsDelegate>{
@private
    int photoCount;
    
    HotelPhotoType photoType;
    NSMutableArray *bigImageUrls;      // 存放大图url的数组
}

- (id)initFromType:(HotelPhotoType)type;

@end
