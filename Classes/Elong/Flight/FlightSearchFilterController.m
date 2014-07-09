//
//  FlightSearchFilterController.m
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightSearchFilterController.h"

@interface FlightSearchFilterController ()

@property (nonatomic, retain) FlightFilterAirlineViewController *airlineViewController;
@property (nonatomic, retain) FlightFilterDepartureAirportViewController *departureAirportViewController;
@property (nonatomic, retain) FlightFilterArrivalAirportViewController *arrivalAirportViewController;

@property (nonatomic, retain) NSArray *airline;
@property (nonatomic, retain) NSArray *departureAirport;
@property (nonatomic, retain) NSArray *arrivalAirport;

@property (nonatomic, assign) NSInteger airlineIndex;
@property (nonatomic, assign) NSInteger departureAirportIndex;
@property (nonatomic, assign) NSInteger arrivalAirportIndex;

@property (nonatomic, retain) NSMutableDictionary *tabHolder;
@property (nonatomic, retain) NSMutableDictionary *filterConditions;

@property (nonatomic, assign) BOOL topItemAddFlag;
@property (nonatomic, assign) BOOL topItemRemoveFlag;

@end

@implementation FlightSearchFilterController

- (void)dealloc
{
    self.airlineViewController = nil;
    self.departureAirportViewController = nil;
    self.arrivalAirportViewController = nil;
    
    self.airline = nil;
    self.departureAirport = nil;
    self.arrivalAirport = nil;
    
    self.tabHolder = nil;
    self.filterConditions = nil;
    
    [super dealloc];
}

- (id)initWithAirlineArray:(NSMutableArray*)airlineArray departureAirportArray:(NSMutableArray*)departureAirportArray arrivalAirportArray:(NSMutableArray*)arrivalAirportArray
{
    self = [self initWithNibName:@"FilterController" bundle:nil];
    if (self) {
        self.airline = airlineArray;
        self.departureAirport = departureAirportArray;
        self.arrivalAirport = arrivalAirportArray;
        
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
        self.tabHolder = tempDictionary;
        
        // Filter conditions initialize.
//        self.filterConditions = @{[NSString stringWithFormat:@"%d", FilterAirline]: @[], [NSString stringWithFormat:@"%d", FilterDepartureAirport]: @[], [NSString stringWithFormat:@"%d", FilterArrivalAirport]: @[]};
        
        self.filterConditions = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray array],[NSString stringWithFormat:@"%d", FilterAirline], [NSArray array], [NSString stringWithFormat:@"%d", FilterDepartureAirport],[NSArray array],[NSString stringWithFormat:@"%d", FilterArrivalAirport], nil];
        
        self.airlineIndex = -1;
        self.departureAirportIndex = -1;
        self.arrivalAirportIndex = -1;
        
        self.locationNavigationBar.frame = CGRectMake(SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, 0.0f);
        
        // Do any additional setup after loading the view from its nib.
        
        self.priceLabel.text = @"航空公司";
        self.starLabel.text = @"起飞机场";
        self.locationlabel.text = @"到达机场";
        
        UIImage *airlineImage = [UIImage imageNamed:@"filter_airline.png"];
        UIImage *airlineSelectedImage = [UIImage imageNamed:@"filter_airline_selected.png"];
        [self.priceButton setImage:airlineImage forState:UIControlStateNormal];
        [self.priceButton setImage:airlineSelectedImage forState:UIControlStateSelected];
        [self.priceButton setImage:airlineSelectedImage forState:UIControlStateHighlighted];
        
        UIImage *departureAirlineImage = [UIImage imageNamed:@"departure_airport.png"];
        UIImage *departureAirlineSelectedImage = [UIImage imageNamed:@"departure_airport_selected.png"];
        [self.starButton setImage:departureAirlineImage forState:UIControlStateNormal];
        [self.starButton setImage:departureAirlineSelectedImage forState:UIControlStateSelected];
        [self.starButton setImage:departureAirlineSelectedImage forState:UIControlStateHighlighted];
        
        UIImage *arrivalAirlineImage = [UIImage imageNamed:@"arrival_airport.png"];
        UIImage *arrivalAirlineSelectedImage = [UIImage imageNamed:@"arrival_airport_selected.png"];
        [self.locationButton setImage:arrivalAirlineImage forState:UIControlStateNormal];
        [self.locationButton setImage:arrivalAirlineSelectedImage forState:UIControlStateSelected];
        [self.locationButton setImage:arrivalAirlineSelectedImage forState:UIControlStateHighlighted];
        
        self.brandTab.hidden = YES;
        self.otherTab.hidden = YES;
        
        [self updateTab];
    }

    return self;
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
	// Do any additional setup after loading the view.
    
    _topItemAddFlag = NO;
    _topItemRemoveFlag = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods

- (void)updateTab
{
    self.priceButton.selected = NO;
    self.starButton.selected = NO;
    self.locationButton.selected = NO;
    
    self.priceLabel.highlighted = NO;
    self.starLabel.highlighted = NO;
    self.locationlabel.highlighted = NO;
    
    for (UIView *subView in [self.selectedContainer subviews]) {
        [subView removeFromSuperview];
    }
    
    if (self.airlineViewController == nil) {
        self.airlineViewController = [[[FlightFilterAirlineViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.airlineViewController.airlineArray = [NSMutableArray arrayWithArray:_airline];
        self.airlineViewController.delegate = self;
        [_airlineViewController.airlineArray insertObject:@"全部" atIndex:0];
        
        for (NSUInteger index = 0; index < [_airlineViewController.airlineArray count]; index++) {
            [_airlineViewController.airlineTabDictionary setValue:[_airlineViewController.airlineArray safeObjectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
        }
//        if (_filterConditions && [_filterConditions count] != 0) {
//            NSArray *typeArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterType]];
//            if ([typeArray indexOfObject:[NSString stringWithFormat:@"%d", 1]] != NSNotFound && [typeArray indexOfObject:[NSString stringWithFormat:@"%d", 2]] != NSNotFound) {
//                [_airlineViewController.air setValue:[_typeViewController.typeArray objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d", 0]];
//            }
//        }
    }
    
    if (self.departureAirportViewController == nil) {
        self.departureAirportViewController = [[[FlightFilterDepartureAirportViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.departureAirportViewController.delegate = self;
        self.departureAirportViewController.departureAirportArray = [NSMutableArray arrayWithArray:_departureAirport];
        [_departureAirportViewController.departureAirportArray insertObject:@"全部" atIndex:0];
        
        for (NSUInteger index = 0; index < [_departureAirportViewController.departureAirportArray count]; index++) {
            [_departureAirportViewController.departureAirportTabDictionary setValue:[_departureAirportViewController.departureAirportArray safeObjectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
        }
//        if (_filterConditions && [_filterConditions count] != 0) {
//            NSArray *departureArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterDepartureTime]];
//            if ([departureArray count] != 4) {
//                for (NSString *departureKey in departureArray) {
//                    [_departureTimeViewController.departureTimeTabDictionary setValue:[_departureTimeViewController.departureTimeArray objectAtIndex:[departureKey integerValue]] forKey:departureKey];
//                }
//            }
//        }
    }
    
    if (self.arrivalAirportViewController == nil) {
        self.arrivalAirportViewController = [[[FlightFilterArrivalAirportViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.arrivalAirportViewController.delegate = self;
        self.arrivalAirportViewController.arrivalAirportArray = [NSMutableArray arrayWithArray:_arrivalAirport];
        [_arrivalAirportViewController.arrivalAirportArray insertObject:@"全部" atIndex:0];
        
        for (NSUInteger index = 0; index < [_arrivalAirportViewController.arrivalAirportArray count]; index++) {
            [_arrivalAirportViewController.arrivalAirportTabDictionary setValue:[_arrivalAirportViewController.arrivalAirportArray safeObjectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
        }
//        if (_filterConditions && [_filterConditions count] != 0) {
//            NSArray *arrivalArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterArrivalTime]];
//            if ([arrivalArray count] != 4) {
//                for (NSString *arrivalKey in arrivalArray) {
//                    [_arrivalTimeViewController.arrivalTimeTabDictionary setValue:[_arrivalTimeViewController.arrivalTimeArray objectAtIndex:[arrivalKey integerValue]] forKey:arrivalKey];
//                }
//            }
//        }
    }
    
    switch (self.selectedIndex) {
        case 0:
            self.priceButton.selected = YES;
            self.priceLabel.highlighted = YES;
            
            [self.selectedContainer addSubview:self.airlineViewController.view];
            self.airlineViewController.view.frame = self.selectedContainer.bounds;
            
            break;
        case 1:
            self.starButton.selected = YES;
            self.starLabel.highlighted = YES;
            
            [self.selectedContainer addSubview:self.departureAirportViewController.view];
            self.departureAirportViewController.view.frame = self.selectedContainer.bounds;
            
            break;
        case 2:
        {
            self.locationButton.selected = YES;
            self.locationlabel.highlighted = YES;

            [self.selectedContainer addSubview:self.arrivalAirportViewController.view];
            self.arrivalAirportViewController.view.frame = self.selectedContainer.bounds;
        }
            break;
        default:
            break;
    }
}

- (void)itemWithTagTapped:(NSUInteger)tag
{
    NSUInteger tagType = tag / kFilterAirline;
    switch (tagType) {
        case 1: // type
            self.airlineIndex = tag - kFilterAirline;
            [_airlineViewController setAirlineIndex:_airlineIndex];
            
            break;
        case 10: // star
            self.departureAirportIndex = tag - kFilterDepartureAirport;
            [_departureAirportViewController setDepartureAirportIndex:_departureAirportIndex];
            break;
        case 100: // brand
            self.arrivalAirportIndex = tag - kFilterArrivalAirport;
            [_arrivalAirportViewController setArrivalAirportIndex:_arrivalAirportIndex];
            break;
    }
    
    NSUInteger itemCount = [self.displayContainer subviews].count;
//    if (self.selectedIndex == 0 && itemCount > 1)
//    {
//        [_airlineViewController.airlineTableView setViewHeight:(_airlineViewController.airlineTableView.frame.size.height-heightMargin)];
//    }
    if (self.selectedIndex == 0 && itemCount == 1)
    {
        _topItemRemoveFlag = YES;
        _topItemAddFlag = NO;
        [_airlineViewController.airlineTableView setViewHeight:(MAINCONTENTHEIGHT-44)];
    }
}

- (void)tabTappedAtIndex:(NSUInteger)index
{
    [super tabTappedAtIndex:index];
}

- (void)reset
{
    for (NSInteger airlineIndex = 0; airlineIndex < [_airlineViewController.airlineArray count]; airlineIndex++) {
        if (![[_airlineViewController.airlineTabDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", airlineIndex]]) {
            [_airlineViewController setAirlineIndex:airlineIndex];
        }
    }
    
    for (NSInteger departureAirportIndex = 0; departureAirportIndex < [_departureAirportViewController.departureAirportArray count]; departureAirportIndex++) {
        if (![[_departureAirportViewController.departureAirportTabDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", departureAirportIndex]]) {
            [_departureAirportViewController setDepartureAirportIndex:departureAirportIndex];
        }
    }
    
    for (NSInteger arrivalAirportIndex = 0; arrivalAirportIndex < [_arrivalAirportViewController.arrivalAirportArray count]; arrivalAirportIndex++) {
        if (![[_arrivalAirportViewController.arrivalAirportTabDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", arrivalAirportIndex]]) {
            [_arrivalAirportViewController setArrivalAirportIndex:arrivalAirportIndex];
        }
    }
    
//    NSArray *existAirlineArray = [_airlineViewController.airlineTabDictionary allKeys];
//    for (NSString *key in existAirlineArray) {
//        [_airlineViewController setAirlineIndex:[key integerValue]];
//    }
//    
//    for (NSString *key in [_departureAirportViewController.departureAirportTabDictionary allKeys]) {
//        [_departureAirportViewController setDepartureAirportIndex:[key integerValue]];
//    }
//    
//    for (NSString *key in [_arrivalAirportViewController.arrivalAirportTabDictionary allKeys]) {
//        [_arrivalAirportViewController setArrivalAirportIndex:[key integerValue]];
//    }
    
    NSUInteger itemCount = [self.displayContainer subviews].count;
    if (self.selectedIndex == 0 && itemCount > 0)
    {
        _topItemRemoveFlag = YES;
        _topItemAddFlag = NO;
        [_airlineViewController.airlineTableView setViewHeight:MAINCONTENTHEIGHT - 44];
    }
    
    for (UIView *subView in [self.displayContainer subviews]) {
        [subView removeFromSuperview];
    }
    [self clearItems];
}

- (void)confirm
{
    // Airline filter result.
    NSMutableArray *airlineResultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *airlineKeys = [_airlineViewController.airlineTabDictionary allKeys];
    
    if ([airlineKeys count] == 0) {
        [Utils alert:@"请选择需要筛选的航空公司"];
        return;
    }
    
    for (NSString *airlineKey in airlineKeys) {
        [airlineResultArray addObject:[_airlineViewController.airlineArray safeObjectAtIndex:[airlineKey integerValue]]];
    }
    [_filterConditions setValue:airlineResultArray forKey:[NSString stringWithFormat:@"%d", FilterAirline]];
    
    NSMutableArray *departureAirportResultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *departureAirportKeys = [_departureAirportViewController.departureAirportTabDictionary allKeys];
    
    if ([departureAirportKeys count] == 0) {
        [Utils alert:@"请选择起飞机场"];
        return;
    }
    
    for (NSString *departureAirportKey in departureAirportKeys) {
        [departureAirportResultArray addObject:[_departureAirportViewController.departureAirportArray safeObjectAtIndex:[departureAirportKey integerValue]]];
    }
    [_filterConditions setValue:departureAirportResultArray forKey:[NSString stringWithFormat:@"%d", FilterDepartureAirport]];
    
    NSMutableArray *arrivalAirportResultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *arrivalAirportKeys = [_arrivalAirportViewController.arrivalAirportTabDictionary allKeys];
    
    if ([arrivalAirportKeys count] == 0) {
        [Utils alert:@"请选择到达机场"];
        return;
    }
    
    for (NSString *arrivalAirportKey in arrivalAirportKeys) {
        [arrivalAirportResultArray addObject:[_arrivalAirportViewController.arrivalAirportArray safeObjectAtIndex:[arrivalAirportKey integerValue]]];
    }
    [_filterConditions setValue:arrivalAirportResultArray forKey:[NSString stringWithFormat:@"%d", FilterArrivalAirport]];
    
    
    if (self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(searchFilterController:didFinishedWithInfo:)]) {
        [self.filterDelegate searchFilterController:self didFinishedWithInfo:_filterConditions];
    }
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)back {
    //    [self reset];
    // Clear all.
    if ([[_filterConditions safeObjectForKey:@"0"] count] != 0 && [[_filterConditions safeObjectForKey:@"1"] count] != 0 && [[_filterConditions safeObjectForKey:@"2"] count] != 0) {
        for (NSInteger airlineIndex = 0; airlineIndex < [_airlineViewController.airlineArray count]; airlineIndex++) {
            if ([[_airlineViewController.airlineTabDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", airlineIndex]]) {
                [_airlineViewController setAirlineIndex:airlineIndex];
            }
        }
        
        for (NSInteger departureAirportIndex = 0; departureAirportIndex < [_departureAirportViewController.departureAirportArray count]; departureAirportIndex++) {
            if ([[_departureAirportViewController.departureAirportTabDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", departureAirportIndex]]) {
                [_departureAirportViewController setDepartureAirportIndex:departureAirportIndex];
            }
        }
        
        for (NSInteger arrivalAirportIndex = 0; arrivalAirportIndex < [_arrivalAirportViewController.arrivalAirportArray count]; arrivalAirportIndex++) {
            if ([[_arrivalAirportViewController.arrivalAirportTabDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", arrivalAirportIndex]]) {
                [_arrivalAirportViewController setArrivalAirportIndex:arrivalAirportIndex];
            }
        }
        for (UIView *subView in [self.displayContainer subviews]) {
            [subView removeFromSuperview];
        }
        [self clearItems];
        
        // Set back.
        if (self.airlineViewController != nil) {
            if (_filterConditions && [[_filterConditions safeObjectForKey:@"0"] count] != 0) {
                NSArray *airlineArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterAirline]];
                if ([[_filterConditions safeObjectForKey:@"0"] count] != [_airline count] + 1) {
                    for (NSString *airlineKey in airlineArray) {
                        NSUInteger index = [_airlineViewController.airlineArray indexOfObject:airlineKey];
                        //                [_airlineViewController.airlineTabDictionary setValue:[_airlineViewController.airlineArray objectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
                        //                    [_airlineViewController setAirlineIndex:index];
                        FlightCheckboxCell *cell = (FlightCheckboxCell *)[_airlineViewController.airlineTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                        [_airlineViewController tableViewCell:cell selected:NO];
                        //                    [self flightFilterAirlineViewCtrontroller:_airlineViewController didSelectIndex:index];
                    }
                }
                else if ([[_filterConditions safeObjectForKey:@"0"] count] == [_airline count] + 1 && [_airlineViewController.airlineTabDictionary count] == 0) {
                    for (NSInteger airlineIndex = 0; airlineIndex < [_airlineViewController.airlineArray count]; airlineIndex++) {
                        [_airlineViewController setAirlineIndex:airlineIndex];
                    }
                }
                //            [_airlineViewController.airlineTableView reloadData];
            }
        }
        
        if (self.departureAirportViewController != nil) {
            if (_filterConditions && [[_filterConditions safeObjectForKey:@"1"] count] != 0) {
                NSArray *departureArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterDepartureAirport]];
                if ([[_filterConditions safeObjectForKey:@"1"] count] != [_departureAirport count] + 1) {
                    for (NSString *departureKey in departureArray) {
                        NSUInteger index = [_departureAirportViewController.departureAirportArray indexOfObject:departureKey];
                        //                [_departureAirportViewController.departureAirportTabDictionary setValue:[_departureAirportViewController.departureAirportArray objectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
                        //                    [_departureAirportViewController setDepartureAirportIndex:index];
                        //                    [self flightFilterDepartureAirportViewCtrontroller:_departureAirportViewController didSelectIndex:index];
                        FlightCheckboxCell *cell = (FlightCheckboxCell *)[_departureAirportViewController.departureAirportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                        [_departureAirportViewController tableViewCell:cell selected:NO];
                    }
                }
                else if ([_departureAirportViewController.departureAirportTabDictionary count] == 0) {
                    for (NSString *departureKey in departureArray) {
                        NSUInteger index = [_departureAirportViewController.departureAirportArray indexOfObject:departureKey];
                        [_departureAirportViewController setDepartureAirportIndex:index];
                    }
                }
                //            [_departureAirportViewController.departureAirportTableView reloadData];
            }
        }
        
        if (self.arrivalAirportViewController != nil) {
            if (_filterConditions && [[_filterConditions safeObjectForKey:@"2"] count] != 0) {
                NSArray *arrivalArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterArrivalAirport]];
                if ([[_filterConditions safeObjectForKey:@"2"] count] != [_arrivalAirport count] + 1) {
                    for (NSString *arrivalKey in arrivalArray) {
                        NSUInteger index = [_arrivalAirportViewController.arrivalAirportArray indexOfObject:arrivalKey];
                        //                [_arrivalAirportViewController.arrivalAirportTabDictionary setValue:[_arrivalAirportViewController.arrivalAirportArray objectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
                        //                    [_arrivalAirportViewController setArrivalAirportIndex:index];
                        //                    [self flightFilterArrivalAirportViewCtrontroller:_arrivalAirportViewController didSelectIndex:index];
                        FlightCheckboxCell *cell = (FlightCheckboxCell *)[_arrivalAirportViewController.arrivalAirportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                        [_arrivalAirportViewController tableViewCell:cell selected:NO];
                    }
                }
                else if ([_arrivalAirportViewController.arrivalAirportTabDictionary count] == 0) {
                    for (NSString *arrivalKey in arrivalArray) {
                        NSUInteger index = [_arrivalAirportViewController.arrivalAirportArray indexOfObject:arrivalKey];
                        [_arrivalAirportViewController setArrivalAirportIndex:index];
                    }
                }
                //            [_arrivalAirportViewController.arrivalAirportTableView reloadData];
            }
        }
    }
    
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    //    [self popModalViewControllerAnimated:YES];
}

#pragma mark -  TrainSearchTypeDelegate

- (void)flightFilterAirlineViewCtrontroller:(FlightFilterAirlineViewController *)controller didSelectIndex:(NSUInteger)index {
    NSMutableDictionary *tabDictionary = controller.airlineTabDictionary;
    NSString *selectedKey = [NSString stringWithFormat:@"%d", index];
    // 当前是选中状态
    if ([tabDictionary objectForKey:selectedKey]) {
        // 将除点击外的cell,其他cell都添加tab
        if ([tabDictionary count] == controller.airlineArray.count) {
            [tabDictionary removeObjectForKey:selectedKey];
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterAirline;
                
                [self addItem:[_airlineViewController.airlineArray safeObjectAtIndex:tabIndex] withStartPoint:self.touchPoint withTag:buttonIndex];
            }
        }
        // 删除当前cell已经添加的tab
        else {
            [tabDictionary removeObjectForKey:selectedKey];
            [self deleteItem:index + kFilterAirline animated:NO];
        }
    }
    
    // 当前不是选中状态
    else {
        // 如果新加入后正好是全选状态,移除当前所有的tab
        if (tabDictionary.count + 1 == controller.airlineArray.count) {
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterAirline;
                [self deleteItem:buttonIndex animated:NO];
            }
        }
        else {
            [self addItem:[_airlineViewController.airlineArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:index + kFilterAirline];
        }
        [tabDictionary setValue:[controller.airlineArray safeObjectAtIndex:index] forKey:selectedKey];
    }
    
    if ([tabDictionary safeObjectForKey:@"0"] == nil && [[tabDictionary allKeys] count] == [controller.airlineArray count] - 1) {
        for (NSString *airlineKey in [tabDictionary allKeys]) {
            [controller tableView:controller.airlineTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[airlineKey integerValue] inSection:0]];
        }
        [controller tableView:controller.airlineTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    if ([tabDictionary safeObjectForKey:@"0"] != nil && [[tabDictionary allKeys] count] == [controller.airlineArray count] - 1) {
        [self deleteItem:0 + kFilterAirline animated:NO];
        [controller setAirlineIndex:0];
    }
    
    // 高度变化大小
    CGFloat heightMargin = 44;
    if (IOSVersion_7)
    {
        heightMargin = 44;
    }
    
    NSUInteger itemCount = [self.displayContainer subviews].count;
    if (itemCount > 0 && !_topItemAddFlag)
    {
        _topItemAddFlag = YES;
        _topItemRemoveFlag = NO;
        
        [controller.airlineTableView setViewHeight:(controller.airlineTableView.frame.size.height-heightMargin)];
//        [controller.airlineTableView reloadData];    
    }
    else if (itemCount == 0 && !_topItemRemoveFlag)
    {
        _topItemRemoveFlag = YES;
        _topItemAddFlag = NO;
        
        [controller.airlineTableView setViewHeight:(controller.airlineTableView.frame.size.height+heightMargin)];
//        [controller.airlineTableView reloadData];
    }
}

#pragma mark -  TrainSearchDepartureTimeDelegate
- (void)flightFilterDepartureAirportViewCtrontroller:(FlightFilterDepartureAirportViewController *)controller didSelectIndex:(NSUInteger)index {
    NSMutableDictionary *tabDictionary = controller.departureAirportTabDictionary;
    
    NSString *selectedKey = [NSString stringWithFormat:@"%d", index];
    // 当前是选中状态
    if ([tabDictionary objectForKey:selectedKey]) {
        // 将除点击外的cell,其他cell都添加tab
        if ([tabDictionary count] == controller.departureAirportArray.count) {
            [tabDictionary removeObjectForKey:selectedKey];
            
            // Add
            if (controller.departureAirportArray.count == 2) {
                if ([tabDictionary count] == controller.departureAirportArray.count - 1) {
                    [controller setDepartureAirportIndex:0];
                    return;
                }
            }
            // End
            
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterDepartureAirport;
                
                [self addItem:[_departureAirportViewController.departureAirportArray safeObjectAtIndex:tabIndex] withStartPoint:self.touchPoint withTag:buttonIndex];
            }
        }
        // 删除当前cell已经添加的tab
        else {
            [tabDictionary removeObjectForKey:selectedKey];
            [self deleteItem:index + kFilterDepartureAirport animated:NO];
        }
    }
    
    // 当前不是选中状态
    else {
        // 如果新加入后正好是全选状态,移除当前所有的tab
        if (tabDictionary.count + 2 == controller.departureAirportArray.count) {
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterDepartureAirport;
                [self deleteItem:buttonIndex animated:NO];
            }
        }
        else {
            [self addItem:[_departureAirportViewController.departureAirportArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:index + kFilterDepartureAirport];
        }
        [tabDictionary setValue:[controller.departureAirportArray safeObjectAtIndex:index] forKey:selectedKey];
    }
    
    if ([tabDictionary safeObjectForKey:@"0"] == nil && [[tabDictionary allKeys] count] == [controller.departureAirportArray count] - 1) {
        for (NSString *departureAirportKey in [tabDictionary allKeys]) {
            [controller tableView:controller.departureAirportTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[departureAirportKey integerValue] inSection:0]];
        }
        [controller tableView:controller.departureAirportTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    if ([tabDictionary safeObjectForKey:@"0"] != nil && [[tabDictionary allKeys] count] == [controller.departureAirportArray count] - 1) {
        [self deleteItem:0 + kFilterDepartureAirport animated:NO];
        [controller setDepartureAirportIndex:0];
    }
}

#pragma mark -  TrainSearchArrivalTimeDelegate
- (void)flightFilterArrivalAirportViewCtrontroller:(FlightFilterArrivalAirportViewController *)controller didSelectIndex:(NSUInteger)index {
    NSMutableDictionary *tabDictionary = controller.arrivalAirportTabDictionary;
    
    NSString *selectedKey = [NSString stringWithFormat:@"%d", index];
    // 当前是选中状态
    if ([tabDictionary objectForKey:selectedKey]) {
        // 将除点击外的cell,其他cell都添加tab
        if ([tabDictionary count] == controller.arrivalAirportArray.count) {
            [tabDictionary removeObjectForKey:selectedKey];
            
            // Add
            if (controller.arrivalAirportArray.count == 2) {
                if ([tabDictionary count] == controller.arrivalAirportArray.count - 1) {
                    [controller setArrivalAirportIndex:0];
                    return;
                }
            }
            // End
            
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterArrivalAirport;
                
                [self addItem:[_arrivalAirportViewController.arrivalAirportArray safeObjectAtIndex:tabIndex] withStartPoint:self.touchPoint withTag:buttonIndex];
            }
        }
        // 删除当前cell已经添加的tab
        else {
            [tabDictionary removeObjectForKey:selectedKey];
            [self deleteItem:index + kFilterArrivalAirport  animated:NO];
        }
    }
    
    // 当前不是选中状态
    else {
        // 如果新加入后正好是全选状态,移除当前所有的tab
        if (tabDictionary.count + 1 == controller.arrivalAirportArray.count) {
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterArrivalAirport;
                [self deleteItem:buttonIndex animated:NO];
            }
        }
        else {
            [self addItem:[_arrivalAirportViewController.arrivalAirportArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:index + kFilterArrivalAirport];
        }
        [tabDictionary setValue:[controller.arrivalAirportArray safeObjectAtIndex:index] forKey:selectedKey];
    }
    
    if ([tabDictionary safeObjectForKey:@"0"] == nil && [[tabDictionary allKeys] count] == [controller.arrivalAirportArray count] - 1) {
        for (NSString *departureAirportKey in [tabDictionary allKeys]) {
            [controller tableView:controller.arrivalAirportTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[departureAirportKey integerValue] inSection:0]];
        }
        [controller tableView:controller.arrivalAirportTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    if ([tabDictionary safeObjectForKey:@"0"] != nil && [[tabDictionary allKeys] count] == [controller.arrivalAirportArray count] - 1) {
        [self deleteItem:0 + kFilterArrivalAirport animated:NO];
        [controller setArrivalAirportIndex:0];
    }
}

@end
