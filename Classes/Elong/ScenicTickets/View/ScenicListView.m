//
//  ScenicListView.m
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicListView.h"
#import "SearchBarView.h"
#import "ScenicListCell.h"
#import  "UIView+Addtions.h"
#import "JScenicListRequest.h"
#import "ScenicTicketsPublic.h"
#import "SceneryList.h"
#import "ScenicDetail.h"
#import "ScenicAreaDetailViewController.h"
#import "ScenicListViewController.h"

@implementation ScenicListView
@synthesize listTable;
- (void)dealloc
{
    [listTable release];
    [_sAr  release];
    [jReq  release];
   [modelAr  release];
    if (listUtil) {
        [listUtil  cancel];
        SFRelease(listUtil);
    }
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  modelAr:(NSArray *)array
{
    self =  [super  initWithFrame:frame];
    if (self) {
        
      //  modelAr = [[NSMutableArray  alloc]initWithArray:array];
        
        self.sAr = array;
        
      //  [self  parseModel];
        
        jReq = [[JScenicListRequest alloc]init];
        
         [self addTableView];
       
        [self addMapFooterView];
        
        [self  addSearchBar];
        
     
        
    }
    return self;
}

- (void) parseModel{
    
}

- (void)setSAr:(NSArray *)sAr
{
    if (_sAr != sAr)
    {
        [_sAr release];
        _sAr = [sAr retain];
    }

}

- (void)addTableView
{
    listTable = [[UITableView  alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, MAINCONTENTHEIGHT-45) style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource =  self;
    [self addSubview:listTable];
    
}
- (void) addSearchBar
{
    SearchBarView  *searchBar = [[SearchBarView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"输入城市/景点名";
    [self addSubview:searchBar];
    [searchBar  release];
    
}

-(void)addMapFooterView{
    //
	mapFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, self.height - 45, 320, 45)];
    mapFooterView.delegate = self;
    //推荐
    BaseBottomBarItem *recommendItem = [[BaseBottomBarItem alloc] initWithTitle:@"艺龙推荐"
                                                                      titleFont:[UIFont systemFontOfSize:12.0f]
                                                                          image:@"basebar_location.png"
                                                                highligtedImage:@"basebar_location_h.png"];
    
    //goCenter
    BaseBottomBarItem *salesItem = [[BaseBottomBarItem alloc] initWithTitle:@"人气指数"
                                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                                      image:@"basebar_map.png"
                                                            highligtedImage:@"basebar_map_h.png"];
    
    //筛选
    BaseBottomBarItem  *mapFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                                       titleFont:[UIFont systemFontOfSize:12.0f]
                                                                           image:@"basebar_filter.png" highligtedImage:@"basebar_filter_h.png"];
    
    
    
    
    
	//switchViews
    NSMutableArray *itemArray = [NSMutableArray array];
    [itemArray addObject:recommendItem];
    recommendItem.allowRepeat = YES;
    recommendItem.autoReverse = YES;
    [recommendItem release];
    
    [itemArray addObject:salesItem];
    salesItem.allowRepeat = YES;
    salesItem.autoReverse = YES;
    [salesItem release];
       
    [itemArray addObject:mapFilterItem];
    mapFilterItem.allowRepeat = YES;
    mapFilterItem.autoReverse = YES;
    [mapFilterItem release];
    
    
    mapFooterView.baseBottomBarItems = itemArray;
    
	[self  insertSubview:mapFooterView aboveSubview:listTable];
	[mapFooterView release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sAr.count;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str = @"cell";
    ScenicListCell  *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell  =[[[NSBundle  mainBundle]loadNibNamed:@"ScenicListCell" owner:self options:Nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = [self.sAr  safeObjectAtIndex:indexPath.row];
    
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



- (void)mapClick
{
    
}
- (void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index
{
    if ([self.delegate  respondsToSelector:@selector(didSelectIndex:andBottomBar:)])
    {
        [self.delegate  didSelectIndex:index andBottomBar:bar];
    }
}



- (NSInteger) getPage
{
   
    return page;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    //当个数满了，不再加载更多
    
    if (self.isAll)
    {
        return;
    }
        // 当还有更多酒店时在滑到倒数第5行时发起请求
        NSArray *array = [listTable visibleCells];
        NSIndexPath *cellIndex = [listTable indexPathForCell:[array lastObject]];
        
        if (cellIndex.row >= [modelAr  count] - 5)
        {
           
             page = modelAr.count/ScenicPageSize + 1;

            if ([self.delegate  respondsToSelector:@selector(didScrollToPageDelegate:)])
            {
                [self.delegate  didScrollToPageDelegate:page];
            }
          
        }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SceneryList *model = [self.sAr safeObjectAtIndex:indexPath.row];
    NSString *url = [ScenicDetail getScenicDetailRequestByGivenListModel:model];
    if (STRINGHASVALUE(url)) {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    
    
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    //赋值
    
    NSIndexPath *path = [listTable indexPathForSelectedRow];
    SceneryList *model = [self.sAr objectAtIndex:path.row];
    ScenicDetail *detail = [[ScenicDetail alloc] init];
    [detail convertObjectFromGievnDictionary:root relySelf:YES];
    detail.policyList = (NSArray *)[ScenicDetail convertThePricePolicy:detail.policyList];
    detail.nearbySceneryList = (NSArray *)[ScenicDetail convertTheNearByPoints:detail.nearbySceneryList];
    
    ScenicAreaDetailViewController *detailVC = [[ScenicAreaDetailViewController alloc] initWithTitle:model.sceneryName style:NavBarBtnStyleOnlyBackBtn];
    detailVC.type = [model.bookFlag intValue] + 100;
    detailVC.scenerySummary = model.scenerySummary;
    detailVC.mainImageURL = model.imgPath;
    detailVC.scenicDetail = detail;
    [detail release];

    UIViewController *controller = nil;
    if (_delegate && [_delegate isKindOfClass:[ScenicListViewController class]]) {
        controller = (ScenicListViewController *)_delegate;
    }
    if (controller) {
        [controller.navigationController pushViewController:detailVC animated:YES];
    }
    [detailVC release];
    
}

@end
