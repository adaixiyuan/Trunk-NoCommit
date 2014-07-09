//
//  HomeAdNavi.m
//  ElongClient
//
//  Created by Dawn on 14-5-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HomeAdNavi.h"
#import "MainPageController.h"
#import "HotelPromotionInfoRequest.h"
#import "GDetailRequest.h"
#import "CommentHotelRequest.h"
#import "CashAccountReq.h"
#import "OrderHistoryPostManager.h"

@interface HomeAdNavi(){
@private
    HttpUtil *hotelDetailHttpUtil;
    HttpUtil *grouponDetailHttpUtil;
    HttpUtil *hotelCommentHttpUtil;
    HttpUtil *cashAccountHttpUtil;
    HttpUtil *feedbackHttpUtil;
    HttpUtil *feedbackHttpUtil1;
    HttpUtil *hotelorderListHttpUtil;
    HttpUtil *hotelorderDetailHttpUtil;
}
@property (nonatomic,assign) ElongClientAppDelegate *appDelegate;
@property (nonatomic,assign) MainPageController *mainPageController;
@property (nonatomic,assign) BOOL hotelDetailFromH5;
@property (nonatomic,assign) BOOL grouponDetailFromH5;
@property (nonatomic,copy) NSString *orderid;
@property (nonatomic,retain) NSDictionary *order;
@property (nonatomic,assign) BOOL active;
@end

@implementation HomeAdNavi

- (void) dealloc{
    self.delegate = nil;
    self.orderid = nil;
    self.order = nil;
    self.checkInDate = nil;
    self.checkOutDate = nil;
    if (hotelDetailHttpUtil) {
        [hotelDetailHttpUtil cancel];
        SFRelease(hotelDetailHttpUtil);
    }
    if (grouponDetailHttpUtil) {
        [grouponDetailHttpUtil cancel];
        SFRelease(grouponDetailHttpUtil);
    }
    if (hotelCommentHttpUtil) {
        [hotelCommentHttpUtil cancel];
        SFRelease(hotelCommentHttpUtil);
    }
    if (cashAccountHttpUtil) {
        [cashAccountHttpUtil cancel];
        SFRelease(cashAccountHttpUtil);
    }
    if (feedbackHttpUtil) {
        [feedbackHttpUtil cancel];
        SFRelease(feedbackHttpUtil);
    }
    if (feedbackHttpUtil1) {
        [feedbackHttpUtil1 cancel];
        SFRelease(feedbackHttpUtil1);
    }
    if (hotelorderListHttpUtil) {
        [hotelorderListHttpUtil cancel];
        SFRelease(hotelorderListHttpUtil);
    }
    if (hotelorderDetailHttpUtil) {
        [hotelorderDetailHttpUtil cancel];
        SFRelease(hotelorderDetailHttpUtil);
    }
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        self.appDelegate = (ElongClientAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.mainPageController = self.appDelegate.startup.mainPageController;
        self.checkInDate = nil;
        self.checkOutDate = nil;
    }
    return self;
}

- (MainPageController *) mainPageController{
    if (!_mainPageController) {
        self.mainPageController = self.appDelegate.startup.mainPageController;
    }
    return _mainPageController;
}

- (BOOL) adsJumpUrl:(NSString *)url hasKey:(NSString *)key{
    if (STRINGHASVALUE(url) && STRINGHASVALUE(key)) {
        if ([url rangeOfString:key options:NSCaseInsensitiveSearch].length > 0) {
            return YES;
        }
        return NO;
    }else{
        return NO;
    }
}

- (BOOL) adsJumpUrl:(NSString *)url equalKey:(NSString *)key{
    if (STRINGHASVALUE(url) && STRINGHASVALUE(key)) {
        return [url isEqualToString:key];
    }else{
        return NO;
    }
}

- (BOOL) loginNeeded:(NSString *)jumpLink{
    if([self adsJumpUrl:jumpLink equalKey:@"gotocashaccount"]){
        // 跳转到现金账户
        return YES;
    }else if([self adsJumpUrl:jumpLink equalKey:@"gotohotelorderlist"]){
        // 跳转到订单列表
        return YES;
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotohotelcomment"]){
        // 跳转酒店点评
        return YES;
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotohotelfeedback"]){
        // 跳转酒店入住反馈
        return YES;
    }else if ([self adsJumpUrl:jumpLink hasKey:@"gotohotelorderdetail"]){
        // 跳转酒店订单详情页
        return YES;
    }
    return NO;
}

- (void) adNaviJumpUrl:(NSString *)jumpLink title:(NSString *)title {
    [self adNaviJumpUrl:jumpLink title:title active:NO];
}

- (void) adNaviJumpUrl:(NSString *)jumpLink title:(NSString *)title active:(BOOL)active{
    if (self.checkInDate && self.checkOutDate) {
        self.mainPageController.checkInDate = self.checkInDate;
        self.mainPageController.checkOutDate = self.checkOutDate;
    }else{
        self.mainPageController.checkInDate = nil;
        self.mainPageController.checkOutDate = nil;
    }
    self.active = active;
    if([self adsJumpUrl:jumpLink equalKey:@"gotoflight"]){
        // 跳转到机票查询页面：gotoflight
        if (active) {
            [self.mainPageController goModuleActive:MainTypeAirplane];
        }else{
            [self.mainPageController goModule:MainTypeAirplane];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if([self adsJumpUrl:jumpLink equalKey:@"gotorailway"]){
        // 跳转到火车票查询页面：gotorailway
        if (active) {
            [self.mainPageController goModuleActive:MainTypeTrain];
        }else{
            [self.mainPageController goModule:MainTypeTrain];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if([self adsJumpUrl:jumpLink equalKey:@"gotogroupon"]){
        // 跳转到团购查询页面：gotogroupon
        if (active) {
            [self.mainPageController goModuleActive:MainTypeGroupon];
        }else{
            [self.mainPageController goModule:MainTypeGroupon];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if([self adsJumpUrl:jumpLink equalKey:@"gotohotel"]){
        // 跳转到酒店查询页面：gotohotel
        if (active) {
            [self.mainPageController goModuleActive:MainTypeHotel];
        }else{
            [self.mainPageController goModule:MainTypeHotel];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if ([self adsJumpUrl:jumpLink equalKey:@"gotocustom"]){
        // 跳转到自定义模块选择页面
        if ([self.delegate respondsToSelector:@selector(homeAdNaviItems:)]) {
            [self.delegate homeAdNaviItems:self];
        }
    }else if([self adsJumpUrl:jumpLink equalKey:@"gotocashaccount"]){
        // 跳转到现金账户
        //NSString *hotelid = 0;
        [self goCashAccount];
    }else if([self adsJumpUrl:jumpLink equalKey:@"gotohotelorderlist"]){
        // 跳转到订单列表
        [self goHotelOrderList];
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotolmhotel"]){
        // 跳转到今日特价酒店查询页面
        if (jumpLink.length == @"gotolmhotel:".length || jumpLink.length == @"gotolmhotel".length) {
            if (active) {
                [self.mainPageController goModuleActive:MainTypeLMHotel object:nil];
            }else{
                [self.mainPageController goModule:MainTypeLMHotel object:nil];
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }else{
            NSString *city = [jumpLink substringFromIndex:@"gotolmhotel:".length];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:city forKey:@"city"];
            
            if (active) {
                [self.mainPageController goModuleActive:MainTypeLMHotel object:dict];
            }else{
                [self.mainPageController goModule:MainTypeLMHotel object:dict];
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }
        
        
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotohotelcomment"]){
        // 跳转酒店点评
        //NSString *hotelId = [jumpLink substringFromIndex:@"gotohotelcomment:".length];
        [self goHotelComment];
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotohotelfeedback"]){
        // 跳转酒店入住反馈
        NSString *orderid = [jumpLink substringFromIndex:@"gotohotelfeedback:".length];
        [self goFeedback:orderid];
    }else if ([self adsJumpUrl:jumpLink hasKey:@"gotohotelorderdetail"]){
        // 跳转酒店订单详情页
        NSString *orderid = [jumpLink substringFromIndex:@"gotohotelorderdetail:".length];
        [self goHotelOrderDetail:orderid];
    }else if ([self adsJumpUrl:jumpLink hasKey:@"gotourl"]) {
        // 去往外部URL：gotourl:abcd.htm
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[jumpLink substringFromIndex:@"gotourl:".length],@"url",title,@"title", nil];
        if (active) {
            [self.mainPageController goModuleActive:MainTypeWebAds object:dict];
        }else{
            [self.mainPageController goModule:MainTypeWebAds object:dict];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotogroupondetail"]){
        // 跳转到具体的团购页面：gotogroupondetail
        NSString *grouponId = [jumpLink substringFromIndex:@"gotogroupondetail:".length];
        self.grouponDetailFromH5 = NO;
        [self goGrouponDetail:grouponId];
    }else  if([self adsJumpUrl:jumpLink hasKey:@"gotohoteldetail"]){
        // 跳转到具体的酒店页面：gotohoteldetail
        NSString *hotelId = [jumpLink substringFromIndex:@"gotohoteldetail:".length];
        self.hotelDetailFromH5 = NO;
        [self goHotelDetail:hotelId];
    }else  if([self adsJumpUrl:jumpLink hasKey:@"gotopoigroupon"]){
        // 周边团购
        if (jumpLink.length == @"gotopoigroupon".length || jumpLink.length == @"gotopoigroupon:".length) {
            // 默认周边
            if (self.active) {
                [self.mainPageController goModuleActive:MainTypeGrouponPOI object:nil];
            }else{
                [self.mainPageController goModule:MainTypeGrouponPOI object:nil];
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }else{
            NSArray *poi = [[jumpLink substringFromIndex:@"gotopoigroupon:".length] componentsSeparatedByString:@","];
            if (poi.count == 3) {
                // 带参数
                NSString *city = [poi objectAtIndex:0];
                float lat = [[poi objectAtIndex:1] floatValue];
                float lng = [[poi objectAtIndex:2] floatValue];
                if (self.active) {
                    [self.mainPageController goModuleActive:MainTypeGrouponPOI object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng",city,@"city", nil]];
                }else{
                    [self.mainPageController goModule:MainTypeGrouponPOI object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng",city,@"city", nil]];
                }
                
            }else{
                // 默认周边
                if (self.active) {
                    [self.mainPageController goModuleActive:MainTypeGrouponPOI object:nil];
                }else{
                    [self.mainPageController goModule:MainTypeGrouponPOI object:nil];
                }
            }
            if (self.active) {
                
            }else{
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotopoihotel"]){
        // 周边酒店
        if (jumpLink.length == @"gotopoihotel".length || jumpLink.length == @"gotopoihotel:".length) {
            // 默认周边
            if (self.active) {
                [self.mainPageController goModuleActive:MainTypeHotelPOI object:nil];
            }else{
                [self.mainPageController goModule:MainTypeHotelPOI object:nil];
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }else{
            NSArray *poi = [[jumpLink substringFromIndex:@"gotopoihotel:".length] componentsSeparatedByString:@","];
            if (poi.count == 2) {
                // 带参数
                float lat = [[poi objectAtIndex:0] floatValue];
                float lng = [[poi objectAtIndex:1] floatValue];
                if (self.active) {
                    [self.mainPageController goModuleActive:MainTypeHotelPOI object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng", nil]];
                }else{
                    [self.mainPageController goModule:MainTypeHotelPOI object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng", nil]];
                }
            }else{
                // 默认周边
                if (self.active) {
                    [self.mainPageController goModuleActive:MainTypeHotelPOI object:nil];
                }else{
                    [self.mainPageController goModule:MainTypeHotelPOI object:nil];
                }
            }
            if (self.active) {
                
            }else{
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }
    }else if([self adsJumpUrl:jumpLink hasKey:@"gotohotelcity"]){
        // 按城市搜索酒店
        if (jumpLink.length == @"gotohotelcity:".length) {
            
        }else{
            NSString *city = [jumpLink substringFromIndex:@"gotohotelcity:".length];
            if (self.active) {
                [self.mainPageController goModuleActive:MainTypeHotelList object:[NSDictionary dictionaryWithObject:city forKey:@"city"]];
            }else{
                [self.mainPageController goModule:MainTypeHotelList object:[NSDictionary dictionaryWithObject:city forKey:@"city"]];
            }
            
            if (self.active) {
                
            }else{
                if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                    [self.delegate homeAdNaviOpen:self];
                }
            }
        }
    }
    
    else {
        // 没有任何匹配跳转活动公告
        if (self.active) {
            [self.mainPageController goModuleActive:MainTypeMessage];
        }else{
            [self.mainPageController goModule:MainTypeMessage];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }
}

- (BOOL) adNaviJumpUrl:(NSString *)jumpLink active:(BOOL) active{
    self.active = active;
    //jumpLink = @"http://m.elong.com/tuan/89568.html?app=tuandetail&ref=mbaidu";
    //jumpLink = @"http://m.elong.com/hotel/beijing/00301048/?checkindate=20140530&checkoutdate=20140531&distance=%E4%BA%94%E6%A3%B5%E6%9D%BE%E4%BD%93%E8%82%B2%E9%A6%86&app=hoteldetail";
    
    // 酒店详情页面reg
    NSString *hotelDetailReg = @".*?(m\\.elong\\.com).*?(app)(=)(hoteldetail)";
    NSArray *hotelDetailArray = [jumpLink componentsMatchedByRegex:hotelDetailReg];
    if ([hotelDetailArray count] > 0){
        NSString *hotelIdReg = @".*?\\/.*?\\/.*?\\/.*?\\/.*?(\\/)(\\d+)";
        NSArray *hotelIdArray = [jumpLink componentsMatchedByRegex:hotelIdReg];
        if (hotelIdArray.count) {
            hotelIdReg = @"(\\d+)";
            hotelIdArray = [[hotelIdArray objectAtIndex:0] componentsMatchedByRegex:hotelIdReg];
            if (hotelIdArray.count) {
                self.hotelDetailFromH5 = YES;
                NSString *hotelId = [hotelIdArray objectAtIndex:0];
                NSString *dateReg = @"((?:(?:[1]{1}\\d{1}\\d{1}\\d{1})|(?:[2]{1}\\d{3}))(?:[0]?[1-9]|[1][012])(?:(?:[0-2]?\\d{1})|(?:[3][01]{1})))(?![\\d])";
                NSArray *dateArray = [jumpLink componentsMatchedByRegex:dateReg];
                if (dateArray.count == 2) {
                    NSString *checkindate = [dateArray objectAtIndex:0];
                    NSString *checkoutdate = [dateArray objectAtIndex:1];
                    NSRange yearRange,monthRange,dayRange;
                    yearRange.location = 0;
                    yearRange.length = 4;
                    monthRange.location = 4;
                    monthRange.length = 2;
                    dayRange.location = 6;
                    dayRange.length = 2;
                    if (checkindate.length == 8 && checkoutdate.length == 8) {
                        checkindate = [NSString stringWithFormat:@"%@-%@-%@",[checkindate substringWithRange:yearRange],[checkindate substringWithRange:monthRange],[checkindate substringWithRange:dayRange]];
                        checkoutdate = [NSString stringWithFormat:@"%@-%@-%@",[checkoutdate substringWithRange:yearRange],[checkoutdate substringWithRange:monthRange],[checkoutdate substringWithRange:dayRange]];
                        
                        [self hoteldetail:hotelId CheckInDate:checkindate CheckOutDate:checkoutdate isUnsigned:NO];
                        
                        return YES;
                    }
                }else{
                    [self goHotelDetail:hotelId];
                    return YES;
                }
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
    
    // 团购详情页reg
    NSString *grouponDetailReg = @".*?(m\\.elong\\.com).*?(app)(=)(tuandetail)";
    NSArray *grouponDetailArray = [jumpLink componentsMatchedByRegex:grouponDetailReg];
    if (grouponDetailArray.count) {
        NSString *grouponIdReg = @"(\\d+)";
        NSArray *grouponIdArray = [[grouponDetailArray objectAtIndex:0] componentsMatchedByRegex:grouponIdReg];
        if (grouponIdArray.count) {
            NSString *grouponId = [grouponIdArray objectAtIndex:0];
            self.grouponDetailFromH5 = YES;
            [self goGrouponDetail:grouponId];
            return YES;
        }else{
            return NO;
        }
    }
    
    
    return NO;
}

- (BOOL) adNaviJumpUrl:(NSString *)jumpLink{
    return [self adNaviJumpUrl:jumpLink active:NO];
}

#pragma mark -
#pragma mark 酒店详情
- (void) goHotelDetail:(NSString *)hotelId{
    // 获取入离店日期
    NSString *CheckonDate = nil;
    NSString *CheckoutDate = nil;
    
    if (CheckonDate == nil) {
        CheckonDate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
        CheckoutDate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
    }
    
    BOOL isUnsined= NO;
    
    [self hoteldetail:hotelId CheckInDate:CheckonDate CheckOutDate:CheckoutDate isUnsigned:isUnsined];
}

-(void)hoteldetail:(NSString *)hotelId CheckInDate:(NSString *)checkInDate CheckOutDate:(NSString *)checkOutDate isUnsigned:(BOOL) isUnsigned{
    
    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
    [hoteldetail clearBuildData];
    [hoteldetail setHotelId:hotelId];
    [hoteldetail setIsUnsigned:isUnsigned];
    [hoteldetail setCheckDate:checkInDate checkoutdate:checkOutDate];
    
    if (hotelDetailHttpUtil) {
        [hotelDetailHttpUtil cancel];
        SFRelease(hotelDetailHttpUtil);
    }
    hotelDetailHttpUtil = [[HttpUtil alloc] init];
    [hotelDetailHttpUtil connectWithURLString:HOTELSEARCH Content:[hoteldetail requesString:YES] Delegate:self];
}

#pragma mark -
#pragma mark 团购详情
- (void)goGrouponDetail:(NSString *)prodId{
    if (![prodId isEqual:[NSNull null]] && [prodId intValue] != 0) {
        GDetailRequest *gDReq = [GDetailRequest shared];
        [gDReq setProdId:prodId];
        
        if (grouponDetailHttpUtil) {
            [grouponDetailHttpUtil cancel];
            SFRelease(grouponDetailHttpUtil);
        }
        
        grouponDetailHttpUtil = [[HttpUtil alloc] init];
        [grouponDetailHttpUtil connectWithURLString:GROUPON_SEARCH Content:[gDReq grouponDetailCompress:YES] Delegate:self];
    }
	else {
        [PublicMethods showAlertTitle:@"该团购已失效" Message:@"请选择其它酒店"];
    }
}

#pragma mark -
#pragma mark 登录

- (BOOL) loginCheck{
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (!islogin) {
//        [self.mainPageController goModule:MainTypeMessageBox];
//        if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
//            [self.delegate homeAdNaviOpen:self];
//        }
        
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([delegate.navigationController.viewControllers count] > 1){
            LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_GeneralLoginWithOutNonmember];
            login.delegate = self;
            [delegate.navigationController pushViewController:login animated:YES];
            [login release];
        }else{
            LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_GeneralLoginWithOutNonmember];
            login.delegate = self;
            [delegate.navigationController pushViewController:login animated:NO];
            [login release];
            
            [delegate.startup animtadForOpen];
        }
        
    }
    return islogin;
}

- (void) cancelBtnClick:(id)sender{
    [self.appDelegate.startup dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 酒店点评
- (void) goHotelComment{
    self.homeAdNaviType = HomeAdNaviComment;
    if (![self loginCheck]) {
        return;
    }
    CommentHotelRequest *commentReq = [CommentHotelRequest shared];
    [commentReq restoreData];
    if (hotelCommentHttpUtil) {
        [hotelCommentHttpUtil cancel];
        SFRelease(hotelCommentHttpUtil);
    }
    hotelCommentHttpUtil = [[HttpUtil alloc] init];
    [hotelCommentHttpUtil connectWithURLString:HOTELSEARCH Content:[commentReq getCanCommentHotel] Delegate:self];
}

#pragma mark -
#pragma mark 现金账户
- (void) goCashAccount{
    self.homeAdNaviType = HomeAdNaviCashAccount;
    if (![self loginCheck]) {
        return;
    }
    if (cashAccountHttpUtil) {
        [cashAccountHttpUtil cancel];
        SFRelease(cashAccountHttpUtil);
    }
    cashAccountHttpUtil = [[HttpUtil alloc] init];
    [cashAccountHttpUtil connectWithURLString:GIFTCARD_SEARCH Content:[CashAccountReq getCashAmountByBizType:BizTypeMyelong] Delegate:self];
}

#pragma mark -
#pragma mark 入住反馈酒店
- (void) goFeedback:(NSString *)orderid{
    self.homeAdNaviType = HomeAdNaviFeedback;
    if (orderid != nil) {
        self.orderid = orderid;
    }
    
    if (![self loginCheck]) {
        return;
    }
    if (feedbackHttpUtil) {
        [feedbackHttpUtil cancel];
        SFRelease(feedbackHttpUtil);
    }
    feedbackHttpUtil = [[HttpUtil alloc] init];
    
    JHotelOrderHistory *jhol=[OrderHistoryPostManager hotelorderhistory];
    [jhol clearBuildData];
    [jhol setHalfYear];
    [jhol setPageZero];
    [jhol setPageSize:20];      //获取前20个
    [feedbackHttpUtil connectWithURLString:MYELONG_SEARCH Content:[jhol requesString:YES] Delegate:self];
}

- (void) getFeedbackStatus{
    if (feedbackHttpUtil1) {
        [feedbackHttpUtil1 cancel];
        SFRelease(feedbackHttpUtil1);
    }
    feedbackHttpUtil1 = [[HttpUtil alloc] init];
    long long cardNo = 0;
    if ([[AccountManager instanse] isLogin]){
        cardNo = [[[AccountManager instanse] cardNo] longLongValue];
    }
    
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:cardNo],@"CardNo",self.orderid,@"orderNos", nil];
    NSString *reqContent = [reqDictInfo JSONString];
    
    // 发起请求
    [feedbackHttpUtil1 requestWithURLString:[PublicMethods composeNetSearchUrl:@"myelong" forService:@"getFeedbackStatusList"] Content:reqContent Delegate:self];
}

#pragma mark -
#pragma mark 酒店订单列表
- (void) goHotelOrderList{
    self.homeAdNaviType = HomeAdNaviOrderList;
    if (![self loginCheck]) {
        return;
    }
    if (hotelorderListHttpUtil) {
        [hotelorderListHttpUtil cancel];
        SFRelease(hotelorderListHttpUtil);
    }
    hotelorderListHttpUtil = [[HttpUtil alloc] init];
    
    JHotelOrderHistory *jhol=[OrderHistoryPostManager hotelorderhistory];
    [jhol clearBuildData];
    [jhol setHalfYear];
    [jhol setPageZero];
    [hotelorderListHttpUtil connectWithURLString:MYELONG_SEARCH Content:[jhol requesString:YES]  Delegate:self];
}

#pragma mark -
#pragma mark 酒店订单详情页
- (void) goHotelOrderDetail:(NSString *)orderid{
    self.homeAdNaviType = HomeAdNaviOrderDetail;
    if (orderid != nil) {
        self.orderid = orderid;
    }
    if (![self loginCheck]) {
        return;
    }
    if (hotelorderDetailHttpUtil) {
        [hotelorderDetailHttpUtil cancel];
        SFRelease(hotelorderDetailHttpUtil);
    }
    hotelorderDetailHttpUtil = [[HttpUtil alloc] init];
    //会员请求订单详情
    JHotelOrderDetail *hotelOrderDetail = [HotelPostManager hotelorderdetail];
    hotelOrderDetail.orderNo = [self.orderid longLongValue];
    hotelOrderDetail.cardNo = [[AccountManager instanse] cardNo];
    
    [hotelorderDetailHttpUtil connectWithURLString:MYELONG_SEARCH Content:[hotelOrderDetail requesString:YES] Delegate:self];
}

#pragma mark -
#pragma mark LoginManagerDelegate
- (void) loginManager:(LoginManager *)loginManager didLogin:(NSDictionary *)dict{
    [self.appDelegate.navigationController popViewControllerAnimated:NO];
    
    switch (self.homeAdNaviType) {
        case HomeAdNaviComment:{
            [self goHotelComment];
        }
            break;
        case HomeAdNaviFeedback:{
            [self goFeedback:nil];
        }
            break;
        case HomeAdNaviCashAccount:{
            [self goCashAccount];
        }
            break;
        case HomeAdNaviOrderDetail:{
            [self goHotelOrderDetail:nil];
        }
            break;
        case HomeAdNaviOrderList:{
            [self goHotelOrderList];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark HttpUtil

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if(util == hotelDetailHttpUtil){
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        
        if ([[root objectForKey:HOTELID_REQ] isEqual:[NSNull null]]) {
            [PublicMethods showAlertTitle:@"酒店信息已过期" Message:nil];
            return;
        }
        
        [[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
        [[HotelDetailController hoteldetail] removeRepeatingImage];
        
        NSString *CheckonDate = nil;
        NSString *CheckoutDate = nil;
        
        if (CheckonDate == nil) {
            CheckonDate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
            CheckoutDate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
        }
        HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
        promotionInfoRequest.orderEntrance = OrderEntranceAd;
        promotionInfoRequest.checkinDate = CheckonDate;
        promotionInfoRequest.checkoutDate = CheckoutDate;
        promotionInfoRequest.hotelId = [root safeObjectForKey:@"HotelId"];
        promotionInfoRequest.hotelName = [root safeObjectForKey:@"HotelName"];
        promotionInfoRequest.cityName = [root safeObjectForKey:@"CityName"];
        promotionInfoRequest.star = [root safeObjectForKey:@"NewStarCode"];
        
        if (self.active) {
            if (self.hotelDetailFromH5) {
                [self.mainPageController goModuleActive:MainTypeHotelDetailFromH5];
            }else{
                [self.mainPageController goModuleActive:MainTypeHotelDetail];
            }
        }else{
            if (self.hotelDetailFromH5) {
                [self.mainPageController goModule:MainTypeHotelDetailFromH5];
            }else{
                [self.mainPageController goModule:MainTypeHotelDetail];
            }
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if(util == grouponDetailHttpUtil){
        // 进入详情页面
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([root objectForKey:@"ProductDetail"]==[NSNull null]) {
            [PublicMethods showAlertTitle:nil Message:@"该团购产品已过期"];
            return;
        }
        if (self.active) {
            if (self.grouponDetailFromH5) {
                [self.mainPageController goModuleActive:MainTypeGrouponDetailFromH5 object:root];
            }else{
                [self.mainPageController goModuleActive:MainTypeGrouponDetail object:root];
            }
        }else{
            if (self.grouponDetailFromH5) {
                [self.mainPageController goModule:MainTypeGrouponDetailFromH5 object:root];
            }else{
                [self.mainPageController goModule:MainTypeGrouponDetail object:root];
            }
            
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if(util == hotelCommentHttpUtil){
        // 进入酒店点评
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        [[CommentHotelRequest shared] clearHotelReqData];
        if (self.active) {
            [self.mainPageController goModuleActive:MainTypeHotelComment object:root];
        }else{
            [self.mainPageController goModule:MainTypeHotelComment object:root];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if(util == cashAccountHttpUtil){
        // 进入现金账户
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if (self.active) {
            [self.mainPageController goModuleActive:MainTypeCashAccount object:root];
        }else{
            [self.mainPageController goModule:MainTypeCashAccount object:root];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if(util == feedbackHttpUtil){
        // 得到需要的order
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        NSArray *tmpOrders = [root safeObjectForKey:ORDERS];
        BOOL exist = NO;
        for(NSDictionary *anOrder in tmpOrders){
            NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
            if ([orderNO isEqualToString:self.orderid]) {
                exist = YES;
                self.order = [NSDictionary dictionaryWithDictionary:anOrder];
                [self getFeedbackStatus];
            }
        }
        if (!exist) {
            self.order = nil;
            [self getFeedbackStatus];
        }
    }else if(util == feedbackHttpUtil1){
        // 入住反馈酒店
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        //针对获取的20条列表数据，再次访问反馈状态列表
        NSArray *statusList = [root objectForKey:@"FeedbackStatus"];
        NSArray *orderList = nil;
        for(NSDictionary *feedbackStatus in statusList){
            NSString *orderId = [feedbackStatus objectForKey:@"orderId"];
            int status = [[feedbackStatus objectForKey:@"FeedbackStatus"] intValue];
            if([orderId isEqualToString:self.orderid]){
                if(status==0 || status == 2){
                    //0 可反馈   1 不可反馈  2  反馈处理中
                    orderList = [NSArray arrayWithObject:self.order];
                }
                break;
            }
        }
        if (self.active) {
            [self.mainPageController goModuleActive:MainTypeHotelFeedback object:orderList object1:statusList];
        }else{
            [self.mainPageController goModule:MainTypeHotelFeedback object:orderList object1:statusList];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if(util == hotelorderListHttpUtil){
        // 酒店订单列表
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        NSArray *orders = [root safeObjectForKey:ORDERS];
        int totalNumber = [[root safeObjectForKey:TOTALCOUNT] intValue];
        
        if (self.active) {
            [self.mainPageController goModuleActive:MainTypeHotelOrderList object:orders object1:NUMBER(totalNumber)];
        }else{
            [self.mainPageController goModule:MainTypeHotelOrderList object:orders object1:NUMBER(totalNumber)];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }else if(util == hotelorderDetailHttpUtil){
        // 酒店订单详情
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            [PublicMethods showAlertTitle:nil Message:@"订单信息获取失败！"];
            return;
        }
        if (self.active) {
            [self.mainPageController goModuleActive:MainTypeHotelOrderDetail object:root];
        }else{
            [self.mainPageController goModule:MainTypeHotelOrderDetail object:root];
            if ([self.delegate respondsToSelector:@selector(homeAdNaviOpen:)]) {
                [self.delegate homeAdNaviOpen:self];
            }
        }
    }
}

@end
