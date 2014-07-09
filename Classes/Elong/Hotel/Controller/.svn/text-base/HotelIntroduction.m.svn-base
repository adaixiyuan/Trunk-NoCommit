//
//  RoomIntroduction.m
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelIntroduction.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"

@implementation HotelIntroduction

-(int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width{
	
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
	
	
	return expectedLabelSize.height;
	
}

-(int)addContentView:(int)ypos parentView:(UIView *)parentView subtitle:(NSString *)subtitle subtext:(NSString *)subtext{
	
	//对于没有详情的不予显示 by shuguang
	subtext = [subtext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([subtext length]==0) {
		return ypos;
	}

	int subtitleHeight=40;
	
	int subtextHeight =[self labelHeightWithNSString:FONT_13 string:subtext width:280];
	
	int totalHeight = subtitleHeight+subtextHeight + 10;
	
	UIView *subTitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, BOTTOM_BUTTON_WIDTH, subtitleHeight)];
	//subTitleView.backgroundColor=[UIColor colorWithRed:201/255.0 green:229/255.0 blue:240/255.0 alpha:1.0];
	
	UILabel *subTitle=[[UILabel alloc] initWithFrame:CGRectMake(4, 2, 282, 21)];
	subTitle.text=[NSString stringWithFormat:@"%@",subtitle];
	subTitle.textColor=[UIColor blackColor];
	subTitle.backgroundColor=[UIColor clearColor];
	subTitle.font=FONT_B16;
	[subTitle sizeToFit];
	[subTitleView addSubview:subTitle];
	[subTitle release];
	
	UIView *subcontentView=[[UIView alloc] initWithFrame:CGRectMake(0, subtitleHeight, BOTTOM_BUTTON_WIDTH, subtextHeight)];
	subcontentView.backgroundColor=[UIColor clearColor];
	
	UILabel *subContent=[[UILabel alloc] initWithFrame:CGRectMake(4, 0, 282, subtextHeight)];
	subContent.lineBreakMode=UILineBreakModeCharacterWrap;
	subContent.numberOfLines=0;
	subContent.text=[NSString stringWithFormat:@"%@",subtext];
	subContent.textColor=[UIColor blackColor];
	subContent.backgroundColor=[UIColor clearColor];
	subContent.font=FONT_13;

	[subcontentView addSubview:subContent];
	[subContent release];
	
	UIView *contenView =[[UIView alloc] initWithFrame:CGRectMake(15, ypos, BOTTOM_BUTTON_WIDTH, totalHeight)];
	contenView.backgroundColor=[UIColor clearColor];
	[contenView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, totalHeight - 1, BOTTOM_BUTTON_WIDTH, 1)]];
	[contenView addSubview:subTitleView];
	[contenView addSubview:subcontentView];
	[subTitleView release];
	[subcontentView release];
	[parentView addSubview:contenView];
	[contenView release];
	return ypos+totalHeight;
}

- (id)initWithFrame:(CGRect)rect {
	if (self = [super initWithFrame:rect]) {
		self.backgroundColor=[UIColor whiteColor];
		
		int ypos=0;
		//增加酒店名称显示
		ypos = [self addContentView:0 parentView:self subtitle:@"酒店名称" subtext:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S]];

        if (YES) {
            ypos = [self addContentView:ypos parentView:self subtitle:@"酒店前台电话" subtext:[[HotelDetailController hoteldetail] safeObjectForKey:@"Phone"]];
        }
		if ([[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Address_S]!=[NSNull null]) {
			ypos = [self addContentView:ypos parentView:self subtitle:@"酒店地址" subtext:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Address_S]];
		}
		if ([[HotelDetailController hoteldetail] safeObjectForKey:RespHD_FeatureInfo_S]!=[NSNull null]) {
			ypos=[self addContentView:ypos parentView:self subtitle:@"特色介绍" subtext: [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_FeatureInfo_S]];
		}
		if ([[HotelDetailController hoteldetail] safeObjectForKey:RespHD_GeneralAmenities_S]!=[NSNull null]) {
			ypos=[self addContentView:ypos parentView:self subtitle:@"设施服务" subtext: [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_GeneralAmenities_S]];
		}
		if ([[HotelDetailController hoteldetail] safeObjectForKey:RespHD_TrafficAndAroundInformations_S]!=[NSNull null]) {
			ypos=[self addContentView:ypos parentView:self subtitle:@"交通状况" subtext: [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_TrafficAndAroundInformations_S]];
			
		}
		
		if (ypos==0) {
			m_tipView = [Utils addView:@"该酒店目前没有简介"];
			CGRect oldframe=m_tipView.frame;
			oldframe.origin.y=(416-m_tipView.frame.size.height)/2-40;
			m_tipView.frame=oldframe;
			[self addSubview:m_tipView];
			self.backgroundColor=[UIColor whiteColor];
			
		}
		self.contentSize=CGSizeMake(306, ypos+40);
	}
	
	return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
