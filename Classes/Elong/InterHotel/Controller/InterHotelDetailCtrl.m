//
//  InterHotelDetailCtrl.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelDetailCtrl.h"
#import "Utils.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "TimeUtils.h"
#import "ElongURL.h"
#import "InterHotelPostManager.h"
#import "InterHotelDetailMapCtrl.h"
#import "InterFillOrderCtrl.h"
#import "InterHotelSearcher.h"
#import "StarsView.h"
#import "HotelPhotoViewController.h"
#import "InterHotelDetailIntroVC.h"
#import "RoundCornerView.h"
#import "RoundCornerView+WebCache.h"
#import "InterHotelSendCommentCtrl.h"
#import "InterHotelCommentVC.h"

#define ROOMER_NUM   1
#define ROOMER_ADULT 2
#define ROOMER_CHILD 0

@interface InterHotelDetailCtrl ()

@property(nonatomic,retain) UITableView *mainTable;
@property(nonatomic,copy) NSString *hotelId;
@property(nonatomic,copy) NSString *listImgUrl;

@property(nonatomic,copy) NSString *liveInStr;      //入住日期
@property(nonatomic,copy) NSString *leaveOutStr;    //离店日期
@property(nonatomic,retain) UILabel *liveInLabel;       //入住日期提示
@property(nonatomic,retain) UILabel *leaveOutLabel;     //离店日期提示
@property(nonatomic) int adultNum,childNum,roomNum;     //房间数，成人数以及儿童数
@property(nonatomic,retain) UILabel *adultLabel,*childLabel,*roomLabel;
@property (nonatomic,retain) NSArray *roomerArray;   // 房间入住人

@property(nonatomic) BOOL firstLoadingRoom; //第一次加载房间
@property(nonatomic,retain) HttpUtil *roomUtil;
@property(nonatomic) BOOL isLoadingRoomFailed;

-(void)fillTableHeaderView;     //填充TableHeaderView内容，此处不是SectionHeaderView，区分开。
-(void)startLoadingRoom;
-(void)endLoadingRoom;      //异步加载房间时的loading显示

-(void)goHotelDetailDesp;       //查看具体详情，to be by haibo.zhao
-(void)goHotelComment;     //查看到到网评论，to be by haibo.zhao
-(void)browsePhotoDetail;   //查看图片详情，to be by haibo.zhao
-(void)browseMapInfo;       //查看地图信息
-(void)goDateSetting;       //日期重新设置        //to  be by haibo.zhao
-(void)goRoomSetting;       //房间重新设置    //to be by shuguang.wang


-(NSString *)getDateNoteWithDate:(NSDate *)date;/* 根据日期，获取对应的星期 */
-(int)getDaysWithDate:(NSDate *)date otherDate:(NSDate *)otherDate;/*获取两个日期间对应的天数*/


//Send Request
@property(nonatomic,copy) NSString *requestType;
-(void)sendDetailRequest;   //发送获取酒店详情请求
-(void)sendRoomRequest;     //发送获取酒店对应房间的请求

@end

@implementation InterHotelDetailCtrl
@synthesize mainTable;
@synthesize listImgUrl;
@synthesize liveInStr,leaveOutStr;
@synthesize liveInLabel,leaveOutLabel;
@synthesize adultNum,childNum,roomNum;
@synthesize adultLabel,childLabel,roomLabel;
@synthesize hotelId;
@synthesize requestType;
@synthesize roomerArray;
@synthesize firstLoadingRoom;
@synthesize roomUtil;
@synthesize isLoadingRoomFailed;


//酒店详情
static NSMutableDictionary *detailDict = nil;
+(NSMutableDictionary *)detail{
    @synchronized(self){
        if(!detailDict){
            detailDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
    }
    return detailDict;
}

//酒店房间
static NSMutableArray *roomArr = nil;
+(NSMutableArray *)rooms{
    @synchronized(self){
        if(!roomArr){
            roomArr = [[NSMutableArray alloc] initWithCapacity:1];
        }
    }
    return roomArr;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [mainTable release];
    [listImgUrl release];
    [liveInStr release];
    [leaveOutStr release];
    [liveInLabel release];
    [leaveOutLabel release];
    [adultLabel release];
    [childLabel release];
    [roomLabel release];
    [hotelId release];
    self.roomerArray = nil;
    
    [requestType release];
    [roomUtil cancel];
    SFRelease(roomUtil);
    [[InterHotelDetailCtrl detail] removeAllObjects];
    [[InterHotelDetailCtrl rooms] removeAllObjects];
    if (_couponUtil) {
        [_couponUtil cancel];
        SFRelease(_couponUtil);
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
    }
    return self;
}

-(id)initWithDataDic:(NSDictionary *)hotelDic{
    self = [super initWithTopImagePath:nil andTitle:@"酒店详情" style:_NavNormalBtnStyle_];
    if(self){
        //Custom initialization
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        self.view.exclusiveTouch = YES;
        
//        UIBarButtonItem  *commentItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"点评酒店" Target:self Action:@selector(goToCommentCtrl)];
//    
//        self.navigationItem.rightBarButtonItem = commentItem;

        
        [self preloadCouponInfo];
           
        //初始化所需数据
        CFShow(hotelDic);
        NSString *hID = [hotelDic safeObjectForKey:HOTELID_REQ];
        NSString *listIconUrl = [hotelDic safeObjectForKey:InterHotel_ListImgUrl];
        NSString *arriveDate = [hotelDic safeObjectForKey:Req_ArriveDate];
        NSString *departureDate  = [hotelDic safeObjectForKey:Req_DepartureDate];
        
        self.hotelId = hID;
        self.listImgUrl = listIconUrl;      //列表中的IconUrl
        //日期默认设置,格式例子为2013-7-18
        self.liveInStr =   arriveDate;
        self.leaveOutStr =  departureDate;
        
        // 初始化入住人信息，
        NSMutableDictionary *roomerDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ROOMER_ADULT],@"adult",[NSNumber numberWithInt:ROOMER_CHILD],@"child",[NSMutableArray arrayWithCapacity:0],@"age", nil];
        self.roomerArray = [NSMutableArray arrayWithObjects:roomerDict, nil];
        self.roomNum = self.roomerArray.count;
        self.adultNum = 0;
        self.childNum = 0;
        for (NSDictionary *dict in self.roomerArray) {
            NSInteger adult = [[dict safeObjectForKey:@"adult"] intValue];
            NSInteger child = [[dict safeObjectForKey:@"child"] intValue];
            self.adultNum = self.adultNum + adult;
            self.childNum = self.childNum + child;
        }
        
        
        //add MainTable
        if(!mainTable){
            mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20) style:UITableViewStylePlain];
        }
        self.mainTable.delegate = self;
        self.mainTable.dataSource =self;
        self.mainTable.backgroundColor = [UIColor clearColor];
        self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mainTable];
        self.mainTable.hidden = YES;        //默认隐藏
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        footerView.backgroundColor = [UIColor clearColor];
        self.mainTable.tableFooterView = footerView;
        [footerView release];
        
        
        
        //发送请求酒店详情数据
        [[InterHotelDetailCtrl detail] removeAllObjects];
        [[InterHotelDetailCtrl rooms] removeAllObjects];
        [self sendDetailRequest];
        
        if (UMENG) {
            //国际酒店房型页面
            [MobClick event:Event_InterHotelDetail];
        }
        
        
    }
    return self;
}

#pragma mark -
#pragma mark 预加载Coupon

- (void)preloadCouponInfo{
//    int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
//
//    if (promotionTag != 3) {
//        // 非返现酒店暂时不需要coupon
//        return;
//    }
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin) {
        // 登陆状态下预加载coupon
        JCoupon *coupon = [MyElongPostManager coupon];
        [[MyElongPostManager coupon] clearBuildData];
        if (_couponUtil) {
            [_couponUtil cancel];
            SFRelease(_couponUtil);
        }
        
        _couponUtil = [[HttpUtil alloc] init];
        [_couponUtil connectWithURLString:MYELONG_SEARCH
                                  Content:[coupon requesActivedCounponString:YES]
                             StartLoading:NO
                               EndLoading:NO
                                 Delegate:self];
    }
}

#pragma mark - UI Methods
/*  展示酒店名和星级 */
-(void)presentHotelNameAndStarLevelInView:(UIView *)tmpView{
    UIButton *goDetailDespBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goDetailDespBtn addTarget:self action:@selector(goHotelDetailDesp) forControlEvents:UIControlEventTouchUpInside];
    goDetailDespBtn.frame = CGRectMake(0, 10, 232, 44);
    goDetailDespBtn.backgroundColor = [UIColor whiteColor];
    [goDetailDespBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [tmpView addSubview:goDetailDespBtn];
    UIImageView *dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 232, SCREEN_SCALE)];
    dashLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [goDetailDespBtn addSubview:dashLineView];
    [dashLineView release];
    
    dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 232, SCREEN_SCALE)];
    dashLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [goDetailDespBtn addSubview:dashLineView];
    [dashLineView release];

    
    
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    //HotelName
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 232 - 10, 26)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    nameLabel.lineBreakMode  = UILineBreakModeWordWrap;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [goDetailDespBtn addSubview:nameLabel];
    [nameLabel release];
    
    nameLabel.text = @"";
    if(DICTIONARYHASVALUE(baseInfo)){
        NSString *tmpHotelName = [baseInfo safeObjectForKey:@"HotelName"];
        NSString *hotelName = STRINGHASVALUE(tmpHotelName)?tmpHotelName:@"";
        int count = 0;
        NSMutableString *newHotelName = [NSMutableString stringWithString:@""];
        
        for (int i = 0; i < hotelName.length;i++) {
            int hnc = [hotelName characterAtIndex:i];
            NSRange range;
            range.location = i;
            range.length = 1;
            [newHotelName appendString:[hotelName substringWithRange:range]];
            if(hnc > 0x4e00 && hnc < 0x9fff){
                count += 2;
            }else{
                count++;
            }
            if (count > 38) {
                [newHotelName appendString:@"..."];
                break;
            }
        }
        CGSize size = CGSizeMake(232 - 16, 1000);
        CGSize newSize = [newHotelName sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        nameLabel.frame = CGRectMake(8, 8, 232 - 16, newSize.height);
        nameLabel.text = newHotelName;
    }

    //Star Level
    NSString *hotelRating = @"0";
    if(DICTIONARYHASVALUE(baseInfo)){
        hotelRating = [baseInfo safeObjectForKey:@"HotelRating"];
    }
    StarsView *starView = [[StarsView alloc] initWithFrame:CGRectMake(232 - 116, 27, 80, 13)];
    [starView setStarNumber:hotelRating];
    [goDetailDespBtn addSubview:starView];
    [starView release];
    
    //详情Note And Arrow
    UILabel *detailNoteLb = [[UILabel alloc] initWithFrame:CGRectMake(182, 26, 30, 14)];
    detailNoteLb.font = [UIFont systemFontOfSize:12.0f];
    detailNoteLb.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0f];
    detailNoteLb.backgroundColor = [UIColor clearColor];
    detailNoteLb.text = @"详情";
    detailNoteLb.textAlignment = UITextAlignmentRight;
    [goDetailDespBtn addSubview:detailNoteLb];
    [detailNoteLb release];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(232 - 16, 29, 8, 9)];
    arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    arrowView.contentMode = UIViewContentModeCenter;
    [goDetailDespBtn addSubview:arrowView];
    [arrowView release];
}

/* 展示到到网评论 */
-(void)presentCommentInView:(UIView *)tmpView{
    UIButton *goDaoDaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goDaoDaoBtn addTarget:self action:@selector(goHotelComment) forControlEvents:UIControlEventTouchUpInside];
    goDaoDaoBtn.frame = CGRectMake(0, 44+10, 232, 44);
    goDaoDaoBtn.backgroundColor = [UIColor whiteColor];
    [goDaoDaoBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [tmpView addSubview:goDaoDaoBtn];
    goDaoDaoBtn.userInteractionEnabled = YES;
    
    UIImageView *dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 232, SCREEN_SCALE)];
    dashLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [goDaoDaoBtn addSubview:dashLineView];
    [dashLineView release];
    
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    //DaoDao Logo and StarLevel
    float ddRating = 0.0;
    if(DICTIONARYHASVALUE(baseInfo)){
        ddRating = [[baseInfo safeObjectForKey:@"MedianUserRating"] floatValue];
    }
    if(ddRating>0.0){
        //add Logo
        UIImageView *ddIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 24, 14)];
        ddIcon.image = [UIImage imageNamed:@"daodaoFlag2.png"];
        [goDaoDaoBtn addSubview:ddIcon];
        [ddIcon release];
        
        //add StarLevel
        int score_int = floor(ddRating);
        BOOL isHalf = NO;
        float minus = ddRating-score_int;
        if(minus>0.0){
            isHalf = YES;
        }
		UIView *starBackView = [[UIView alloc] initWithFrame:CGRectMake(35, 16, 60, 12)];
        starBackView.userInteractionEnabled = NO;
        for(int i=0; i<5;i++){
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(i*12, 0, 12, 12)];
            if(score_int==5){
                [icon setImage:[UIImage imageNamed:@"daodaoIcon_1"]];
            }else{
                if(i<score_int){
                    [icon setImage:[UIImage imageNamed:@"daodaoIcon_1"]];
                }else if(i==score_int){
                    if(isHalf){
                        [icon setImage:[UIImage imageNamed:@"daodaoIcon_2"]];
                    }else{
                        [icon setImage:[UIImage imageNamed:@"daodaoIcon_3"]];
                    }
                }else{
                    [icon setImage:[UIImage imageNamed:@"daodaoIcon_3"]];
                }
            }
            [starBackView addSubview:icon];
            [icon release];
        }
        [goDaoDaoBtn addSubview:starBackView];
        [starBackView release];
        
        //add RatingScore
        UILabel *scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, 40, 16)];
        scoreLb.font = [UIFont systemFontOfSize:13.0f];
        scoreLb.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
        scoreLb.backgroundColor = [UIColor clearColor];
        scoreLb.text = [NSString stringWithFormat:@"%.1f分",ddRating];
        [goDaoDaoBtn addSubview:scoreLb];
        [scoreLb release];
        
        
        //Comment Note and Arrow
        UILabel *commentNoteLb = [[UILabel alloc] initWithFrame:CGRectMake(182, 0, 30, 44)];
        commentNoteLb.font = [UIFont systemFontOfSize:12.0f];
        commentNoteLb.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0f];
        commentNoteLb.backgroundColor = [UIColor clearColor];
        commentNoteLb.text = @"评论";
        commentNoteLb.textAlignment = UITextAlignmentRight;
        [goDaoDaoBtn addSubview:commentNoteLb];
        [commentNoteLb release];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(232-16, 0, 8, 44)];
        arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        arrowView.contentMode = UIViewContentModeCenter;
        [goDaoDaoBtn addSubview:arrowView];
        [arrowView release];
    }else{
        //没有评论时
        goDaoDaoBtn.userInteractionEnabled = NO;
        
        UILabel *commentNoteLb = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 210, 44)];
        commentNoteLb.font = [UIFont systemFontOfSize:12.0f];
        commentNoteLb.textColor = [UIColor darkTextColor];
        commentNoteLb.backgroundColor = [UIColor clearColor];
        commentNoteLb.text = @"暂无评论";
        [goDaoDaoBtn addSubview:commentNoteLb];
        [commentNoteLb release];
    }
    

}

//展示图片集
-(void)presentPhotoDetailInView:(UIView *)tmpView{
    //Photo
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(232, 10, 88, 88);
    photoButton.backgroundColor = [UIColor whiteColor];
    photoButton.contentMode = UIViewContentModeScaleToFill;
    [photoButton setBackgroundImage:[UIImage noCacheImageNamed:@"hotel_detail_image.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(browsePhotoDetail) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:photoButton];
    //PhotoDetail container
    
    //Number Note
    UILabel *photoNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 88-16, 88, 16)];
    photoNumLbl.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    photoNumLbl.font = [UIFont boldSystemFontOfSize:12.0f];
    photoNumLbl.textColor = [UIColor whiteColor];
    photoNumLbl.textAlignment = UITextAlignmentCenter;
    [photoButton addSubview:photoNumLbl];
    [photoNumLbl release];
    //设置图片显示
    NSArray *photoUrlArray = nil;
    NSDictionary *ImageInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"ImageInfo"];
    if(DICTIONARYHASVALUE(ImageInfo)){
        photoUrlArray = [ImageInfo safeObjectForKey:@"Items"];
    }
    if(ARRAYHASVALUE(photoUrlArray)){
        photoNumLbl.text = [NSString stringWithFormat:@"%d张",photoUrlArray.count];
        //缓存
        if (self.listImgUrl) {
            UIImage *photoButtonImg = [[CacheManage manager] getHotelListImageByURL:self.listImgUrl];
            if (photoButtonImg) {
                [photoButton setBackgroundImage:photoButtonImg forState:UIControlStateNormal];
                [photoButton setBackgroundImage:photoButtonImg forState:UIControlStateHighlighted];
                [photoButton setBackgroundImage:photoButtonImg forState:UIControlStateDisabled];
            }else{
                NSString *urlStr = [[photoUrlArray safeObjectAtIndex:0] safeObjectForKey:@"ThumbnailUrl"];     //PicUrl，取图片数组中的第一个图片显示
                if(STRINGHASVALUE(urlStr)){
                    [photoButton setImageWithURL:[NSURL URLWithString:urlStr]
                                placeholderImage:[UIImage noCacheImageNamed:@"hotel_detail_image.png"]
                                         options:SDWebImageCacheMemoryOnly];
                }
            }
        }else{
            NSString *urlStr = [[photoUrlArray safeObjectAtIndex:0] safeObjectForKey:@"ThumbnailUrl"];     //PicUrl，取图片数组中的第一个图片显示
            if(STRINGHASVALUE(urlStr)){
                [photoButton setImageWithURL:[NSURL URLWithString:urlStr]
                            placeholderImage:[UIImage noCacheImageNamed:@"hotel_detail_image.png"]
                                     options:SDWebImageCacheMemoryOnly];
            }
        }
        
        photoButton.enabled = YES;
    }else{
        photoNumLbl.text = @"0张";
        photoButton.enabled = NO;
    }
}

//展示地图
-(void)presentMapInView:(UIView *)tmpView
{
    UIButton *goMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goMapBtn.frame = CGRectMake(0, 10 * 2 + 44 * 2, SCREEN_WIDTH, 44);
    [goMapBtn addTarget:self action:@selector(browseMapInfo) forControlEvents:UIControlEventTouchUpInside];
    goMapBtn.backgroundColor = [UIColor whiteColor];
    [goMapBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [tmpView addSubview:goMapBtn];
    
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    //address
    UILabel *addressLb = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 240, 22)];
    addressLb.font = [UIFont systemFontOfSize:13.0f];
    addressLb.textColor = RGBACOLOR(52, 52, 52, 1);
    addressLb.backgroundColor = [UIColor clearColor];
    addressLb.text = @"";
    if(DICTIONARYHASVALUE(baseInfo)){
        NSString *hotelAddress = [baseInfo safeObjectForKey:@"HotelAddress"];
        addressLb.text = STRINGHASVALUE(hotelAddress)?hotelAddress:@"";
    }
    [goMapBtn addSubview:addressLb];
    [addressLb release];
    
    //district
    UILabel *locationDespLb = [[UILabel alloc] initWithFrame:CGRectMake(8, 22, 240, 22)];
    locationDespLb.textColor = [UIColor colorWithWhite:118.0f/255.0f alpha:1.0f];
    locationDespLb.backgroundColor = [UIColor clearColor];
    locationDespLb.text = @"";
    if(DICTIONARYHASVALUE(baseInfo)){
        NSString *locatioinDesp = [baseInfo safeObjectForKey:@"LocationDescription"];
        locationDespLb.text = STRINGHASVALUE(locatioinDesp)?locatioinDesp:@"";
    }
    
    //根据文字长度设置字体大小
    CGFloat actualSize ;
    [locationDespLb.text sizeWithFont:[UIFont systemFontOfSize:12] minFontSize:10 actualFontSize:&actualSize forWidth:240 lineBreakMode:UILineBreakModeTailTruncation];
    locationDespLb.font = [UIFont systemFontOfSize:actualSize];
    
    [goMapBtn addSubview:locationDespLb];
    [locationDespLb release];
    
    
    //详情Note And Arrow
    UIImageView *mapInfoView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 60, 44)];
    mapInfoView.contentMode = UIViewContentModeCenter;
    mapInfoView.image = [UIImage noCacheImageNamed:@"groupon_detail_map.png"];
    [goMapBtn addSubview:mapInfoView];
    [mapInfoView release];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 0, 8, 44)];
    arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    arrowView.contentMode = UIViewContentModeCenter;
    [goMapBtn addSubview:arrowView];
    [arrowView release];
    
    UIImageView *dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    dashLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [goMapBtn addSubview:dashLineView];
    [dashLineView release];
    
    dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    dashLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [goMapBtn addSubview:dashLineView];
    [dashLineView release];
}

/*填充TableHeaderView内容，此处不是SectionHeaderView，区分开*/
-(void)fillTableHeaderView{
    //HeaderView  Container
    UIView *tmpHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10 * 3 + 44 * 3 )];
    [self presentHotelNameAndStarLevelInView:tmpHeader];        //酒店名和星级
    [self presentCommentInView:tmpHeader];  //到到网评论和到到网评分
    [self presentPhotoDetailInView:tmpHeader];  //图片集浏览
    [self presentMapInView:tmpHeader];  //查看地图
    
    self.mainTable.tableHeaderView  = tmpHeader;
    [tmpHeader release];
}

-(void)startLoadingRoom{
    [self.mainTable setScrollEnabled:NO];
    UIView *loadingBg = [[UIView alloc] initWithFrame:CGRectMake(0,self.mainTable.contentOffset.y + 150, 320, self.mainTable.contentSize.height-150)];
    loadingBg.tag = 1031;
    [self.mainTable addSubview:loadingBg];
    [loadingBg release];
    
    //add Loading
    for (SmallLoadingView *aView in loadingBg.subviews) {
		if ([aView isMemberOfClass:[SmallLoadingView class]]) {
            // 已经有时就不再添加
			return;
		}
	}
    SmallLoadingView *smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, 100, 50, 50)];
    smallLoading.imageRadius = 2.0f;
    [loadingBg addSubview:smallLoading];
	[smallLoading startLoading];
    [smallLoading release];
}

-(void)endLoadingRoom{
    [self.mainTable setScrollEnabled:YES];
    UIView *loadingBg = (UIView *)[self.mainTable viewWithTag:1031];
    
    for (SmallLoadingView *aView in loadingBg.subviews)
    {
		if ([aView isMemberOfClass:[SmallLoadingView class]])
        {
            [aView removeFromSuperview];
            aView = nil;
		}
	}
    [loadingBg removeFromSuperview];
}

#pragma mark - Public methods
/* 根据日期，获取对应的星期 */
-(NSString *)getDateNoteWithDate:(NSDate *)date{
    //用于今日、明日显示判断
    NSString *todayStr = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"M月d日"];
    NSString *tomorrowStr = [TimeUtils displayDateWithNSDate:[NSDate dateWithTimeInterval:24*3600 sinceDate:[NSDate date]] formatter:@"M月d日"];
    NSString *dateStr = [TimeUtils displayDateWithNSDate:date formatter:@"M月d日"];
    
    NSString *dateNote = @"";
    if([todayStr isEqualToString:dateStr]){
        dateNote = @"今天";   //判断今天
    }else if([tomorrowStr isEqualToString:dateStr]){
        dateNote = @"明天";   //判断明天
    }else{
        //如果不是今天、明天，则显示周几..
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                                              fromDate:date];
        NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
        switch (weekday) {
            case 1:
                dateNote = @"周日";
                break;
            case 2:
                dateNote = @"周一";
                break;
            case 3:
                dateNote = @"周二";
                break;
            case 4:
                dateNote = @"周三";
                break;
            case 5:
                dateNote = @"周四";
                break;
            case 6:
                dateNote = @"周五";
                break;
            case 7:
                dateNote = @"周六";
                break;
            default:
                break;
        }
    }
    return dateNote;
}

/*获取两个日期间对应的天数*/
-(int)getDaysWithDate:(NSDate *)date otherDate:(NSDate *)otherDate{
    NSTimeInterval time0 = [date timeIntervalSince1970];
    NSTimeInterval time1 = [otherDate timeIntervalSince1970];
    
    int days = (time1 -time0)/(24*3600);
    return days;
}

#pragma mark - Send Request Methods
 //发送获取酒店详情请求
-(void)sendDetailRequest{
    JInterHotelDetail *interHotelDetail = [InterHotelPostManager interHotelDetail];
    [interHotelDetail setInterHotelId:self.hotelId];

    self.requestType = @"RequestDetail";
    [Utils request:INTER_SEARCH req:[interHotelDetail requestString:YES] policy:CachePolicyHotelDetail  delegate:self];
}

//发送获取酒店对应房间的请求
-(void)sendRoomRequest{
    
    JInterHotelRoom *interHotelRoom = [InterHotelPostManager interHotelRoom];
    [interHotelRoom setInterHotelId:self.hotelId];
    NSString *liveDate_j =  [TimeUtils makeJsonDateWithDisplayNSStringFormatter:self.liveInStr formatter:@"yyyy-MM-dd"];
    NSString *leaveDate_j =  [TimeUtils makeJsonDateWithDisplayNSStringFormatter:self.leaveOutStr formatter:@"yyyy-MM-dd"];
    [interHotelRoom setLiveDate:liveDate_j andLeaveDate:leaveDate_j];
    
    NSMutableArray *roomListInfo =[NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *roomDict in self.roomerArray) {
        NSDictionary *dict = nil;
        if ([[roomDict safeObjectForKey:@"child"]intValue] == 0) {
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[roomDict safeObjectForKey:@"adult"],@"NumberOfAdults",[roomDict safeObjectForKey:@"child"],@"NumberOfChildren" ,@"",@"ChildAges",nil];
        }else{
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[roomDict safeObjectForKey:@"adult"],@"NumberOfAdults",[roomDict safeObjectForKey:@"child"],@"NumberOfChildren" ,[[roomDict safeObjectForKey:@"age"] componentsJoinedByString:@","],@"ChildAges",nil];
        }
        [roomListInfo addObject:dict];
    }
    
    [interHotelRoom setRoomGroup:roomListInfo];
    
    int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
    [interHotelRoom setPromotionTag:promotionTag];
    
    self.requestType = @"RequestRoom";
    if(!roomUtil){
        roomUtil = [[HttpUtil alloc] init];
    }
    
    [self startLoadingRoom];
    [roomUtil sendAsynchronousRequest:INTER_SEARCH PostContent:[interHotelRoom requestString:YES] CachePolicy:CachePolicyHotelDetail Delegate:self];
}


#pragma mark - Action Methods
 //查看具体详情，to be by haibo.zhao
-(void)goHotelDetailDesp{
    InterHotelDetailIntroVC *detailVC = [[InterHotelDetailIntroVC alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

//查看到到网评论，to be by haibo.zhao
-(void)goHotelComment{
    
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
//    DaodaoCommentVC *comentVC = [[DaodaoCommentVC alloc] initWithHotelId:hotelId];
//    [self.navigationController pushViewController:comentVC animated:YES];
//    [comentVC release];
    
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    NSString *eHotelID = [baseInfo safeObjectForKey:HOTELID_REQ];
    if (STRINGHASVALUE(eHotelID))
    {
        InterHotelCommentVC *comentVC = [[InterHotelCommentVC alloc] initWithHotelId:hotelId];
        [self.navigationController pushViewController:comentVC animated:YES];
        [comentVC release];
    }
    
}

//查看图片详情，to be by haibo.zhao
-(void)browsePhotoDetail{
    HotelPhotoViewController *hotelPhotoVC = [[HotelPhotoViewController alloc] initFromType:HotelPhotoTypeInterHotel];
    [self.navigationController pushViewController:hotelPhotoVC animated:YES];
    [hotelPhotoVC release];
    
    if (UMENG) {
        //国际酒店图片页面
        [MobClick event:Event_InterHotelPhoto];
    }
}

//查看地图信息
-(void)browseMapInfo{
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    float latitude = 0.0;
    float longitude = 0.0;
    if(DICTIONARYHASVALUE(baseInfo)){
        latitude = [[baseInfo safeObjectForKey:@"Latitude"] floatValue];
        longitude = [[baseInfo safeObjectForKey:@"Longitude"] floatValue];
    }
    
    if(latitude==0.0&&longitude==0.0){
        [Utils popSimpleAlert:@"" msg:@"该酒店暂无提供地图位置信息"];
        return;
    }
    
    InterHotelDetailMapCtrl *detailMapCtrl = [[InterHotelDetailMapCtrl alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [self.navigationController pushViewController:detailMapCtrl animated:YES];
    [detailMapCtrl release];
}

//日期重新设置
-(void)goDateSetting{
    NSDate *checkInDate = [TimeUtils displayNSStringToGMT8NSDate:self.liveInStr];
    NSDate *checkOutDate = [TimeUtils displayNSStringToGMT8NSDate:self.leaveOutStr];
    
    ELCalendarViewController *calendar = [[ELCalendarViewController alloc] initWithCheckIn:checkInDate checkOut:checkOutDate type:GlobelHotelCalendar];
    calendar.delegate = self;
    [self.navigationController pushViewController:calendar animated:YES];
    [calendar release];
}

//房间重新设置
-(void)goRoomSetting{
    InterRoomerSelectorViewController *interRoomerSelectorVC = [[InterRoomerSelectorViewController alloc] initWithRoomers:self.roomerArray];
    interRoomerSelectorVC.delegate = self;
    [self.navigationController pushViewController:interRoomerSelectorVC animated:YES];
    [interRoomerSelectorVC release];
}



#pragma mark - 入住房间、成人等信息
#pragma mark InterRoomerSelectorViewControllerDelegate
- (void) interRoomerSelectorVC:(InterRoomerSelectorViewController *)interRoomerSelectorVC didSelectRoomers:(NSArray *)roomers{
    self.roomerArray = roomers;
    self.roomNum = self.roomerArray.count;
    self.adultNum = 0;
    self.childNum = 0;
    for (NSDictionary *dict in self.roomerArray) {
        NSInteger adult = [[dict safeObjectForKey:@"adult"] intValue];
        NSInteger child = [[dict safeObjectForKey:@"child"] intValue];
        self.adultNum = self.adultNum + adult;
        self.childNum = self.childNum + child;
    }
    
    [self sendRoomRequest];
    
    if (UMENG) {
        //国际酒店选择入住人
        [MobClick event:Event_InterRoomerSelector];
    }
}

#pragma mark - InterRoom Delegate 点击预订房型
-(void)bookingRoom{
    BOOL isLogin = [[AccountManager instanse] isLogin];
    if(isLogin){
        InterFillOrderCtrl *interFillOrder  = [[InterFillOrderCtrl alloc] init];
        [self.navigationController pushViewController:interFillOrder animated:YES];
        [interFillOrder release];
    }else{
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_FillInterHotelOrder_];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
    }
}


#pragma mark - InterRoomDetailView Delegate
-(void)bookRoomFromDetailView{
    BOOL isLogin = [[AccountManager instanse] isLogin];
    if(isLogin){
        InterFillOrderCtrl *interFillOrder  = [[InterFillOrderCtrl alloc] init];
        [self.navigationController pushViewController:interFillOrder animated:YES];
        [interFillOrder release];
    }else{
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_FillInterHotelOrder_];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
    }
}


#pragma mark - UITableView Delegate and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [[InterHotelDetailCtrl rooms] count];
    return count>0?count:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int count = [[InterHotelDetailCtrl rooms] count];
    if(count>0){
        //正常数据
        static NSString *cellName =@"InterRoomCell";
        InterRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[[InterRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
            cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        }
        cell.tag = indexPath.row;       //用来标识房间
        cell.delegate = self;
        
        //设置Cell 高度
        NSDictionary *room = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:indexPath.row];
        NSString *promotionDesp = [room safeObjectForKey:@"PromoDescription"];
        int height = STRINGHASVALUE(promotionDesp)?150:130;       //如果有促销提示信息，则返回150，否则为130
        [cell setCellHeight:height];
        //UI设置
        [cell defaultUISetting];        //先重置UI
        
        // 酒店返现和预付卡
        [cell setDiscountPrice:0];      //初始化返现金额
        [cell setGiftCardPrice:0];      ////初始化预付卡

        int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
        if (promotionTag ==3) {
            if (!OBJECTISNULL([[[room safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0] safeObjectForKey:@"DiscountTotal"])) {
                NSDate *checkInDate = [NSDate dateFromString:self.liveInStr withFormat:@"yyyy-MM-dd"];
                NSDate *checkOutDate = [NSDate dateFromString:self.leaveOutStr withFormat:@"yyyy-MM-dd"];
                int bookDays = [checkOutDate timeIntervalSinceDate:checkInDate]/(24*3600);
                bookDays = bookDays>0?bookDays:1;
                
                [cell setDiscountPrice:[[[[room safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0] safeObjectForKey:@"DiscountTotal"] floatValue]/bookDays/self.roomNum];
            }else{
                [cell setDiscountPrice:0];
            }
        }else if (promotionTag ==4) {
            if (!OBJECTISNULL([[[room safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0] safeObjectForKey:@"GiftCardAmount"])) {
                //此处预付卡金额 api说跟房间数和间夜数没有关系
                [cell setGiftCardPrice:[[[[room safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0] safeObjectForKey:@"GiftCardAmount"] floatValue]];
            }
        }

        
        //设置数据
        //房型图片
        NSString *picUrlStr = [room safeObjectForKey:@"PicUlr"];
        NSURL *picUrl = nil;
        if(STRINGHASVALUE(picUrlStr)){
            picUrl = [NSURL URLWithString:picUrlStr];
            [cell.roomIconImg setImageWithURL:picUrl placeholderImage:nil options:SDWebImageCacheMemoryOnly];
        }else{
            cell.roomIconImg.image = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
        }
        NSString *roomName  = [room safeObjectForKey:@"RoomName"];
        cell.roomNameLabel.text = [NSString stringWithFormat:@"%@",STRINGHASVALUE(roomName)?roomName:@""]; //房型名字
        NSString *breakfast  = [room safeObjectForKey:@"Breakfast"];
        NSString *breakfastStr = [NSString stringWithFormat:@"•%@",STRINGHASVALUE(breakfast)?breakfast:@"不含早餐"];  //早餐
        int smokeType = [[room safeObjectForKey:@"RoomSmokingType"] intValue];
        NSString *smokeDesp = @"";
        switch (smokeType) {
            case 0:
                smokeDesp = @"吸烟/无烟房";
                break;
            case 1:
                smokeDesp = @"无烟房";
                break;
            case 2:
                smokeDesp = @"吸烟房";
                break;
            default:
                break;
        }
        cell.smokeLabel.text = [NSString stringWithFormat:@"•%@",smokeDesp];       //吸烟/无烟房
        
        NSString *bedDesp = @"";
        NSDictionary *bedGroup = [room safeObjectForKey:@"BedGroup"];
        if(DICTIONARYHASVALUE(bedGroup)){
            NSArray *bedItems = [bedGroup safeObjectForKey:@"BedItems"];
            NSMutableArray *despArr = [[NSMutableArray alloc] init];
            if(ARRAYHASVALUE(bedItems)){
                for(NSDictionary *bedDetail in bedItems){
                    NSString *desp = [bedDetail safeObjectForKey:@"BedDestciption"];
                    if(STRINGHASVALUE(desp)){
                        [despArr addObject:desp];
                    }
                }
                bedDesp = [despArr componentsJoinedByString:@"/"];
                [despArr release];
            }else{
                [despArr release];
            }
        }
        NSString *bedStr = [NSString stringWithFormat:@"•%@",bedDesp];       //床型
        NSString *netType = [room safeObjectForKey:@"FreeNet"];
        NSString *netStr = [NSString stringWithFormat:@"•%@",STRINGHASVALUE(netType)?netType:@"无免费WIFI"];       //网络
       
        cell.breakfastLabel.text = [NSString stringWithFormat:@"%@ %@",breakfastStr,netStr];
        cell.netTypeLabel.text = bedStr;
        cell.bedTypeLabel.text = @"";
        
        NSArray *rateInfos = [room safeObjectForKey:@"RateInfos"];
        NSString *actualPrice = @"¥0";
        if(ARRAYHASVALUE(rateInfos)){
            NSDictionary *priceInfo = [rateInfos safeObjectAtIndex:0];
            //注意，传给后台和Mis时则不使用字段ElongViewAvgRate，而传入后台的是总价和原价
            float actualPrice_f = [[priceInfo safeObjectForKey:@"ElongViewAvgRate"] floatValue];
            float originPrice_f = [[priceInfo safeObjectForKey:@"ActualAvgRate"] floatValue];
            
            actualPrice = [NSString stringWithFormat:@"%.f",actualPrice_f];
            if(floor(originPrice_f) >floor(actualPrice_f)){
                [cell setOriginPrice:[NSString stringWithFormat:@"¥ %.f",originPrice_f]];        //原价
            }
        }
        [cell setActualPrice:actualPrice];      //实际价格
        
        if(STRINGHASVALUE(promotionDesp)){
            [cell setPromotionNote:promotionDesp];      //促销信息
        }
        
        int remainRoomNum = [[room safeObjectForKey:@"CurrentAllotement"] intValue];
        //remainRoomNum==-1时默认是充足的房间
        if(remainRoomNum>=0){
            [cell setRemainRoomNum:remainRoomNum];      //设置剩余房间
            if(self.roomNum>remainRoomNum){ //当需要的房间数大于剩余房间时，则置灰预订按钮
                cell.isAllowBooking = NO;
            }
        }
        
        return cell;
    }else{
        //暂无数据提示
        static NSString *cellName = @"NoneCellData";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cellBtn.tag = 1021;
            cellBtn.frame = CGRectMake(0, 0,SCREEN_WIDTH, 150);
            [cellBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
            [cellBtn addTarget:self action:@selector(sendRoomRequest) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cellBtn];
            
            UILabel *noneLB = [[UILabel alloc] initWithFrame:cellBtn.bounds];
            noneLB.backgroundColor = [UIColor clearColor];
            noneLB.tag = 1022;
            noneLB.font = [UIFont boldSystemFontOfSize:15];
            noneLB.textAlignment = NSTextAlignmentCenter;
            noneLB.text = @"暂无合适的房间";
            [cellBtn addSubview:noneLB];
            [noneLB release];
            
            UIImageView *dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            dashLineView.image= [UIImage noCacheImageNamed:@"dashed.png"];
            [cellBtn addSubview:dashLineView];
            [dashLineView release];
        }
        //处理第一次加载时
        UIButton *cellBtn = (UIButton *)[cell viewWithTag:1021];
        UILabel *noneLB = (UILabel *)[cellBtn viewWithTag:1022];
        
        //第一次加载
        if(self.firstLoadingRoom){
            noneLB.hidden = NO;
        }else{
            noneLB.hidden = YES;
        }
        
        if(self.isLoadingRoomFailed){
            noneLB.text = @"点击此处重新加载";
            cellBtn.userInteractionEnabled = YES;
        }else{
            noneLB.text = @"暂无合适的房间";
            cellBtn.userInteractionEnabled = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int count = [[InterHotelDetailCtrl rooms] count];
    if(count>0){
        NSDictionary *room = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:indexPath.row];
        NSString *promotionDesp = [room safeObjectForKey:@"PromoDescription"];
        return STRINGHASVALUE(promotionDesp)?150:130;       //如果有促销提示信息，则返回140，否则为130
    }else{
        //无数据时
        return 150;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    tmpView.backgroundColor = [UIColor whiteColor];
    
    
    //Date Btn
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
    [dateBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [dateBtn addTarget:self action:@selector(goDateSetting) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:dateBtn];
    
    UIImageView *arrow0 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 16, 0, 8, 44)];
    arrow0.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    arrow0.contentMode = UIViewContentModeCenter;
    [dateBtn addSubview:arrow0];
    [arrow0 release];
    
    //入住提示
    if(!liveInLabel){
        liveInLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 126, 20)];
    }
    self.liveInLabel.backgroundColor = [UIColor clearColor];
    self.liveInLabel.font = [UIFont systemFontOfSize:13.0f];
    self.liveInLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    self.liveInLabel.backgroundColor = [UIColor clearColor];
    NSDate *liveDate = [TimeUtils NSStringToNSDate:self.liveInStr formatter:@"yyyy-MM-dd"];
    self.liveInLabel.text = [NSString stringWithFormat:@"入 : %@ (%@)",[TimeUtils displayDateWithNSDate:liveDate formatter:@"M月d日"],[self getDateNoteWithDate:liveDate]];
    [dateBtn addSubview:self.liveInLabel];
    //离店提示
    if(!leaveOutLabel){
        leaveOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, 126, 20)];
    }
    self.leaveOutLabel.backgroundColor = [UIColor clearColor];
    self.leaveOutLabel.font = [UIFont systemFontOfSize:13.0f];
    self.leaveOutLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    self.leaveOutLabel.backgroundColor = [UIColor clearColor];
    NSDate *leaveDate = [TimeUtils NSStringToNSDate:self.leaveOutStr formatter:@"yyyy-MM-dd"];
    self.leaveOutLabel.text = [NSString stringWithFormat:@"离 : %@ (%d晚)",[TimeUtils displayDateWithNSDate:leaveDate formatter:@"M月d日"],[self getDaysWithDate:liveDate otherDate:leaveDate]];
    [dateBtn addSubview:self.leaveOutLabel];
    
    //Room Btn
    UIButton *roomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    roomBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44);
    [roomBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [roomBtn addTarget:self action:@selector(goRoomSetting) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:roomBtn];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 16, 0, 8, 44)];
    arrow1.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    arrow1.contentMode = UIViewContentModeCenter;
    [roomBtn addSubview:arrow1];
    [arrow1 release];
    
    
    //总宽度为132.
    if(!roomLabel){
        roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 16, 44)];
    }
    self.roomLabel.backgroundColor = [UIColor clearColor];
    self.roomLabel.textAlignment = NSTextAlignmentRight;
    self.roomLabel.font = [UIFont boldSystemFontOfSize:23.0f];
    self.roomLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    self.roomLabel.text = [NSString stringWithFormat:@"%d",self.roomNum];
    [roomBtn addSubview:self.roomLabel];
    
    UILabel *roomNote = [[UILabel alloc] initWithFrame:CGRectMake(5+15, 15, 25, 20)];
    roomNote.backgroundColor = [UIColor clearColor];
    roomNote.font = [UIFont systemFontOfSize:11];
    roomNote.textColor = RGBACOLOR(52, 52, 52, 1);
    roomNote.text = @"间房";
    [roomBtn addSubview:roomNote];
    [roomNote release];
    
    if(!adultLabel){
        adultLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, 26, 44)];
    }
    self.adultLabel.backgroundColor = [UIColor clearColor];
    self.adultLabel.textAlignment = NSTextAlignmentCenter;
    self.adultLabel.font = [UIFont boldSystemFontOfSize:23.0f];
    self.adultLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    self.adultLabel.text = [NSString stringWithFormat:@"%d",self.adultNum];
    [roomBtn addSubview:self.adultLabel];
    
    UILabel *adultNote = [[UILabel alloc] initWithFrame:CGRectMake(5+63, 15, 25, 20)];
    adultNote.backgroundColor = [UIColor clearColor];
    adultNote.font = [UIFont systemFontOfSize:11];
    adultNote.textColor = RGBACOLOR(52, 52, 52, 1);
    adultNote.text = @"成人";
    [roomBtn addSubview:adultNote];
    [adultNote release];
    
    if(!childLabel){
        childLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 26, 44)];
    }
    self.childLabel.backgroundColor = [UIColor clearColor];
    self.childLabel.textAlignment = NSTextAlignmentCenter;
    self.childLabel.font = [UIFont boldSystemFontOfSize:23.0f];
    self.childLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    self.childLabel.text = [NSString stringWithFormat:@"%d",self.childNum];
    [roomBtn addSubview:self.childLabel];
    
    UILabel *childNote = [[UILabel alloc] initWithFrame:CGRectMake(116, 15, 25, 20)];
    childNote.backgroundColor = [UIColor clearColor];
    childNote.font = [UIFont systemFontOfSize:11];
    childNote.textColor = RGBACOLOR(52, 52, 52, 1);
    childNote.text = @"儿童";
    [roomBtn addSubview:childNote];
    [childNote release];
    
    //SplitView
    UIImageView *separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 1, 24)];
    separateLine.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:0.7];
    [roomBtn addSubview:separateLine];
    [separateLine release];
    
    //虚线
    UIImageView *dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    dashLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [tmpView addSubview:dashLine];
    [dashLine release];
    
    dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    dashLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [tmpView addSubview:dashLine];
    [dashLine release];
    
    return [tmpView autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int count = [[InterHotelDetailCtrl rooms] count];
    if(count>0){        //当没有合适的房间时不能点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSInteger index = [tableView cellForRowAtIndexPath:indexPath].tag;
        ElongClientAppDelegate *app = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        InterRoomDetailView *roomDetailView = [[InterRoomDetailView alloc] initWithRoomIndex:index withFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        roomDetailView.delegate = self;
        [app.window addSubview:roomDetailView];
        
        roomDetailView.alpha = 0.0;
        [UIView beginAnimations:@"EaseOut" context:nil];
        [UIView setAnimationDuration:0.3];
        roomDetailView.alpha = 1.0;
        [UIView commitAnimations];
        
        if (UMENG) {
            //国际酒店房型详情
            [MobClick event:Event_InterRoomDetail];
        }
    }
}

#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidCanceled:(HttpUtil *)util{
    if([@"RequestRoom" isEqualToString:self.requestType]){
        [self endLoadingRoom];
    }
}

-(void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    if([@"RequestRoom" isEqualToString:self.requestType]){
        [self endLoadingRoom];
    }
}

-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{

    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (_couponUtil == util) {
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        [[Coupon activedcoupons] removeAllObjects];
        [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
        return;
    }else{
        
        if ([Utils checkJsonIsError:root]) {
            if([@"RequestRoom" isEqualToString:self.requestType]){
                [self endLoadingRoom];
                self.isLoadingRoomFailed = YES;
                self.firstLoadingRoom = YES;
                
                [[InterHotelDetailCtrl rooms] removeAllObjects];
                [self.mainTable reloadData];
            }
            
            return ;
        }
        if([@"RequestDetail" isEqualToString:self.requestType]){
            //酒店详情
            //处理详情数据
            [[InterHotelDetailCtrl detail] removeAllObjects];       //清空原有数据
            NSDictionary *hotelDetailInfo = [root safeObjectForKey:@"HotelDetailInformation"];
            if(DICTIONARYHASVALUE(hotelDetailInfo)){
                [[InterHotelDetailCtrl detail] addEntriesFromDictionary:hotelDetailInfo];
            }
            [self fillTableHeaderView]; //填充MainTable的HeaderView。
            self.mainTable.hidden = NO;
            
            //接着发送房间请求
            [self sendRoomRequest];
        }else if([@"RequestRoom" isEqualToString:self.requestType]){
            //酒店房间
            [self endLoadingRoom];
            self.isLoadingRoomFailed = NO;
            self.firstLoadingRoom = YES;
            
            [[InterHotelDetailCtrl rooms] removeAllObjects];
            NSArray *roomList = [root safeObjectForKey:GHHOTEL_ROOM_INFOLIST];
            if(ARRAYHASVALUE(roomList)){
                [[InterHotelDetailCtrl rooms] addObjectsFromArray:roomList];
            }
            self.firstLoadingRoom = YES;
            //展示UI
            [self.mainTable reloadData];
        }
    }
}

#pragma mark -
#pragma mark ElCalendarViewSelectDelegate
- (void) ElcalendarViewSelectDay:(ELCalendarViewController *)elViewController checkinDate:(NSDate *)checkin checkoutDate:(NSDate *)checkout{
    self.liveInLabel.text = [NSString stringWithFormat:@"入 : %@ (%@)",[TimeUtils displayDateWithNSDate:checkin formatter:@"M月d日"],[self getDateNoteWithDate:checkin]];
    self.leaveOutLabel.text = [NSString stringWithFormat:@"离 : %@ (%d晚)",[TimeUtils displayDateWithNSDate:checkout formatter:@"M月d日"],[self getDaysWithDate:checkin otherDate:checkout]];
    
    
    //更改日期，重新发送请求
    self.liveInStr = [TimeUtils displayDateWithNSDate:checkin formatter:@"yyyy-MM-dd"];
    self.leaveOutStr = [TimeUtils displayDateWithNSDate:checkout formatter:@"yyyy-MM-dd"];
    [self sendRoomRequest];
    
    if (UMENG) {
        //国际酒店详情页改变日历
        [MobClick event:Event_InterHotelDetail_Calendar];
    }
}


@end
