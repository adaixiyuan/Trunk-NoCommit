//
//  FlightFilterAirlineViewController.m
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightFilterAirlineViewController.h"

#define kAirlineTableViewCellTag 1024

@interface FlightFilterAirlineViewController ()

@end

@implementation FlightFilterAirlineViewController

- (void)dealloc
{
    self.airlineArray = nil;
    _airlineTableView.dataSource = nil;
    _airlineTableView.delegate = nil;
    self.airlineTableView = nil;
    self.airlineTabDictionary = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.airlineTabDictionary = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, HSC_CELL_HEGHT * _airlineArray.count)];

    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, MAINCONTENTHEIGHT-44)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.airlineTableView = tempTableView;
    [tempTableView release];
    
    [self.view addSubview:_airlineTableView];
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
	return [_airlineArray count];
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
        cell.tag = kAirlineTableViewCellTag + indexPath.row;
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, HSC_CELL_HEGHT - 0.5f, SCREEN_WIDTH, 0.5f)]];
    }
    
    if (indexPath.row > 0) {
        [cell setAirlineImageViewImage:[UIImage noCacheImageNamed:[Utils getAirCorpPicName:[_airlineArray safeObjectAtIndex:indexPath.row]]]];
    }
    cell.cellTextLabel.text = [_airlineArray safeObjectAtIndex:indexPath.row];
    
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    
    if ([_airlineTabDictionary safeObjectForKey:key]) {
        [cell setCheckBoxButtonSelected:YES];
//        if (indexPath.row == 0) {
//            [_airlineTabDictionary removeObjectForKey:key];
//            [self tableViewCell:cell selected:YES];
//        }
//        else {
//            CheckboxCell *firstCheckboxCell = (CheckboxCell *)[_airlineTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//            
//            if (!firstCheckboxCell.selected) {
//                [_airlineTabDictionary removeObjectForKey:key];
//                [self tableViewCell:cell selected:YES];
//            }
//        }
    }
    else {
        [cell setCheckBoxButtonSelected:NO];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightCheckboxCell *cell = (FlightCheckboxCell *)[_airlineTableView cellForRowAtIndexPath:indexPath];
    [cell buttonClicked:cell.checkBoxButton];
}


#pragma mark - CheckboxDelegate
- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected {
    NSUInteger cellIndex = cell.tag - kAirlineTableViewCellTag;
    FlightCheckboxCell *checkBoxCell = (FlightCheckboxCell *)cell;

    // 全部
    if (cellIndex == 0) {
        if ([_airlineTabDictionary count] != 0 && [_airlineTabDictionary count] < [_airlineArray count]) {
            NSArray *existArray = [_airlineTabDictionary allKeys];
            for (NSString *airlineKey in existArray) {
                if (_delegate && [_delegate respondsToSelector:@selector(flightFilterAirlineViewCtrontroller:didSelectIndex:)]) {
                    [_delegate flightFilterAirlineViewCtrontroller:self didSelectIndex:[airlineKey integerValue]];
                }
            }
            
            for (NSUInteger airlineIndex = 0; airlineIndex < [_airlineArray count]; airlineIndex++) {
                if (![existArray containsObject:[NSString stringWithFormat:@"%d", airlineIndex]]) {
                    [self setAirlineIndex:airlineIndex];
                }
                else {
                    [_airlineTabDictionary setValue:[_airlineArray safeObjectAtIndex:airlineIndex] forKey:[NSString stringWithFormat:@"%d", airlineIndex]];
                }
            }
            return;
        }
        
        for (NSUInteger airlineIndex = 0; airlineIndex < [_airlineArray count]; airlineIndex++) {
            [self setAirlineIndex:airlineIndex];
        }
        return;

    }

    [checkBoxCell setCheckBoxButtonSelected:!selected];
    if (_delegate && [_delegate respondsToSelector:@selector(flightFilterAirlineViewCtrontroller:didSelectIndex:)]) {
        [_delegate flightFilterAirlineViewCtrontroller:self didSelectIndex:cellIndex];
    }
}

#pragma mark - Custom Method
- (void)setAirlineIndex:(NSUInteger)index {
//    FlightCheckboxCell *cell = (FlightCheckboxCell *)[_airlineTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    NSString *key = [NSString stringWithFormat:@"%d", index];
//    if (cell.checkBoxButton.selected) {
//        [cell setCheckBoxButtonSelected:NO];
//        [_airlineTabDictionary removeObjectForKey:key];
//    }
//    else {
//        [cell setCheckBoxButtonSelected:YES];
//        [_airlineTabDictionary setValue:[_airlineArray safeObjectAtIndex:index] forKey:key];
//    }
    NSString *key = [NSString stringWithFormat:@"%d", index];
    if ([_airlineTabDictionary safeObjectForKey:key]) {
        [_airlineTabDictionary removeObjectForKey:key];
    }
    else {
        [_airlineTabDictionary setValue:[_airlineArray safeObjectAtIndex:index] forKey:key];
    }
    [_airlineTableView reloadData];
}

@end
