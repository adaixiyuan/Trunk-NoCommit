//
//  ScenicDetail.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicDetail.h"
#import "SceneryList.h"

@implementation ScenicDetail
-(void)dealloc{
    self.sceneryId = nil;
    self.sceneryAddress = nil;
    self.sceneryName = nil;
    self.supplierId = nil;
    self.cityId = nil;
    self.intro = nil;
    self.buyNotie = nil;
    self.payMode = nil;
    self.payModeName = nil;
    self.lat = nil;
    self.lon = nil;
    self.amountAdvice = nil;
    self.policyList = nil;
    self.notice = nil;
    self.ahead = nil;
    self.nearbySceneryList = nil;
    self.sameThemeSceneryList = nil;
    self.imageList = nil;
    self.extInfoOfImageList = nil;
    [super dealloc];
}

+(NSString *)getScenicDetailRequestByGivenListModel:(SceneryList *)model{
    NSDictionary  *req = @{@"sceneryId":model.sceneryId,
                           @"cs":@"1",
                           @"latitude":[NSString stringWithFormat:@"%f",[model.lat floatValue]],
                           @"longitude":[NSString stringWithFormat:@"%f",[model.lon floatValue]],
                           @"radius":@"",
                           @"themeId":@"",
                           @"bookFlag":model.bookFlag,
                           @"themes":@"",};
    NSString *reqString = [req JSONString];
   return [PublicMethods composeNetSearchUrl:@"mtools/ticket" forService:@"getSceneryDetail" andParam:reqString];
}

+(NSArray *)convertThePricePolicy:(NSArray *)policyList{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in policyList) {
        ScenicPrice *price = [[ScenicPrice alloc] init];
        [price convertObjectFromGievnDictionary:dictionary relySelf:YES];
        [array addObject:price];
        [price release];
    }
    return [array autorelease];
}

+(NSArray *)convertTheNearByPoints:(NSArray *)nearBylist{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in nearBylist) {
        SimpleScenic *simple = [[SimpleScenic alloc] init];
        [simple convertObjectFromGievnDictionary:dictionary relySelf:YES];
        [array addObject:simple];
        [simple release];
    }
    return [array autorelease];
    
}


@end


@implementation SimpleScenic

-(void)dealloc{

    self.sceneryName = nil;
    self.sceneryId = nil;
    self.imgPath = nil;
    [super dealloc];
}

@end

@implementation ScenicPrice

-(void)dealloc{
    self.maxT = nil;
    self.realName= nil;
    self.ticketId= nil;
    self.ticketName= nil;
    self.bDate= nil;
    self.eDate= nil;
    self.poenDateType= nil;
    self.openDateValue= nil;
    self.closeDate= nil;
    self.policyId= nil;
    self.policyName= nil;
    self.remark= nil;
    self.price= nil;
    self.elongPrice= nil;
    self.pMode= nil;
    self.pModeName= nil;
    self.gMode= nil;
    self.gModeName = nil;
    self.minT = nil;
    [super dealloc];
}

@end
