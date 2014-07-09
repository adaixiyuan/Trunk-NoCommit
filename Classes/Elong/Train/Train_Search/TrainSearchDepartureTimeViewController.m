//
//  TrainSearchDepartureTimeViewController.m
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainSearchDepartureTimeViewController.h"

#define kDepartureTimeTableViewCellTag (1024 + 100)

@interface TrainSearchDepartureTimeViewController ()

@end

@implementation TrainSearchDepartureTimeViewController

- (void)dealloc {
    self.departureTimeArray = nil;
    self.departureTimeTableView = nil;
    self.departureTimeTabDictionary = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.departureTimeTabDictionary = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    for (NSUInteger index = 0; index < [_departureTimeArray count]; index++) {
//        [_departureTimeTabDictionary setValue:[_departureTimeArray safeObjectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
//    }
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, HSC_CELL_HEGHT * _departureTimeArray.count)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    self.departureTimeTableView = tempTableView;
    [tempTableView release];
    
    [self.view addSubview:_departureTimeTableView];
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
	return [_departureTimeArray count];
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
    
    CheckboxCell *cell = (CheckboxCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (!cell) {
        cell = [[CheckboxCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT selected:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.tag = kDepartureTimeTableViewCellTag + indexPath.row;
    }
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    if ([_departureTimeTabDictionary objectForKey:key]) {
        [cell setCheckBoxButtonSelected:YES];
        [_departureTimeTabDictionary removeObjectForKey:key];
        [self tableViewCell:cell selected:YES];
    }
    cell.cellTextLabel.text = [_departureTimeArray safeObjectAtIndex:indexPath.row];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckboxCell *cell = (CheckboxCell *)[_departureTimeTableView cellForRowAtIndexPath:indexPath];
    [cell buttonClicked:cell.checkBoxButton];
}


#pragma mark - CheckboxDelegate
- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected {
    if (_delegate && [_delegate respondsToSelector:@selector(trainSearchDepartureTimeViewCtrontroller:didSelectIndex:)]) {
        [_delegate trainSearchDepartureTimeViewCtrontroller:self didSelectIndex:cell.tag - kDepartureTimeTableViewCellTag];
    }
}

#pragma mark - Custom Method
- (void)setDepartureTimeIndex:(NSUInteger)index {
    CheckboxCell *cell = (CheckboxCell *)[_departureTimeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSString *key = [NSString stringWithFormat:@"%d", index];
    if ([cell.checkBoxButton isSelected]) {
        [cell setCheckBoxButtonSelected:NO];
        [_departureTimeTabDictionary removeObjectForKey:key];
    }
    else {
        [cell setCheckBoxButtonSelected:YES];
        [_departureTimeTabDictionary setValue:[_departureTimeArray safeObjectAtIndex:index] forKey:key];
    }
}

@end
