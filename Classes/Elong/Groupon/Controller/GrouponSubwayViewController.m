//
//  GrouponSubwayViewController.m
//  ElongClient
//
//  Created by Dawn on 13-8-1.
//  Copyright (c) 2013年 elong. All rights reserved.
// 

#import "GrouponSubwayViewController.h"
#import "GrouponSubwayDetailViewController.h"

@interface GrouponSubwayViewController ()

@end

@implementation GrouponSubwayViewController
@synthesize dataArray;
@synthesize delegate;

- (void) dealloc{
    [_stations release];
    _subwayList.delegate=nil;
    [_subwayList release];
    [_item release];
    self.dataArray = nil;
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    self.navigationController.navigationBarHidden = YES;
    
    self.subwayList = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.subwayList.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.subwayList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subwayList.delegate = self;
    self.subwayList.dataSource = self;
    self.subwayList.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.subwayList];
    
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void) reloadData{
    [self.subwayList reloadData];
    [self.subwayList setContentOffset:CGPointMake(0, 0)];
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
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT style:CommonCellStyleRightArrow] autorelease];
        cell.textLabel.autoresizingMask = 0;
    }
    
    cell.textLabel.text		= [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"LineName"];
    cell.textLabel.font		= [UIFont systemFontOfSize:16];
    CGSize titleSize		= [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:16]];
    cell.textLabel.frame	= CGRectMake(cell.textLabel.frame.origin.x, 14, titleSize.width, 20);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSString *linename = [[self.dataArray safeObjectAtIndex:indexPath.row] objectForKey:@"LineName"];
    NSMutableArray *currentSubwayArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.stations) {
        if ([[dict objectForKey:@"LineName"] isEqualToString:linename]) {
            [currentSubwayArray addObject:dict];
        }
    }
    GrouponSubwayDetailViewController *subwayDetailVC = [[GrouponSubwayDetailViewController alloc] init];
    subwayDetailVC.dataArray = currentSubwayArray;
    subwayDetailVC.item = self.item;
    subwayDetailVC.delegate = (id)self.navigationController.delegate;
    [self.navigationController pushViewController:subwayDetailVC animated:YES];
    [subwayDetailVC release];
}

@end
