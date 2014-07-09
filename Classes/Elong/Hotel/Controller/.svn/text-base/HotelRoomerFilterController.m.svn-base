//
//  HotelRoomerFilterController.m
//  ElongClient
//
//  Created by Dawn on 14-3-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelRoomerFilterController.h"

@interface HotelRoomerFilterController (){
    UITableView *numberList;
    BOOL isall;
    
}
@property (nonatomic,retain) NSArray *numberArray;
@end

@implementation HotelRoomerFilterController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) dealloc{
    self.delegate    = nil;
    self.numberArray = nil;
    [super dealloc];
}


- (id) init{
    if (self = [super init]) {
        self.numberArray = [NSArray arrayWithObjects:@"人数不限",@"1人",@"2人",@"3人",@"4人",@"5人",@"6人", nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    numberList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    numberList.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    numberList.dataSource = self;
    numberList.separatorStyle = UITableViewCellSeparatorStyleNone;
    numberList.delegate = self;
    [self.view addSubview:numberList];
    [numberList release];
}

- (void) setNumber:(NSInteger)number{
    _number = number;
    
    [numberList reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberArray.count;
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
    cell.textLabel.text = [self.numberArray safeObjectAtIndex:indexPath.row];
    if (indexPath.row == self.number) {
        cell.checked = YES;
    }else{
        cell.checked = NO;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.number = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(hotelRoomerFilterController:didSelectNumber:)]) {
        [self.delegate hotelRoomerFilterController:self didSelectNumber:self.number];
    }
}


@end
