//
//  FlightFilterArrivalAirportViewController.m
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightFilterArrivalAirportViewController.h"

#define kArrivalAirportTableViewCellTag (1024 + 200)

@interface FlightFilterArrivalAirportViewController ()

@end

@implementation FlightFilterArrivalAirportViewController

- (void)dealloc
{
    self.arrivalAirportArray = nil;
    self.arrivalAirportTabDictionary = nil;
    
    _arrivalAirportTableView.dataSource = nil;
    _arrivalAirportTableView.delegate = nil;
    self.arrivalAirportTableView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrivalAirportTabDictionary = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, HSC_CELL_HEGHT * _arrivalAirportArray.count)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.arrivalAirportTableView = tempTableView;
    [tempTableView release];
    
    [self.view addSubview:_arrivalAirportTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrivalAirportArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HSC_CELL_HEGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	FlightCheckboxCell *cell = (FlightCheckboxCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (!cell) {
        cell = [[FlightCheckboxCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT selected:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.tag = kArrivalAirportTableViewCellTag + indexPath.row;
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, HSC_CELL_HEGHT - 0.5f, SCREEN_WIDTH, 0.5f)]];
    }
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    if ([_arrivalAirportTabDictionary objectForKey:key]) {
        [cell setCheckBoxButtonSelected:YES];
//        [_arrivalAirportTabDictionary removeObjectForKey:key];
//        [self tableViewCell:cell selected:YES];
    }
    else {
        [cell setCheckBoxButtonSelected:YES];
    }
    cell.cellTextLabel.text = [_arrivalAirportArray safeObjectAtIndex:indexPath.row];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightCheckboxCell *cell = (FlightCheckboxCell *)[_arrivalAirportTableView cellForRowAtIndexPath:indexPath];
    [cell buttonClicked:cell.checkBoxButton];
}

#pragma mark - CheckboxDelegate
- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected {
//    if (_delegate && [_delegate respondsToSelector:@selector(flightFilterArrivalAirportViewCtrontroller:didSelectIndex:)]) {
//        [_delegate flightFilterArrivalAirportViewCtrontroller:self didSelectIndex:cell.tag - kArrivalAirportTableViewCellTag];
//    }
    
    NSUInteger cellIndex = cell.tag - kArrivalAirportTableViewCellTag;
    FlightCheckboxCell *checkBoxCell = (FlightCheckboxCell *)cell;
    
    // 全部
    if (cellIndex == 0) {
        if ([_arrivalAirportTabDictionary count] != 0 && [_arrivalAirportTabDictionary count] < [_arrivalAirportArray count]) {
            NSArray *existArray = [_arrivalAirportTabDictionary allKeys];
            for (NSString *arrivalAirportKey in existArray) {
                if (_delegate && [_delegate respondsToSelector:@selector(flightFilterArrivalAirportViewCtrontroller:didSelectIndex:)]) {
                    [_delegate flightFilterArrivalAirportViewCtrontroller:self didSelectIndex:[arrivalAirportKey integerValue]];
                }
            }
            
            for (NSUInteger arrivalAirportIndex = 0; arrivalAirportIndex < [_arrivalAirportArray count]; arrivalAirportIndex++) {
                if (![existArray containsObject:[NSString stringWithFormat:@"%d", arrivalAirportIndex]]) {
                    [self setArrivalAirportIndex:arrivalAirportIndex];
                }
                else {
                    [_arrivalAirportTabDictionary setValue:[_arrivalAirportArray safeObjectAtIndex:arrivalAirportIndex] forKey:[NSString stringWithFormat:@"%d", arrivalAirportIndex]];
                }
            }
            return;
        }
        
        for (NSUInteger departureAirportIndex = 0; departureAirportIndex < [_arrivalAirportArray count]; departureAirportIndex++) {
            [self setArrivalAirportIndex:departureAirportIndex];
        }
        return;
        
    }
    
    [checkBoxCell setCheckBoxButtonSelected:!selected];
    if (_delegate && [_delegate respondsToSelector:@selector(flightFilterArrivalAirportViewCtrontroller:didSelectIndex:)]) {
        [_delegate flightFilterArrivalAirportViewCtrontroller:self didSelectIndex:cellIndex];
    }
}

#pragma mark - Custom Method
- (void)setArrivalAirportIndex:(NSUInteger)index {
    FlightCheckboxCell *cell = (FlightCheckboxCell *)[_arrivalAirportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSString *key = [NSString stringWithFormat:@"%d", index];
    if ([cell.checkBoxButton isSelected]) {
        [cell setCheckBoxButtonSelected:NO];
        [_arrivalAirportTabDictionary removeObjectForKey:key];
    }
    else {
        [cell setCheckBoxButtonSelected:YES];
        [_arrivalAirportTabDictionary setValue:[_arrivalAirportArray safeObjectAtIndex:index] forKey:key];
    }
}

@end
