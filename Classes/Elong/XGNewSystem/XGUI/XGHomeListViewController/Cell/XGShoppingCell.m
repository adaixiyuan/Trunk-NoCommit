//
//  XGShoppingCell.m
//  ElongClient
//
//  Created by guorendong on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#import "XGShoppingCell.h"
#import "UIImageView+WebCache.h"
@implementation XGShoppingCell


-(void)setViewInfoForObject:(XGHotelInfo *)hotelInfo
{
    if (hotelInfo ==nil) {
        return;
    }
    
    self.tagObject =hotelInfo;
    self.wifiAndParkBack.layer.cornerRadius=2;
    self.otherInfoLable.layer.masksToBounds=YES;
    self.otherInfoLable.layer.cornerRadius=2;
    self.onlineLable.layer.masksToBounds=YES;
    self.onlineLable.layer.cornerRadius=2;
    self.hotelImage.layer.masksToBounds=YES;
    self.hotelImage.layer.cornerRadius=5;
    self.otherView.hidden =((hotelInfo.Remark&&hotelInfo.Remark.length>0)?NO:YES);
    self.hotelNameLable.text =hotelInfo.HotelName;
    [self.hotelImage setImageWithURL:[NSURL URLWithString:hotelInfo.PicUrl] placeholderImage:[UIImage imageNamed:@"hotel_detail_image"]];
    
    //self.hotelImage.image =hotelInfo.hotelName;
    double distance =[hotelInfo.Distance floatValue];
    self.distanceLable.hidden=NO;
    if (distance>1000) {
        self.distanceLable.text =[NSString stringWithFormat:@"距离%.1f公里",distance/1000.0f];
    }
    else if(distance>0){
        self.distanceLable.text =[NSString stringWithFormat:@"距离%.0f米",distance];
    }
    else{
        self.distanceLable.hidden=YES;
    }
    self.otherInfo.text =hotelInfo.Remark;
    //self.otherInfoLable.text =@"其他说明";
    self.finalPriceLable.text = [NSString stringWithFormat:@"%.0f",[hotelInfo.FinalPrice floatValue]];
    //只显示这几个
    long hotelFacilityCode = [hotelInfo.HotelFacilityCode longValue];//[[hoteldetail safeObjectForKey:@"HotelFacilityCode"] longValue];
    
    self.wifiImage.hidden =YES;
    self.stopImage.hidden=YES;
    BOOL isWifi =NO;
    BOOL isPark=NO;
    
    /////////
    for (int i = 0; i < 15;i++) {
        if((hotelFacilityCode & (1 << i)) > 0){
            switch (i) {
                case 0:
                    isWifi = YES;
                    //flcodeDesp.text=@"WIFI";
                    break;
                case 1:
                    isWifi = YES;

                    break;
                case 2:
                    //isWifi = YES;

                    break;
                case 3:
                    break;
                case 4:
                    isPark = YES;
                    //flcodeDesp.text=@"停车场";
                    break;
                case 5:
                    isPark = YES;
                        //flcodeDesp.text=@"停车场";
                    break;
                case 6:
                    //flcodeDesp.text=@"接机";
                    break;
                case 7:
                        //flcodeDesp.text=@"接机";
                    break;
                case 8:
                    //flcodeDesp.text=@"游泳池";
                    break;
                case 9:
                        //flcodeDesp.text=@"游泳池";
                    break;
                case 10:
                    //flcodeDesp.text=@"健身房";
                    break;
                case 11:
                    //flcodeDesp.text=@"商务中心";
                    break;
                case 12:
                    //flcodeDesp.text=@"会议室";
                    break;
                case 13:
                    //flcodeDesp.text=@"餐厅";
                    break;
                case 14:
                    isWifi = YES;

                    //flcodeDesp.text=@"宽带";
                    break;
                default:
                    break;
            }
        }
    }
    /////////

    self.wifiImage.hidden =!isWifi;
    self.stopImage.hidden =!isPark;
    if (isWifi&&isPark) {
        self.wifiImage.frame=CGRectMake(self.hotelImage.right-self.wifiImage.width, self.hotelImage.bottom-self.wifiImage.height, self.wifiImage.width, self.wifiImage.height);
        self.stopImage.frame=CGRectMake(self.hotelImage.right-self.wifiImage.width-self.stopImage.width, self.hotelImage.bottom-self.stopImage.height, self.stopImage.width, self.stopImage.height);
        [self.contentView bringSubviewToFront:self.stopImage];
        [self.contentView bringSubviewToFront:self.wifiImage];
    }
    else if(isWifi)
    {
        self.wifiImage.frame=CGRectMake(self.hotelImage.right-self.wifiImage.width, self.hotelImage.bottom-self.wifiImage.height, self.wifiImage.width, self.wifiImage.height);
        [self.contentView bringSubviewToFront:self.wifiImage];
    }
    else if(isPark)
    {
        self.stopImage.frame=CGRectMake(self.hotelImage.right-self.stopImage.width, self.hotelImage.bottom-self.stopImage.height, self.stopImage.width, self.stopImage.height);
        [self.contentView bringSubviewToFront:self.stopImage];
    }
    self.onlineLable.hidden =[hotelInfo.room.Auto boolValue];
    self.roomStyleName.text =[PublicMethods getStar:[hotelInfo.Star intValue]];
    
    NSInteger good = [hotelInfo.GoodCommentCount intValue];
    NSInteger bad = [hotelInfo.BadCommentCount intValue];
    
    if (good + bad == 0) {
        self.tagAndCommentLable.text = @"暂无评论";
    }else if(good == 0 ){
        self.tagAndCommentLable.text = [NSString stringWithFormat:@"%d条评论",good + bad];
       
    }else{
        NSInteger persent = ceil(good * 100/ (good + bad + 0.0f));
        self.tagAndCommentLable.text = [NSString stringWithFormat:@"%d%%好评",persent];
    }
}

- (void)dealloc {
}
@end
