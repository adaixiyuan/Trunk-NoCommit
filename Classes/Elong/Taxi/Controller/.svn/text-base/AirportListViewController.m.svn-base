//
//  AirportListViewController.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "AirportListViewController.h"
#import "ChineseToPinyin.h"
#import "TaxiPublicDefine.h"
#import "SearchBarView.h"
#import "RentCity.h"
#import "TaxiUtils.h"

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface NSMutableArray (contains)
-(BOOL)containsAirport:(CustomAirportTerminal *)airport;
@end

@implementation NSMutableArray (contains)

-(BOOL)containsAirport:(CustomAirportTerminal *)airport{

    for (CustomAirportTerminal *terminal in self) {
        if ([terminal.name isEqualToString:airport.name]) {
            return YES;
        }
    }
    
    return NO;
}

@end

@interface AirportListViewController ()

@end

@implementation AirportListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *sec = [[NSMutableArray alloc] init];
        self.sectionArray = sec;
        [sec release];
        
        
        NSMutableArray *search = [[NSMutableArray alloc] init];
        self.searchResults = search;
        [search release];
        
        //设置sectionArray
        for (int i = 0; i<27; i++) {
            [self.sectionArray addObject:[NSMutableArray array]];
        }

        //读取缓存的历史记录
        self.historyArray = [TaxiUtils getRentCarHistoryWithGivenType:RentHistory_Airport];
        
    }
    return self;
}

-(void)initDataSource{

    for (CustomAirportTerminal *model in self.dataSource) {
        NSString *sectionName = nil;
        if ([model.name hasPrefix:@"重"] || [model.name hasPrefix:@"长"]) {
            sectionName = @"C";
        }else if ([model.name hasPrefix:@"沈"]){
            sectionName = @"S";//多音字。。。。chen
        }else if ([model.name hasPrefix:@"厦"]){
            sectionName = @"X";
        }else{
            sectionName = [[NSString stringWithFormat:@"%c",jianyinFirstLetter([model.name characterAtIndex:0])] uppercaseString];
        }
        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
        if (firstLetter != NSNotFound)
        {
            [[self.sectionArray objectAtIndex:firstLetter] addObject:model];
        }
    }
    
}

-(void)dealloc{
    self.dataSource = nil;
    self.sectionArray = nil;
    self.searchResults = nil;
    self.historyArray = nil;
    [_defaultTableView release];
    [_displayController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDataSource];
    
	// Do any additional setup after loading the view.
    UISearchBar *searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
    searchBar.placeholder = @"城市名或机场名";
    
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
        return 27+1;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==_defaultTableView) {
        if (section == 0) {
            return [self.historyArray count];//历史
        }else{
            return [[self.sectionArray objectAtIndex:section-1] count];
        }
    }else{
        return [self.searchResults count];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _defaultTableView) {
        if (section >=1) {
            if ([[self.sectionArray objectAtIndex:section-1] count] == 0)
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
        }    }else{
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
        }else{
            //SectionArray
            if ([[self.sectionArray objectAtIndex:section-1] count] == 0)
            {
                [label release];
                return nil;
            }
            else
            {
                label.text =  [NSString stringWithFormat:@"    %@", [[ALPHA substringFromIndex:section-1] substringToIndex:1]];
            }        }
        label.font = FONT_B15;
        label.textColor = RGBACOLOR(52, 52, 52, 1.0);
        return [label autorelease];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifyer = @"Cell_List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyer] autorelease];
        
        UIView *v  = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = RGBACOLOR(237, 237, 237, 1.0);
        cell.selectedBackgroundView = v;
        [v release];
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    }
    if (tableView == _defaultTableView) {
        if (indexPath.section == 0) {
            //
            NSArray *display = [[self.historyArray reverseObjectEnumerator] allObjects];
            CustomAirportTerminal *model = [display objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
        }else{
            CustomAirportTerminal *model = [[self.sectionArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
        }
        
    }else{
        CustomAirportTerminal *model = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}

#pragma mark ---  索引相关

//添加索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == _defaultTableView)
	{
        NSMutableArray *indices = [NSMutableArray arrayWithObjects:@"历史",nil];
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
    }
	return [ALPHA rangeOfString:title].location+1;

}


#pragma  mark
#pragma  mark UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomAirportTerminal *selected = nil;
    BOOL save;
    if (tableView == _defaultTableView) {
        if (indexPath.section == 0) {
            NSArray *array = [[self.historyArray reverseObjectEnumerator] allObjects];
            selected = [array objectAtIndex:indexPath.row];
            save = NO;
        }else{
            selected = [[self.sectionArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            save = YES;
        }
    }else{
        selected = [self.searchResults objectAtIndex:indexPath.row];
        save = YES;
    }
    
    //历史记录处理
    if (save) {
        if (![self.historyArray containsAirport:selected]) {
            if ([self.historyArray count] < 5) {
                [self.historyArray addObject:selected];
            }else{
                [self.historyArray replaceObjectAtIndex:4 withObject:selected];
            }
            [TaxiUtils saveTheHistoryData:self.historyArray Type:RentHistory_Airport];
        }
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedCustomAirport:)]) {
        [_delegate getTheSelectedCustomAirport:selected];
    }
    [self back];
}


#pragma mark
#pragma mark UISearBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if ([self.searchResults count] != 0) {
        [self.searchResults removeAllObjects];
    }
    [_displayController.searchResultsTableView reloadData];
    return YES;
}

// called when keyboard search button pressed

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}

//得到文字的首字母简拼
-(NSString *)getLetterStringFromGivenString:(NSString *)string{
    
    NSString *result = @"";
    for (int i = 0; i < [string length]; i++) {
        if([result length] < 1)
        {
            result = [NSString stringWithFormat:@"%c",jianyinFirstLetter([string characterAtIndex:i])];
        }
        else
        {
            result = [NSString stringWithFormat:@"%@%c",result,jianyinFirstLetter([string characterAtIndex:i])];
        }
    }
    return result;
}

-(NSString *)getQuanPingFromGivenString:(NSString  *)string{
    
    return [ChineseToPinyin pinyinFromChiniseString:string];
    
}

#pragma mark
#pragma mark UISearDisplayControllerDelegate

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"searchText is %@",searchText);
    
    if (!STRINGHASVALUE(searchText)) {
        return;
    }
    
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.searchResults count] != 0) {
        [self.searchResults removeAllObjects];
    }
    for (CustomAirportTerminal *dic in self.dataSource) {
        NSString *string = dic.name;//[dic safeObjectForKey:@"name"];
        //名字 汉字
        NSComparisonResult result = [string compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        //全拼
        NSComparisonResult result1 = [[self getQuanPingFromGivenString:string] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        //首字母 简拼
        NSComparisonResult result2 = [[self getLetterStringFromGivenString:string] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame || result1 == NSOrderedSame || result2 == NSOrderedSame)
        {
            [self.searchResults addObject:dic];
        }
        
    }
    [_displayController.searchResultsTableView reloadData];
}

@end
