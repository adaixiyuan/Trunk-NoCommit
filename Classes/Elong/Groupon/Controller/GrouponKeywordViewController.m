//
//  GrouponKeywordViewController.m
//  ElongClient
//
//  Created by Dawn on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponKeywordViewController.h"
#import "GrouponKeywordListRequest.h"
#import "GListRequest.h"
#import "GrouponHomeViewController.h"
#import "SearchBarView.h"

static int cell_height = 37;

@interface GrouponKeywordViewController ()
@property (nonatomic,retain) NSMutableArray *historyArray;

@property (nonatomic,retain) NSArray *filterArray;
@end

@implementation GrouponKeywordViewController
@synthesize searchBar;
@synthesize searchCity = _searchCity;
@synthesize historyArray;
@synthesize searchcontent = _searchcontent;
@synthesize viewController;
@synthesize m_key;
@synthesize delegate;
@synthesize withNavHidden;
@synthesize searchList;
@synthesize searchBarIsShow;

- (void) dealloc{
    self.searchCity = nil;
    self.historyArray = nil;
    self.searchcontent = nil;
    self.m_key = nil;
    self.filterArray = nil;
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.searchCity  = nil;
	self.historyArray = nil;
    [searchBar release];
    [searchList release];
    [super dealloc];
}

- (id) initWithSearchCity:(NSString *)city contentsController:(UIViewController *)vc{
    if (self = [super init]) {
        self.viewController = vc;
        self.withNavHidden = YES;
        
        suggestHasUpdated = NO;
        
        // 关键词搜索城市
        self.searchCity = city;
        
        
        // 搜索框
        searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchBar.placeholder   = @"酒店名、商圈、行政区等";
        searchBar.delegate      = self;
        
        searchList = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44) style:UITableViewStylePlain];
        searchList.backgroundColor = [UIColor whiteColor];
        searchList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 注册消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshByNoti:) name:NOTI_KEYWORD_UPDATE object:nil];
    }
    return self;
}

- (void) setSearchCity:(NSString *)searchCity{
    [_searchCity release];
    _searchCity = searchCity;
    [_searchCity retain];
    
    // 搜索历史
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.historyArray = array;
    [array release];
    
    // 加载搜索历史
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSMutableArray *temphistoryarray = [NSMutableArray arrayWithArray:[data objectForKey:GROUPONSEARCHHISTORIES]];
    
    for (NSDictionary* dict in temphistoryarray) {
        NSString *cityname = [dict safeObjectForKey:@"City"];
        if ([cityname isEqualToString:self.searchCity]) {
            [self.historyArray addObject:dict];
        }
    }
    
}

- (void) setSearchcontent:(NSString *)searchcontent{
    [_searchcontent release];
    _searchcontent = searchcontent;
    [_searchcontent retain];
}

#pragma mark -
#pragma mark Private Method

// ???
- (void)refreshByNoti:(NSNotification *)noti {
	NSString *keyword = (NSString *)[noti object];
    NSString *searchWord = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	if ([keyword isEqualToString:searchWord]) {
		// 如果是当前正在搜索的关键字，则对列表进行刷新
		[self refreshAddressListByKeyword:keyword];
	}
}



// 清空搜索结果
- (void)cancelSearchCondition {
    m_key = nil;
	
    GListRequest *request = [GListRequest shared];
    request.aioCondition = nil;
	
}

//
- (void)refreshAddressListByKeyword:(NSString *)key {
	// 更新地址列表
    self.m_key = key;
	if (key) {
        GrouponKeywordListRequest *hklReq = [GrouponKeywordListRequest shared];
        // 从本地查询cityid
        hklReq.currentCityID = [PublicMethods getCityIDWithCity:self.searchCity];
        
        NSArray *addressArray;
		// 无搜索字段时
        if ([key isEqualToString:@" "]) {
            addressArray = self.historyArray;
        }
		// 有搜索字段时
        else {
            addressArray = [hklReq getAddressListByKeyword:[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        
		if ([addressArray isKindOfClass:[NSArray class]]) {
			// 已请求过的情况
			self.filterArray = addressArray;
			[searchList reloadData];
		}
		else {
			// 未请求时，重新请求
			NSString *newkey =  [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[hklReq requestForKeyword:newkey];
            suggestHasUpdated = YES;
		}
	}
	else {
		// 没有搜索字段时
		self.filterArray = [NSArray array];
		[searchList reloadData];
	}
}

// 返回keyword类型
- (NSString *) keywordName:(NSDictionary *)filter{
    NSInteger type = [[filter safeObjectForKey:@"HitType"] intValue];
    switch (type) {
        case 2:{        // 2：商圈
            return @"商圈    ";
            break;
        }
        case 3:{        // 3：行政区
            return @"行政区    ";
            break;
        }
        case 4:{        // 4：标签
            return @"";
            break;
        }
        case 5:{        // 5：产品名
            return @"";
            break;
        }
        case 6:{        // 6：酒店名
            return @"";
            break;
        }
        case 7:{        // 7：酒店地址
            return @"";
            break;
        }
        case 8:{       // 8：星级
            return @"";
            break;
        }
        default:
            return @"";
            break;
    }
}

// 设定搜索条件
- (void) keywordFilter:(NSDictionary *)filter{
    GListRequest *request = [GListRequest shared];
    request.aioCondition = [NSMutableDictionary dictionaryWithCapacity:0];

    switch ([[filter safeObjectForKey:@"HitType"] intValue]) {
        case 2:{        // 2：商圈
            [request.aioCondition safeSetObject:[filter safeObjectForKey:@"Id"] forKey:@"BizSection"];
            [request.aioCondition safeSetObject:[filter safeObjectForKey:@"Name"] forKey:@"BizSectionName"];
            break;
        }
        case 3:{        // 3：行政区
            [request.aioCondition safeSetObject:[filter safeObjectForKey:@"Id"] forKey:@"District"];
            [request.aioCondition safeSetObject:[filter safeObjectForKey:@"Name"] forKey:@"DistrictName"];
            break;
        }
        default:{
            [request.aioCondition safeSetObject:[filter safeObjectForKey:@"Name"] forKey:@"Keyword"];
            break;
        }
    }
}

// 清空搜索历史
- (void)deleteallcell:(id)sender {
    [self.historyArray removeAllObjects];
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray* hotelsearchkeywordsarray = [[NSMutableArray alloc] initWithArray:[data objectForKey:GROUPONSEARCHHISTORIES]];
    NSMutableArray* hotelsearchkeywordsarraytemp = [[NSMutableArray alloc] initWithArray:[data objectForKey:GROUPONSEARCHHISTORIES]];
    
    for (NSDictionary* dict in hotelsearchkeywordsarray) {
        NSString *cityname = [dict safeObjectForKey:@"City"];
        if ([cityname isEqualToString:self.searchCity]) {
            [hotelsearchkeywordsarraytemp removeObject:dict];
        }
    }
    
    [data setValue:hotelsearchkeywordsarraytemp forKey:GROUPONSEARCHHISTORIES];
    [hotelsearchkeywordsarray release];
    [hotelsearchkeywordsarraytemp release];
    [data synchronize];
    
    [searchList reloadData];
    
    self.searchBar.text = @"";
}

#pragma mark -
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (![m_key isEqualToString:@" "] && m_key) {
		if ([self.filterArray count] > 0) {
			if ([[[self.filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP] isEqualToString:self.searchBar.text]) {
				// 不重复显示联想与输入重复的内容
				return [self.filterArray count];
			}
			else {
				return [self.filterArray count] + 1;
			}
		}
		else {
			return 1;
		}
    }
    else {
        if (self.historyArray==nil || self.historyArray.count == 0) {
            return 0;
        }else{
            return [self.historyArray count]+1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([searchBar.text isEqualToString:@" "] && indexPath.row == [self.historyArray count]) {
        return cell_height+20;
    }
    return cell_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectOffset(view.frame, -1, 0)];
    [view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"     搜索历史:";
    [label release];
    if (([m_key isEqualToString:@" "] || m_key == nil) && [self.historyArray count])
        return view;
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (([m_key isEqualToString:@" "] || m_key == nil)  && [self.historyArray count])
        return 30;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
	static NSString *SelectTableCellKeyex = @"SelectTableCellKeyex";
    CommonCell *cell ;
	
	if ([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        
        if (indexPath.row == [self.historyArray count]){
            cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKeyex];
            if (!cell) {
                cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKeyex
                                                        height:cell_height+20
                                                         style:CommonCellStyleRightArrow] autorelease];
                
                UIImageView *dashview = (UIImageView*)[cell.contentView viewWithTag:101];
                dashview.hidden = YES;
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(92, 2, 136, 30);
                button.tag = 103;
                [button addTarget:self action:@selector(deleteallcell:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
                [button setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
                [button setTitle:@"清除搜索历史" forState:UIControlStateNormal];
                [cell addSubview:button];
                cell.clipsToBounds = NO;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.cellImage.hidden = YES;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
                
                cell.detailTextLabel.textColor = RGBACOLOR(103, 103, 103, 103);
                cell.detailTextLabel.highlightedTextColor = RGBACOLOR(103, 103, 103, 103);
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
                cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
            }
            
        }
        else{
            cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
            if (!cell) {
                cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey
                                                        height:cell_height
                                                         style:CommonCellStyleRightArrow] autorelease];
                
                cell.cellImage.hidden = YES;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
                cell.detailTextLabel.textColor = RGBACOLOR(103, 103, 103, 103);
                cell.detailTextLabel.highlightedTextColor = RGBACOLOR(103, 103, 103, 103);
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
                cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
            }
            
        }
        
        
        if (indexPath.row == [self.historyArray count]) {
            
            UIButton *button = (UIButton*)[cell viewWithTag:103];
            button.hidden = NO;
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
        if (indexPath.row != [self.historyArray count]){
            UIButton *button = (UIButton*)[cell viewWithTag:103];
            button.hidden = NO;
            cell.textLabel.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0];
            NSDictionary *dict = [self.historyArray safeObjectAtIndex:indexPath.row];
            if ([dict safeObjectForKey:@"HitType"] && [dict safeObjectForKey:@"HitType"]!=[NSNull null]) {
                cell.detailTextLabel.text = [self keywordName:dict];
            }else{
                cell.detailTextLabel.text = @"";
            }
            cell.textLabel.text = [dict safeObjectForKey:NAME_RESP];
        }
	}
    else{
        cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
		if (!cell) {
			cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey
													height:cell_height
													 style:CommonCellStyleRightArrow] autorelease];
			cell.cellImage.hidden = YES;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.detailTextLabel.textColor = RGBACOLOR(103, 103, 103, 103);
            cell.detailTextLabel.highlightedTextColor = RGBACOLOR(103, 103, 103, 103);
            cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
            cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
		}
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.hidden = YES;
            }
        }
        
        if (indexPath.row == 0) {
            // 第一行显示用户当前搜索内容
            cell.textLabel.text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = @"";
        }
        else {
            if ([[[self.filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP] isEqualToString:self.searchBar.text]) {
                // 不重复显示联想与输入重复的内容
                NSDictionary *dict = [self.filterArray safeObjectAtIndex:indexPath.row];
                cell.textLabel.text = [dict safeObjectForKey:NAME_RESP];
                
                if ([dict safeObjectForKey:@"HitType"] && [dict safeObjectForKey:@"HitType"]!=[NSNull null]) {
                    cell.detailTextLabel.text = [self keywordName:dict];
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
            else {
                NSDictionary *dict = [self.filterArray safeObjectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [dict safeObjectForKey:NAME_RESP];
                
                if ([dict safeObjectForKey:@"HitType"] && [dict safeObjectForKey:@"HitType"]!=[NSNull null]) {
                    cell.detailTextLabel.text = [self keywordName:dict];
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
        }
        
    }
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 240, cell.textLabel.frame.size.height);
	return cell;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
        self.searchBar.showsCancelButton = YES;
        
        for(id cc in [self.searchBar subviews]){
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)cc;
                btn.enabled = YES;
            }
        }
    }
}

#pragma mark -
#pragma mark 用户点击搜索建议数据

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[GrouponHomeViewController class]]) {
                GrouponHomeViewController *grouponHomeVC = (GrouponHomeViewController *)self.viewController;
                grouponHomeVC.favBtn.hidden = NO;
                
                ((UIButton *)grouponHomeVC.navigationItem.titleView).enabled = YES;
            }
        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
    
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];
	
	if (![m_key isEqualToString:@" "] && ![self.filterArray isEqualToArray:self.historyArray]) {
		NSString *searchStr = nil;
        NSInteger hitType = 0;
        if ([self.filterArray count] > 0 && [[[self.filterArray safeObjectAtIndex:0] safeObjectForKey:NAME_RESP] isEqualToString:self.searchBar.text]) {
            // 联想出的数据与搜索关键字一样
            NSDictionary *dict = [self.filterArray safeObjectAtIndex:indexPath.row];
            searchStr = [dict safeObjectForKey:NAME_RESP];
            hitType = [[dict safeObjectForKey:@"HitType"] intValue];
            
            [self keywordFilter:dict];
            
            // 保存搜索历史
            [self saveSearchHistory:dict];
        }
        else if ([self.filterArray count] > 0 && indexPath.row != 0) {
            // 有联想出的数据时,且不是第一行时，用联想数据
            NSDictionary *dict = [self.filterArray safeObjectAtIndex:indexPath.row - 1];
            searchStr = [dict safeObjectForKey:NAME_RESP];
            [self keywordFilter:dict];
            
             hitType = [[dict safeObjectForKey:@"HitType"] intValue];
            // 保存搜索历史
            [self saveSearchHistory:dict];
        }
        else {
            // 用户自己输入的数据
            searchStr = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //
            NSString *searchName = [NSString stringWithFormat:@"%@",searchStr];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:searchName, @"Name", NUMBER(0), @"HitType", nil];
            [self keywordFilter:dict];
            
             hitType = [[dict safeObjectForKey:@"HitType"] intValue];
            
            // 保存搜索历史
            [self saveSearchHistory:dict];
        }
        
        
        if ([delegate respondsToSelector:@selector(grouponKeywordVC:didGetKeyword:hitType:)]) {
            [delegate grouponKeywordVC:self didGetKeyword:searchStr hitType:hitType];
        }
       

	}else{
		if (indexPath.row == [self.historyArray count]) {
            return;
        }
        NSString *searchStr = nil;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.filterArray safeObjectAtIndex:indexPath.row]];
        NSInteger hitType = 0;
        searchStr = [dict safeObjectForKey:NAME_RESP];
        if ([dict safeObjectForKey:@"HitType"] && [dict safeObjectForKey:@"HitType"]!=[NSNull null]) {
            hitType = [[dict safeObjectForKey:@"HitType"] intValue];
        }else{
            [dict safeSetObject:NUMBER(0) forKey:@"HitType"];
        }
        
        [self keywordFilter:dict];
        
        if ([delegate respondsToSelector:@selector(grouponKeywordVC:didGetKeyword:hitType:)]) {
            [delegate grouponKeywordVC:self didGetKeyword:searchStr hitType:hitType];
        }
	}
}

- (void) saveSearchHistory:(NSDictionary *)dict_{

    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSMutableArray* hotelsearchkeywordsarray = [[NSMutableArray alloc] initWithArray:[data objectForKey:GROUPONSEARCHHISTORIES]];
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict_];
    [dict safeSetObject:self.searchCity forKey:@"City"];
        
    if (![hotelsearchkeywordsarray containsObject:dict]) {
        [hotelsearchkeywordsarray insertObject:dict atIndex:0];
        while (hotelsearchkeywordsarray.count > 3) {
            [hotelsearchkeywordsarray removeLastObject];
        }
        [data setValue:hotelsearchkeywordsarray forKey:GROUPONSEARCHHISTORIES];
        [data synchronize];
    }
    
    [hotelsearchkeywordsarray release];
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar_{
    
   
    // 状态设置为显示
    searchBarIsShow = YES;
    if ([delegate respondsToSelector:@selector(grouponKeywordVCDidBeginEdit:)]) {
        [delegate grouponKeywordVCDidBeginEdit:self];
    }
    
    searchList.delegate = self;
    searchList.dataSource = self;
    [self setSearchCity:[NSString stringWithFormat:@"%@",self.searchCity]];
    
    self.filterArray = nil;
    
    [searchBar setShowsCancelButton:YES animated:YES];
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[GrouponHomeViewController class]]) {
                GrouponHomeViewController *grouponHomeVC = (GrouponHomeViewController *)self.viewController;
                grouponHomeVC.favBtn.hidden = YES;
                
                ((UIButton *)grouponHomeVC.navigationItem.titleView).enabled = NO;
            }
        }else{
            [self.viewController.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    
    
    if (searchBar.superview && !searchList.superview) {
        [self.viewController.view addSubview:searchList];
        searchList.alpha = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 1;
    }];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_{
    NSString *searchStr = searchBar.text;
	if (STRINGHASVALUE(searchStr)) {
		searchBar.text = searchStr;				// 启动搜索表格
		[self refreshAddressListByKeyword:searchStr];
	}
    NSString *tempstring = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.historyArray count] && [tempstring length] == 0){
        [self refreshAddressListByKeyword:@" "];	// 启动搜索表格
    }else{
        [searchList reloadData];
    }
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];		// 把tableview撑高
	footView.backgroundColor = [UIColor clearColor];
	searchList.tableFooterView = footView;
	[footView release];
	
	searchList.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *tempstring = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([tempstring length]>0) {
        [self refreshAddressListByKeyword:tempstring];
    }
	if ([tempstring length] == 0) {
        //        return YES;
        [self refreshAddressListByKeyword:@" "];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar_ {
    
    
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[GrouponHomeViewController class]]) {
                GrouponHomeViewController *grouponHomeVC = (GrouponHomeViewController *)self.viewController;
                grouponHomeVC.favBtn.hidden = NO;
                ((UIButton *)grouponHomeVC.navigationItem.titleView).enabled = YES;
            }
            
        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];
    
    if ([delegate respondsToSelector:@selector(grouponKeywordVC:cancelWithContent:)]) {
        [delegate grouponKeywordVC:self cancelWithContent:[NSString stringWithFormat:@"%@",searchBar_.text]];
    }
    //searchBar_.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
   
    
    // 状态设置为隐藏
    searchBarIsShow = NO;
    
    NSString *tempstring = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempstring = [tempstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tempstring length] == 0 ) {
        return;
    }
	
    
    // 用户自己输入的数据
    NSString *searchName = [NSString stringWithFormat:@"%@",tempstring];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:searchName, @"Name", NUMBER(0), @"HitType", nil];
    [self keywordFilter:dict];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if (self.withNavHidden) {
        if (IOSVersion_7) {
            if ([self.viewController isKindOfClass:[GrouponHomeViewController class]]) {
                GrouponHomeViewController *grouponHomeVC = (GrouponHomeViewController *)self.viewController;
                grouponHomeVC.favBtn.hidden = NO;
                
                ((UIButton *)grouponHomeVC.navigationItem.titleView).enabled = YES;
            }
            
        }else{
            [self.viewController.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchList.alpha = 0;
    } completion:^(BOOL finished) {
        [searchList removeFromSuperview];
    }];
    
    [searchBar resignFirstResponder];
    
    if ([delegate respondsToSelector:@selector(grouponKeywordVC:didGetKeyword:hitType:)]) {
        [delegate grouponKeywordVC:self didGetKeyword:tempstring hitType:0];
    }
    
    // 保存搜索历史
    [self saveSearchHistory:dict];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	NSString *searchStr = controller.searchBar.text;
	if (!STRINGHASVALUE(searchStr)) {
		[self cancelSearchCondition];
	}
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
	
}


@end
