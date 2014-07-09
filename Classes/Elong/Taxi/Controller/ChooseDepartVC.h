//
//  ChooseDepartVC.h
//  ElongClient
//  叫车出发地 目的地选择
//  Created by Jian.Zhao on 14-2-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

@class AddressInfo;

typedef enum {

    TaxiDepart_start = 10,
    TaxiDepart_end,
    
}TaxiDepart_Type;

typedef enum {
    Entrance_Taxi = 20,
    Entrance_RentCar,
}EntranceType;


@protocol SelectAddressDelegate <NSObject>

@required
-(void)getTheSelectedAddressInfo:(AddressInfo *)info andDepartType:(TaxiDepart_Type)type;

@optional
-(void)getTheUserInputAddress:(NSString *)address andDepartType:(TaxiDepart_Type)type;

@end

@interface ChooseDepartVC : ElongBaseViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{

    UITableView *_tableView;
    
    HttpUtil *poiUtil;
    
    CLLocationCoordinate2D currentld;

    
    NSMutableArray *_arounds;//周边
    NSMutableArray *_hisyorys;//历史
    NSMutableArray *_searchResults;//搜索
    
    BOOL searchBarIsActice;
    
    id<SelectAddressDelegate>_delegate;
    
    TaxiDepart_Type _type;
    
    BOOL locatedSuccess;
    BOOL _needLatAndLongtitude;
    BOOL _checkSpanCity;//检查跨城市
}
@property (nonatomic,assign)  id<SelectAddressDelegate>delegate;
@property(nonatomic,retain)  NSMutableArray *hisyorys;//历史
@property (nonatomic,copy) NSString *searchCity;
@property (nonatomic,assign) BOOL needLatAndLongtitude;
@property (nonatomic,assign) BOOL checkSpanCity;
@property (nonatomic,retain) AddressInfo *selected_Address;
@property (nonatomic,assign) EntranceType entrance;

-(void)setType:(TaxiDepart_Type)type;
-(int)type;

@end

@interface NSMutableArray (contains)
-(BOOL)containsTheAddress:(AddressInfo *)info;
@end
