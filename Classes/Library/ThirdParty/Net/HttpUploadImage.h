//
//  HttpUploadImage.h
//  ElongClient
//
//  Created by chenggong on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

//#define HOTEL_UPLOAD_IMAGE_URL    @"http://192.168.14.68:8082/mtools/hotelImg"
#define HOTEL_UPLOAD_IMAGE_URL    @"http://mobile-api2011.elong.com/mtools/hotelImg"
//#define HOTEL_UPLOAD_IMAGE_URL    @"http://192.168.14.51/mtools/hotelImg"

typedef enum {
    ImageTypePNG = 0,
    ImageTypeJPEG
}ImageType;

@protocol HttpUploadImageDelegate;

@interface HttpUploadImage : NSObject

@property (nonatomic, assign) id<HttpUploadImageDelegate> delegate;
@property (nonatomic, assign) NSUInteger tag;

- (id)initWithParamsJsonString:(NSString *)params imageAssets:(ALAsset *)asset imageData:(NSData *)data;
- (void)startUpload;
- (void)stopUpload;

@end

@protocol HttpUploadImageDelegate <NSObject>

- (void)imageUploadDone:(NSIndexPath *)indexPath returnData:(NSMutableData *)data;
- (void)imageUploadError:(NSIndexPath *)indexPath error:(NSError *)error;

@end