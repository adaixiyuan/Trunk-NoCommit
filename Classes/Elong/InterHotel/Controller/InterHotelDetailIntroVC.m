//
//  InterHotelDetailVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelDetailIntroVC.h"
#import "InterHotelDetailCtrl.h"
#import "CustomSegmented.h"
#import "HotelInfoWeb.h"


@interface InterHotelDetailIntroVC ()

@end

@implementation InterHotelDetailIntroVC

- (void)dealloc
{
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)init
{
    self = [super initWithTopImagePath:nil andTitle:@"酒店信息" style:_NavNormalBtnStyle_];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    // 添加底栏
    NSArray *itemTitleArray = [NSArray arrayWithObjects:@"简介", @"周边", @"服务", @"其它",nil];
    NSMutableArray *itemArray= [NSMutableArray array];
    for (NSString *item in itemTitleArray) {
        BaseBottomBarItem *barItem = [[BaseBottomBarItem alloc] initWithTitle:item titleFont:[UIFont systemFontOfSize:14.0f]];
        [itemArray addObject:barItem];
        [barItem release];
    }
    
    
    
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
    bottomBar.baseBottomBarItems = itemArray;
    
    // 选中第一项
    BaseBottomBarItem *firstBarItem = (BaseBottomBarItem *)[itemArray objectAtIndex:0];
    bottomBar.selectedItem = firstBarItem;
    [firstBarItem changeStateToPressed:YES];
    
    
    
    [self.view addSubview:bottomBar];
    bottomBar.delegate = self;
    [bottomBar release];
    
    // 添加酒店简介页
    introView = [[HotelInfoWeb alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
    [introView reloadDataByType:HotelInfoTypeInterIntro];       // 默认显示国际酒店简介
    [self.view addSubview:introView];
    [introView release];
    
    if (UMENG) {
        //国际酒店简介页面
        [MobClick event:Event_InterHotelInfo];
    }
}

#pragma mark -
#pragma mark BaseBottomBarDelegate
- (void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [introView reloadDataByType:HotelInfoTypeInterIntro];
            break;
        case 1:
            [introView reloadDataByType:HotelInfoTypeInterAround];
            break;
        case 2:
            [introView reloadDataByType:HotelInfoTypeInterService];
            break;
        case 3:
            [introView reloadDataByType:HotelInfoTypeInterOther];
            break;
        default:
            break;
    }
}

@end
