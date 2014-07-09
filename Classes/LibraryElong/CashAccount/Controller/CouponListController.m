//
//  CouponListController.m
//  ElongClient
//
//  Created by 赵岩 on 13-8-8.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CouponListController.h"
#import "Utils.h"
#import "CouponListCell.h"

@interface CouponListController ()

@end

@implementation CouponListController

- (void)dealloc
{
    [_detailList release];
    [super dealloc];
}

- (id)init
{
    if (self = [super initWithTopImagePath:nil andTitle:@"消费券" style:_NavOnlyBackBtnStyle_]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain] autorelease];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"";
    CouponListCell *cell = (CouponListCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CouponListCell" owner:self options:nil];
		cell = [nib safeObjectAtIndex:0];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    if (indexPath.row == 0) {
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0.09 green:0.45 blue:0.80 alpha:1.0];
        cell.expiryDateLabel.textColor = [UIColor whiteColor];
        cell.totalMoneyLabel.textColor = [UIColor whiteColor];
        cell.remainMoneyLabel.textColor = [UIColor whiteColor];
        cell.expiryDateLabel.text = @"有效期";
        cell.totalMoneyLabel.text = @"发放总金额";
        cell.remainMoneyLabel.text = @"可用余额";
    }
    else {
        NSDictionary *info = [self.detailList safeObjectAtIndex:indexPath.row - 1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.expiryDateLabel.textColor = [UIColor blackColor];
        cell.totalMoneyLabel.textColor = [UIColor blackColor];
        cell.remainMoneyLabel.textColor = [UIColor colorWithRed:1.0 green:0.60 blue:0.11 alpha:1.0];
        
        if ([info safeObjectForKey:@"TotalAmount"]!=[NSNull null]) {
            NSNumber* num = [info safeObjectForKey:@"TotalAmount"];
            cell.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%d",[num intValue]];
        }else {
            cell.totalMoneyLabel.text = nil;
        }
        
        if ([info safeObjectForKey:@"RemainAmount"]!=[NSNull null]) {
            NSNumber* num = [info safeObjectForKey:@"RemainAmount"];
            cell.remainMoneyLabel.text = [NSString stringWithFormat:@"￥%d",[num intValue]];
        }else {
            cell.remainMoneyLabel.text = nil;
        }
        
        if ([info safeObjectForKey:@"EffectiveDate"]!=[NSNull null]) {
            cell.expiryDateLabel.text = [TimeUtils displayDateWithJsonDate:[info safeObjectForKey:@"EffectiveDate"] formatter:@"yyyy-MM-dd"];
        }
        else {
            cell.expiryDateLabel.text = nil;
        }
    
    }

    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - HttpRequestDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *root = [string JSONValue];
    if ([Utils checkJsonIsError:root]) {
        return ;
    }
    
    NSArray *list = [root safeObjectForKey:@"IncomeRecords"];
    self.detailList = list;
    
    [self.tableView reloadData];
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    
}

@end
