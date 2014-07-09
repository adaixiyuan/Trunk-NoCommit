//
//  InterRoomerSelectorViewController.m
//  ElongClient
//
//  Created by Dawn on 13-6-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterRoomerSelectorViewController.h"
#import "InterRoomerSelectorCell.h"

#define ROOM_MAXNUM 8
#define ROOM_MINNUM 1
#define ADULT_MAXNUM 4
#define ADULT_MINNUM 1
#define CHILD_MAXNUM 3
#define CHILD_MINNUM 0

@interface InterRoomerSelectorViewController ()
@property (nonatomic,retain) NSMutableArray *roomerArray;
@property (nonatomic,retain) NSIndexPath *selectedIndexPath;
@end

@implementation InterRoomerSelectorViewController
@synthesize roomerArray;
@synthesize delegate;
@synthesize selectedIndexPath;


- (void) dealloc{
    self.roomerArray = nil;
    [super dealloc];
}

- (id) initWithRoomers:(NSArray *)roomers{
    if (self = [super initWithTopImagePath:nil andTitle:@"选择房间&入住人" style:_NavOnlyBackBtnStyle_]) {
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        // 接收传入数据，如果传入数据为空则用默认值初始化：1房间，2成人，0儿童
        if (roomers && roomers.count) {
            self.roomerArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dict in roomers) {
                NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict safeObjectForKey:@"adult"],@"adult",[dict safeObjectForKey:@"child"],@"child",[NSMutableArray arrayWithArray:[dict safeObjectForKey:@"age"]],@"age", nil];
                [self.roomerArray addObject:newDict];
            }
            
        }else{
            NSMutableDictionary *roomerDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"adult",[NSNumber numberWithInt:0],@"child",[NSMutableArray arrayWithCapacity:0],@"age", nil];
            self.roomerArray = [NSMutableArray arrayWithObjects:roomerDict, nil];
        }
        
        // 构造页面
        roomerList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        roomerList.separatorStyle = UITableViewCellSeparatorStyleNone;
        roomerList.delegate = self;
        roomerList.dataSource = self;
        roomerList.backgroundColor = [UIColor clearColor];
        [self.view addSubview:roomerList];
        [roomerList release];
        
        roomerList.tableFooterView  = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)] autorelease];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(clickConfirm)];
    }
    return self;
}


#pragma mark -
#pragma mark Actions
- (void)clickConfirm{
    NSLog(@"%@",self.roomerArray);
    for (int i = 0; i < self.roomerArray.count; i++) {
        NSArray *ageArray = [[self.roomerArray safeObjectAtIndex:i] safeObjectForKey:@"age"];
        if (ageArray) {
            for (int j = 0; j < ageArray.count; j++) {
                if ([[ageArray safeObjectAtIndex:j] intValue] == -1) {
                    NSString *errorMsg = [NSString stringWithFormat:@"请选择房间儿童年龄"];
                    [PublicMethods showAlertTitle:nil Message:errorMsg];
                    return;
                }
            }
        }
    }
    
    
    
    if ([delegate respondsToSelector:@selector(interRoomerSelectorVC:didSelectRoomers:)]) {
        [delegate interRoomerSelectorVC:self didSelectRoomers:self.roomerArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark InterRoomerSelectorCellDelegate

- (void) interRoomerSelectorCell:(InterRoomerSelectorCell *)cell minusButtonClick:(id)sender{
    switch (cell.personType) {
        case Roomer:{
            [self.roomerArray removeLastObject];
            [roomerList reloadData];
            break;
        }
        case Adult:{
            NSInteger adult = [cell.numLbl.text intValue];
            [cell.roomDict safeSetObject:[NSNumber numberWithInt:adult] forKey:@"adult"];
            [roomerList reloadData];
            break;
        }
        case Child:{
            NSInteger child = [cell.numLbl.text intValue];
            [cell.roomDict safeSetObject:[NSNumber numberWithInt:child] forKey:@"child"];
            [[cell.roomDict safeObjectForKey:@"age"] removeLastObject];
            [roomerList reloadData];
            break;
        }
        default:
            break;
    }
}

- (void) interRoomerSelectorCell:(InterRoomerSelectorCell *)cell plusButtonClick:(id)sender{
    switch (cell.personType) {
        case Roomer:{
            NSMutableDictionary *roomerDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"adult",[NSNumber numberWithInt:0],@"child",[NSMutableArray arrayWithCapacity:0],@"age", nil];
            
            [self.roomerArray addObject:roomerDict];
            [roomerList reloadData];
            break;
        }
        case Adult:{
            NSInteger adult = [cell.numLbl.text intValue];
            [cell.roomDict safeSetObject:[NSNumber numberWithInt:adult] forKey:@"adult"];
            [roomerList reloadData];
            break;
        }
        case Child:{
            NSInteger child = [cell.numLbl.text intValue];
            [cell.roomDict safeSetObject:[NSNumber numberWithInt:child] forKey:@"child"];
            [[cell.roomDict safeObjectForKey:@"age"] addObject:@"-1"];
            [roomerList reloadData];
            
            NSIndexPath *indexPath = [roomerList indexPathForCell:cell];
            [roomerList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self tableView:roomerList numberOfRowsInSection:indexPath.section] - 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.roomerArray.count + 1;  // 房间数量+1
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        NSDictionary *dict = (NSDictionary *)[self.roomerArray safeObjectAtIndex:section - 1];
        NSInteger child = [[dict safeObjectForKey:@"child"] intValue];
        return child + 1 + 1; 
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"RoomerSelectorCell";
    InterRoomerSelectorCell *cell = (InterRoomerSelectorCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[[InterRoomerSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 重置数据
    [cell reset];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置delegate
    cell.delegate = self;
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"房间数";
        // celltype
        [cell setCellType:NormalCell];
        // 数量选择控件
        [cell setActionHidden:NO];
        // 是否可点选
        cell.selectabled = NO;
        // 房量显示
        cell.numLbl.text = [NSString stringWithFormat:@"%d",self.roomerArray.count];
        // 最大最小值
        cell.minNum = ROOM_MINNUM;
        cell.maxNum = ROOM_MAXNUM;
        // 类型
        cell.personType = Roomer;
        
        if (self.roomerArray.count <= ROOM_MINNUM)
        {
            cell.minusBtn.hidden = YES;// .enabled = NO;
        }
        else
        {
            cell.minusBtn.hidden = NO; // .enabled = YES;
        }
        
        if (self.roomerArray.count >= ROOM_MAXNUM)
        {
            cell.plusBtn.hidden = YES; //.enabled = NO;
        }
        else
        {
            cell.plusBtn.hidden = NO;// .enabled = YES;
        }
    }
    else
    {
        // 成人和儿童的数量
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.roomerArray safeObjectAtIndex:indexPath.section - 1];
        NSInteger child = [[dict safeObjectForKey:@"child"] intValue];
        NSInteger adult = [[dict safeObjectForKey:@"adult"] intValue];
        cell.roomDict = dict;
        
        if (indexPath.row == 0)
        {
            cell.titleLabel.text = @"成人数";
            [cell setCellType:HeaderCell];
            [cell setActionHidden:NO];
            cell.selectabled = NO;
            cell.numLbl.text = [NSString stringWithFormat:@"%d", adult];
            cell.minNum = ADULT_MINNUM;
            cell.maxNum = ADULT_MAXNUM;
            cell.personType = Adult;
            
            if (adult <= ADULT_MINNUM)
            {
                cell.minusBtn.hidden = YES;// .enabled = NO;
            }
            else
            {
                cell.minusBtn.hidden = NO;// .enabled = YES;
            }
            if (adult >= ADULT_MAXNUM)
            {
                cell.plusBtn.hidden = YES;// .enabled = NO;
            }
            else
            {
                cell.plusBtn.hidden = NO;// .enabled = YES;
            }
        }
        else if(indexPath.row == 1)
        {
            cell.titleLabel.text = @"儿童数";
            if (child == 0)
            {
                [cell setCellType:FooterCell];
            }
            else
            {
                [cell setCellType:MiddleCell];
            }
            [cell setActionHidden:NO];
            cell.selectabled = NO;
            cell.numLbl.text = [NSString stringWithFormat:@"%d",child];
            cell.minNum = CHILD_MINNUM;
            cell.maxNum = CHILD_MAXNUM;
            cell.personType = Child;
            
            if (child <= CHILD_MINNUM)
            {
                cell.minusBtn.hidden = YES;// .enabled = NO;
            }
            else
            {
                cell.minusBtn.hidden = NO;//.enabled = YES;
            }
            if (child >= CHILD_MAXNUM)
            {
                cell.plusBtn.hidden = YES; // .enabled = NO;
            }
            else
            {
                cell.plusBtn.hidden = NO; // .enabled = YES;
            }
        }
        else
        {
            cell.titleLabel.text = [NSString stringWithFormat:@"儿童%d年龄",indexPath.row - 1];
            [cell setActionHidden:YES];
            cell.selectabled = YES;
            [cell setArrowHidden:NO];
            [cell setTipsHidden:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            // 处理年龄显示问题
            NSArray *ageArray = [dict safeObjectForKey:@"age"];
            NSInteger age = [[ageArray safeObjectAtIndex:indexPath.row - 2] intValue];
            NSString *ageStr = nil;
            if(age == -1)
            {
                ageStr = @"?岁";
            }
            else if (age == 0)
            {
                ageStr = @"<1岁";
            }
            else
            {
                ageStr = [NSString stringWithFormat:@"%d岁",age];
            }
            cell.tipsLbl.text = [NSString stringWithFormat:@"%@",ageStr];
            if (child == indexPath.row -1)
            {
                [cell setCellType:FooterCell];
            }
            else
            {
                [cell setCellType:MiddleCell];
            }
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 30;
    }
    else
    {
        return 30;
    }
}

- (float) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
    }
    else
    {
        NSDictionary *dict = (NSDictionary *)[self.roomerArray safeObjectAtIndex:section - 1];
        NSInteger child = [[dict safeObjectForKey:@"child"] intValue];
        NSInteger adult = [[dict safeObjectForKey:@"adult"] intValue];
        
        UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        sectionLbl.backgroundColor = [UIColor whiteColor];
        sectionLbl.font = [UIFont systemFontOfSize:14.0f];
        sectionLbl.text = [NSString stringWithFormat:@"    房间%d  (%d成人%d儿童)", section, adult, child];
        return [sectionLbl autorelease];
    }
}

#pragma mark -
#pragma mark UITableDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 1 || indexPath.row < 2) {
        return;
    }
    self.selectedIndexPath = indexPath;
    
    if (!ageSelectorView) {
		ageSelectorView = [[InterAgeSelectorView alloc] init];
        ageSelectorView.view.frame = CGRectMake(ageSelectorView.view.frame.origin.x, ageSelectorView.view.frame.origin.y, SCREEN_HEIGHT, 200);
		
		[self.view addSubview:ageSelectorView.view];
	}else{
        if (ageSelectorView.view.superview != self.view) {
            [ageSelectorView.view removeFromSuperview];
        }
        [self.view addSubview:ageSelectorView.view];
    }
    ageSelectorView.delegate = self;
    [ageSelectorView selectRow:-1];

    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	
	[ageSelectorView showInView];
}

#pragma mark -
#pragma mark FilterViewDelegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView
{
    
}

- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView{
    NSMutableDictionary *dict = (NSMutableDictionary *)[self.roomerArray safeObjectAtIndex:self.selectedIndexPath.section - 1];
    NSMutableArray *ageArray = [dict safeObjectForKey:@"age"];
    
    [ageArray replaceObjectAtIndex:self.selectedIndexPath.row - 2 withObject:[NSNumber numberWithInt:index]];
    
    [roomerList reloadData];
}

@end
