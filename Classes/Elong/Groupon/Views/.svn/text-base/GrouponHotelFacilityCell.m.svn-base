//
//  GrouponHotelFacilityCell.m
//  ElongClient
//
//  Created by garin on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponHotelFacilityCell.h"

@implementation GrouponHotelFacilityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景色
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        //设施载体
        facilityView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 245, 45)];
        facilityView.backgroundColor=[UIColor clearColor];
        facilityView.clipsToBounds=YES;
        [bgImageView addSubview:facilityView];
        [facilityView release];
        
        noFacilityTips=[[UILabel alloc] initWithFrame:CGRectMake(9 , 0, 200, 45)];
        noFacilityTips.text=@"查看酒店详情信息";
        noFacilityTips.backgroundColor=[UIColor clearColor];
        noFacilityTips.font=[UIFont systemFontOfSize:14];
        noFacilityTips.textColor=RGBACOLOR(52, 52, 52, 1);
        noFacilityTips.textAlignment=NSTextAlignmentLeft;
        [bgImageView addSubview:noFacilityTips];
        [noFacilityTips release];
        noFacilityTips.hidden=YES;
        
        //酒店详情
        hotelDetailLbl = [[UILabel alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 9 - 5 - 60, 3, 55, 40)];
        hotelDetailLbl.backgroundColor = [UIColor clearColor];
        hotelDetailLbl.font = [UIFont systemFontOfSize:12];
        hotelDetailLbl.textAlignment=NSTextAlignmentRight;
        hotelDetailLbl.textColor = RGBACOLOR(129, 129, 129, 1);
        hotelDetailLbl.text=@"酒店详情";
        [bgImageView addSubview:hotelDetailLbl];
        [hotelDetailLbl release];
        
        // 右侧指示箭头
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 9-5, (45 - 5)/2-1, 5, 9)];
        arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [bgImageView addSubview:arrowView];
        [arrowView release];
        
        UIImageView *downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, 45- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
    }
    return self;
}

-(void) setHotelDetailLblTitle:(NSString *) title
{
    hotelDetailLbl.text=title;
}

//设置设施
//0 宽带，1wifi，2健身房，3商务中心，4会议室，5酒店餐厅，6停车场，7游泳池
static int upSpan=55;
static int downSpan=55;

-(void) setFacilities:(NSArray *) facArr containBreakfast:(BOOL) containBreakfast
{
    [self removeFacilityViewSubviews];
    
    //只显示这几个
//    BOOL isCanting=[facArr containsObject:NUMBER(5)];
    BOOL isCanting = containBreakfast;
    BOOL isWifi=[facArr containsObject:NUMBER(1)];
    BOOL isKuanDai=[facArr containsObject:NUMBER(0)];
    BOOL isPark=[facArr containsObject:NUMBER(6)];
    
    //显示餐厅，wifi,宽带，停车
    NSArray *arr=@[[NSNumber numberWithBool:isCanting],[NSNumber numberWithBool:isWifi],[NSNumber numberWithBool:isKuanDai],[NSNumber numberWithBool:isPark]];
    
    for (int i=0;i<arr.count;i++)
    {
        UIImageView *upIcon=[[UIImageView alloc] initWithFrame:CGRectMake(18+upSpan*i, 8, 20, 15)];
        upIcon.contentMode= UIViewContentModeCenter;
        [facilityView addSubview:upIcon];
        [upIcon release];
        
        UILabel *downLbl=[[UILabel alloc] initWithFrame:CGRectMake(7 +downSpan*i, 26, 44, 13)];
        downLbl.font=[UIFont systemFontOfSize:10];
        downLbl.textAlignment=NSTextAlignmentCenter;
        downLbl.backgroundColor=[UIColor clearColor];
        [facilityView addSubview:downLbl];
        [downLbl release];
        
        BOOL isCouldUse=[[arr safeObjectAtIndex:i] boolValue];
        
        if (isCouldUse)
        {
            downLbl.textColor=RGBACOLOR(52, 52, 52, 1);
        }
        else
        {
            downLbl.textColor=RGBACOLOR(153, 153, 153, 1);
        }
        
        NSString *imgUrl=nil;
        NSString *txt=nil;
        
        switch (i)
        {
            //餐厅
            case 0:
                if (isCouldUse)
                {
                    imgUrl=@"room_breakfast.png";
                    txt=@"免费早餐";
                }
                else
                {
                    imgUrl=@"room_breakfast_no.png";
                    txt=@"不含早餐";
                }
                break;
            //wifi
            case 1:
                if (isCouldUse)
                {
                    imgUrl=@"room_wifi.png";
                    txt=@"免费WiFi";
                }
                else
                {
                    imgUrl=@"room_wifi_no.png";
                    txt=@"不含WiFi";
                }
                break;
            //宽带
            case 2:
                if (isCouldUse)
                {
                    imgUrl=@"room_online.png";
                    txt=@"免费宽带";
                }
                else
                {
                    imgUrl=@"room_online_no.png";
                    txt=@"不含宽带";
                }
                break;
            //停车
            case 3:
                if (isCouldUse)
                {
                    imgUrl=@"room_park.png";
                    txt=@"免费停车";
                }
                else
                {
                    imgUrl=@"room_park_no.png";
                    txt=@"不含停车";
                }
                break;
                
            default:
                break;
        }
        
        upIcon.image=[UIImage noCacheImageNamed:imgUrl];
        downLbl.text=txt;
    }
}

//清空设施view的子view
-(void) removeFacilityViewSubviews
{
    if (facilityView.subviews.count>0)
    {
        for (UIView *c in facilityView.subviews)
        {
            if ([c isMemberOfClass:[UIImageView class]])
            {
                [c removeFromSuperview];
            }
            else if ([c isMemberOfClass:[UILabel class]])
            {
                [c removeFromSuperview];
            }
        }
    }
}

@end
