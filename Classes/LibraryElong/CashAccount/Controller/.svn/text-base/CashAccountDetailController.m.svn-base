//
//  CashAccountDetailController.m
//  ElongClient
//
//  Created by 赵岩 on 13-8-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountDetailController.h"
#import "CashAccountDetailCell.h"
#import "Utils.h"
#import "CashAccountReq.h"
#import "ElongURL.h"
#import "HttpUtil.h"

@interface CashAccountDetailController ()

@property (nonatomic, retain) HttpUtil *httpRequest;

@end

@implementation CashAccountDetailController

- (void)dealloc
{
    [_loading release];
    [_httpRequest cancel];
    SFRelease(_httpRequest);

    [_balance release];
    [_detailList release];
    [super dealloc];
}

- (id)init
{
    if (self = [super initWithTopImagePath:nil andTitle:@"余额详情" style:_NavOnlyBackBtnStyle_]) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 72, 14)];
    label.font = FONT_14;
    label.text = @"账户余额：";
    [headerView addSubview:label];
    [label release];
    
    UILabel *cashRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y - 1, 120, 16)];
    cashRemainLabel.font = FONT_15;
    cashRemainLabel.textColor = RGBACOLOR(254, 75, 32, 1);
    [headerView addSubview:cashRemainLabel];
    [cashRemainLabel release];
    self.balanceLabel = cashRemainLabel;
    cashRemainLabel.text = self.balance;
    
    UILabel *tipsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 14)] autorelease];
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.font = [UIFont systemFontOfSize:13];
    tipsLabel.text = @"提示：艺龙会自动优先使用即将到期的余额";
    [headerView addSubview:tipsLabel];
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain] autorelease];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView  = headerView;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (!self.loading) {
		self.loading = [[[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (MAINCONTENTHEIGHT - 50) / 2, 50, 50)] autorelease];
		[self.view addSubview:self.loading];
	}
	
	[self.loading startLoading];
    
    if (_httpRequest) {
        [_httpRequest cancel];
        SFRelease(_httpRequest);
    }
    _httpRequest = [[HttpUtil alloc] init];
    [_httpRequest connectWithURLString:MYELONG_SEARCH
                                Content:[CashAccountReq getIncomeRecord]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBalance:(NSString *)balance
{
    self.balanceLabel.text = balance;
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
        cell.balanceLabel.text = [info safeObjectForKey:@"BackAmount"] == [NSNull null] ? @"" : [NSString stringWithFormat:@"¥ %@", [[info safeObjectForKey:@"BackAmount"] stringValue]];
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
//    NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
 //   NSDictionary *root = [string JSONValue];
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        return ;
    }
    [self.loading stopLoading];
    NSArray *list = [root safeObjectForKey:@"IncomeRecords"];
    
    if (list.count == 0) {
        UILabel *label = [[[UILabel alloc] initWithFrame:self.view.bounds] autorelease];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无余额记录";
        [self.view addSubview:label];
    }
    else {
        self.detailList = list;
    
        [self.tableView reloadData];
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{

}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{

}

@end
