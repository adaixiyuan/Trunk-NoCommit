//
//  ScenicBookingTable.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicBookingTable.h"
#import "ScenicAreaDetailViewController.h"
#import "ScenicDetail.h"
#import "ScenicBookingHeader.h"
#import "ScenicBookingCell.h"
#import "ScenicFillOrderVC.h"

@implementation ScenicBookingTable

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)tickets
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化数据
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for (ScenicPrice *price in tickets) {
            [keys addObject:price.policyName];
            [values addObject:[NSArray arrayWithObject:price]];
        }
        
        _dataDictionary = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        [values  release];
        [keys release];
        
        isOpen = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [[self.dataDictionary allKeys] count]; i++) {
            NSString *string = [[self.dataDictionary allKeys] objectAtIndex:i];
            [isOpen setValue:[NSNumber  numberWithBool:YES] forKey:string];
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        UIImageView *bottom = [UIImageView graySeparatorWithFrame:CGRectZero];
        bottom.tag = 100;
        [self addSubview:bottom];
    }
    return self;
}

-(void)setHeight:(CGFloat)height{
    UIView *bottom = (UIView *)[self viewWithTag:100];
    CGRect frame = CGRectMake(0,SCREEN_SCALE, SCREEN_WIDTH, height-SCREEN_SCALE*2);
    [self setFrame:frame];
 //   [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:0.1];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height-SCREEN_SCALE*3);
    [bottom setFrame:CGRectMake(0, _tableView.frame.size.height, SCREEN_WIDTH, SCREEN_SCALE)];
  //  [UIView commitAnimations];
}

-(void)dealloc{
    [_tableView  release];
    [_dataDictionary release];
    [isOpen release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    NSLog(@"drawRect-----");
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [[self.dataDictionary allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString *key = [[self.dataDictionary allKeys] objectAtIndex:section];
    
    BOOL yes = [[isOpen objectForKey:key] boolValue];
    if (yes) {
        return 0;
    }else{
        return [[self.dataDictionary objectForKey:key] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 65;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ScenicBookingHeader *v = [[ScenicBookingHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    NSString *key = [[self.dataDictionary allKeys] objectAtIndex:section];
    BOOL yes = [[isOpen objectForKey:key] boolValue];
    [v refreshTheArrowWithReavel:yes];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 320, 44)];
    btn.tag = section;
    [btn addTarget:self action:@selector(displayTheContent:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    v.userInteractionEnabled = YES;
    return [v autorelease];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    ScenicBookingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *key = [[self.dataDictionary allKeys] objectAtIndex:indexPath.section];
    NSArray *array = [self.dataDictionary objectForKey:key];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ScenicBookingCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_SCALE)]];
        }
        if (indexPath.row!=([array count]-1)) {
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,cell.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
        }
    }
    
    ScenicPrice *price =  [array objectAtIndex:indexPath.row];
    cell.price = price;
    [cell loadData];
    return cell;
}

-(void)displayTheContent:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSString *key = ((ScenicBookingHeader *)btn.superview).policyName.text;
    
    BOOL yes = [[isOpen objectForKey:key] boolValue];
    [isOpen setValue:[NSNumber numberWithBool:!yes] forKey:key];

    if (_delegate && [_delegate respondsToSelector:@selector(adjustBookingTableHeightWithOpenDic:andDataSource:)]) {
        [_delegate adjustBookingTableHeightWithOpenDic:isOpen andDataSource:self.dataDictionary];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *key = [[self.dataDictionary allKeys] objectAtIndex:indexPath.section];
    ScenicPrice *price =  [[self.dataDictionary objectForKey:key] objectAtIndex:indexPath.row];
    
    UIViewController *controller = nil;
    if (_delegate && [_delegate isKindOfClass:[ScenicAreaDetailViewController class]]) {
         controller = (ScenicAreaDetailViewController *)_delegate;
    }
    if (controller) {
        //
        ScenicFillOrderVC *order = [[ScenicFillOrderVC alloc] initWithTitle:@"填写订单" style:NavBarBtnStyleOnlyBackBtn];
        order.priceDetail = price;
        [controller.navigationController pushViewController:order animated:YES];
        [order release];
        
    }else{
        NSLog(@"There is an error when you take a scenicOrder ~~~~");
    }
}


@end
