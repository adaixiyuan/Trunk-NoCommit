//
//  HotelStarFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelStarFilterController.h"

@interface HotelStarFilterController ()

@end

@implementation HotelStarFilterController
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dealloc{
    self.tableView.delegate=nil;
    self.selectedIndexs = nil;
    self.starArray = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.starArray = [NSArray arrayWithObjects:
                          STAR_LIMITED_NONE,
                          STAR_LIMITED_FIVE,
                          STAR_LIMITED_FOUR,
                          STAR_LIMITED_THREE,
                          STAR_LIMITED_OTHER, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 单选模式
    if (self.selectedIndexs == nil) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    self.tableView.backgroundColor=[UIColor whiteColor];
}

- (void) setStarArray:(NSArray *)starArray{
    [_starArray release];
    _starArray = starArray;
    [_starArray retain];
    
    [self.tableView reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if ([self isViewLoaded]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void) setSelectedIndexs:(NSMutableArray *)selectedIndexs{
    [_selectedIndexs release];
    _selectedIndexs = selectedIndexs;
    [_selectedIndexs retain];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.starArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        if (self.selectedIndexs) {
            cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleCheckBox] autorelease];
        }else{
            cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleChoose] autorelease];
        }
        
        [cell.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    if (self.selectedIndexs) {
        BOOL checked = [[self.selectedIndexs safeObjectAtIndex:indexPath.row] boolValue];
        cell.checked = checked;
    }
    
    cell.textLabel.text = [_starArray safeObjectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexs) {
        if (indexPath.row == 0) {
            // 全部选中
            for (int i = 0; i < self.selectedIndexs.count; i++) {
                [self.selectedIndexs replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }
            [self.selectedIndexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
            [self.tableView reloadData];
        }else{
            BOOL checked = ![[self.selectedIndexs safeObjectAtIndex:indexPath.row] boolValue];
            [self.selectedIndexs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:checked]];
            
            
            // 如果所有的星级都被选中则把第一项选中，否则第一项不选中
            BOOL isALlSelected = YES;
            BOOL isAllNoSelected = YES;
            for (int i = 1; i < self.selectedIndexs.count; i++) {
                if (![[self.selectedIndexs objectAtIndex:i] boolValue]) {
                    isALlSelected = NO;
                }else{
                    isAllNoSelected = NO;
                }
            }
            if (isALlSelected || isAllNoSelected) {
                // 第一项选中
                [self.selectedIndexs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
                for (int i = 1; i < self.selectedIndexs.count; i++) {
                    [self.selectedIndexs replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                }
                
            }else{
                // 第一项不选中
                [self.selectedIndexs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
            }
            
            [self.tableView reloadData];
        }
        
        if([self.delegate respondsToSelector:@selector(hotelStarFilterController:didSelectIndexs:)]){
            [self.delegate hotelStarFilterController:self didSelectIndexs:self.selectedIndexs];
        }
    }else{
        [_delegate hotelStarFilterController:self didSelectIndex:indexPath.row];
    }
}

@end
