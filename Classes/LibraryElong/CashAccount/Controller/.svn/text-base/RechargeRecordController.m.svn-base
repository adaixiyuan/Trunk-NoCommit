//
//  RechargeRecordController.m
//  ElongClient
//
//  Created by 赵岩 on 13-8-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RechargeRecordController.h"
#import "Utils.h"
#import "ElongURL.h"
#import "CashAccountDetailCell.h"
#import "CashAccountReq.h"

@interface RechargeRecordController ()

@end

@implementation RechargeRecordController

- (void)dealloc
{
    [_loading release];
    [_detailList release];
    [super dealloc];
}

- (id)init
{
    if (self = [super initWithTopImagePath:nil andTitle:@"余额详情" style:_NavOnlyBackBtnStyle_]) {
        [Utils request:MYELONG_SEARCH req:[CashAccountReq getIncomeRecord] delegate:self];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITableView *tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
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
    CashAccountDetailCell *cell = (CashAccountDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CashAccountDetailCell" owner:self options:nil];
		cell = [nib safeObjectAtIndex:0];
    }
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.09 green:0.45 blue:0.80 alpha:1.0];
        cell.balanceLabel.textColor = [UIColor whiteColor];
        cell.sourceLabel.textColor = [UIColor whiteColor];
        cell.arriveDateLabel.textColor = [UIColor whiteColor];
        cell.expiryDateLabel.textColor = [UIColor whiteColor];
        cell.balanceLabel.text = @"金额";
        cell.sourceLabel.text = @"来源";
        cell.arriveDateLabel.text = @"到帐日";
        cell.expiryDateLabel.text = @"有效期至";
    }
    else {
        NSDictionary *info = [self.detailList safeObjectAtIndex:indexPath.row - 1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.balanceLabel.textColor = [UIColor blackColor];
        cell.sourceLabel.textColor = [UIColor blackColor];
        cell.arriveDateLabel.textColor = [UIColor blackColor];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date1 = [formatter dateFromString:[info safeObjectForKey:@"EffectiveDate"]];
        NSDate *date2 = [NSDate date];
        NSTimeInterval timeInterval = [date1 timeIntervalSinceDate:date2];
        if (timeInterval / (60 * 60 * 24) < 30) {
            cell.expiryDateLabel.textColor = [UIColor redColor];
        }
        else {
            cell.expiryDateLabel.textColor = [UIColor blackColor];
        }
        cell.balanceLabel.text = [info safeObjectForKey:@"BackAmount"] == [NSNull null] ? @"" : [NSString stringWithFormat:@"￥%@", [[info safeObjectForKey:@"BackAmount"] stringValue]];
        cell.sourceLabel.text = [info safeObjectForKey:@"Compaign"] == [NSNull null] ? @"" : [info safeObjectForKey:@"Compaign"];
        cell.arriveDateLabel.text = [info safeObjectForKey:@"BackCashDate"] == [NSNull null] ? @"" : [info safeObjectForKey:@"BackCashDate"];
        cell.expiryDateLabel.text = [info safeObjectForKey:@"EffectiveDate"] == [NSNull null] ? @"" : [info safeObjectForKey:@"EffectiveDate"];
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
