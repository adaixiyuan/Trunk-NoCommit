//
//  XGSpecialProductDetailViewController.m
//  ElongClient
//
//  Created by licheng on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGSpecialProductDetailViewController.h"
#import "XGMapInfoCell.h"
#import "XGMixedTableViewCell.h"
#import "XGRoomTableViewCell.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "ImageDownLoader.h"
#import "UIImageView+WebCache.h"
#import "HotelThumbnailVC.h"
#import "HotelMapViewController.h"
#import "XGMapViewController.h"
#import "XGHotelInfoViewController.h"
#import "RoomDetailView.h"
#import "UMengEventC2C.h"
#import "XGhomeOrderFillInViewController.h"
#define GOODSFAVORITEAFTERLOGIN @"GOODSFAVORITEAFTERLOGIN"  //登陆成功后发起的通知
// room cell 高度
#define kCellNormalHeight         110

#define kCellDetailHeight         (SCREEN_HEIGHT-120)

#define kCellPhotoHeight          180


@interface XGSpecialProductDetailViewController ()<ImageDownDelegate>

@property (nonatomic,strong) UIView *markView;
@property (nonatomic,strong) RoomDetailView *detailCell;
@property (nonatomic,strong) UIButton *roomCellCloseBtn;
@property (nonatomic,strong) NSIndexPath *detailIndexPath;
@property (nonatomic,strong) UIButton *leftBtn ;

@end

@implementation XGSpecialProductDetailViewController
@synthesize roomCellCloseBtn=_roomCellCloseBtn;
-(UIButton *)roomCellCloseBtn
{
    if (_roomCellCloseBtn ==nil) {
        _roomCellCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _roomCellCloseBtn.exclusiveTouch = YES;
        [_roomCellCloseBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [_roomCellCloseBtn addTarget:self action:@selector(closeRoomDetail) forControlEvents:UIControlEventTouchUpInside];
        _roomCellCloseBtn.alpha = 0;
        _roomCellCloseBtn.frame = CGRectMake(_detailCell.frame.size.width + _detailCell.frame.origin.x - 32, _detailCell.frame.origin.y - 28, 60, 60);
    }
    return _roomCellCloseBtn;
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    
	if (self=[super initWithTitle:nil style:_NavOnlyBackBtnStyle_]) {
//        self.isPreLoaded = YES;
        
        self.tableImgeDict	= [[NSMutableDictionary alloc] initWithCapacity:2];
		self.progressManager	= [[NSMutableArray alloc] initWithCapacity:2];
		self.queue			= [[NSOperationQueue alloc] init];
        
        self.isPreLoaded = YES;
    }
    return self;
}


-(void) addTopImageTitle:(NSString *)titleStr
{
    UIView *topView = [[UIView alloc] init];
    
    int offX = 0;
    
    CGSize size = [titleStr sizeWithFont:FONT_B17];
    if (size.width >= 190) {
        size.width = 185;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 12, size.width, 20)];
    label.tag = 101;
    label.backgroundColor	= [UIColor clearColor];
    label.font				= FONT_B17;
    label.textColor			= COLOR_NAV_TITLE;
    label.text				= titleStr;
    label.textAlignment		= UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 14.0f;
    
    
    UILabel *starLbl = [[UILabel alloc] initWithFrame:CGRectMake(label.right, 13, 60, 20)];
    starLbl.backgroundColor = [UIColor clearColor];
    starLbl.textAlignment = UITextAlignmentLeft;
    starLbl.font = [UIFont boldSystemFontOfSize:12];
    starLbl.textColor = RGBACOLOR(108, 108, 108, 1);
    starLbl.text = [PublicMethods getStar:[[[HotelDetailController hoteldetail] safeObjectForKey:NEWSTAR_CODE] intValue]];
//    starLbl.text = @"豪华型";
    [topView addSubview:starLbl];
    
    topView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
    [topView addSubview:label];
    self.navigationItem.titleView = topView;
    
}

-(id)navBarButtonItemWithTarget:(id)target
                      rightIcon:(NSString *)rightIconPath
              rightButtonAction:(SEL)rightSelector
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 44, 44)];
    buttonView.backgroundColor = [UIColor clearColor];
    
    // 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor = [UIColor clearColor];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn addTarget:target action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:rightIconPath] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(13,20, 14, 7)];
    [buttonView addSubview:rightBtn];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (IOSVersion_7) {
        negativeSpacer.width = -15;
    }
    NSArray *rightArray= [NSArray arrayWithObjects:negativeSpacer, buttonItem, nil];
    
    return rightArray;
}

-(void)calltele{
    NSLog(@"联系商家。。。。");
    [super calltel400];
    UMENG_EVENT(UEvent_C2C_Home_List_Detail_TelBTN)
    
}

-(id)navBarLeftButtonItemWithTarget:(id)target
                   leftButtonAction:(SEL)leftSelector
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 50, 44)];
    // 右按钮
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 48, 44);
    [_leftBtn setImage:[UIImage imageNamed:@"XGback.png"] forState:UIControlStateNormal];
    [_leftBtn addTarget:target action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(14,5, 13, 34)];
    [buttonView addSubview:_leftBtn];
    
    _badgeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, 21, 15)];
    _badgeLabel.backgroundColor = [UIColor colorWithRed:210/255.0 green:70/255.0 blue:36/255.0 alpha:1];
    _badgeLabel.layer.masksToBounds = YES;
    
    _badgeLabel.center = CGPointMake(44/2+5, 44/2);
    _badgeLabel.layer.cornerRadius = 7.5;
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.font = [UIFont systemFontOfSize:12];
    _badgeLabel.textColor = [UIColor whiteColor];
    [_leftBtn addSubview:_badgeLabel];
    
    [self changeMessageCount:(self.filter.reponseReplayNum-self.filter.perResponseNum)];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        negativeSpacer.width = -11;
    }else{
        negativeSpacer.width = -2;
    }
    
    NSArray *rightArray= [NSArray arrayWithObjects:negativeSpacer, buttonItem, nil];
    
    return rightArray;
}

#pragma mark --修改 新酒店数量设置

-(void)changeMessageCount:(int)count{
    
    if (count>=10) {
        
        _badgeLabel.frame = CGRectMake(0, 0, 21, 15);
        _badgeLabel.center = CGPointMake(44/2+5, 44/2);
        _badgeLabel.hidden = NO;
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(14,5, 13, 34)];
        [_leftBtn setImage:[UIImage imageNamed:@"XGback.png"] forState:UIControlStateNormal];
    }else if(count>0){
        _badgeLabel.frame = CGRectMake(0, 0, 15, 15);
        _badgeLabel.center = CGPointMake(44/2+5, 44/2);
        _badgeLabel.hidden = NO;
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(14,5, 13, 34)];
        [_leftBtn setImage:[UIImage imageNamed:@"XGback.png"] forState:UIControlStateNormal];
    }else if (count>=99){
        count=99;
        _badgeLabel.hidden = NO;
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(14,5, 13, 34)];
        [_leftBtn setImage:[UIImage imageNamed:@"XGback.png"] forState:UIControlStateNormal];
        
    }else if (count<=0){
        count = 0;
        _badgeLabel.hidden = YES;
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5,0, 5, 0)];
        [_leftBtn setImage:[UIImage imageNamed:@"btn_navback_normal.png"] forState:UIControlStateNormal];
        
    }
    _badgeLabel.text = [NSString stringWithFormat:@"%d",count];
    
    
//    if (count>0){
//        
//        _badgeLabel.frame = CGRectMake(0, 0, 15, 15);
//        _badgeLabel.center = CGPointMake(44/2+5, 44/2);
//        _badgeLabel.hidden = NO;
//        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(14,5, 13, 34)];
//        [_leftBtn setImage:[UIImage imageNamed:@"XGback.png"] forState:UIControlStateNormal];
//        
//    }else if (count<=0){
//        count = 0;
//        _badgeLabel.hidden = YES;
//        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5,0, 5, 0)];
//        [_leftBtn setImage:[UIImage imageNamed:@"btn_navback_normal.png"] forState:UIControlStateNormal];
//        
//    }
}

-(void)backAction{
    [super back];
}

#pragma mark - 通知  新酒店相应数量通知
-(void)updateReplayCount:(NSNotification *)notification{
    
    id countNUM = [notification object];
    if (countNUM!=nil&&![countNUM isKindOfClass:[NSNull class]]) {
        int count = [countNUM intValue];
        [self changeMessageCount:count];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReplayCount:) name:NotifactionXGSearchFilterMessage object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nowPayHotelFillOrderPage) name:GOODSFAVORITEAFTERLOGIN object:nil];
    
    //title
    [self addTopImageTitle:[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {
        self.navigationItem.leftBarButtonItems =[self navBarLeftButtonItemWithTarget:self leftButtonAction:@selector(backAction)];
        self.navigationItem.rightBarButtonItems =[self navBarButtonItemWithTarget:self rightIcon:@"XGtel.png" rightButtonAction:@selector(calltele)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem=[self navBarLeftButtonItemWithTarget:self leftButtonAction:@selector(backAction)][1];
        self.navigationItem.rightBarButtonItem=[self navBarButtonItemWithTarget:self rightIcon:@"XGtel.png" rightButtonAction:@selector(calltele)][1];
    }
    // 滑动手势，返回列表
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    self.sourceArray = [[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"];

    NSLog(@"remark===\n%@",self.remark);
    
    
    // 添加主题容器
    [self addContentView];
    
    UMENG_EVENT(UEvent_C2C_Home_List_Detail)
}


// 添加主体容器框架
- (void) addContentView
{
    self.contentList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    self.contentList.backgroundColor = [UIColor clearColor];
    self.contentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentList];
    self.contentList.tableHeaderView = [self createTableHeaderView];
    self.contentList.tableFooterView = [self createTableFooterView];
    self.contentList.dataSource = self;
    self.contentList.delegate = self;
}
//创建表头
-(UIView *)createTableHeaderView{
    
    UIView *headerView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageViewBg = [[UIImageView alloc]initWithFrame:headerView.frame];
    imageViewBg.contentMode = UIViewContentModeScaleAspectFill;
    imageViewBg.clipsToBounds = YES;
    NSArray *imageArray=[[HotelDetailController hoteldetail] safeObjectForKey:HOTEL_IMAGE_ITEMS];
    
    NSURL *imageUrl =  nil;

    
    for (int i =0; i<[imageArray count]; i++) {
        NSDictionary *dict  = [imageArray safeObjectAtIndex:i];
        NSString *imagePath = [dict safeObjectForKey:@"ImagePath"];
        if (STRINGHASVALUE(imagePath)) {
            imageUrl = [NSURL URLWithString:imagePath];
            break;
        }
    }
    
    [imageViewBg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"XGhomeDefault.png"] options:SDWebImageCacheMemoryOnly];
    [headerView addSubview:imageViewBg];
    
    UIButton *imagebgBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    imagebgBTN.backgroundColor = [UIColor clearColor];
    imagebgBTN.frame = headerView.frame;
    [imagebgBTN addTarget:self action:@selector(seePicsAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:imagebgBTN];
    
    UIImageView *darkImage =  [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-111, 150-25, 111, 25)];
    darkImage.image = [UIImage noCacheImageNamed:@"XGdark.png"];
    [headerView addSubview:darkImage];
    
    
    UILabel *imagesNum = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-111, 150-25, 111, 25)];
    imagesNum.backgroundColor = [UIColor clearColor];
    imagesNum.textColor = [UIColor whiteColor];
    NSString *totalCount = [NSString stringWithFormat:@"    共%d张",[imageArray count]];
    imagesNum.text = totalCount;
    imagesNum.textAlignment = NSTextAlignmentCenter;
    imagesNum.font = FONT_15;
    [headerView addSubview:imagesNum];
    
    return headerView;
}

-(UIView *)createTableFooterView{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UIButton *telePhone = [UIButton buttonWithType:UIButtonTypeCustom];
    telePhone.backgroundColor = [UIColor whiteColor];
    telePhone.layer.masksToBounds = YES;
    telePhone.layer.cornerRadius = 2.0;
    telePhone.layer.borderWidth = .5;
    telePhone.layer.borderColor = [UIColor colorWithWhite:200/255.0 alpha:1].CGColor;
    telePhone.frame = CGRectMake(7.5, 7.5, 305, 35);
    [telePhone addTarget:self action:@selector(calltele) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:telePhone];
    
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(111, 16.5, 17, 17)];
    imageIcon.image = [UIImage noCacheImageNamed:@"XGtel.png"];
    [footerView addSubview:imageIcon];
    
    UILabel *titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(135, 15, 60, 20)];
    titleLabel.text = @"联系商家";
    titleLabel.font = FONT_B14;
    titleLabel.textColor = RGBACOLOR(130, 130, 130, 1);
    [footerView addSubview:titleLabel];
    
    return footerView;
}


#pragma mark -
#pragma mark 查看酒店图片
-(void)seePicsAction{
    NSLog(@"查看照片");
    
    NSArray *orgImageArray = [[HotelDetailController hoteldetail] safeObjectForKey:HOTEL_IMAGE_ITEMS];
    if (orgImageArray != nil && [orgImageArray count] > 0)
    {
        HotelThumbnailVC *hotelPhotoVC = [[HotelThumbnailVC alloc] initWithTitle:@""];
        [hotelPhotoVC setArrayAllImgs:orgImageArray];
        [self.navigationController pushViewController:hotelPhotoVC animated:YES];
    }

}
#pragma mark -
#pragma mark 查看酒店地图

-(void)seeMapDetailAction{
    
    NSLog(@"知悉map");
    
    XGMapViewController *hotelMapVC = [[XGMapViewController alloc] initWithTitle:@"酒店位置" style:NavBarBtnStyleOnlyBackBtn];
    hotelMapVC.lat = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Latitude_D];
    hotelMapVC.lng = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Longitude_D];
    hotelMapVC.hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S];;
    hotelMapVC.hotelSubtitle = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Address_S];;
    [self.navigationController pushViewController:hotelMapVC animated:YES];
    
}

#pragma mark -
#pragma mark 查看详情
-(void)seeInfoDetailAction{
    
    XGHotelInfoViewController * hotelInfoVC = [[XGHotelInfoViewController alloc]initWithTitle:@"酒店详情" style:NavBarBtnStyleOnlyBackBtn];
    [hotelInfoVC setHotelInfoWebByData:[HotelDetailController hoteldetail] type:HotelInfoTypeNativeFromXGHomeDetail];
    [self.navigationController pushViewController:hotelInfoVC animated:YES];
    
}

#pragma mark -
#pragma mark 查看评价
-(void)seeEvaluteAction{
    
    XGCommentViewController * commentVC = [[XGCommentViewController alloc] initWithTitle:@"酒店评论" style:NavBarBtnStyleOnlyBackBtn];
    commentVC.hotelDic = [HotelDetailController hoteldetail];
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

#pragma mark -
#pragma mark UITableViewDataSource

//多少个区域
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//每个区域 多少个cell
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return 2;
    }else{
        return [self.sourceArray count];
    }
    
}
//生成cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __unsafe_unretained typeof(self) vcself = self;
    if (indexPath.section==0) {
        
        if (indexPath.row == 0) {
            
            static NSString *cellIdentifier1 = @"InfoCell1";
            XGMapInfoCell *cell = (XGMapInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (!cell) {
                cell = [[XGMapInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
            }
            cell.hoteldetailDict = [HotelDetailController hoteldetail];
            
            cell.mapActionBlock = ^(void){
                [vcself seeMapDetailAction];
            };
            
            return cell;
            
        }else if (indexPath.row ==1 ){
            
            static NSString *cellIdentifier2 = @"InfoCell2";
            XGMixedTableViewCell *cell = (XGMixedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (!cell) {
                cell = [[XGMixedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            }
            cell.hoteldetailDict = [HotelDetailController hoteldetail];
            
            cell.detailBlock = ^(void){
                [vcself seeInfoDetailAction];
            };
            
            cell.evaluateBlock = ^(void){
                [vcself seeEvaluteAction];
            };
            
            return cell;
            
        }
    }else{
        
        static NSString *cellIdentifier3 = @"InfoCell3";
        XGRoomTableViewCell *cell = (XGRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (!cell) {
            cell = [[XGRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        }
        
        NSDictionary *dict = [self.sourceArray safeObjectAtIndex:indexPath.row];
        cell.viewController = self;
        cell.roomDict = dict;
        cell.roomindex = indexPath.row;
        [cell setValueByModelDictionary:dict];
        if (indexPath.row == 0) {
            cell.topLineImgView.hidden = NO;
        }else{
            cell.topLineImgView.hidden = YES;
        }
        
        cell.clickboockBlock = ^(int RoomIndex){
            
            [vcself preJudgeLogin:RoomIndex];
        };

        return cell;

    }
    return nil;
}


//区头 view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0 ) {
        return nil;
    }else if (section ==1){
        
        UIView *bgView = [[UIView alloc] init];
        
        if(STRINGHASVALUE(self.remark)){
            bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
            UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, 44, 12)];
            otherLabel.backgroundColor =  RGBACOLOR(85, 136, 204, 1);
            otherLabel.textColor = [UIColor whiteColor];
            otherLabel.textAlignment = NSTextAlignmentCenter;
            otherLabel.text = @"商家说明";
            otherLabel.font = [UIFont systemFontOfSize:9];
            [bgView addSubview:otherLabel];
            
            NSString *words=self.remark; //@"必须上午12点前退房,可提供果盘一份。最后一件,给你打了88折";
            CGSize size = [words sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 11, size.width, size.height)];
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.numberOfLines =0;
            contentLabel.font = FONT_12;
            contentLabel.text = words;
            contentLabel.textColor = [UIColor blackColor];
            [bgView addSubview:contentLabel];
        }else{
            bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        }
        
        return bgView;
    }
    return nil;
}

//区头 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else if (section ==1){
        
        if(STRINGHASVALUE(self.remark)){
            
            NSString *words=self.remark; //@"必须上午12点前退房,可提供果盘一份。最后一件,给你打了88折";
            CGSize size = [words sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:NSLineBreakByWordWrapping];
            return size.height+20;
            
        }else{
            return 15;
        }
    }
    return 0;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            return 62;
        }else if (indexPath.row==1){
            return 40;
        }
    }else if (indexPath.section == 1){
        
        return 105;
        
    }
    return 44;
}
//显示详情
- (void)setRoomTypeDetailView:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // markview
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.markView.backgroundColor = [UIColor blackColor];
    self.markView.alpha = 0.0;
    [window addSubview:self.markView];
    
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailMarkSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.markView addGestureRecognizer:singleTap];
    
    // 拷贝cell
    self.detailCell = [[RoomDetailView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT - kCellDetailHeight)/2, 280, kCellDetailHeight) ];
    [window addSubview:self.detailCell];
    self.detailCell.alpha = 0;
    self.detailCell.hotelImageView.alpha = 0;
    
    // 附加
    // 关闭按钮
    [window addSubview:self.roomCellCloseBtn];
    
    
    self.detailIndexPath = indexPath;
    
    XGRoomTableViewCell *cell = (XGRoomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *formerText = [cell.room getRoomTypeFormerTextByAdditionInfoList];
    NSString *roomTypeTips = [cell.room roomTypeTips];
    self.detailCell.hotelNameLbl.text = @"";
    if (![roomTypeTips isEqualToString:@""]) {
        self.detailCell.hotelNameLbl.text = [NSString stringWithFormat:@"%@ %@",formerText,roomTypeTips];
        [self.detailCell.hotelNameLbl setColor:[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1] fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [self.detailCell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:formerText.length];
        [self.detailCell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:12.0f] fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [self.detailCell.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:formerText.length];
    }else{
        self.detailCell.hotelNameLbl.text = formerText;
        [self.detailCell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:self.detailCell.hotelNameLbl.text.length];
        [self.detailCell.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:formerText.length];
    }
    /////
    // 房型设施
    self.detailCell.breakfastLbl.text = cell.room.breakfast;//[dic safeObjectForKey:@"Content"];
    // 宽带说明
    self.detailCell.networkLbl.text = cell.room.network;// [dic safeObjectForKey:@"Content"];
    // 面积说明
    self.detailCell.areaLbl.text = cell.room.area;// [dic safeObjectForKey:@"Content"];
    self.detailCell.floorLbl.text = cell.room.floor;
    // 床型说明
    self.detailCell.bedLbl.text =cell.room.bed;
    if (self.detailCell.bedLbl.text.length < 16) {
        self.detailCell.bedLbl.frame = CGRectMake(self.detailCell.bedLbl.frame.origin.x, self.detailCell.bedLbl.frame.origin.y, self.detailCell.bedLbl.frame.size.width, 17);
    }
    self.detailCell.priceLbl.text = [NSString stringWithFormat:@"%@%@",cell.priceMarkLbl.text,cell.priceLbl.text];
    
    if (cell.room.GiftDescription && cell.room.GiftDescription.length>0) {
        [self.detailCell setGift:cell.room.GiftDescription];
    }
    
    // 满房
    self.detailCell.bookingBtn.enabled = cell.bookingBtn.enabled;
    [self.detailCell.bookingBtn setTitle:cell.bookingBtn.titleLabel.text forState:UIControlStateNormal];
    
    
    // 房型设施
    // 其他信息
    if (cell.room.other) {
        [self.detailCell setOtherInfo:cell.room.other];
    }
    
    if (STRINGHASVALUE(cell.room.PicUrl)) {
        if (![self.tableImgeDict safeObjectForKey:indexPath]) {
            [self.detailCell.hotelImageView setImageWithURL:[NSURL URLWithString:cell.room.PicUrl] options:SDWebImageCacheMemoryOnly progress:YES];
        }else {
            self.detailCell.hotelImageView.contentMode =  UIViewContentModeScaleAspectFill;
            self.detailCell.hotelImageView.image = [self.tableImgeDict safeObjectForKey:indexPath];
        }
    }else{
        self.detailCell.hotelImageView.image = [UIImage noCacheImageNamed:@"bg_detail_nohotelpic.png"];
    }
    [self.detailCell.bookingBtn addTarget:self action:@selector(clickBookingBtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 动画开始整
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0.8;
        self.roomCellCloseBtn.alpha = 1;
        self.detailCell.alpha = 1;
        self.detailCell.hotelImageView.alpha = 1;
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 只处理section=1的情况
    if(indexPath.section == 0){
        return;
    }
    
    if (self.markView) {
        return;
    }
    
    [self setRoomTypeDetailView:indexPath tableView:tableView];
}


//点击预订按钮
- (void) clickBookingBtn{
    
    
    NSLog(@"aaa");

    XGRoomTableViewCell *cell = (XGRoomTableViewCell *)[self.contentList cellForRowAtIndexPath:self.detailIndexPath];
    [cell performSelector:@selector(booking)];
    
    [self closeRoomDetail];
}

- (void)detailMarkSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    [self closeRoomDetail];
}

- (void) closeRoomDetail{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.detailIndexPath.row inSection:self.detailIndexPath.section];
    self.detailIndexPath = nil;
    [self.contentList reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0.0;
        self.detailCell.alpha = 0.0;
        self.roomCellCloseBtn.alpha = 0.0;
        self.detailCell.alpha = 0;
        self.detailCell.hotelImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [self.detailCell removeFromSuperview];
        [self.roomCellCloseBtn removeFromSuperview];
    }];
}



#pragma mark - 点击预定 包括预付和 非预付

-(void)preJudgeLogin:(int)roomindex{
    
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    
	[RoomType setCurrentRoomIndex:roomindex];
    
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:roomindex];
    
	[[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD_IsCustomerNameEn]
                                                forKey:RespHD_IsCustomerNameEn];				// 判断是否需要用户必须选择英文用户名
    [[HotelDetailController hoteldetail] safeSetObject:[NSNull null]
                                                forKey:RespHD__HotelCoupon_DI];				// 优惠券返现
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:room];
    [newDict safeSetObject:[NSNull null] forKey:RespHD__HotelCoupon_DI];
    
    
    [[HotelDetailController hoteldetail] safeSetObject:[room safeObjectForKey:RespHD__RoomTypeName_S]
                                                forKey:ExSelectRoomType];
    
    [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] setObject:newDict atIndex:roomindex];
    
    
    // 设置预付参数
    if ([[room safeObjectForKey:@"PayType"] intValue] == 1) {
        [RoomType setIsPrepay:YES];
    }
    else {
        [RoomType setIsPrepay:NO];
    }
    

    if ([[room safeObjectForKey:@"PayType"] intValue] == 0) { //现付  自己写
        
        if (islogin) {
            [self nowPayHotelFillOrderPage];
        }else{
            LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:GOODS_FAVORITE_];
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }else{  //主逻辑   //带预付的
        
        if (islogin) {
            [self nowPayHotelFillOrderPage];
        }else{
            
            LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:GOODS_FAVORITE_];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
    
}


//现付 自己写的
- (void)nowPayHotelFillOrderPage{
    
    int roomIndex = [RoomType currentRoomIndex];
    NSDictionary *roomDict = [self.sourceArray safeObjectAtIndex:roomIndex];
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:roomIndex];
    if ([[room safeObjectForKey:@"PayType"] intValue] == 0) {  //现付    走自己的
        XGhomeOrderFillInViewController *fillVC = newObject(XGhomeOrderFillInViewController);
        fillVC.roomDict = roomDict;
        fillVC.filter = self.filter;
        [self.navigationController pushViewController:fillVC animated:YES];
    }
    else {  //预付  走主aip
        
        // 进入酒店订单填写页面
        FillHotelOrder *fillhotelOrder = [[FillHotelOrder alloc] init];
        fillhotelOrder.isSkipLogin = YES;
        fillhotelOrder.currentBookingType = C2C_Booking;
        fillhotelOrder.filter = self.filter;
        [self.navigationController pushViewController:fillhotelOrder animated:YES];
    }
    
}




#pragma mark -
#pragma mark 滑动手势处理，返回列表页

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [super back];
        
    }
}

#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo
{
    UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
    NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
    
    [self.tableImgeDict safeSetObject:image forKey:indexPath];
    
    NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:
                              indexPath, @"indexPath",
                              image, @"image",
                              nil];
    
    [self performSelectorOnMainThread:@selector(setCellImageWithData:) withObject:celldata waitUntilDone:NO];
}

- (void)setCellImageWithData:(id)celldata
{
	UIImage *img		= [celldata safeObjectForKey:@"image"];
	NSIndexPath *index	= [celldata safeObjectForKey:@"indexPath"];
	
	XGRoomTableViewCell *cell = (XGRoomTableViewCell *)[self.contentList cellForRowAtIndexPath:index];
	[cell.hotelImageView endLoading];
	cell.hotelImageView.image = img;
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _contentList)
    {
        CGFloat sectionHeaderHeight = [self tableView:_contentList heightForHeaderInSection:1];
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
