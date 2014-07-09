//
//  InterHotelKeywordSearchController.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelKeywordSearchController.h"
#import "InterHotelSuggestRequest.h"
#import "SearchBarView.h"

@interface InterHotelKeywordSearchController ()

@end

@implementation InterHotelKeywordSearchController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cityName release];
    [_keyword release];
    [_historyList release];
    [_keywordList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keywordRequestFinished:) name:NOTI_INTERHOTEL_SUGGEST object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.translucent	= YES;
    
    
    if (!IOSVersion_5) {
        self.searchBar.backgroundColor = RGBACOLOR(236, 236, 236, 1);
        for (UIView *subview in self.searchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                subview.alpha = 0.0;
                break;
            }
        }
    }else{
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.backgroundImage = [UIImage stretchableImageWithPath:@"searchbar_bg.png"];
        [self.searchBar setSearchFieldBackgroundImage:[UIImage noCacheImageNamed:@"searchbar_field_bg.png"] forState:UIControlStateNormal];
    }
    
    self.searchBar.text = self.keyword;
    [self.searchBar setShowsCancelButton:YES animated:NO];
    
    [self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    
    if (IOSVersion_7) {
        self.searchBar.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        self.view.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        self.tableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }else{
        self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark = Actions

- (void)keywordRequestFinished:(NSNotification *)notification
{
    NSString *keyword = (NSString *)[notification object];
    
    NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([keyword isEqualToString:text]) {
        InterHotelSuggestRequest *isreq = [InterHotelSuggestRequest shared];
        NSArray *addressArray = [isreq getSuggestByKeyword:keyword];
        if ([addressArray isKindOfClass:[NSArray class]]) {
            self.keywordList = addressArray;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBar.text.length == 0) {
        return 0;
    }
    else {
        NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *firstWord = self.keywordList.count == 0 ? nil : [self.keywordList safeObjectAtIndex:0];
        if ([text isEqualToString:firstWord]) {
            return self.keywordList.count;
        }
        else {
            return self.keywordList.count + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
    CommonCell *cell = nil;
    NSUInteger row = indexPath.row;
    
    if (self.searchBar.text.length == 0) {
        
    }
    else {
        cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
		if (!cell) {
			cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey
													height:37
													 style:CommonCellStyleRightArrow] autorelease];
			cell.cellImage.hidden = YES;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.highlightedTextColor = [UIColor grayColor];
		}
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.hidden = YES;
            }
        }
        
        NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *firstWord = self.keywordList.count == 0 ? nil : [self.keywordList safeObjectAtIndex:0];
        if ([text isEqualToString:firstWord]) {
            cell.textLabel.text = [self.keywordList safeObjectAtIndex:row];
        }
        else {
            if (row == 0) {
                cell.textLabel.text = self.searchBar.text;
            }
            else {
                cell.textLabel.text = [self.keywordList safeObjectAtIndex:row - 1];
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectOffset(view.frame, 0, 0)];
    [view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"     搜索历史:";
    [label release];
    if (self.searchBar.text.length == 0 && self.historyList.count > 0)
        return view;
    else
        return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchBar.text.length == 0 && self.historyList.count > 0)
        return 30;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    [self.searchBar resignFirstResponder];
    
    if (self.searchBar.text.length == 0) {
        
    }
    else {
        NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *firstWord = self.keywordList.count == 0 ? nil : [self.keywordList safeObjectAtIndex:0];
        if ([text isEqualToString:firstWord]) {
            [self.delegate interHotelKeywordSearchController:self searchWithKeyword:[self.keywordList safeObjectAtIndex:row]];
        }
        else {
            if (row == 0) {
                 [self.delegate interHotelKeywordSearchController:self searchWithKeyword:self.searchBar.text];
            }
            else {
                [self.delegate interHotelKeywordSearchController:self searchWithKeyword:[self.keywordList safeObjectAtIndex:row - 1]];
            }
        }
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar_
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_
{
    // Cancel按钮换成中文显示
    UIView *viewTop = IOSVersion_7 ? searchBar_.subviews[0] : searchBar_;
    NSString *classString = IOSVersion_7 ? @"UINavigationButton" : @"UIButton";
    
    for (UIView *subView in viewTop.subviews) {
        if ([subView isKindOfClass:NSClassFromString(classString)]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    // 去掉键盘搜索默认置灰
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? searchBar_.subviews : [[searchBar_.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (searchText.length > 0) {
        InterHotelSuggestRequest *isreq = [InterHotelSuggestRequest shared];
        
        NSArray *addressArray = [isreq getSuggestByKeyword:searchText];
        
		if ([addressArray isKindOfClass:[NSArray class]]) {
			self.keywordList = addressArray;
		}
		else {
			[isreq requestForKeyword:searchText];
            [self.tableView reloadData];
		}
	}
	else {
		[self.tableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar_
{
    NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length == 0) {
        [self.delegate interHotelKeywordSearchController:self searchWithKeyword:nil];
    }
    else {
        [self.delegate interHotelKeywordSearchControllerDidCanceled:self];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
{
    NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length == 0) {
        [self.delegate interHotelKeywordSearchController:self searchWithKeyword:nil];
    }
    else {
        [self.delegate interHotelKeywordSearchController:self searchWithKeyword:text];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *result = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if ([result length] == 0) return YES; // Allow delete all character which are entered.
    
    NSString *searchText = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText length] > 0)
    {
        NSString *regex = @"^\\s+.*";
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return ![prd evaluateWithObject:result];
    }
    
    return YES;
}

@end
