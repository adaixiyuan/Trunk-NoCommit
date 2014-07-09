//
//  GrouponSubwayDetailViewController.m
//  ElongClient
//
//  Created by Dawn on 13-8-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#define kNumberLabelTag 238

#import "GrouponSubwayDetailViewController.h"

@interface GrouponSubwayDetailViewController ()

@end

@implementation GrouponSubwayDetailViewController
@synthesize dataArray;
@synthesize item;
@synthesize delegate;

- (void) dealloc{
    _subwayList.delegate=nil;
    [_subwayList release];
    self.dataArray = nil;
    self.item = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    
    self.subwayList = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.subwayList.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.subwayList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subwayList.delegate = self;
    self.subwayList.dataSource = self;
    [self.view addSubview:self.subwayList];
}

- (void) reloadData{
    [self.subwayList reloadData];
    [self.subwayList setContentOffset:CGPointMake(0, 0)];
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
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT style:CommonCellStyleChoose] autorelease];
        cell.textLabel.autoresizingMask = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text		= [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"StationName"];
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
    self.item = [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"StationName"];
    [tableView reloadData];
        
    [delegate grouponSubwayDetailVC:self didSelectedAtIndex:indexPath.row];
}

@end
