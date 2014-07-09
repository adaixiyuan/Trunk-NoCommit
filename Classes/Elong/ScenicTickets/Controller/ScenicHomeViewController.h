//
//  ScenicHomeViewController.h
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//
typedef enum
{
    HOTCITY_SECTION = 0,
    HOTSCENIC_SECTION,
    HOTTHEME_SECTION
}SCENIC_SECTION_TYPE;


#import "ElongBaseViewController.h"
#import "HotScenicButton.h"

@interface ScenicHomeViewController : ElongBaseViewController<UISearchBarDelegate,HttpUtilDelegate,UITableViewDataSource,UITableViewDelegate,SCenicButtonDelegate>
{
    UITableView  *homeTable ;
    NSMutableDictionary  *modelDic;
    NSMutableDictionary  *textDic;
    NSMutableArray  *allTheme;
    HttpUtil  *homeUtil;
    int  listIsAll;
    int firstPage;
}
@end
