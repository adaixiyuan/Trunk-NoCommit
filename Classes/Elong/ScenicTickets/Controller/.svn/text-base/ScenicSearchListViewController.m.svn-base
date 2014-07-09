//
//  ScenicSearchListViewController.m
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicSearchListViewController.h"
#import "SearchBarView.h"
#import "UIViewExt.h"
#import "ScenicUtils.h"
#import "CityList.h"
#import "SuggesTionModel.h"
#import "HotModel.h"
#import "JScenicListRequest.h"
#import "ScenicTicketsPublic.h"
#import "SceneryList.h"
#import "ScenicListViewController.h"

@interface ScenicSearchListViewController ()

@end

@implementation ScenicSearchListViewController
- (void)dealloc
{
    [tabView  release];
    [_sModel  release];
    [_modelAr release];
    [_textAr  release];
    [cityModelAr release];
    [historyModelAr  release];
    [homeSearchBar  release];
    [scenicModelAr  release];
    if (searchUrl) {
        [searchUrl  cancel];
        SFRelease(searchUrl);
    }
    [super dealloc ];
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
    
    cityModelAr = [[NSMutableArray alloc]init];
    scenicModelAr = [[NSMutableArray  alloc]init];
    _sModel = [[ScenicListSearch  alloc]init];
    historyModelAr = [[NSMutableArray  alloc]init];
    homeSearchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	homeSearchBar.delegate = self;
    homeSearchBar.placeholder = @"地址、地标、关键词";
    homeSearchBar.showsCancelButton = YES;
    [self.view addSubview:homeSearchBar];
  
    
    tabView = [[UITableView  alloc]initWithFrame:CGRectMake(0, homeSearchBar.bottom, SCREEN_WIDTH, MAINCONTENTHEIGHT - homeSearchBar.height) style:UITableViewStylePlain];
    tabView.delegate =  self;
    tabView.dataSource =  self;
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.tableFooterView = [self  footViewSet];
    [self.view addSubview:tabView];
    
    isInSearch = NO;
    [self  updateHistory];
    
	// Do any additional setup after loading the view.
}


- (void)updateHistory
{
   // [self  clearAction];
    [historyModelAr  removeAllObjects];
    NSLog(@"%@",[ScenicUtils  getHistoryFromPath:ScenicSearchHomePath]);
   for (id obj in [ScenicUtils  getHistoryFromPath:ScenicSearchHomePath])
   {
//       if ([obj isKindOfClass:[Citys  class]])
//       {
//           [cityModelAr  addObject:obj];
//       }
//       if ([obj isKindOfClass:[HotSceneryList  class]]) {
//           [scenicModelAr  addObject:obj];
//       }
       [historyModelAr  addObject:obj];
   }
    [tabView  reloadData];
    
}
- (void) requestUrl
{
    if (searchUrl) {
        [searchUrl  cancel];
        SFRelease(searchUrl);
    }
    NSDictionary  *jsonDic = [NSDictionary  dictionaryWithObject:searchBarText forKey:@"keyword"];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"ticket/getSuggestion" andParam:jsonString];
    searchUrl = [[HttpUtil  alloc]init];
    [searchUrl  requestWithURLString:url Content:Nil StartLoading:NO EndLoading:NO Delegate:self];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSArray  *ar = [ScenicUtils  getHistory];
    if (isInSearch)
    {
         return cityModelAr.count + scenicModelAr.count;
    }else
    {
        return historyModelAr.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str = @"cell";
    UITableViewCell  *cell = [tabView  dequeueReusableCellWithIdentifier:str] ;
    if (!cell)
    {
        cell = [[[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str]autorelease];
        
        UIImageView  *bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
        [cell   addSubview:bottomLineView];
        [bottomLineView  release];
        
    }
    if (isInSearch)
    {
        if (indexPath.row < cityModelAr.count)
        {
            Citys  *city = [cityModelAr  objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString  stringWithFormat:@"城市：%@",city.cityName];
            
        }else if (indexPath.row < cityModelAr.count + scenicModelAr.count -1)
        {
            HotSceneryList  *scenic = [scenicModelAr  objectAtIndex:indexPath.row - cityModelAr.count ];
            cell.textLabel.text =[NSString  stringWithFormat:@"景点：%@",scenic.sceneryName] ;
        }
    }else
    {   id obj = [historyModelAr  objectAtIndex:indexPath.row];
        if ([obj  isKindOfClass:[Citys  class]])
        {
            cell.textLabel.text = [NSString  stringWithFormat:@"城市：%@",((Citys *)obj).cityName];
        }else
        {
            cell.textLabel.text =[NSString  stringWithFormat:@"景点：%@",(( HotSceneryList*)obj).sceneryName] ;
        }
    }
   
    return cell;
}

- (NSString  *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isInSearch) {
        return nil;
    }else
    {
          return @"历史搜索";
    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isInSearch)
    {
         [self  savaHisTory:indexPath];
    }
   if (isInSearch)
   {
    if (indexPath.row < cityModelAr.count)
    {
        homeSearchBar.text = [[cityModelAr objectAtIndex:indexPath.row] cityName];
        [self  CityAction:[cityModelAr objectAtIndex:indexPath.row]];
    }else  if (indexPath.row < cityModelAr.count + scenicModelAr.count-1)
    {
        homeSearchBar.text = [[scenicModelAr objectAtIndex:indexPath.row - cityModelAr.count ] sceneryName];
        
        [self  ScenicAction:[scenicModelAr objectAtIndex:indexPath.row - cityModelAr.count ]];
    }
   }else
   {   //针对历史记录排序的问题
       id obj = [historyModelAr  objectAtIndex:indexPath.row];
       if ([obj  isKindOfClass:[Citys  class]])
       {
           [self  CityAction:obj];
       }else
       {
           [self  ScenicAction:obj];
       }
      
   }
}

- (void) CityAction:(Citys *)model
{
    JScenicListRequest  *jreq = [[JScenicListRequest  alloc]initWithDataDic:Nil];
    jreq.type = [NSNumber numberWithInt:1];
    jreq.pageSize = [NSNumber  numberWithInt:ScenicPageSize];
    jreq.page =   [NSNumber  numberWithInt:1];
    NSString  *url = [jreq  getListUrl];
    [jreq release];
    [HttpUtil  requestURL:url postContent:Nil delegate:self];
}

- (void)ScenicAction:(HotSceneryList *)model
{
    
    
    
}

- (UIView *)footViewSet
{
    UIButton  *foot = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [foot  setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    foot.titleLabel.font = [UIFont  systemFontOfSize:15];
    [foot  setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [foot setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [foot setTitleColor:COLOR_NAV_BIN_TITLE_DISABLE forState:UIControlStateDisabled];
    [foot  addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    return [foot autorelease];
    
}
- (void)clearHistory
{
    [ScenicUtils  clearHistoryFromPath:ScenicSearchHomePath];
    [self  updateHistory];
  
}
- (void) clearAction
{
    [cityModelAr  removeAllObjects];
    [scenicModelAr  removeAllObjects];
    
}


#pragma mark - searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    isInSearch = YES;
//    [self  clearAction];
//    [tabView reloadData];
//    tabView.tableFooterView.hidden = YES;
    if (![searchBar.text isEqualToString:@""])
    {
        isInSearch = YES;
        searchBarText = searchBar.text;
        [self  requestUrl];
    }
    return YES;
}


//
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    [self  requestUrl];
//    return YES;
//}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{    searchBarText = searchText;
    isInSearch = YES;
    
    if ([searchBarText  isEqualToString:@""])
    {
        //当搜索框框里面字符数为空时，显示历史
        isInSearch = NO;
        [self  updateHistory];
        return;
    }
        [self  requestUrl];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchUrl ) {
        [searchUrl cancel];
        SFRelease(searchUrl);
    }
    isInSearch = NO;
    [self  updateHistory];
    [searchBar  resignFirstResponder];
}
#pragma mark - httpDelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods unCompressData:responseData ];
    if ([Utils  checkJsonIsError:root])
    {
        return;
    }
    NSLog(@"%@",root);
    if (util == searchUrl) {
        [self  clearAction];
        if ([[root  objectForKey:@"cities"] count] > 0)
        {
            for (NSDictionary  *dic  in  [root  objectForKey:@"cities"] )
            {
                Citys  *searchCity = [[Citys  alloc]initWithDataDic:dic];
                [cityModelAr  addObject:searchCity];
                [searchCity release];
            }
        }
        if ([[root  objectForKey:@"sceneries"] count] > 0)
        {
            for(NSDictionary  *dic in [root  objectForKey:@"sceneries"] )
            {
                HotSceneryList  *scenicList = [[HotSceneryList alloc]initWithDataDic:dic];
                [scenicModelAr  addObject:scenicList];
                [scenicList release];
                
            }
            
        }
        [tabView reloadData];
    }else
    {
        if (  [[root objectForKey:@"page"]  intValue] >= [[root  objectForKey:@"totalPage"] intValue] )
        {
            listIsAll = YES;
        }
        firstPage =  [[root  objectForKey:@"page"]  intValue];
       
        NSArray  *ar = [root  safeObjectForKey:@"sceneryList"];
        
        [self parseListModel:ar];

    }
    
}
- (void)savaHisTory:(NSIndexPath  *) indexPath
{
    if (indexPath.row < cityModelAr.count )
    {
        if ([self  FilterModel:[cityModelAr  objectAtIndex:indexPath.row]])
        {
            [ScenicUtils  savaHistory:[cityModelAr  objectAtIndex:indexPath.row] toPath:ScenicSearchHomePath withCount:3];
        }
        
    }else  if (indexPath.row < scenicModelAr.count + cityModelAr.count-1)
    {
        if ([self FilterModel:[scenicModelAr  objectAtIndex:indexPath.row] ])
        {
             [ScenicUtils  savaHistory:[scenicModelAr  objectAtIndex:indexPath.row-cityModelAr.count] toPath:ScenicSearchHomePath  withCount:3];
            NSLog(@"%@", [[scenicModelAr  objectAtIndex:indexPath.row]  sceneryName]);
        }
       
    }
    
}

- (BOOL)FilterModel:(BaseModel *)model
{
    if ([model  isKindOfClass:[Citys class]])
    {
        for (id  obj in  [ScenicUtils  getHistoryFromPath:ScenicSearchHomePath])
        {
            if ([obj isKindOfClass:[Citys  class]])
            {
                if ([((Citys *)model).cityId  intValue]== [((Citys *)obj).cityId  intValue])
                {
                    return NO;
                }
            }

        }
    }
    else
    {
        for (id  obj in  [ScenicUtils  getHistoryFromPath:ScenicSearchHomePath])
        {
            if ([obj isKindOfClass:[HotSceneryList  class]])
            {
                if ([((HotSceneryList *)obj).sceneryId  intValue] == [((HotSceneryList *)model).sceneryId intValue])
                    return NO;
            }
        }
    }
    return YES;
}


- (void)parseListModel:(NSArray  *) ar
{
    NSMutableArray  *modelAr= [NSMutableArray array];
    for (NSDictionary  *dic in ar)
    {
        SceneryList  *list = [[SceneryList  alloc]initWithDataDic:dic];
        [modelAr  addObject:list];
        [list release];
    }
    [self jumpToList:modelAr];
}

- (void)jumpToList:(NSArray *)array
{
    ElongClientAppDelegate  *navdelegate = (ElongClientAppDelegate *)[UIApplication  sharedApplication].delegate;
    
    
    
    ScenicListViewController  *listCtrl = [[ScenicListViewController  alloc]initWithTitle:@"景点门票" style:NavBarBtnStyleOnlyBackBtn];
    
    listCtrl.sModelAr =  array;
    
    listCtrl.isAll =  listIsAll;
    
    listCtrl.page = firstPage;
    
    [navdelegate.navigationController  pushViewController:listCtrl animated:YES];
    
    [listCtrl  release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
