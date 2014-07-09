//
//  HotelPayTypeFilterController.m
//  ElongClient
//
//  Created by Dawn on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelPayTypeFilterController.h"

@interface HotelPayTypeFilterController (){
@private
    UITableView *payTypeList;
}

@end

@implementation HotelPayTypeFilterController

- (void) dealloc{
    self.payTypeArray       = nil;
    self.delegate           = nil;
    self.selectedIndexs     = nil;
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    payTypeList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    payTypeList.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    payTypeList.dataSource = self;
    payTypeList.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTypeList.delegate = self;
    [self.view addSubview:payTypeList];
    [payTypeList release];
}

- (void) setSelectedIndexs:(NSMutableArray *)selectedIndexs{
    [_selectedIndexs release];
    _selectedIndexs = selectedIndexs;
    [_selectedIndexs retain];
    
    [payTypeList reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payTypeArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"PayTypeCell";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleCheckBox] autorelease];
        [cell.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    cell.textLabel.text = [self.payTypeArray safeObjectAtIndex:indexPath.row];
    BOOL checked = [[self.selectedIndexs safeObjectAtIndex:indexPath.row] boolValue];
    cell.checked = checked;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL checked = ![[self.selectedIndexs safeObjectAtIndex:indexPath.row] boolValue];
    [self.selectedIndexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:checked]];
    
    [payTypeList reloadData];
    
    if ([self.delegate respondsToSelector:@selector(hotelPayTypeFilterController:didSelectIndexs:)]) {
        [self.delegate hotelPayTypeFilterController:self didSelectIndexs:self.selectedIndexs];
    }
}

@end
