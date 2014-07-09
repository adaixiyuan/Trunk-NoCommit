//
//  HotelPriceStarFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelPriceFilterController.h"
#import "CommonCell.h"
#import "HotelSearch.h"
#import "AccountManager.h"

@interface HotelPriceFilterController ()

@end

@implementation HotelPriceFilterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _showVipContainer = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vipButton.selected = _vip;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    self.tableView.backgroundColor=[UIColor whiteColor];
    
    BOOL isLogin = [[AccountManager instanse] isLogin];
    int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
    if (isLogin && (userLevel == 2) && _showVipContainer) {
        self.vipContainer.hidden = NO;
    }
    else {
        self.vipContainer.hidden = YES;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.vipButton = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Method

- (void)setVip:(BOOL)vip
{
    _vip = vip;
    self.vipButton.selected = _vip;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if ([self isViewLoaded]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _priceRangeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleChoose] autorelease];
        [cell.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    
    cell.textLabel.text = [_priceRangeArray safeObjectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate hotelPriceFilterController:self didSelectIndex:indexPath.row];
}

#pragma mark Private Actions

- (IBAction)vipCheckStateChanged:(id)sender
{
    self.vipButton.selected = !self.vipButton.selected;
    _vip = self.vipButton.selected;
    [_delegate hotelPriceFilterController:self vipCheckStateChanged:self.vipButton.selected];
}

- (void)dealloc
{
    [_priceRangeArray release];
    [super dealloc];
}

@end
