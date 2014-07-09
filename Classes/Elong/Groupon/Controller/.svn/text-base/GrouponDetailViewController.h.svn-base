//
//  GrouponDetailViewController.h
//  ElongClient
//	团购详情页面
//
//  Created by haibo on 11-11-8.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "HotelDefine.h"
#import <MapKit/MapKit.h>
#import "GrouponCommentViewController.h"
#import "GrouponDetailOrderCell.h"
#import "PhotoView.h"
#import "GrouponDetailCommentInfoCell.h"
#import "FullImageView.h"
#import "GrouponShareOrderCell.h"
#import "GrouponAppointViewController.h"
#import "HttpUtil.h"
#import "GrouponProductIdStack.h"
#import "GrouponDetailMapAddressCell.h"
#import "GrouponDetailAppointmentCellDelegate.h"
#import "GrouponDetailCellDelegate.h"

@class GrouponDetailView;
@class HotelMap;
@interface GrouponDetailViewController : DPNav <UITableViewDataSource, UITableViewDelegate,GrouponCommentViewControllerDelegate,GrouponDetailAppointmentCellDelegate,GrouponDetailOrderCellDelegate,PhotoViewDelegate,FullImageViewDelegate,GrouponDetailCommentCellDelegate,GrouponDetailCellDelegate> {
	NSString *hotelDescription;
    NSString *hotelname;
    NSString *hotelphoneNO;
	CLLocationCoordinate2D publiccenterCoodinate;
@private
    NSArray *hotelInfoArray;			// 酒店信息列表
    
    UITableView *contentList;
    NSArray *grouponItemArray;
    GrouponCommentViewController *commentVC;
    PhotoView *photoView;
    UIView *markerView;
    GrouponSharedInfo *gInfo;
    
    BOOL commentBack;
    
    int totalCount;
    int goodCount;
    int badCount;
    
    BOOL isMultipleStore;
    HttpUtil *addGrouponFavRequest;
    HttpUtil *existGrouponFavRequest;
    HttpUtil *packageIdRequest;
    HttpUtil *detailRequest;
    FullImageView *detailImage;
    int packageId;     //包id
    double cacheFileCreateTime;                     // 缓存文件创建时间
    HttpUtil *hoteldetailRequest;
    
    float grouponDetailOrderCellHeight;         //团购title cell的高度
    float grouponDetailBuyTipsCellHeight;         //团购购买须知的高度
    BOOL isShowedMoreOtherPackgeData;            //是否已经显示了其他打包
}

@property (nonatomic,assign) CLLocationCoordinate2D publiccenterCoodinate;
@property (nonatomic,copy)   NSString *hotelname;
@property (nonatomic,copy)   NSString *hotelphoneNO;
@property (nonatomic,copy)   NSString *hotelDescription;
@property (nonatomic,copy)   NSString *phoneNum;
@property (nonatomic,assign) NSInteger salesNum;
@property (nonatomic,retain) NSArray *packageData;   //打包的数据
@property (nonatomic,copy)   NSString *addtionalInfos;  //附加的信息

- (id)initWithDictionary:(NSDictionary *)dictionary addtionalInfos:(NSString *) addtionalInfos;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
