//
//  InterHotelLocationCatalogFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelLocationCatalogFilterController.h"
#import "InterHotelLocationDataFilterController.h"

@interface InterHotelLocationCatalogFilterController ()

@end

@implementation InterHotelLocationCatalogFilterController

- (void)dealloc
{
    [_catalogList release];
    [_selectedData release];
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
	
    if (self.catalogList.count == 0) {
        UIActivityIndicatorView *view = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 40, 40)] autorelease];
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.loadingView = view;
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [view startAnimating];
        [self.view addSubview:view];     
    }
    else {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView = tableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        tableView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:tableView];
        [tableView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCatalogList:(NSArray *)catalogList
{
    [catalogList retain];
    [_catalogList release];
    _catalogList = catalogList;
    
    if (self.catalogList.count == 0) {
        UIActivityIndicatorView *view = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 40, 40)] autorelease];
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.loadingView = view;
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [view startAnimating];
        [self.view addSubview:view];
        
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    else {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView = tableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:tableView];
        [tableView release];
        
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.catalogList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *catalog = [self.catalogList safeObjectAtIndex:row];

    NSString *tableCellidentifier = @"";
    CommonCell *cell = nil;
    cell = [[[CommonCell alloc] initWithIdentifier:tableCellidentifier height:44 style:CommonCellStyleNone] autorelease];
    [cell.button removeFromSuperview];
    cell.button = nil;
    
    NSString *name = nil;
    NSString *englishName = nil;
    
    if ([catalog safeObjectForKey:@"HasSubType"]) {
        name = [catalog safeObjectForKey:@"LandMarkTypeCn"];
        englishName = [catalog safeObjectForKey:@"LandMarkTypeEn"];
    }
    else {
        name = [catalog safeObjectForKey:@"LandMarkSTypeCn"];
        englishName = [catalog safeObjectForKey:@"LandMarkSTypeEn"];
    }
    
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
    NSDictionary *catalog = [self.catalogList safeObjectAtIndex:row];
    
    if ((![catalog safeObjectForKey:@"HasSubType"]) || ([[catalog safeObjectForKey:@"HasSubType"] boolValue] == NO)) {
        InterHotelLocationDataFilterController *controller = [[[InterHotelLocationDataFilterController alloc] init] autorelease];
        controller.dataList = [catalog safeObjectForKey:@"NewLandMarkList"];
        controller.selectedData = self.selectedData;
        controller.locationTitle = [catalog safeObjectForKey:@"LandMarkTypeCn"] != nil ? [catalog safeObjectForKey:@"LandMarkTypeCn"] : [catalog safeObjectForKey:@"LandMarkSTypeCn"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        InterHotelLocationCatalogFilterController *controller = [[[InterHotelLocationCatalogFilterController alloc] init] autorelease];
        controller.catalogList = [catalog safeObjectForKey:@"LandMarkStList"];
        controller.selectedData = self.selectedData;
        controller.locationTitle = [catalog safeObjectForKey:@"LandMarkTypeCn"] != nil ? [catalog safeObjectForKey:@"LandMarkTypeCn"] : [catalog safeObjectForKey:@"LandMarkSTypeCn"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
