//
//  HotelFacilityFilterController.m
//  ElongClient
//
//  Created by Dawn on 14-3-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelFacilityFilterController.h"

@interface HotelFacilityFilterController (){
    UITableView *facilityList;
    BOOL isall;
}
@end

@implementation HotelFacilityFilterController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) dealloc{
    self.facilityArray  = nil;
    self.delegate       = nil;
    self.selectedIndexs = nil;
    [super dealloc];
}


- (id) init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    facilityList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    facilityList.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    facilityList.dataSource = self;
    facilityList.separatorStyle = UITableViewCellSeparatorStyleNone;
    facilityList.delegate = self;
    [self.view addSubview:facilityList];
    [facilityList release];
}

- (void) setSelectedIndexs:(NSMutableArray *)selectedIndexs{
    [_selectedIndexs release];
    _selectedIndexs = selectedIndexs;
    [_selectedIndexs retain];
    
    [facilityList reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.facilityArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"FacilityCell";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleCheckBox] autorelease];
        [cell.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    cell.textLabel.text = [self.facilityArray safeObjectAtIndex:indexPath.row];
    BOOL checked = [[self.selectedIndexs safeObjectAtIndex:indexPath.row] boolValue];
    cell.checked = checked;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.facilityArray.count <= 1) {
        return;
    }
    
    if (indexPath.row == 0) {
        // 全部选中
        for (int i = 0; i < self.selectedIndexs.count; i++) {
            [self.selectedIndexs replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
        [self.selectedIndexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        [facilityList reloadData];
    }else{
        BOOL checked = ![[self.selectedIndexs safeObjectAtIndex:indexPath.row] boolValue];
        [self.selectedIndexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:checked]];
        
        // 如果所有的设施都被选中则把第一项选中，否则第一项不选中
        BOOL isALlSelected = YES;
        BOOL isAllNoSelected = YES;
        for (int i = 1; i < self.selectedIndexs.count; i++) {
            if (![[self.selectedIndexs objectAtIndex:i] boolValue]) {
                isALlSelected = NO;
            }else{
                isAllNoSelected = NO;
            }
        }
        if (isAllNoSelected) {
            // 第一项选中
            [self.selectedIndexs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
            for (int i = 1; i < self.selectedIndexs.count; i++) {
                [self.selectedIndexs replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }
        }else{
            // 第一项不选中
            [self.selectedIndexs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
        }
        
        [facilityList reloadData];
    }
    
    if ([self.delegate respondsToSelector:@selector(hotelFacilityFilterController:didSelectIndexs:)]) {
        [self.delegate hotelFacilityFilterController:self didSelectIndexs:self.selectedIndexs];
    }
}



@end
