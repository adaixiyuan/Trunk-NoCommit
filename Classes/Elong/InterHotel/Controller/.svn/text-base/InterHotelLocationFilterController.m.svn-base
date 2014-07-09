//
//  InterHotelLocationFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelLocationFilterController.h"
#import "CommonCell.h"

@interface InterHotelLocationFilterController ()

@end

@implementation InterHotelLocationFilterController

- (void)dealloc
{
    [_tableView release];
    [_selectedLocation release];
    [_locationItemList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor=[UIColor whiteColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
    [tableView release];
    
    [self updateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedLocation:(NSDictionary *)selectedLocation
{
    [selectedLocation retain];
    [_selectedLocation release];
    _selectedLocation = selectedLocation;
    
    [self updateSelected];
}

- (void)updateSelected
{
    NSUInteger index = 0;
    for (NSDictionary *location in self.locationItemList) {
        NSString *name = [location safeObjectForKey:@"CnName"];
        
        NSString *selectedName = [self.selectedLocation safeObjectForKey:@"CnName"];
        
        if ([name isEqualToString:selectedName]) {
            break;
        }
        
        ++index;
    }
    
    if (index < self.locationItemList.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    else {
        [self.tableView selectRowAtIndexPath:nil animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *locationInfo = [self.locationItemList safeObjectAtIndex:row];
    NSArray *subLocationList = [locationInfo safeObjectForKey:@"SubItems"];
    NSUInteger subCount = [locationInfo safeObjectForKey:@"SubItemCnt"];
    NSString *tableCellidentifier = @"";
    CommonCell *cell = nil;
    if (subCount > 0 && subLocationList != nil && subLocationList.count != 0) {
        cell = [[[CommonCell alloc] initWithIdentifier:tableCellidentifier height:44 style:CommonCellStyleNone] autorelease];
    }
    else {
        cell = [[[CommonCell alloc] initWithIdentifier:tableCellidentifier height:44 style:CommonCellStyleChoose] autorelease];
    }
    [cell.button removeFromSuperview];
    cell.button = nil;
    
    NSString *name = [locationInfo safeObjectForKey:@"CnName"];
    NSString *englishName = [locationInfo safeObjectForKey:@"EnName"];
    NSString *text = nil;
    
    if (englishName.length > 0) {
        if (name.length > 0) {
            text = [NSString stringWithFormat:@"%@(%@)", englishName, name];
        }
        else {
            text = englishName;
        }
    }
    else {
        text = name;
    }
    
    cell.textLabel.text = text;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *locationInfo = [self.locationItemList safeObjectAtIndex:row];
    NSArray *subLocationList = [locationInfo safeObjectForKey:@"SubItems"];
    NSUInteger subCount = [locationInfo safeObjectForKey:@"SubItemCnt"];
    
    if (subCount > 0 && subLocationList != nil && subLocationList.count != 0) {
        InterHotelLocationFilterController *subController = [[[InterHotelLocationFilterController alloc] init] autorelease];
        subController.locationItemList = subLocationList;
        subController.selectedLocation = self.selectedLocation;
        subController.delegate = self.delegate;
        [self.navigationController pushViewController:subController animated:YES];
    }
    else {
        [self.delegate interHotelLocationFilter:self didSelectLocation:locationInfo];
    }
}

@end
