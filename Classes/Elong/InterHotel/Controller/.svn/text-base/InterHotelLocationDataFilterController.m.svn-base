//
//  InterHotelLocationDataFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelLocationDataFilterController.h"
#import "InterHotelLocationDataFilterDelegate.h"

@interface InterHotelLocationDataFilterController ()

@end

@implementation InterHotelLocationDataFilterController

- (void)dealloc
{
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
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tableView];
    [tableView release];
    
    [self updateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedData:(NSDictionary *)selectedData
{
    if (_selectedData != nil && selectedData == nil) {
        [self.tableView selectRowAtIndexPath:nil animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    [selectedData retain];
    [_selectedData release];
    _selectedData = selectedData;
    
    [self updateSelected];
}

- (void)updateSelected
{
    NSUInteger index = 0;
    for (NSDictionary *location in self.dataList) {
        NSString *name = [location safeObjectForKey:@"LandMarkNameEn"];
        
        NSString *selectedName = [self.selectedData safeObjectForKey:@"LandMarkNameEn"];
        
        if ([name isEqualToString:selectedName]) {
            break;
        }
        
        ++index;
    }
    
    if (index < self.dataList.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *data = [self.dataList safeObjectAtIndex:row];
    
    NSString *name = [data safeObjectForKey:@"LandMarkNameCn"];
    NSString *englishName = [data safeObjectForKey:@"LandMarkNameEn"];
    
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
    
    CGSize size = [text sizeWithFont:FONT_B16 constrainedToSize:CGSizeMake(tableView.frame.size.width - 120, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSString *tableCellidentifier = @"";
    CommonCell *cell = nil;
    cell = [[[CommonCell alloc] initWithIdentifier:tableCellidentifier height:size.height + 20 style:CommonCellStyleChoose] autorelease];
    [cell.button removeFromSuperview];
    cell.button = nil;
    
    CGRect frame = cell.textLabel.frame;
    frame.size.width = 240;
    cell.textLabel.frame = frame;
    
    cell.textLabel.text = text;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *data = [self.dataList safeObjectAtIndex:row];
    
    NSString *name = [data safeObjectForKey:@"LandMarkNameCn"];
    NSString *englishName = [data safeObjectForKey:@"LandMarkNameEn"];
    
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
    
    CGSize size = [text sizeWithFont:FONT_B16 constrainedToSize:CGSizeMake(tableView.frame.size.width - 120, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *data = [self.dataList safeObjectAtIndex:row];
    
    id<InterHotelLocationDataFilterDelegate> delegate = (id<InterHotelLocationDataFilterDelegate>)self.navigationController.delegate;
    [delegate InterHotelLocationDataFilter:self didSelectData:data];
}

@end
