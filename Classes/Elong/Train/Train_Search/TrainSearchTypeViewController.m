//
//  TrainSearchTypeViewController.m
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainSearchTypeViewController.h"

#define kTypeTableViewCellTag 1024

@interface TrainSearchTypeViewController ()

@end

@implementation TrainSearchTypeViewController

- (void)dealloc {
    self.typeArray = nil;
    self.typeTableView = nil;
    self.typeTabDictionary = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.onlyCRH = FALSE;
        self.typeTabDictionary = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    for (NSUInteger index = 0; index < [_typeArray count]; index++) {
//        [_typeTabDictionary setValue:[_typeArray safeObjectAtIndex:index] forKey:[NSString stringWithFormat:@"%d", index]];
//    }
//    if (_onlyCRH) {
//        [_typeTabDictionary setValue:[_typeArray safeObjectAtIndex:FilterTypeCRH] forKey:[NSString stringWithFormat:@"%d", FilterTypeCRH]];
//    }
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, HSC_CELL_HEGHT * _typeArray.count)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    self.typeTableView = tempTableView;
    [tempTableView release];
    
    [self.view addSubview:_typeTableView];
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
	return [_typeArray count];
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
        cell.tag = kTypeTableViewCellTag + indexPath.row;
        
        
//        else {
//            cell = [[CheckboxCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT selected:NO];
//        }
    }
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    if ([_typeTabDictionary safeObjectForKey:key]) {
        //            [self setTypeIndex:indexPath.row];
        [cell setCheckBoxButtonSelected:YES];
        [_typeTabDictionary removeObjectForKey:key];
        [self tableViewCell:cell selected:YES];
    }
//    if (_onlyCRH && indexPath.row == FilterTypeCRH) {
//        [self tableViewCell:cell selected:YES];
//        cell.checkBoxButton.selected = YES;
//    }
    
    cell.cellTextLabel.text = [_typeArray safeObjectAtIndex:indexPath.row];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckboxCell *cell = (CheckboxCell *)[_typeTableView cellForRowAtIndexPath:indexPath];
    [cell buttonClicked:cell.checkBoxButton];
}


#pragma mark - CheckboxDelegate
- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected {
    if (_delegate && [_delegate respondsToSelector:@selector(trainSearchTypeViewCtrontroller:didSelectIndex:)]) {
        [_delegate trainSearchTypeViewCtrontroller:self didSelectIndex:cell.tag - kTypeTableViewCellTag];
    }
}

#pragma mark - Custom Method
- (void)setTypeIndex:(NSUInteger)index {
    CheckboxCell *cell = (CheckboxCell *)[_typeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSString *key = [NSString stringWithFormat:@"%d", index];
    if ([cell.checkBoxButton isSelected]) {
        [cell setCheckBoxButtonSelected:NO];
        [_typeTabDictionary removeObjectForKey:key];
    }
    else {
        [cell setCheckBoxButtonSelected:YES];
        [_typeTabDictionary setValue:[_typeArray safeObjectAtIndex:index] forKey:key];
    }
}

@end
