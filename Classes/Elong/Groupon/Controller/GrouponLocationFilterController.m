//
//  GrouponLocationFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
// 

#import "GrouponLocationFilterController.h"
#import "GrouponDistrictViewController.h"
#import "GrouponSubwayViewController.h"
#import "GrouponAirportDetailViewController.h"

#define kIconViewTag	6477
#define kTextFieldTag	6478
#define kTopSplitViewTag 6479
#define kBottomSplitViewTag 6480

@interface GrouponLocationFilterController ()

@end

@implementation GrouponLocationFilterController

- (void)dealloc
{
    keyTable.delegate=nil;
    [_iconArray release];
    [_smallIconArray release];
    [_placeHolderArray release];
    
    [_districtArray release];
    [_businessDistrictArray release];
    [_subwayArray release];
    [_stations release];
    [_airports release];
    
    self.location=nil;
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

- (id)init
{
    if (self = [super init]) {
        self.iconArray = [[[NSArray alloc] initWithObjects:
                     @"business_ico.png",
                     @"district_ico.png",
                     @"metro_ico.png",
                     @"traffic_ico.png",
                     nil] autorelease];
        
        self.smallIconArray = [[[NSArray alloc] initWithObjects:
                          @"business_ico.png",
                          @"district_ico.png",
                          @"metro_ico.png",
                          @"traffic_ico.png",
                          nil] autorelease];
		
		self.placeHolderArray = [[[NSArray alloc] initWithObjects:
							@"商    圈",
							@"行政区",
							@"地    铁",
							@"机场 / 火车站",
                            nil] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    if (self.error) {
        UILabel *view = [[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2-10, self.view.frame.size.height / 2+2, 80, 40)] autorelease];
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        view.text = @"加载失败";
        view.font = [UIFont systemFontOfSize:12];
        view.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:view];
    }
    else if (self.businessDistrictArray.count == 0 && self.districtArray.count == 0 && self.subwayArray.count == 0 && self.airports.count == 0) {
        UIActivityIndicatorView *view = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 40, 40)] autorelease];
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [view startAnimating];
        [self.view addSubview:view];
    }
	else {
        keyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 17, 320, SCREEN_HEIGHT-17) style:UITableViewStylePlain];
        keyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        keyTable.dataSource		= self;
        keyTable.delegate		= self;
        keyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:keyTable];
        keyTable.backgroundColor=[UIColor whiteColor];
        
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)] autorelease];
        keyTable.tableHeaderView=headerView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
    UITableViewCell *cell = nil;
    
	cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectTableCellKey]autorelease];
        
        // icon
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 50)];
        iconView.contentMode = UIViewContentModeCenter;
        iconView.tag		 = kIconViewTag;
        [cell.contentView addSubview:iconView];
        [iconView release];
        
        // condition
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, SCREEN_WIDTH - 64, 50)];
        titleLbl.font			 = FONT_B16;
        titleLbl.tag			 = kTextFieldTag;
        titleLbl.textColor	 =  RGBACOLOR(52, 52, 52, 1);
        [cell.contentView addSubview:titleLbl];
        [titleLbl release];
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        topSplitView.tag = kTopSplitViewTag;
        [cell.contentView addSubview:topSplitView];
        [topSplitView release];
        
        UIImageView *bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        bottomSplitView.tag = kBottomSplitViewTag;
        [cell.contentView addSubview:bottomSplitView];
        [bottomSplitView release];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 0, 8, 50)];
        arrow.contentMode =  UIViewContentModeCenter;
        arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [cell.contentView addSubview:arrow];
        [arrow release];
    }
    
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:kIconViewTag];
    icon.image = [UIImage noCacheImageNamed:[_iconArray safeObjectAtIndex:indexPath.row]];
    
    UITextField *conditionField = (UITextField *)[cell.contentView viewWithTag:kTextFieldTag];
    conditionField.text			= [_placeHolderArray safeObjectAtIndex:indexPath.row];
    
    UIImageView *topSplitView = (UIImageView *)[cell.contentView viewWithTag:kTopSplitViewTag];
    UIImageView *bottomSplitView = (UIImageView *)[cell.contentView viewWithTag:kBottomSplitViewTag];
    if (indexPath.row == 0) {
        topSplitView.hidden = NO;
        bottomSplitView.hidden = NO;
    }else{
        topSplitView.hidden = YES;
        bottomSplitView.hidden = NO;
    }
    if (indexPath.row == 0) {
        topSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        bottomSplitView.frame = CGRectMake(64, 50 - SCREEN_SCALE, SCREEN_WIDTH - 64, SCREEN_SCALE);
    }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1){
        bottomSplitView.frame = CGRectMake(0, 50 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    }else{
        topSplitView.frame = CGRectMake(64, 0, SCREEN_WIDTH - 64, SCREEN_SCALE);
        bottomSplitView.frame = CGRectMake(64, 50 - SCREEN_SCALE, SCREEN_WIDTH - 64, SCREEN_SCALE);
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            GrouponDistrictViewController *districtVC = [[GrouponDistrictViewController alloc] init];
            districtVC.item = [self.location safeObjectForKey:@"Name"];
            districtVC.type = 0;
            districtVC.dataArray = self.businessDistrictArray;
            districtVC.delegate = (id)self.navigationController.delegate;
            [self.navigationController pushViewController:districtVC animated:YES];
            [districtVC release];
        }
            break;
        case 1:
        {
            GrouponDistrictViewController *districtVC = [[GrouponDistrictViewController alloc] init];
            districtVC.item = [self.location safeObjectForKey:@"Name"];
            districtVC.type = 1;
            districtVC.dataArray = self.districtArray;
            districtVC.delegate = (id)self.navigationController.delegate;
            [self.navigationController pushViewController:districtVC animated:YES];
            [districtVC release];
        }
            break;
        case 2:
        {
            GrouponSubwayViewController *subwayVC = [[GrouponSubwayViewController alloc] init];
            subwayVC.dataArray = self.subwayArray;
            subwayVC.stations = self.stations;
            subwayVC.item = [self.location safeObjectForKey:@"Name"];
            [self.navigationController pushViewController:subwayVC animated:YES];
            [subwayVC release];
        }
            break;
        case 3:
        {
            GrouponAirportDetailViewController *airportVC = [[GrouponAirportDetailViewController alloc] init];
            airportVC.item = [self.location safeObjectForKey:@"Name"];
            airportVC.dataArray = self.airports;
            airportVC.delegate = (id)self.navigationController.delegate;
            [self.navigationController pushViewController:airportVC animated:YES];
            [airportVC release];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if (self.businessDistrictArray.count > 0) {
                return 50;
            }
            else {
                return 0;
            }
            break;
        case 1:
            if (self.districtArray.count > 0) {
                return 50;
            }
            else {
                return 0;
            }
            break;
        case 2:
            if (self.subwayArray.count > 0) {
                return 50;
            }
            else {
                return 0;
            }
            break;
        case 3:
            if (self.airports.count > 0) {
                return 50;
            }
            else {
                return 0;
            }
            break;
        default:
            return 0;
            break;
    }
}

@end
