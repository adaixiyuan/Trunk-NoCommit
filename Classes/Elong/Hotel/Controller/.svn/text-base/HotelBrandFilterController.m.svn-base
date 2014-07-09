//
//  HotelBrandFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelBrandFilterController.h"
#import "JHotelSearch.h"

@interface HotelBrandFilterController ()
@property (nonatomic,retain) NSMutableArray *brandSelectIndexs;
@property (nonatomic,retain) NSMutableArray *chainSelectIndexs;
@end

@implementation HotelBrandFilterController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    self.tableView.delegate=nil;
    self.selectedIndexs = nil;
    self.chainArray = nil;
    self.brandArray = nil;
    self.brandSelectIndexs = nil;
    self.chainSelectIndexs = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
    if (brandSeg) {
        self.tableView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 * 3 - 20);
    }else{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 * 2 - 20);
    }
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)] autorelease];
}

- (void) setNeedChain{
    [self addSwitchItem];
}


// 添加顶部的切换栏
- (void)addSwitchItem
{
    //增加国内酒店以及国际酒店选项
    if (brandSeg==nil) {
        NSArray *titleArray = [NSArray arrayWithObjects:@"品牌", @"连锁", nil];
        brandSeg = [[CustomSegmented alloc] initSegmentedWithFrame:CGRectMake((SCREEN_WIDTH - 60 - 170)/2, 8, 170, 28) titles:titleArray normalIcons:nil highlightIcons:nil];
        brandSeg.delegate = self;
        [self.view addSubview:brandSeg];
        [brandSeg release];
        
        if (self.isChain) {
            brandSeg.selectedIndex = 1;
        }else{
            brandSeg.selectedIndex = 0;
        }
    }
}


#pragma mark -
#pragma mark CustomSegmentedDelegate 
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index{
    if (index == 0) {
        self.isChain = NO;
    }else{
        self.isChain = YES;
    }
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark Private Method

- (void) setSelectedIndexs:(NSMutableArray *)selectedIndexs{
    if (self.isChain) {
        self.chainSelectIndexs = [NSMutableArray arrayWithArray:selectedIndexs];
        self.brandSelectIndexs = nil;
        [self resetBrandSelectIndexs];
    }else{
        self.brandSelectIndexs = [NSMutableArray arrayWithArray:selectedIndexs];
        self.chainSelectIndexs = nil;
        [self resetChainSelectIndexs];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *) selectedIndexs{
    if (self.isChain) {
        return self.chainSelectIndexs;
    }else{
        return self.brandSelectIndexs;
    }
}

- (void) resetChainSelectIndexs{
    if (!self.chainSelectIndexs) {
        self.chainSelectIndexs = [NSMutableArray arrayWithArray:0];
        for (int i = 0; i < self.chainArray.count; i++) {
            [self.chainSelectIndexs addObject:[NSNumber numberWithBool:NO]];
        }
    }else{
        for (int i = 0; i < self.chainArray.count; i++) {
            [self.chainSelectIndexs replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
    }
    if (self.chainArray.count) {
        [self.chainSelectIndexs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    }
}

- (void) resetBrandSelectIndexs{
    if(!self.brandSelectIndexs){
        self.brandSelectIndexs = [NSMutableArray arrayWithArray:0];
        for (int i = 0; i < self.brandArray.count; i++) {
            [self.brandSelectIndexs addObject:[NSNumber numberWithBool:NO]];
        }
    }else{
        for (int i = 0 ; i < self.brandArray.count; i++) {
            [self.brandSelectIndexs replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
    }
    if (self.brandArray.count) {
        [self.brandSelectIndexs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    }
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (brandSeg.selectedIndex == 0) {
        return self.brandArray.count;
    }else{
        return self.chainArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleCheckBox] autorelease];
        [cell.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    if (self.isChain) {
        cell.textLabel.text = [self.chainArray safeObjectAtIndex:indexPath.row];
        BOOL checked = [[self.chainSelectIndexs safeObjectAtIndex:indexPath.row] boolValue];
        cell.checked = checked;
    }else{
        cell.textLabel.text = [self.brandArray safeObjectAtIndex:indexPath.row];
        BOOL checked = [[self.brandSelectIndexs safeObjectAtIndex:indexPath.row] boolValue];
        cell.checked = checked;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.brandArray.count <= 1) {
        return;
    }

    if (self.isChain) {
        self.brandSelectIndexs = nil;
        [self resetBrandSelectIndexs];
    }else{
        self.chainSelectIndexs = nil;
        [self resetChainSelectIndexs];
    }
    
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
        
        
        if (!self.isChain) {
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
        }else{
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
        }
        
        
        
        [self.tableView reloadData];
    }

    if ([self.delegate respondsToSelector:@selector(hotelBrandFilterController:didSelectIndexs:isChain:)]) {
        [self.delegate hotelBrandFilterController:self didSelectIndexs:self.selectedIndexs isChain:self.isChain];
    }
}



@end
