//
//  GrouponAirportViewController.m
//  ElongClient
//
//  Created by Dawn on 13-8-2.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponAirportViewController.h"
#import "GrouponAirportDetailViewController.h"

@interface GrouponAirportViewController ()

@end

@implementation GrouponAirportViewController
@synthesize delegate;
@synthesize dataArray;

- (void) dealloc{
    [_airports release];
    [_airportList release];
    self.dataArray = nil;
    [_item release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    self.navigationController.navigationBarHidden = YES;
    
    self.airportList = [[[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 47) style:UITableViewStylePlain] autorelease];
    self.airportList.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.airportList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.airportList.delegate = self;
    self.airportList.dataSource = self;
    self.airportList.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.airportList];
}

- (void) reloadData{
    [self.airportList reloadData];
    [self.airportList setContentOffset:CGPointMake(0, 0)];
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
        cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT style:CommonCellStyleRightArrow] autorelease];
        cell.textLabel.autoresizingMask = 0;
    }
    
    cell.textLabel.text		= [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Name"];
    cell.textLabel.font		= FONT_B16;
    CGSize titleSize		= [cell.textLabel.text sizeWithFont:FONT_B16];
    cell.textLabel.frame	= CGRectMake(cell.textLabel.frame.origin.x, 14, titleSize.width, 20);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger airportType = [[[self.dataArray safeObjectAtIndex:indexPath.row] objectForKey:@"Type"] intValue];
    NSMutableArray *currentAirportRailwayArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.airports) {
        if ([[dict objectForKey:@"Type"] intValue] == airportType) {
            [currentAirportRailwayArray addObject:dict];
        }
    }
    GrouponAirportDetailViewController *airportDetailVC = [[GrouponAirportDetailViewController alloc] init];
    airportDetailVC.dataArray = currentAirportRailwayArray;
    airportDetailVC.item = self.item;
    airportDetailVC.delegate = (id)self.navigationController.delegate;
    [self.navigationController pushViewController:airportDetailVC animated:YES];
    [airportDetailVC release];
}

@end