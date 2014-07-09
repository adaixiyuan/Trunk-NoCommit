//
//  HotelThumbnailVC.h
//  ElongClient
//
//  Created by bruce on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "QStreetViewKit.h"
#import "QMapKit.h"

@interface HotelThumbnailVC : DPNav <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,QReverseGeocoderDelegate,QOverViewRequestDelegate>{
    UIAlertView *wifiAlertView;
}


@property (nonatomic, strong) NSArray *arrayAllImgs;           // 所有图片
@property (nonatomic, strong) NSArray *guestRoomImgs;          // 客房图片
@property (nonatomic, strong) NSArray *exteriorImgs;           // 外观图片
@property (nonatomic, strong) NSArray *receptionImgs;          // 前台图片
@property (nonatomic, strong) NSArray *otherImgs;              // 设施图片
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, strong) NSString *hotelName;
@property(nonatomic, strong) QReverseGeocoder* streetViewPoiRequest;
@property(nonatomic, strong) UIImageView* overViewImageView;
@property(nonatomic, strong) QOverViewRequest* overViewRequest;

- (id)initWithTitle:(NSString *)title;

- (id) initWithTitle:(NSString *)title lat:(float) lat lng:(float)lng hotelName:(NSString *)hotelName;

@end
