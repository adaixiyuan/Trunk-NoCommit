//
//  XGHomeTableViewDelegateAndDataSource.m
//  ElongClient
//
//  Created by guorendong on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHomeTableViewDelegateAndDataSource.h"
#import "XGHomeListViewController.h"
#import "XGShoppingCell.h"
#import "XGHotelInfo.h"
#import "XGSpecialProductDetailViewController.h"
#import "XGTabView.h"
#import "UMengEventC2C.h"
#import "Utils.h"
@implementation XGHomeTableViewDelegateAndDataSource
-(void)dealloc
{
    self.viewController=nil;
}
@synthesize viewController=_viewController;

@synthesize dataArray=_dataArray;

-(NSMutableArray *)dataArray
{
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

@synthesize sortArray=_sortArray;
-(NSMutableArray *)sortArray
{
    if (_sortArray ==nil) {
        _sortArray =[[NSMutableArray alloc] init];
    }
    return _sortArray;
}
-(int)getHandlerCount
{
    int handleCount =0;
    for (XGHotelInfo *i in self.dataArray) {
        XGRoomStyle *room=i.RoomsEntity.count>0?i.RoomsEntity[0]:nil;
        if ([room.Auto intValue]<=0) {
            handleCount++;
        }
    }
    return handleCount;
}
//用于排序，参数
-(void)sortForData:(BOOL)isReloadData
{
    [self.sortArray removeAllObjects];
    [self.sortArray addObjectsFromArray:self.dataArray];
    switch (self.viewController.orderType) {
        case ListOrderByTypeDefault:
            
            break;
        case ListOrderByTypePrice:
        {
            NSInteger tag=self.viewController.tab2.tag;
            [self.sortArray sortUsingComparator:^(id obj1,id obj2){
                XGHotelInfo *hInfo1 =(XGHotelInfo *)obj1;
                XGHotelInfo *hInfo2 =(XGHotelInfo *)obj2;
                float p1=[hInfo1.FinalPrice floatValue];
                float p2=[hInfo2.FinalPrice floatValue];
                if (tag%2==1) {
                    return p1>p2?1:(p2>p1?-1:0);
                }
                return p2>p1?1:(p1>p2?-1:0);
            }];
        }
            break;
        case ListOrderByTypeDistance:
        {
            [self.sortArray sortUsingComparator:^(id obj1,id obj2){
                XGHotelInfo *hInfo1 =(XGHotelInfo *)obj1;
                XGHotelInfo *hInfo2 =(XGHotelInfo *)obj2;
                float d1 =[hInfo1.Distance floatValue];
                float d2 =[hInfo2.Distance floatValue];
                return d1>d2?1:(d2>d1?-1:0);
            }];
        }
            break;
        case ListOrderByTypeStarts:
        {
            NSInteger tag=self.viewController.tab4.tag;
            [self.sortArray sortUsingComparator:^(id obj1,id obj2){
                
                XGHotelInfo *hInfo1 =(XGHotelInfo *)obj1;
                XGHotelInfo *hInfo2 =(XGHotelInfo *)obj2;
                float d1 =[hInfo1.Star floatValue];
                float d2 =[hInfo2.Star floatValue];
                if (tag%2==1) {
                    return d1>d2?1:(d2>d1?-1:0);
                }
                return d2>d1?1:(d1>d2?-1:0);
            }];
        }
            break;
        default:
            break;
    }
    if (isReloadData) {
        [self.viewController.tableView reloadData];

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XGShoppingCell *cell =[tableView dequeueReusableCellWithIdentifier:@"XGHomeTableViewDelegateAndDataSource"];
    if (cell ==nil) {
        cell =xgGetCellForNibName(@"XGShoppingCell", XGShoppingCell);
        if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0f) {
            cell.restorationIdentifier = @"XGHomeTableViewDelegateAndDataSource";
            
        }
        //cell.restorationIdentifier = @"XGHomeTableViewDelegateAndDataSource";
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (self.sortArray.count>indexPath.row) {
        XGHotelInfo *info =self.sortArray[indexPath.row];
        [cell setViewInfoForObject:info];
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XGHotelInfo *info =self.sortArray[indexPath.row];
    
    //XGShoppingCell *cell =(XGShoppingCell*)[tableView cellForRowAtIndexPath:indexPath];
    //如果是由其他说明，则高一些，否则低一些
    return   info.Remark.length>0?112:87;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView             // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self setDataInfo];

    return self.sortArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.viewController isInsertingAnimation]) {
        return;
    }
    
    //请求详情数据
    XGHotelInfo *info =self.sortArray[indexPath.row];
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    
    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:info.HotelId];
//    [hoteldetail setHotelId:@"50101502"];
    [hoteldetail setIsUnsigned:NO];
    if (YES) {
        [hoteldetail setSevenDay:YES];
    }
    
//    NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
//	[oFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *cinStr = [TimeUtils  makeJsonDateWithUTCDate:self.viewController.filter.cinDate];
    NSString *coutStr = [TimeUtils  makeJsonDateWithUTCDate:self.viewController.filter.coutDate];
    
//    NSString *cinStr=[oFormat stringFromDate:self.viewController.filter.cinDate];
//    NSString *coutStr=[oFormat stringFromDate:self.viewController.filter.coutDate];
//    cinStr = @"/Date(1399132800000+0800)/";
//    coutStr = @"/Date(1399219200000+0800)/";
    
	[hoteldetail setCheckDateByElongDate:cinStr checkoutdate:coutStr];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [r evalForURL:HOTELSEARCH req:[hoteldetail requesString:YES] policy:CachePolicyHotelDetail RequestFinished:^(XGHttpRequest *request, XGRequestResultType type, id returnValue) {
        NSLog(@"我aaaaa=====");
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            [Utils alert:@"网络错误，请稍后再试"];
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        NSDictionary *root =returnValue;
//        NSLog(@"dict=====%@",root);
        
        NSArray *roomsArray=info.Rooms;
        NSMutableArray *mutableRoomsArray  = [NSMutableArray arrayWithArray:roomsArray];   //所有房型
        
        for (int j=0; j<[mutableRoomsArray count]; j++) {//每一个房型
            NSDictionary *dictT = [mutableRoomsArray safeObjectAtIndex:j];
            NSMutableDictionary *mutabledict = [NSMutableDictionary dictionaryWithDictionary:dictT];  //其中一个房型
            
            NSArray *arr=[mutabledict safeObjectForKey:@"HoldingTimeOptions"];
            NSMutableArray *HoldingTimeOptionsArray = [NSMutableArray arrayWithArray:arr];  //一个房型的  时间数组
            
            for (int i=0;i<[HoldingTimeOptionsArray count] ;i++ ) {
                
                NSDictionary  *timeDict  = [HoldingTimeOptionsArray safeObjectAtIndex:i];
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:timeDict];
                
                
                long long  ArriveTimeEarlyfloat = [[timeDict safeObjectForKey:@"ArriveTimeEarly"] longLongValue];
                long long ArriveTimeLatefloat = [[timeDict safeObjectForKey:@"ArriveTimeLate"] longLongValue];
                
                NSString *arriveEarlyString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:ArriveTimeEarlyfloat];
                NSString *arriveLateString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:ArriveTimeLatefloat];
                
               
                [mutableDict safeSetObject:arriveEarlyString forKey:@"ArriveTimeEarly"];
                [mutableDict safeSetObject:arriveLateString forKey:@"ArriveTimeLate"];
//                [HoldingTimeOptionsArray removeObjectAtIndex:i];
//                [HoldingTimeOptionsArray insertObject:mutableDict atIndex:i];
                [HoldingTimeOptionsArray setObject:mutableDict atIndexedSubscript:i];
            }
            
            [mutabledict safeSetObject:HoldingTimeOptionsArray forKey:@"HoldingTimeOptions"];
//            [mutableRoomsArray removeObjectAtIndex:j];
//            [mutableRoomsArray insertObject:mutabledict atIndex:j];
            [mutableRoomsArray setObject:mutabledict atIndexedSubscript:j];
        }
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:root];
        [dict setObject:mutableRoomsArray forKey:@"Rooms"];
         NSLog(@"remark===\n%@==%@",info.Remark,roomsArray);
        [[HotelDetailController hoteldetail] removeAllObjects];
        [[HotelDetailController hoteldetail] addEntriesFromDictionary:dict];
        [[HotelDetailController hoteldetail] removeRepeatingImage];
        XGSpecialProductDetailViewController *homeDetailVC =[[XGSpecialProductDetailViewController alloc]init];
        homeDetailVC.remark = info.Remark;
        homeDetailVC.filter = weakSelf.viewController.filter;
        [weakSelf.viewController.navigationController pushViewController:homeDetailVC animated:YES];
    }];
}

-(void)setDataInfo
{
    if (self.viewController.tableViewHelper.sortArray.count<=0) {
        [self.viewController.view addSubview:self.viewController.noDataView];
    }
    else
    {
        [self.viewController.noDataView removeFromSuperview];
    }
}


@end
