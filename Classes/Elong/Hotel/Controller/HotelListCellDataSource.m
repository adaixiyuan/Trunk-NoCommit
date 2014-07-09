//
//  HotelListCellDataSource.m
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelListCellDataSource.h"
#import "AccountManager.h"
#import "HotelListCell.h"
#import "DefineHotelResp.h"
#import "HotelPostManager.h"
#import "HotelConditionRequest.h"
#import "RoundCornerView+WebCache.h"


@implementation HotelListCellDataSource

- (void) dealloc{
    self.keyword = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark HotelListCellDataSource

- (void) hotelListCellFillData:(HotelListCell *)cell{
    NSDictionary *hotel = nil;
    
    if (cell.isLM) {
        hotel = [[HotelSearch tonightHotels] safeObjectAtIndex:cell.dataIndex];
    }else{
        hotel = [[HotelSearch hotels] safeObjectAtIndex:cell.dataIndex];
    }

    // 恢复所有控件状态
    cell.hotelNameLbl.hidden        = NO;
    cell.hotelImageView.hidden      = NO;
    cell.wifiImageView.hidden       = NO;
    cell.parkImageView.hidden       = NO;
    cell.promotionImageView.hidden  = NO;
    cell.vipImageView.hidden        = NO;
    cell.starLbl.hidden             = NO;
    cell.commentLbl.hidden          = NO;
    cell.addressLbl.hidden          = NO;
    cell.priceMarkLbl.hidden        = NO;
    cell.priceLbl.hidden            = NO;
    cell.backImageView.hidden       = NO;
    cell.backPriceLbl.hidden        = NO;
    cell.originalPriceLbl.hidden    = NO;
    cell.priceEndLbl.hidden         = NO;
    cell.fullyBookedLbl.hidden      = NO;
    cell.recommendLbl.hidden        = NO;
    cell.referencePriceLbl.hidden   = YES;
    [cell setAction:NO animated:NO];
    
    // 货币符号转换
    NSString *currency = [hotel safeObjectForKey:RespHL_Currency];
    if ([currency isEqualToString:CURRENCY_RMB]) {
        cell.priceMarkLbl.text = CURRENCY_RMBMARK;
    }
    else if ([currency isEqualToString:CURRENCY_HKD]) {
        cell.priceMarkLbl.text = CURRENCY_HKDMARK;
    }
    else {
        cell.priceMarkLbl.text = currency;
    }
    
    // 设置图片
    BOOL showImage = [[SettingManager instanse] defaultDisplayHotelPic];
    if (showImage) {
        [cell.hotelImageView setImageWithURL:[NSURL URLWithString:[hotel safeObjectForKey:RespHL__PicUrl_S]]
                            placeholderImage:[UIImage imageNamed:@"bg_nohotelpic.png"]
                                     options:SDWebImageRetryFailed];
        
    }
    
    if ([hotel safeObjectForKey:@"IsUnsigned"]&&[[hotel safeObjectForKey:@"IsUnsigned"] boolValue]){
        /* 未签约酒店 */
        
        if ([[hotel objectForKey:RespHL__LowestPrice_D] floatValue] > 0){
            cell.fullyBookedLbl.hidden = YES;
            cell.referencePriceLbl.hidden = NO;
            cell.backImageView.hidden = YES;
            cell.backPriceLbl.hidden = YES;
            cell.originalPriceLbl.hidden = YES;
        }
        else{
            cell.fullyBookedLbl.text = @"暂无报价";
            cell.fullyBookedLbl.hidden  = NO;
            cell.referencePriceLbl.hidden=YES;
            cell.priceMarkLbl.hidden = YES;
            cell.priceLbl.hidden = YES;
            cell.priceEndLbl.hidden = YES;
            cell.backImageView.hidden = YES;
            cell.backPriceLbl.hidden = YES;
            cell.originalPriceLbl.hidden = YES;
        }
        
        
        // 酒店名和最低价格
        cell.hotelNameLbl.text = [hotel safeObjectForKey:RespHL__HotelName_S];
        [cell setPrice:(int)[[hotel safeObjectForKey:RespHL__LowestPrice_D] floatValue]];
        // 设置酒店星级
        int statlevel=[[hotel safeObjectForKey:NEWSTAR_CODE] intValue];
        //星级
        [cell setStar:statlevel];
        
    }else{
        /* 签约酒店 */
        cell.referencePriceLbl.hidden = YES;
        cell.fullyBookedLbl.text = @"满房";
        if ([[hotel objectForKey:RespHL__LowestPrice_D] floatValue] > 0) {
            // 未满房
            cell.fullyBookedLbl.hidden = YES;
        }else{
            // 满房
            cell.priceMarkLbl.hidden = YES;
            cell.priceLbl.hidden = YES;
            cell.priceEndLbl.hidden = YES;
            cell.backImageView.hidden = YES;
            cell.backPriceLbl.hidden = YES;
            cell.originalPriceLbl.hidden = YES;
        }
        
        JHotelSearch *hotelsearcher = nil;
        if (cell.isLM) {
            hotelsearcher = [HotelPostManager tonightsearcher];
        }else{
            hotelsearcher = [HotelPostManager hotelsearcher];
        }
        
        NSInteger filterSign = [[hotelsearcher getFilter] intValue];
        
        // 非特价搜索时
        NSString *discountStr = [hotel safeObjectForKey:@"LastMinutesDesp"];
        BOOL isLM = NO;
        BOOL isPhoneOnly = NO;
        if ([discountStr isKindOfClass:[NSString class]] && discountStr.length > 0) {
            isLM = YES;
        }
        isPhoneOnly = [[hotel objectForKey:@"IsPhoneOnly"] boolValue];
        
        
        // 今日特价 或 手机专享
        cell.promotionImageView.image = nil;
        cell.vipImageView.image = nil;
        cell.originalPriceLbl.hidden = YES;
        
        if (isPhoneOnly || isLM){
            cell.originalPriceLbl.hidden = NO;
            cell.backPriceLbl.hidden = NO;
            cell.backImageView.hidden = NO;
            cell.promotionImageView.image = nil;
            
            // 今日特价
            if (isLM) {
                cell.promotionImageView.image = [UIImage noCacheImageNamed:@"mobilePriceLMIcon.png"];
            }
            
            // 手机专享
            if (isPhoneOnly) {
                cell.promotionImageView.image = [UIImage noCacheImageNamed:@"mobilePriceListIcon.png"];
            }
            
            NSInteger formerPirce = 0;
            if ([hotel safeObjectForKey:@"LmOriPrice"]!=[NSNull null] && [hotel safeObjectForKey:@"LmOriPrice"]) {
                cell.originalPriceLbl.text = [NSString stringWithFormat:@"%@  %@",cell.priceMarkLbl.text,[hotel safeObjectForKey:@"LmOriPrice"]];
                formerPirce = [[hotel safeObjectForKey:@"LmOriPrice"] intValue];
            }
            
            // 原价为零或价格倒挂情况
            if (formerPirce == 0 || formerPirce < [[hotel safeObjectForKey:RespHL__LowestPrice_D] floatValue]) {
                cell.originalPriceLbl.hidden = YES;
            }
            // 满房
            if ([[hotel objectForKey:RespHL__LowestPrice_D] floatValue]<=0) {
                cell.originalPriceLbl.hidden = YES;
            }
        }
        
        // 酒店名和最低价格
        cell.hotelNameLbl.text = [hotel safeObjectForKey:RespHL__HotelName_S];
        [cell setPrice:(int)[[hotel safeObjectForKey:RespHL__LowestPrice_D] floatValue]];
        
        // 处理周边和非周边的地理坐标显示问题
        if ([HotelSearch isPositioning] || [hotelsearcher getIsPos]) {
            float distance = [[hotel safeObjectForKey:RespHL__Distance_D] doubleValue];
            HotelConditionRequest *hcReq = [HotelConditionRequest shared];
            NSString *distanceName = hcReq.keywordFilter.keyword;
            
            if (!distanceName) {
                distanceName = @"";
            }
            
            if (hcReq.keywordFilter.poi) {
                distanceName = hcReq.keywordFilter.poi;
            }
            
            if (distanceName.length > 7) {
                distanceName = [NSString stringWithFormat:@"%@...",[distanceName substringToIndex:7]];
            }
            if (distance <= 0.0) {
                cell.addressLbl.text = [self getAddressTipsFromHotel:hotel];
            }else if (distance < 100) {
                cell.addressLbl.text=[NSString stringWithFormat:@"距离%@%.f米",distanceName,distance];
            }else{
                cell.addressLbl.text=[NSString stringWithFormat:@"距离%@%.1f公里",distanceName,distance/1000];
            }
        }else {
            // 非周边酒店
            HotelConditionRequest *hcReq = [HotelConditionRequest shared];
            if ((hcReq.keywordFilter.keywordType == HotelKeywordTypePOI
                || hcReq.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation
                || hcReq.keywordFilter.keywordType == HotelKeywordTypeSubwayStation) && 0 == filterSign) {
                // 有固定坐标且非今日特价搜索时显示距离
                float distance = [[hotel safeObjectForKey:RespHL__Distance_D] doubleValue];
                NSString *distanceName = hcReq.keywordFilter.keyword;
                if (distanceName.length > 7) {
                    distanceName = [NSString stringWithFormat:@"%@...",[distanceName substringToIndex:7]];
                }
                if (distance < 100) {
                    cell.addressLbl.text=[NSString stringWithFormat:@"距离%@%.f米",distanceName,distance];
                }else{
                    cell.addressLbl.text=[NSString stringWithFormat:@"距离%@%.1f公里",distanceName,distance/1000];
                }
            }else if([hotel safeObjectForKey:@"DistanceName"] && [hotel safeObjectForKey:@"DistanceName"] !=[NSNull null]){     // all in one search result
                float distance = [[hotel safeObjectForKey:RespHL__Distance_D] doubleValue];
                NSString *distanceName = [hotel safeObjectForKey:@"DistanceName"];
                if (distanceName.length > 7) {
                    distanceName = [NSString stringWithFormat:@"%@...",[distanceName substringToIndex:7]];
                }
                if (distance <= 0.0) {
                    cell.addressLbl.text = [self getAddressTipsFromHotel:hotel];
                }else if (distance < 100) {
                    cell.addressLbl.text=[NSString stringWithFormat:@"距离%@%.f米",distanceName,distance];
                }else{
                    cell.addressLbl.text=[NSString stringWithFormat:@"距离%@%.1f公里",distanceName,distance/1000];
                }
            }
            else {
                // 没有坐标时显示所在区域
                cell.addressLbl.text = [self getAddressTipsFromHotel:hotel];
            }
        }
        
        // 设置酒店星级
        int statlevel=[[hotel safeObjectForKey:NEWSTAR_CODE] intValue];
        
        
        // 公寓 HotelCategory
        int hotelCategory = [[hotel objectForKey:@"HotelCategory"] intValue];
        if (hotelCategory==2 || hotelCategory==3) {
            cell.promotionImageView.image =[UIImage noCacheImageNamed:@"mobileHouseListIcon.png"];
            [cell setStarFromHouse:statlevel];
        }else{
            [cell setStar:statlevel];
        }
        
        
        // 龙萃会员
        BOOL DragonVIP=([[hotel safeObjectForKey:@"HotelSpecialType"] intValue] == 2);
        int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
        // 龙萃逻辑最后判断
        if (DragonVIP && userLevel == 2) {
            if (cell.promotionImageView.image) {
                cell.vipImageView.image = [UIImage noCacheImageNamed:@"mobilePriceListVipIconFlag.png"];
            }else{
                cell.promotionImageView.image = [UIImage noCacheImageNamed:@"mobilePriceListVipIconFlag.png"];
            }
        }
        
        // 评论描述
        int goodComment = [[hotel safeObjectForKey:RespHL__GoodCommentCount_I] intValue];
        int badComment = [[hotel safeObjectForKey:RespHL__BadCommentCount_I] intValue];
        
        cell.commentLbl.hidden=NO;

        if ([hotel safeObjectForKey:@"CommentPoint"]&&[hotel safeObjectForKey:@"CommentPoint"]!=[NSNull null])
        {
            float commentPoint = [[hotel safeObjectForKey:@"CommentPoint"] floatValue];
            
            if (commentPoint>0)
            {
                cell.commentLbl.text=[PublicMethods getCommentDespLogic:goodComment badComment:badComment comentPoint:[[hotel safeObjectForKey:@"CommentPoint"] floatValue]];
            }
            else
            {
                cell.commentLbl.text = @"";
                cell.commentLbl.hidden=YES;
            }
        }
        else
        {
            cell.commentLbl.text=[PublicMethods getCommentDespOldLogic:goodComment badComment:badComment];
        }
        
        
        // PSG特殊处理
        BOOL isPSG = NO;
        if ([hotel objectForKey:@"PSGRecommendReason"] != [NSNull null]) {
            if ([hotel objectForKey:@"PSGRecommendReason"]) {
                NSString *psg = [hotel objectForKey:@"PSGRecommendReason"];
                if (STRINGHASVALUE(psg)) {
                    isPSG = YES;
                }
            }
        }
        if (!isPSG) {
            // 特殊处理
            cell.starLbl.text = [NSString stringWithFormat:@"%@  %@",cell.starLbl.text,cell.commentLbl.text];
            cell.commentLbl.text = @"";
        }else{
            cell.starLbl.text = [NSString stringWithFormat:@"%@",cell.starLbl.text];
        }
        
        // 酒店设施 wifi和停车场
        cell.parkImageView.hidden = NO;
        cell.wifiImageView.hidden = NO;
        cell.parkImageView.image = nil;
        cell.wifiImageView.image = nil;
        if (([[hotel safeObjectForKey:@"HotelFacilityCode"] integerValue] & 0x3) == 0) {
            cell.wifiImageView.image = nil;
        }
        else {
            cell.wifiImageView.image  = [UIImage noCacheImageNamed:@"hotellist_wifi.png"];
        }
        
        if (([[hotel safeObjectForKey:@"HotelFacilityCode"] integerValue] & 0x30) == 0) {
            cell.parkImageView.image = nil;
        }
        else {
            if (cell.wifiImageView.image == nil) {
                cell.wifiImageView.image = [UIImage noCacheImageNamed:@"hotellist_park.png"];
            }else{
                cell.parkImageView.image = [UIImage noCacheImageNamed:@"hotellist_park.png"];
            }
        }
        
        // 设置PSG推荐
        if ([hotel objectForKey:@"RecommendIndex"] != [NSNull null]) {
            if ([hotel objectForKey:@"RecommendIndex"]) {
                NSString *psg = [hotel objectForKey:@"PSGRecommendReason"];
                if (STRINGHASVALUE(psg)) {
                    cell.recommendLbl.text = [NSString stringWithFormat:@"推荐理由：%@",psg];
                }
            }
        }
        
        // 调整促销信息布局
        [cell resetPromotionFrame];
        
        
        // 返现
        NSNumber *coupon = [hotel safeObjectForKey:@"Coupon"];
        if (coupon != nil) {
            NSInteger couponMoney = coupon.integerValue;
            if (couponMoney > 0) {
                [cell.backImageView setHidden:NO];
                [cell.backPriceLbl setHidden:NO];
                [cell.backPriceLbl setText:[NSString stringWithFormat:@"￥%d", couponMoney]];
            }
            else if (couponMoney == 0) {
                [cell.backImageView setHidden:NO];
                [cell.backPriceLbl setHidden:YES];
            }
            else {
                [cell.backImageView setHidden:YES];
                [cell.backPriceLbl setHidden:YES];
            }
        }
        else {
            [cell.backImageView setHidden:YES];
            [cell.backPriceLbl setHidden:YES];
        }
        
        // 满房
        if ([[hotel objectForKey:RespHL__LowestPrice_D] floatValue]<=0) {
            [cell.backImageView setHidden:YES];
            [cell.backPriceLbl setHidden:YES];
        }
    }
}

#pragma mark -
#pragma mark Private Methods

- (NSString *) getAddressTipsFromHotel:(NSDictionary *)hotel{
    NSString *tips = @"";
    if ([hotel safeObjectForKey:RespHL__DistrictName]!=[NSNull null]) {
        if([hotel safeObjectForKey:RespHL__BusinessAreaName]!=[NSNull null] && [hotel safeObjectForKey:RespHL__BusinessAreaName]){
            if ([[hotel safeObjectForKey:RespHL__DistrictName] isEqualToString:[hotel safeObjectForKey:RespHL__BusinessAreaName]]) {
                tips = [NSString stringWithFormat:@"%@",[hotel safeObjectForKey:RespHL__DistrictName]];
            }else{
                tips = [NSString stringWithFormat:@"%@  %@",[hotel safeObjectForKey:RespHL__DistrictName],[hotel safeObjectForKey:RespHL__BusinessAreaName]];
            }
        }else{
            tips = [NSString stringWithFormat:@"%@",[hotel safeObjectForKey:RespHL__DistrictName]];
        }
    }
    return tips;
}

@end
