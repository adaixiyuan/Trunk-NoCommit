//
//  RateList.m
//  ElongClient
//
//  Created by Jian.zhao on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RateList.h"
#import "RateCell.h"
#import "pinyin.h"
#import "SearchBarView.h"

#define DEFAULT_ORIGIN_EXCHANGE_RATE @"ORIGIN_EXCHANGE_RATE"//原始的汇率数据
#define SEARCH_DEFAULT @"SEARCH_DEFAULT"//保存在缓存中的点击历史(Only One)

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface RateList ()

@end

@implementation RateList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _historyModel = [[RateModel   alloc] init];
        _searchResults = [[NSMutableArray alloc] init];
        _historyArray = [[NSMutableArray alloc] init];
        _sectionArray = [[NSMutableArray alloc] init];
        _commonArray  = [[NSMutableArray alloc] init];
        
        [self readTheCacheData];
        
    }
    return self;
}

-(void)readTheCacheData{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_ORIGIN_EXCHANGE_RATE];
    _dataSource = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    NSData *history = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DEFAULT];
    if (NULL == history || nil == history) {
        //默认保存人民币\无默认
        //[self.historyArray addObject:[self.dataSource objectAtIndex:0]];//默认显示一个
        
    }else{
        self.historyArray = [NSKeyedUnarchiver unarchiveObjectWithData:history];
    }
    
    //设置sectionArray
    for (int i = 0; i<27; i++) {
        [self.sectionArray addObject:[NSMutableArray array]];
    }
    
    for (RateModel *model in self.dataSource) {
        NSString *sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([[self getCountryNameFromTheRateModel:model] characterAtIndex:0])] uppercaseString];
        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
		if (firstLetter != NSNotFound)
		{
			[[self.sectionArray objectAtIndex:firstLetter] addObject:model];
		}
    }
    
    //设置CommonArray 5个 分别为:人民币、美元、韩元、泰铢、港币
    
    for (RateModel *model  in self.dataSource) {
        if ([model.simplyName isEqualToString:@"CNY"] || [model.simplyName isEqualToString:@"KRW"]
            || [model.simplyName isEqualToString:@"USD"] || [model.simplyName isEqualToString:@"THB"]
            || [model.simplyName isEqualToString:@"HKD"]) {
            [self.commonArray addObject:model];
        }
    }
}

-(void)dealloc{
    SFRelease(_commonArray);
    SFRelease(_sectionArray);
    SFRelease(_historyArray);
    SFRelease(_searchResults);
    SFRelease(_historyModel);
    SFRelease(_dataSource);
    [_displayController release];
    [_defaultTableView release];
    [super dealloc];
}

-(void)back{

    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(back)];
    
    UISearchBar *searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
    searchBar.placeholder = @"国家的关键字";
    
    CGFloat tableHeight = MAINCONTENTHEIGHT-44;
    self.defaultTableView = [[[UITableView alloc]
                              initWithFrame:CGRectMake(0, 0 + searchBar.frame.size.height, self.view.bounds.size.width, tableHeight)
                              style:UITableViewStylePlain] autorelease];
	
	_defaultTableView.backgroundColor = [UIColor whiteColor];
	_defaultTableView.delegate=self;
	_defaultTableView.dataSource=self;
	_defaultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _defaultTableView.showsVerticalScrollIndicator = NO;
    if (IOSVersion_7) {
        _defaultTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
	   
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [_displayController setDelegate:self];
    [_displayController setSearchResultsDataSource:self];
    [_displayController setSearchResultsDelegate:self];
	_displayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[searchBar release];
	
	[self.view addSubview:_displayController.searchBar];
	[self.view addSubview:_defaultTableView];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark
#pragma  mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView == _defaultTableView) {
        return 27+2;
    }else{
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView ==_defaultTableView) {
        if (section == 0) {
            return [self.historyArray count];//历史
        }else if(section == 1){
            return [self.commonArray count];//常用
        }else{
            return [[self.sectionArray objectAtIndex:section-2] count];
        }
    }else{
        return [self.searchResults count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _defaultTableView) {
        if (section >=2) {
            if ([[self.sectionArray objectAtIndex:section-2] count] == 0)
            {
                return 0;
            }else{
                return 22.0f;
            }
     }else{
         
         if (section == 0) {
             if ([self.historyArray count] == 0) {
                 return 0;
             }
         }
         return 22.0f;
        }
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _defaultTableView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
        label.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
        if (section == 0) {
            if ([self.historyArray count] == 0) {
                [label release];
                return nil;
            }
            label.text = @"    历史";
        }else if (section == 1){
            label.text = @"    常用";
        }else{
            //SectionArray
            if ([[self.sectionArray objectAtIndex:section-2] count] == 0)
            {
                [label release];
                return nil;
            }
            else
            {
                label.text =  [NSString stringWithFormat:@"    %@", [[ALPHA substringFromIndex:section-2] substringToIndex:1]];
            }
        }
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = RGBACOLOR(52, 52, 52, 1.0);
        return [label autorelease];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifyer = @"Cell_List";
    RateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [[[RateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyer] autorelease];
        UIView *v  = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = RGBACOLOR(237, 237, 237, 1.0);
        cell.selectedBackgroundView = v;
        [v release];
    }
    
    if (tableView == _defaultTableView) {
        if (indexPath.section == 0) {
            //
            NSArray *display = [[self.historyArray reverseObjectEnumerator] allObjects];
            [cell bindingTheModel:[display  objectAtIndex:indexPath.row]];
            
        }else if(indexPath.section == 1){
            [cell bindingTheModel:[self.commonArray objectAtIndex:indexPath.row]];
        }else{
            [cell bindingTheModel:[[self.sectionArray objectAtIndex:indexPath.section-2] objectAtIndex:indexPath.row]];
        }
        
    }else{
        
        [cell bindingTheModel:[self.searchResults objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
}


#pragma mark ---  索引相关

//添加索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == _defaultTableView)
	{
		NSMutableArray *indices = [NSMutableArray arrayWithObjects:@"历史",@"常用",nil];//WithObject:UITableViewIndexSearch
		for (int i = 0; i < 27; i++)
		{
			if ([[self.sectionArray objectAtIndex:i] count])
			{
				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
			}
		}
		return indices;
	}
	else
	{
		return nil;
	}
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:@"历史"]) {
        return 0;
    }else if ([title isEqualToString:@"常用"]){
        return 1;
    }
	return [ALPHA rangeOfString:title].location+2;
}


#pragma  mark
#pragma  mark UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RateModel *model;
    
    if (tableView == _defaultTableView) {
        
        if (indexPath.section == 0) {
            
            NSArray *display = [[self.historyArray reverseObjectEnumerator] allObjects];
            model = [display   objectAtIndex:indexPath.row];
            
        }else if(indexPath.section == 1){
            model = [self.commonArray objectAtIndex:indexPath.row];
        }else{
            model = [[self.sectionArray objectAtIndex:indexPath.section - 2] objectAtIndex:indexPath.row];
        }
        
    }else{
        model = [self.searchResults objectAtIndex:indexPath.row];
    }
    
    self.historyModel  = model;
    
    if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedRateModel:)]) {
        [_delegate getTheSelectedRateModel:model];
    }
    
    BOOL hasIt = NO;
    //判断原来历史中是否还有此元素
    for (RateModel *model  in self.historyArray) {
        if ([model.simplyName isEqualToString:self.historyModel.simplyName]) {
            hasIt = YES;
            break;
        }
    }
    
    if (!hasIt) {
        if ([self.historyArray count] == 3) {
            [self.historyArray removeObjectAtIndex:0];
            [self.historyArray addObject:self.historyModel];
        }else{
            [self.historyArray addObject:self.historyModel];
        }
        
        //保存在缓存
        NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:self.historyArray];
        [[NSUserDefaults  standardUserDefaults] setObject:cacheData forKey:SEARCH_DEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self back];
}


#pragma  mark
#pragma  mark UISearchBarDelegate
/*
 // return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    //No use
    return YES;
}
// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    //No use
}
*/

-(NSString *)getLetterStringFromGivenString:(NSString *)string{

    NSString *result = @"";
    for (int i = 0; i < [string length]; i++) {
        if([result length] < 1)
        {
            result = [NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:i])];
        }
        else
        {
            result = [NSString stringWithFormat:@"%@%c",result,pinyinFirstLetter([string characterAtIndex:i])];
        }
    }
    return result;
}

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //Import
    NSLog(@"searchText is %@",searchText);
    
    if (!STRINGHASVALUE(searchText)) {
        return;
    }
    if ([self.searchResults count] != 0) {
        [self.searchResults removeAllObjects];
    }
    for (RateModel *model in self.dataSource) {
        //以国家为标准
        NSString *string = [self getCountryNameFromTheRateModel:model];
        //名字 汉字
        NSComparisonResult result = [string compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        //全拼
        NSComparisonResult result1 = [model.pinyin compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        //首字母 简拼
        NSComparisonResult result2 = [[self getLetterStringFromGivenString:string] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame || result1 == NSOrderedSame || result2 == NSOrderedSame)
        {
            [self.searchResults addObject:model];
        }
    }
    //NSLog(@"%@",self.searchResults);
    [_displayController.searchResultsTableView reloadData];
}

-(NSString *)getCountryNameFromTheRateModel:(RateModel *)model{

    /*
     NSRange start = [model.name rangeOfString:@"("];
     NSRange end = [model.name rangeOfString:@")"];
     NSString *country = [model.name substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
     if (STRINGHASVALUE(country)) {
     return country;
     }else{
     NSLog(@"获取国家名字出错误!");
     return @"";
     }
     */
    //也可以通过分拆数组 实现
    NSArray *array = [model.name componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    if ([array count] >= 2) {
        return [array objectAtIndex:1];
    }else{
        NSLog(@"获取国家名字出错误!");
        return @"";
    }
}

-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT
{
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    
	if (result == NSOrderedSame)
	{
        //NSLog(@" Receive");
		return YES;
	}
	else
	{
		return NO;
	}
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}




@end
