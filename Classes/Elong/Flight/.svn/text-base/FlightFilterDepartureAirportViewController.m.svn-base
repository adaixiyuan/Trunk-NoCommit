//
//  FlightFilterDepartureAirportViewController.m
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightFilterDepartureAirportViewController.h"

#define kDepartureAirportTableViewCellTag (1024 + 100)

@interface FlightFilterDepartureAirportViewController ()

@end

@implementation FlightFilterDepartureAirportViewController

- (void)dealloc
{
    self.departureAirportArray = nil;
    self.departureAirportTabDictionary = nil;
    
    _departureAirportTableView.dataSource = nil;
    _departureAirportTableView.delegate = nil;
    self.departureAirportTableView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.departureAirportTabDictionary = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, HSC_CELL_HEGHT * _departureAirportArray.count)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.departureAirportTableView = tempTableView;
    [tempTableView release];
    
    [self.view addSubview:_departureAirportTableView];
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
	return [_departureAirportArray count];
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
        cell.tag = kDepartureAirportTableViewCellTag + indexPath.row;
        
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, HSC_CELL_HEGHT - 0.5f, SCREEN_WIDTH, 0.5f)]];
    }
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    if ([_departureAirportTabDictionary safeObjectForKey:key]) {
        [cell setCheckBoxButtonSelected:YES];
//        [_departureAirportTabDictionary removeObjectForKey:key];
//        [self tableViewCell:cell selected:YES];
    }
    else {
        [cell setCheckBoxButtonSelected:NO];
    }
    cell.cellTextLabel.text = [_departureAirportArray safeObjectAtIndex:indexPath.row];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightCheckboxCell *cell = (FlightCheckboxCell *)[_departureAirportTableView cellForRowAtIndexPath:indexPath];
    [cell buttonClicked:cell.checkBoxButton];
}


#pragma mark - CheckboxDelegate
- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected {
//    if (_delegate && [_delegate respondsToSelector:@selector(flightFilterDepartureAirportViewCtrontroller:didSelectIndex:)]) {
//        [_delegate flightFilterDepartureAirportViewCtrontroller:self didSelectIndex:cell.tag - kDepartureAirportTableViewCellTag];
//    }
    
    NSUInteger cellIndex = cell.tag - kDepartureAirportTableViewCellTag;
    FlightCheckboxCell *checkBoxCell = (FlightCheckboxCell *)cell;
    
    // 全部
    if (cellIndex == 0) {
        if ([_departureAirportTabDictionary count] != 0 && [_departureAirportTabDictionary count] < [_departureAirportArray count]) {
            NSArray *existArray = [_departureAirportTabDictionary allKeys];
            for (NSString *departureAirportKey in existArray) {
                if (_delegate && [_delegate respondsToSelector:@selector(flightFilterDepartureAirportViewCtrontroller:didSelectIndex:)]) {
                    [_delegate flightFilterDepartureAirportViewCtrontroller:self didSelectIndex:[departureAirportKey integerValue]];
                }
            }
            
            for (NSUInteger departureAirportIndex = 0; departureAirportIndex < [_departureAirportArray count]; departureAirportIndex++) {
                if (![existArray containsObject:[NSString stringWithFormat:@"%d", departureAirportIndex]]) {
                    [self setDepartureAirportIndex:departureAirportIndex];
                }
                else {
                    [_departureAirportTabDictionary setValue:[_departureAirportArray safeObjectAtIndex:departureAirportIndex] forKey:[NSString stringWithFormat:@"%d", departureAirportIndex]];
                }
            }
            return;
        }
        
        for (NSUInteger departureAirportIndex = 0; departureAirportIndex < [_departureAirportArray count]; departureAirportIndex++) {
            [self setDepartureAirportIndex:departureAirportIndex];
        }
        return;
        
    }
    
    [checkBoxCell setCheckBoxButtonSelected:!selected];
    if (_delegate && [_delegate respondsToSelector:@selector(flightFilterDepartureAirportViewCtrontroller:didSelectIndex:)]) {
        [_delegate flightFilterDepartureAirportViewCtrontroller:self didSelectIndex:cellIndex];
    }
}

#pragma mark - Custom Method
- (void)setDepartureAirportIndex:(NSUInteger)index {
    FlightCheckboxCell *cell = (FlightCheckboxCell *)[_departureAirportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSString *key = [NSString stringWithFormat:@"%d", index];
    if ([cell.checkBoxButton isSelected]) {
        [cell setCheckBoxButtonSelected:NO];
        [_departureAirportTabDictionary removeObjectForKey:key];
    }
    else {
        [cell setCheckBoxButtonSelected:YES];
        [_departureAirportTabDictionary setValue:[_departureAirportArray safeObjectAtIndex:index] forKey:key];
    }
}

@end
