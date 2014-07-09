//
//  XGHomeSearchViewController.h
//  ElongClient
//
//  Created by licheng on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

//商品特惠入口
//客户端
#import "XGBaseViewController.h"
#import "JHotelKeywordFilter.h"
@class XGSearchFilter;
@interface XGHomeSearchViewController : XGBaseViewController

@property(nonatomic,strong)IBOutlet UITextField *cityTextField;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong) IBOutlet UILabel *checkInDayLabel;
@property(nonatomic,strong) IBOutlet UILabel *checkInMonthLabel;
@property(nonatomic,strong) IBOutlet UILabel *checkInWeekDayLabel;
@property(nonatomic,strong) IBOutlet UILabel *bedTypeLabel;
@property (strong, nonatomic) IBOutlet UIButton *firstButton;
@property (strong, nonatomic) IBOutlet UIButton *secondButton;
@property (strong, nonatomic) IBOutlet UIButton *threeButton;
@property (strong, nonatomic) IBOutlet UIButton *fourButton;
@property (strong, nonatomic) UIButton *searchButton;
@property(nonatomic,strong) IBOutlet UILabel *checkOutDayLabel;
@property(nonatomic,strong) IBOutlet UILabel *checkOutMonthLabel;
@property(nonatomic,strong) IBOutlet UILabel *checkOutWeekDayLabel;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSDate *checkInDate;
@property (nonatomic, strong) NSDate *checkOutDate;
@property(nonatomic,strong)IBOutlet UIView * alphaBg;   //0.7 半透明 view
@property (nonatomic, strong) JHotelKeywordFilter *locationInfo;    // 地理位置信息
@property(nonatomic,strong)XGSearchFilter *searchFilter;

- (IBAction)selectIPButtonTouch:(id)sender;
//选择城市
-(IBAction)selectCity:(id)sender;
//选择日期
-(IBAction)selectdate:(id)sender;
//选择价格区间
-(IBAction)selectpriceRange:(id)sender;

//-(IBAction)bedTypeSelect:(id)sender;
//搜索按钮
-(void)searchAction;

-(void)changelastTimeBadge:(int)badge;

@end
