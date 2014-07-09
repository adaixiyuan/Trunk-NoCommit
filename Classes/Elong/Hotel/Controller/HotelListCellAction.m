//
//  HotelListCellAction.m
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelListCellAction.h"
#import "AccountManager.h"
#import "HotelPostManager.h"

@interface HotelListCellAction()
@property (nonatomic,retain) NSDictionary *hotelDict;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lng;
@property (nonatomic,copy) NSString *hotelName;
@property (nonatomic,assign) NSInteger star;
@property (nonatomic,assign) float rating;
@property (nonatomic,copy) NSString *business;
@property (nonatomic,copy) NSString *district;
@property (nonatomic,copy) NSString *address;
@end

@implementation HotelListCellAction

- (void) dealloc{
    self.hotelDict = nil;
    self.hotelId = nil;
    self.hotelName = nil;
    self.business = nil;
    self.district = nil;
    self.address = nil;
    if (favUtil) {
        [favUtil cancel];
        [favUtil release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


#pragma mark -
#pragma mark HotelListCellDelegate

- (void) hotelListCell:(HotelListCell *)cell didAction:(HotelListActionType)actionType{
    if (cell.isLM) {
        self.hotelDict = [[HotelSearch tonightHotels] safeObjectAtIndex:cell.dataIndex];
    }else{
        self.hotelDict = [[HotelSearch hotels] safeObjectAtIndex:cell.dataIndex];
    }
    
    
    self.hotelId = [self.hotelDict safeObjectForKey:@"HotelId"];
    self.lat = [[self.hotelDict safeObjectForKey:@"Latitude"] doubleValue];
    self.lng = [[self.hotelDict safeObjectForKey:@"Longitude"] doubleValue];
    self.hotelName = [self.hotelDict safeObjectForKey:@"HotelName"];
    self.star = [[self.hotelDict safeObjectForKey:@"NewStarCode"] intValue];
    self.rating = [[self.hotelDict safeObjectForKey:@"Rating"] floatValue];
    self.business = [self.hotelDict safeObjectForKey:@"BusinessAreaName"];
    self.district = [self.hotelDict safeObjectForKey:@"DistrictName"];
    self.address = [self.hotelDict safeObjectForKey:@"Address"];
    
    switch (actionType) {
        case HotelListActionFav:{
            // 注册收藏监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ADDFAVOR_SUCCESS object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFavorSuccess:) name:NOTI_ADDFAVOR_SUCCESS object:nil];
            
            // 调用收藏酒店接口
            BOOL islogin = [[AccountManager instanse] isLogin];
            if (islogin) {
                JAddFavorite *addFavorite = [HotelPostManager addFavorite];
                [addFavorite setHotelId:self.hotelId];
                
                if (favUtil) {
                    [favUtil cancel];
                    [favUtil release];
                }
                favUtil = [[HttpUtil alloc] init];
                [favUtil connectWithURLString:HOTELSEARCH  Content:[addFavorite requesString:YES] StartLoading:NO EndLoading:NO Delegate:self];
                
                // 停止监听
                [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ADDFAVOR_SUCCESS object:nil];
            }else {
                [[HotelDetailController hoteldetail] safeSetObject:self.hotelId forKey:@"HotelId"];
                
                // 需登录收藏
                LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavNormalBtnStyle_ state:_HotelAddFavorite_];
                [self.parentNav pushViewController:login animated:YES];
                [login release];
            }
        }
            break;
        case HotelListActionNav:{
            if ([[ServiceConfig share] monkeySwitch]){
                // 开着monkey时不发生事件
                return;
            }
            if (self.lat == 0 && self.lng == 0) {
                [Utils alert:@"抱歉，酒店坐标不存在，无法导航，谢谢"];
                return;
            }
            
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(self.lat, self.lng) title:self.hotelName];
            return ;
        }
            break;
        case HotelListActionShare:{
            if ([[ServiceConfig share] monkeySwitch]){
                // 开着monkey时不发生事件
                return;
            }
            ElongClientAppDelegate *_delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            UIViewController *controller = [_delegate.navigationController.viewControllers lastObject];
            ShareTools *shareTools = [ShareTools shared];
            shareTools.sharefrom = Sharefromhotelist;
            shareTools.contentViewController = controller;
            shareTools.contentView = nil;
            shareTools.hotelImage = nil;
            shareTools.needLoading = NO;
            shareTools.imageUrl = nil;
            shareTools.mailView = nil;
            NSString *hotelid = self.hotelId;
            shareTools.mailImage = cell.imageView.image;
            shareTools.hotelId = hotelid;
            shareTools.msgContent = @"test";
            shareTools.mailTitle = @"我用艺龙客户端查找到一家酒店";
            shareTools.weiBoContent = [self weiboContent];
            shareTools.msgContent = [self smsContent];
            shareTools.mailContent = [self mailContent];
            [shareTools  showItems];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)getFavorSuccess:(NSNotification *)noti{
	// 停止监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ADDFAVOR_SUCCESS object:nil];
    [PublicMethods showAlertTitle:@"" Message:@"收藏成功"];
}

// 短信分享内容
-(NSString *) smsContent{
    NSString *hotelname = [NSString stringWithFormat:@"我用艺龙客户端查找到一家酒店,%@;",self.hotelName];
    NSString *starlevel =  [NSString stringWithFormat:@"星级:%@;",[PublicMethods getStar:self.star]];
    NSString *Rating =  [NSString stringWithFormat:@"评价:%.1f;",self.rating];
    NSString *BusinessAreaNameandDistrictName =  [NSString stringWithFormat:@"区域:%@ %@;",self.business,self.district];
    NSString *Address =  [NSString stringWithFormat:@"地址:%@,订酒店，用艺龙！下载链接：http://m.elong.com/b/r?p=z",self.address];
    NSString *messageBody = [NSString stringWithFormat:@"%@%@%@%@%@",hotelname,starlevel,Rating,BusinessAreaNameandDistrictName,Address];
	return messageBody;
}


// 邮件分享内容
-(NSString *) mailContent{
    NSString *hotelname = [NSString stringWithFormat:@"我用艺龙客户端查找到一家酒店,%@;",self.hotelName];
    NSString *starlevel =  [NSString stringWithFormat:@"星级:%@;",[PublicMethods getStar:self.star]];
    NSString *Rating =  [NSString stringWithFormat:@"评价:%.1f;",self.rating];
    NSString *BusinessAreaNameandDistrictName =  [NSString stringWithFormat:@"区域:%@ %@;",self.business,self.district];
    NSString *Address =  [NSString stringWithFormat:@"地址:%@,订酒店，用艺龙！",self.address];
    NSString *messageBody = [NSString stringWithFormat:@"%@%@%@%@%@",hotelname,starlevel,Rating,BusinessAreaNameandDistrictName,Address];
	return messageBody;
}


// 微博分享内容
- (NSString *) weiboContent{
    NSString *hotelname = [NSString stringWithFormat:@"我用艺龙客户端查找到一家酒店,%@;",self.hotelName];
    NSString *starlevel =  [NSString stringWithFormat:@"星级:%@;",[PublicMethods getStar:self.star]];
    NSString *Rating =  [NSString stringWithFormat:@"评价:%.1f;",self.rating];
    NSString *BusinessAreaNameandDistrictName =  [NSString stringWithFormat:@"区域:%@ %@;",self.business,self.district];
    NSString *Address =  [NSString stringWithFormat:@"地址:%@,订酒店，用艺龙！下载链接：http://m.elong.com/b/r?p=z",self.address];
    NSString *messageBody = [NSString stringWithFormat:@"%@%@%@%@%@",hotelname,starlevel,Rating,BusinessAreaNameandDistrictName,Address];
	return messageBody;
}

#pragma mark -
#pragma mark HttpUtilDelegate
- (void) httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if (util == favUtil) {
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        [PublicMethods showAlertTitle:@"" Message:@"收藏成功"];
    }
}

@end
