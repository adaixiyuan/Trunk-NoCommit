//
//  Hoteldetail.h
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "FullTypeImageView.h"
#import "CustomSegmented.h"
#import "ImageDownLoader.h"
#import "ELCalendarViewController.h"

typedef enum {
    CancelTypeFree,         // 免费取消
    CancelTypeLimited,      // 限时取消
    CancelTypeForbidden     // 不可取消
}CancelType;

@class RoomType, HotelReview,HotelCommentViewController,HotelMapViewController,HotelInfoViewController;

@interface HotelDetailController : DPNav <UITabBarControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,ImageDownDelegate,FullTypeImageViewDelegate,ElCalendarViewSelectDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isUnsigned;
}
@property (nonatomic, retain) UIButton *favoritebtn;
@property (nonatomic, retain) UITableView *contentList;
@property (nonatomic, retain) HotelCommentViewController *commentVC;
@property (nonatomic, retain) HotelMapViewController *mapVC;
@property (nonatomic, retain) HotelInfoViewController *infoVC;
@property (nonatomic, retain) NSDate *checkIn;
@property (nonatomic, retain) NSDate *checkOut;
@property (nonatomic, retain) UIButton *checkInBtn;
@property (nonatomic, retain) UIButton *checkOutBtn;
@property (nonatomic, assign) NSInteger linkType;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, retain) UIButton *photoButton;
@property (nonatomic, retain) UILabel *photoNumLbl;
@property (nonatomic, retain) RoomType *roomTypeView;
@property (nonatomic, assign) NSInteger today_hour;
@property (nonatomic, assign, getter=isLoaded) BOOL isLoaded;
@property (nonatomic, retain) UIActivityIndicatorView *roomLoadingView;
@property (nonatomic, assign, getter=isCurrentExtend) BOOL isCurrentExtend;
@property (nonatomic, retain) NSMutableDictionary *tableImgeDict;
@property (nonatomic, retain) NSMutableArray *progressManager;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) HttpUtil *hotRequest;
@property (nonatomic, retain) HttpUtil *couponUtil;
@property (nonatomic, retain) HttpUtil *haveFavUtil;

@property (nonatomic,retain) UIBarButtonItem *originBarBtn;     // 原始返回按钮
@property (nonatomic,retain) NSString *listImageUrl;


// 收藏按钮点击事件
-(void)clickFavorite;

// 酒店详情数据源
+ (NSMutableDictionary *)hoteldetail;

// 初始化函数
-(id)init:(NSString *)name style:(NavBtnStyle)style;

- (void) setPsgRecommend:(NSDictionary *)hotel;

@end
