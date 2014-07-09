//
//  HotelPhotoViewController.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelPhotoViewController.h"
#import "PictureThumbnails.h"
#import "HotelDetailController.h"
#import "InterHotelDetailCtrl.h"
#import "FullImageView.h"

@interface HotelPhotoViewController ()

@end

@implementation HotelPhotoViewController


- (void)dealloc {
    [bigImageUrls release];
    
    [super dealloc];
}

- (id)initFromType:(HotelPhotoType)type {
    if (self = [super initWithTopImagePath:@"" andTitle:@"酒店图片" style:_NavOnlyBackBtnStyle_]) {
        photoType = type;
        bigImageUrls = [[NSMutableArray alloc] init];
        
        [self makeUI];
        
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    }
    
    return self;
}

- (void)makeUI
{
    if (UMENG) {
        // 酒店图片页面
        [MobClick event:Event_HotelPhoto];
    }
    
    UILabel *leftTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 260, 30)];
    leftTipsLbl.font = [UIFont systemFontOfSize:14.0f];
    leftTipsLbl.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    leftTipsLbl.backgroundColor = [UIColor clearColor];
    leftTipsLbl.adjustsFontSizeToFitWidth = YES;
    leftTipsLbl.minimumFontSize = 12;
    [self.view addSubview:leftTipsLbl];
    [leftTipsLbl release];
    
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, 30)];
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    tipsLbl.textAlignment = UITextAlignmentRight;
    tipsLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLbl];
    [tipsLbl release];
    
    NSMutableArray *thumbnailUrls = nil;        // 缩略图数组
    PictureThumbnails *thumbnails = nil;
    if (photoType == HotelPhotoTypeNativeHotel) {
        // 国内酒店
        NSArray *smallPicArray = [[HotelDetailController hoteldetail] safeObjectForKey:@"SmallPicUrls"];
        if (ARRAYHASVALUE(smallPicArray)) {
            thumbnailUrls = [NSMutableArray arrayWithArray:smallPicArray];      // 添加小图
        }
        
        NSArray *orgImageArray = [[HotelDetailController hoteldetail] safeObjectForKey:HOTEL_IMAGE_ITEMS];
        if (ARRAYHASVALUE(orgImageArray)) {
            for (NSDictionary *dic in orgImageArray) {
                if (DICTIONARYHASVALUE(dic)) {
                    [bigImageUrls addObject:dic];                 // 添加大图
                }
            }
        }
        
        leftTipsLbl.text = @"酒店真实图片";
    }
    else {
        // 国外酒店
        NSDictionary *dic = [[InterHotelDetailCtrl detail] safeObjectForKey:@"ImageInfo"];
        if (DICTIONARYHASVALUE(dic)) {
            NSMutableArray *imageArray = [dic safeObjectForKey:@"Items"];
            thumbnailUrls = [NSMutableArray array];
            if (ARRAYHASVALUE(imageArray)) {
                for (NSDictionary *item in imageArray) {
                    NSString *url = [item safeObjectForKey:@"ThumbnailUrl"];
                    if (STRINGHASVALUE(url)) {
                        [thumbnailUrls addObject:url];      // 添加缩略图url
                    }
                    url = [item safeObjectForKey:@"Url"];
                    if (STRINGHASVALUE(url)) {
                        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:url, @"ImagePath", nil];
                        [bigImageUrls addObject:paramDic];       // 把大图封装成与国内酒店一样的格式
                    }
                }
            }
        }
        
        leftTipsLbl.text = @"以下图片由该酒店提供";
    }
    
    tipsLbl.text = [NSString stringWithFormat:@"共%d张  ",thumbnailUrls.count];
    thumbnails = [[PictureThumbnails alloc] init:thumbnailUrls page:0];
    photoCount = [thumbnailUrls count];
    
    [self.view addSubview:thumbnails];
    [thumbnails release];
    
    thumbnails.delegate = self;
    thumbnails.frame = CGRectMake(0, 30, SCREEN_WIDTH, MAINCONTENTHEIGHT);
    [thumbnails loadingViews];
    
}

#pragma mark -
#pragma mark PictureThumbnailsDelegate

- (void) animationPresentPhotoPreview:(int)tag
{
    FullImageView *detailImage = [[FullImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:bigImageUrls AtIndex:tag];//photoIndex];
    detailImage.delegate = nil;
    detailImage.alpha = 0;
    //
    //
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:detailImage];
    [detailImage release];
    //
    [UIView animateWithDuration:0.3 animations:^{
        detailImage.alpha = 1;
    }];
}

@end
