//
//  ScenicListViewController.m
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicListViewController.h"
#import "BaseBottomBar.h"
#import "SearchBarView.h"
#import "ScenicListCell.h"
#import "ScenicListView.h"
#import "ScenicMapView.h"
#import "ScenicTicketsPublic.h"

@interface ScenicListViewController ()

@end

@implementation ScenicListViewController
@synthesize isAll;
@synthesize page;
- (void)dealloc
{
   
    [_sModelAr release];
    [modelAr release];
    if (listUtil) {
        [listUtil cancel];
        SFRelease(listUtil);
    }
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isList = YES;
    
 
    
    jReq = [[JScenicListRequest alloc]init];
    
    mapMoreClick = 0;

    modelAr = [[NSMutableArray  alloc]initWithArray:self.sModelAr];
    
    scenicList = [[ScenicListView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT ) modelAr:modelAr];
    
    scenicList.delegate = self;
    
    [self.view  addSubview:scenicList];
    [scenicList release];
   
    [self  reloadRightButton];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self  setBackButton];

    // Do any additional setup after loading the view from its nib.
}

- (void)reloadRightButton
{
   
    if (!mapBt)
    {
        mapBt = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
        mapBt.exclusiveTouch = YES;
        mapBt.adjustsImageWhenDisabled = NO;
        mapBt.titleLabel.font = FONT_B15;
        
        [mapBt  addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];

       
    }
    mapBt.userInteractionEnabled = YES;
    [mapBt setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [mapBt setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    if (isList)
    {
        
        [mapBt setTitle:@"地图" forState:UIControlStateNormal];
       
    }else
    {
        
        if (isAll)
        {
            [mapBt  setTitleColor:[UIColor  grayColor] forState:UIControlStateNormal];
            mapBt.userInteractionEnabled = NO;
        }
        [mapBt setTitle:@"显示更多" forState:UIControlStateNormal];
        
    }
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:mapBt] autorelease];
}

- (void)mapClick
{
    isList = NO;

    
    if ( [mapBt.titleLabel.text  isEqualToString:@"显示更多"])
    {
       
        //地图上的显示更多按钮
        [self  showMapMore];
   }else
   {
       //重新创建mapview
       if (!mapView)
       {
           
           mapView = [[ScenicMapView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT )withAnnotionAr:modelAr];
           mapView.delegate  = self;
           [self.view  insertSubview:mapView belowSubview:scenicList];
           [mapView release];
       }
       
       
       [self  annimationExchange];
   }
    

}
 - (void)showMapMore
{
    mapMoreClick ++;
    [self  requestSort:sortType andPage:page + mapMoreClick];
}
- (void)annimationExchange
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isList)
        {
             [UIView  setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
           
        }else
        {
            [UIView  setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        }
       
         [self.view  exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:^(BOOL finished)
     {
         [self  reloadRightButton];
     }];
}


- (void)setBackButton
{
    
    UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
    [backbtn setImage:[UIImage imageNamed:@"btn_navback_normal.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [backbtn  addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backbarbuttonitem;
    [backbtn release];
    [backbarbuttonitem release];
}

- (void)backAction
{
    if (isList)
    {
        [self.navigationController  popViewControllerAnimated:YES];
    }else
    {
        isList = YES;
        
        [self  annimationExchange];
        //为节省性能，移除map
        if (mapView)
        {
            mapView.delegate = nil;
            [mapView  removeFromSuperview];
            SFRelease(mapView);
        }
        
    }
}


- (void)requestSort:(NSInteger )type andPage:(int )ipage
{

//    if (ipage > totalPage)
//    {
//        isAll = YES;
//        return;
//    }
    
    if  (listUtil )
    {
        [listUtil  cancel];
        SFRelease(listUtil);
    }
    
    jReq.type = [NSNumber numberWithInt:1];
    jReq.pageSize = [NSNumber  numberWithInt:ScenicPageSize];
    jReq.sortType =[NSNumber  numberWithInt:type];
    jReq.page =   [NSNumber  numberWithInt:ipage];
    NSString  *url = [jReq  getListUrl];
    listUtil = [[HttpUtil  alloc]init];
    [listUtil  requestWithURLString:url Content:Nil StartLoading:YES   EndLoading:YES Delegate:self];
    
}

#pragma mark - 网络请求的回调
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    totalPage = [[root  objectForKey:@"totalPage"] intValue];
    
    page = [[root  objectForKey:@"page"] intValue];
    
    if (page >= totalPage)
    {
        isAll = YES;
        scenicList.isAll = YES;
        [self  reloadRightButton];
    }
    
    [self  parseModel:[root  objectForKey:@"sceneryList"]];
    //更新景点列表的model数组
    //无论是否在列表页，都要即使更新列表
    scenicList.sAr = modelAr;
    
    if (!isList)
    {   //当在地图页面的时候 ，直接更新地图
         [mapView  parserAnnotion:modelAr];
    }
   
    
    [scenicList.listTable reloadData];
}
#pragma mark - listview选中的bar
- (void)didSelectIndex:(NSInteger)index andBottomBar:(BaseBottomBar *)bar
{
    if (index == 0)
    {   if (sortType == SCENICRECOMENT)
    {   //点击同一个分类按钮，不再请求
        return;
    }
        
        [modelAr  removeAllObjects];
        
        sortType = SCENICRECOMENT;
    }else if (index == 1)
    {
        if (sortType == SCENICPEOPLE) {
            return;
        }
        
        [modelAr  removeAllObjects];
        
        sortType = SCENICPEOPLE;
    }
    else
    {
        sortType = SCENICFILTER;
        return;
    }
    [self  requestSort:sortType andPage:page];

}
#pragma mark－listview滑动到某一页
- (void)didScrollToPageDelegate:(NSInteger)sPage
{
    [self requestSort:sortType andPage:sPage];
}


- (void)parseModel:(NSArray *) ar
{
    
    for (NSDictionary  *dic  in ar)
    {
        SceneryList  *model = [[SceneryList  alloc]initWithDataDic:dic];
        [modelAr  addObject:model];
        [model  release];
    }
    
}

- (void)longpress:(CLLocationCoordinate2D)cood
{    //每一次长按都把数组清一次
    [modelAr removeAllObjects];
    jReq.latitude = [NSNumber  numberWithFloat:cood.latitude];
    jReq.longitude = [NSNumber  numberWithFloat:cood.longitude];
    //TODO:测试阶段，page还得改
    [self  requestSort:SCENICRECOMENT andPage:0];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
