//
//  GrouponAirportDetailViewController.m
//  ElongClient
//
//  Created by Dawn on 13-8-2.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponAirportDetailViewController.h"

@interface GrouponAirportDetailViewController ()

@end

@implementation GrouponAirportDetailViewController
@synthesize dataArray;
@synthesize item;
@synthesize backTitle;
@synthesize delegate;

- (void) dealloc{
    _airportList.delegate=nil;
    [_airportList release];
    self.dataArray = nil;
    self.item = nil;
    self.backTitle = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    
    self.airportList = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 47 - 30) style:UITableViewStylePlain] autorelease];
    self.airportList.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.airportList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.airportList.delegate = self;
    self.airportList.dataSource = self;
    self.airportList.backgroundColor=[UIColor whiteColor];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.airportList];
}

- (void) reloadData{
    [self.airportList reloadData];
    [self.airportList setContentOffset:CGPointMake(0, 0)];
}

- (void) backBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return HSC_CELL_HEGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     DistrictID",@"DistrictName",@"GrouponCnt
     */
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT style:CommonCellStyleChoose] autorelease];
        cell.textLabel.autoresizingMask = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.textLabel.text		= [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Name"];
    cell.textLabel.font		= [UIFont systemFontOfSize:16];
    CGSize titleSize		= [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:16]];
    cell.textLabel.frame	= CGRectMake(cell.textLabel.frame.origin.x, 15, titleSize.width, 20);
    
    
    if ([self.item isEqualToString:cell.textLabel.text]) {
        cell.cellImage.highlighted = YES;
    }
    else {
        cell.cellImage.highlighted = NO;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.item = [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Name"];
    [tableView reloadData];
    
    [delegate grouponAirportDetailVC:self didSelectedAtIndex:indexPath.row];
}

@end
