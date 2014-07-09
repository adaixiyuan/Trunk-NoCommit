//
//  ScenicHomeViewController.m
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicHomeViewController.h"
#import "HotScenicView.h"
#import "SearchBarView.h"
#import "ScenicSearchListViewController.h"
#import "ScenicListViewController.h"
#import "HomeCityCell.h"
#import "HomeThemeCell.h"
#import "HotModel.h"
#import "JScenicListRequest.h"
#import "ScenicTicketsPublic.h"
#import "SceneryList.h"
@interface ScenicHomeViewController ()

@end

@implementation ScenicHomeViewController
- (void)dealloc
{
    [homeTable release];
    if (homeUtil) {
        [homeUtil  cancel];
        SFRelease(homeUtil);
    }
    [modelDic  release];
    [textDic release];
    [allTheme  release];
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
    modelDic = [[NSMutableDictionary alloc]init];
    textDic = [[NSMutableDictionary alloc]init];
    allTheme = [[NSMutableArray alloc]init];
    SearchBarView  *searchBar = [[SearchBarView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"输入城市/景点名";
    [self.view  addSubview:searchBar];
    [searchBar  release];
    
    
    
    
      homeTable = [[UITableView  alloc]initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44) style:UITableViewStylePlain];
    homeTable.backgroundView = nil;
    homeTable.backgroundColor = [UIColor clearColor];
    homeTable.delegate =  self;
    homeTable.dataSource =  self;
    [self.view addSubview:homeTable];
    
    [self  requestUrl];
//    
//    HotScenicView  *scenicView = [[HotScenicView  alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 44) withHorizontalCount:4 withVerticalCount:1 withTextAr:ar  andFinish:^(UIButton *bt, int i)
//     {
//         
//         ScenicListViewController  *listCtrl = [[ScenicListViewController  alloc]initWithTitle:@"景点门票" style:NavBarBtnStyleOnlyBackBtn];
//         
//         [replaceSelf.navigationController  pushViewController:listCtrl animated:YES];
//         
//         [listCtrl  release];
//         
//    }];
    
//    [self.view addSubview:scenicView];
//    
//    [scenicView release];
    
   
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == HOTCITY_SECTION) {
        return 0;
    }
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HOTCITY_SECTION)
    {
        return 150;
    }
    else
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str1= @"cell1";
    static  NSString  *str2 = @"cell2";
    static  NSString  *str3 = @"cell3";
    HomeCityCell  *cell1 = [tableView dequeueReusableCellWithIdentifier:str1];
    HomeThemeCell  *cell2 = [tableView dequeueReusableCellWithIdentifier:str2];
    HomeThemeCell  *cell3 = [tableView dequeueReusableCellWithIdentifier:str3];
    if (indexPath.section ==  HOTCITY_SECTION)
    {
        if (!cell1)
        {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:@"HomeCityCell" owner:self options:nil]lastObject];
        }
          [cell1  setDelegate:self];
         cell1.textAr = [textDic  safeObjectForKey:@"city"];
        cell1.modelAr = [modelDic  objectForKey:@"city"];
      
        return cell1;
    }
    
    if (indexPath.section == HOTSCENIC_SECTION)
    {
        if (!cell2)
        {
            cell2 = [[[HomeThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2]autorelease];
            cell2.delegate = self;
            
        }
        if ([[textDic allKeys] count] > 0)
        {
            cell2.textAr = [textDic  objectForKey:@"scenic"];
        }
        return cell2;
    }
   else
    {
        if (!cell3)
        {
            cell3 = [[[HomeThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3]autorelease];
            cell3.delegate = self;
            
        }
        if ([[textDic  allKeys]count] > 0)
        {
            if ([textDic  objectForKey:@"theme"]) {
                cell3.textAr = [textDic  objectForKey:@"theme"];
            }
            
        }
        return cell3;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)requestUrl
{
    if (homeUtil) {
        [homeUtil  cancel];
        SFRelease(homeUtil);
    }
        NSDictionary  *dic = [NSDictionary  dictionaryWithObject:@"北京" forKey:@"city"];
        NSString  *jstr = [dic JSONString];
        NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"ticket/getGeneralInfo" andParam:jstr];
        [HttpUtil  requestURL:url postContent:Nil startLoading:NO EndLoading:NO delegate:self];
    

}

//解析首页的model
- (void) parseModel:(NSDictionary  *)root
{
   NSMutableArray *cityAr= [NSMutableArray array];
    NSMutableArray  *scenicAr = [NSMutableArray array];
    NSMutableArray  *themeAr = [NSMutableArray array];
    NSMutableArray  *gradeAr = [NSMutableArray array];
    
    NSMutableArray  *cityText = [NSMutableArray array];
    NSMutableArray  *scenicText = [NSMutableArray array];
    NSMutableArray  *themeText = [NSMutableArray  array];
    NSMutableArray  *gradeText = [NSMutableArray  array];
    for (NSDictionary  *dic in  [root  objectForKey:@"hotCityList"] )
    {
        HotCityList  *city = [[HotCityList alloc]initWithDataDic:dic];
        [cityAr addObject:city];
        [cityText  addObject:city.cityName];
        [city release];
    }
    [modelDic setObject:cityAr forKey:@"city" ];
    [textDic  setObject:cityText forKey:@"city"];
    for (NSDictionary *dic in [root  objectForKey:@"hotSceneryList"] )
    {
        HotSceneryList  *scenic = [[HotSceneryList alloc]initWithDataDic:dic];
        [scenicAr addObject:scenic];
        [scenicText  addObject:scenic.sceneryName];
        [scenic  release];
    }
    [modelDic  setObject:scenicAr forKey:@"scenic"];
    [textDic  setObject:scenicText forKey:@"scenic"];
    for  (NSDictionary *dic in  [root objectForKey:@"hotThemeList"] )
    {
        ThemeList  *theme = [[ThemeList alloc]initWithDataDic:dic];
        [themeAr addObject:theme];
        [themeText  addObject:theme.themeName];
        [theme release];
    }
    [modelDic  setObject:themeAr forKey:@"theme"];
    [textDic  setObject:themeText forKey:@"theme"];
    for (NSDictionary *dic in [root  objectForKey:@"themeList"] )
    {
        ThemeList  *theme = [[ThemeList alloc]initWithDataDic:dic];
        [allTheme addObject:theme];
        [theme  release];
    }
    
    for  (NSDictionary  *dic in [root objectForKey:@"gradeList"] )
    {
        GradeList  *grade = [[GradeList  alloc]initWithDataDic:dic];
        [gradeAr addObject:grade];
        [gradeText  addObject:grade.gradeName];
        [grade release];
    }
    [modelDic  setObject:gradeAr forKey:@"grade"];
    [textDic  setObject:gradeText forKey:@"grade"];
}


- (void)requestListUrl:(int )i  andSection:(NSInteger )section
{
    if (homeUtil) {
        [homeUtil  cancel];
        SFRelease(homeUtil);
    }
     JScenicListRequest  *request = [[JScenicListRequest  alloc]initWithDataDic:nil];
    homeUtil = [[HttpUtil alloc]init];
    
    if (section == 0)
    {   NSArray  *cityAr = [modelDic  safeObjectForKey:@"city"];
         HotCityList  *city = [cityAr safeObjectAtIndex:i];
        city.cityId = [NSNumber numberWithInt:36];//调试
        request.cityId = city.cityId;
        request.isCitySearch = [NSNumber numberWithInt:1];
    }else if (section == 1)
    {
//        NSArray  *senicAr = [modelDic  safeObjectForKey:@"scenic"];
//        HotSceneryList  *scenry =[senicAr  safeObjectAtIndex:i];
        
        
    }else if  (section == 2)
    {
        NSArray  *themeAr = [modelDic  safeObjectForKey:@"theme"];
        ThemeList  *theme = [themeAr  safeObjectAtIndex:i];
        //theme.themeId = [NSNumber numberWithInt:11];
        request.themeId = theme.themeId;
        
    }
    request.type = [NSNumber numberWithInt:1];
    request.page = [NSNumber  numberWithInt:1];
    request.pageSize = [NSNumber  numberWithInt:ScenicPageSize];
  
    request.radius = [NSNumber  numberWithInt:ScenicRadius];
    NSString  *url = [request  getListUrl];
    [homeUtil  requestWithURLString:url Content:Nil Delegate:self];
    [request  release];
    
}

//解析列表里面第一次请求的model
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

#pragma mark -searchbardDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    ScenicSearchListViewController  *searchList = [[ScenicSearchListViewController  alloc]initWithTitle:@"景点搜索" style:NavBarBtnStyleOnlyBackBtn];
    [self.navigationController  pushViewController:searchList animated:YES];
    [searchList  release];
    return YES;
}

#pragma mark - httpdelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils  checkJsonIsError:root])
    {
        return;
    }
    if (util == homeUtil)
    {
        
        if (  [[root objectForKey:@"page"]  intValue] >= [[root  objectForKey:@"totalPage"] intValue] )
        {
            listIsAll = YES;
        }
        firstPage =  [[root  objectForKey:@"page"]  intValue];
        
        NSArray  *ar = [root  safeObjectForKey:@"sceneryList"];
        
        [self parseListModel:ar];
        
    }else
    {
        [self parseModel:root];
        [homeTable  reloadData];
    }
    
}
#pragma mark - buttondelegate

- (void)finishClick:(UIButton *)button withIndex:(int)index
{

    NSLog(@"%@",button.superview);
    
    if ([[self  buttonSuperViewGet:button] isKindOfClass:[HomeCityCell  class]])
    {
        [self  requestListUrl:index-100 andSection:0];
    }else
    {
        HomeCityCell  *cell = (HomeCityCell *)[self  buttonSuperViewGet:button];
        NSIndexPath  *indexpath = [homeTable  indexPathForCell:cell];
        [self  requestListUrl:index andSection:indexpath.section];
    }
//    if ([button.superview  isKindOfClass:[HotScenicView class]])
//    {
//        HotScenicView  *scenic = (HotScenicView *)button.superview;
//        NSLog(@"%@",scenic.superview.superview);
//        if ([scenic.superview.superview  isKindOfClass:[HomeThemeCell class]])
//        {
//            HomeThemeCell  *cell = (HomeThemeCell  *)scenic.superview.superview;
//            NSIndexPath  *index =[homeTable  indexPathForCell:cell];
//            [self requestListUrl:index andSection:index.section];
//        }
//
//    }
}

- (UIView  *) buttonSuperViewGet:(UIView *)sview
{
    UIView  *next;
    next = sview.superview;
    while (next!= nil)
    {
        if ([next isKindOfClass:[HomeThemeCell  class]] || [next isKindOfClass:[HomeCityCell  class]])
        {
            return next;
        }
        next = next.superview;
    }
    return nil;
}

#pragma mark - backhome
- (void)back
{
    [PublicMethods closeSesameInView:self.navigationController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
