//
//  SelectCity.h
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//UITableViewDataSource,UITableViewDelegate

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "SettingManager.h"
#import "CustomSegmented.h"
#import "AIMTableViewIndexBar.h"

typedef enum {
    SelectCityTypeHotel,            // 酒店流程
    SelectCityTypeFlight,           // 机票流程
    SelectCityTypeTrainDepart,      // 列车出发站
    SelectCityTypeTrainArrive,      // 列车到达站
    SelectCityTypeFStatusDepart,    // 航班动态出发站
    SelectCityTypeFStatusArrive,    // 航班动态到达站
}SelectCityType;        // 选择城市控件的流程

// 选择城市代理
@protocol SelectCityDelegate <NSObject>

- (void)selectCityBack:(NSString *)cityName;

@end

@interface SelectCity : DPNav <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,CustomSegmentedDelegate, AIMTableViewIndexBarDelegate>{
  @private
	NSMutableArray *sectionArray;
	NSMutableArray	*filteredListContent;
    NSString* m_searchCityName;
    
    SelectCityType cityType;
    SmallLoadingView *loadingView;  // 请求国际城市时的loading框
    UIView *loadingSuperView;       // 为挡住“无结果”提示加的loading背景框
    UIView *topView;               // 顶部视图
    UIView *footView;               // 国际酒店下部输入框
    BOOL isInterHotel;              // 判断是否是国际酒店城市列表,default = NO
}

@property (nonatomic,retain) UILabel *resultlabel;
@property (nonatomic,retain) NSString *selectedCity;
@property (nonatomic,retain) CustomSegmented *hotelSeg;         // 酒店国内/国外选择器
@property (nonatomic, strong) id <SelectCityDelegate> cityDelegate;            // 代理

-(id)init:(NSString *)name style:(NavBtnStyle)style citylable:(id)citylable cityType:(SelectCityType)type isSave:(BOOL)isSave;

@end
