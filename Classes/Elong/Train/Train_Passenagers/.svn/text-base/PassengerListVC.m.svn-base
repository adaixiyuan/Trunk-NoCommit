//
//  PassengerListVC.m
//  ElongClient
//
//  Created by Zhao Haibo on 13-11-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PassengerListVC.h"
#import "StringFormat.h"
#import "JCustomer.h"
#import "MyElongPostManager.h"
#import "ElongURL.h"
#import "StringEncryption.h"
#import "AddOrEditPassengerVC.h"
#import "Mytrain_submitOrder.h"
#import "TrainFillOrderVC.h"
#import "MyElongCenter.h"

#define k_cellHeight        56              // 行高
#define kMaxTicketCount     5

@interface PassengerListVC ()

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

static NSMutableArray *allPassengers = nil;

@implementation PassengerListVC

+ (NSMutableArray *)allPassengers
{
	@synchronized(self)
    {
		if(!allPassengers)
        {
			allPassengers = [[NSMutableArray alloc] init];
		}
	}
    
	return allPassengers;
}


- (void)dealloc
{
    if (smallLoading)
    {
        [smallLoading release];
    }
    // 终止加载联系人
    [getCustomerListUtil cancel];
    SFRelease(getCustomerListUtil);
	
    [super dealloc];
}


- (id)initWithTicketCount:(NSInteger)count reqPassengerListOver:(BOOL)reqOver passengerType:(PassengerType)type
{
    NSString *title = nil;
    
    passageType = type;
    needReloadList = !reqOver;
    if (passageType == PassengerTypeFlight)
    {
        title = @"选择乘客";
    }
    else
    {
        title = @"选择乘客";
    }
    
    if (self = [super initWithTopImagePath:nil andTitle:title style:_NavOnlyBackBtnStyle_])
    {
        // 加载符
        smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50)/2, (MAINCONTENTHEIGHT-50) / 2, 50, 50)];
        [self.view addSubview:smallLoading];
        
        ticketCount = count;
        
        if(!reqOver)
        {
            // 如果上页预加载请求未成功，则在本页继续加载乘客列表
            [self requestForPassengers];
            [smallLoading startLoading];
        }
    }
    
    return self;
}


#pragma mark - UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeUpNavButton];           
    [self makeUpPassengerListView];
    [self makeUpFooterView];
}


- (void)makeUpNavButton
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"新增" Target:self Action:@selector(clickAddButton)];
}


- (void)makeUpPassengerListView
{
    // 列表
    passengerList = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - k_cellHeight - 20) style:UITableViewStylePlain];
    passengerList.delegate = self;
    passengerList.dataSource = self;
    passengerList.backgroundColor = [UIColor clearColor];
    passengerList.backgroundView = nil;
    passengerList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    passengerList.separatorColor = [UIColor clearColor];
    [self.view addSubview:passengerList];
    [passengerList release];
    
    // 列表头部
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    passengerList.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
    
    // 没有列表时的提示
    m_tipView = [Utils addView:@"请点击此处添加乘客"];
    [self.view addSubview:m_tipView];
    // 点击提示增加入住人
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = m_tipView.bounds;
    [addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [m_tipView addSubview:addButton];
    
    m_tipView.hidden = YES;
    if ([[PassengerListVC allPassengers] count] == 0 &&
        needReloadList == NO) {
        m_tipView.hidden = NO;
    }
}


- (void)makeUpFooterView
{
    // 确定按钮
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    confirmView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:confirmView];
    [confirmView release];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2, 7, SCREEN_WIDTH/2 - 10, 50 - 14);
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [confirmView addSubview:confirmBtn];
    
    // 选择乘客位数显示
    NSInteger count = 0;
    for (NSMutableDictionary *dict in allPassengers)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
            count++;
        }
    }
    
    passengerNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(10, (confirmView.frame.size.height - 14)/2 - 1, SCREEN_WIDTH - 125 - 20, 14)];
    passengerNumberLabel.text = [NSString stringWithFormat:@"已选择%d位乘客", count];
    passengerNumberLabel.backgroundColor = [UIColor clearColor];
    [passengerNumberLabel setColor:[UIColor whiteColor] fromIndex:0 length:passengerNumberLabel.text.length];
    [passengerNumberLabel setColor:RGBACOLOR(245, 113, 25, 1) fromIndex:3 length:2];
    [passengerNumberLabel setFont:FONT_14 fromIndex:0 length:passengerNumberLabel.text.length];
    [confirmView addSubview:passengerNumberLabel];
    [passengerNumberLabel release];
}


#pragma mark - Other
// 请求乘客列表
- (void)requestForPassengers
{
    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:1];
    
    getCustomerListUtil = [[HttpUtil alloc] init];
    [getCustomerListUtil connectWithURLString:MYELONG_SEARCH
                                Content:[customer requesString:YES]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
}


- (NSString *)checkName:(NSString *)name_
{
    NSString *name = [name_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([StringFormat isContainedNumber:name]){
		return @"请输入正确的姓名";
	}else if ([name length] == 0) {
		return @"请输入姓名";
	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5\\\\s]{1,50}'"] evaluateWithObject:name]) {
        return @"请输入正确的姓名";
    }
    else if ([name_ sensitiveWord])
    {
        return [NSString stringWithFormat:@"乘客列表中包含不合法姓名“%@”", name_];
    }
    
    return nil;
}

#pragma mark - Button Methods

// 点击确认按钮
- (void)clickConfirmBtn
{
    BOOL haveSelected = NO;
    for (NSDictionary *dict in allPassengers)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
            haveSelected = YES;
            
            NSString *errorMessage = [self checkName:[dict objectForKey:NAME_RESP]];
            if (errorMessage)
            {
                [PublicMethods showAlertTitle:errorMessage Message:nil];
                return;
            }
        }
    }
    
    if (!haveSelected)
    {
        [PublicMethods showAlertTitle:@"您尚未选择乘客" Message:nil];
        return;
    }
    
    NSInteger count = 0;
    BOOL canBack = YES;
    for (NSMutableDictionary *dict in allPassengers)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
//            if (count >= ticketCount)
            if (count >= kMaxTicketCount)
            {
//                [Utils alert:[NSString stringWithFormat:@"您一共购买了%d张票，每张票仅需选择一名乘客", ticketCount]];
                [Utils alert:[NSString stringWithFormat:@"您不能购买超过%d个乘客", kMaxTicketCount]];
                canBack = NO;
                break;
            }
            else
            {
                count++;
            }
        }
    }
    
    if (canBack)
    {
        if ([_delegate respondsToSelector:@selector(selectedPassengersArray:)])
        {
            [_delegate selectedPassengersArray:[PassengerListVC allPassengers]];
        }
        
        [self back];
    }
    
    UMENG_EVENT(UEvent_Train_FillOrder_PersonSelectAction)
}


- (void)clickAddButton
{
    // 点击新增按钮
    AddOrEditPassengerVC *controller = [[AddOrEditPassengerVC alloc] initWithAllPassengers:allPassengers type:PassengerTypeTrain];
    controller.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    [nav release];
    
    UMENG_EVENT(UEvent_Train_FillOrder_PersonAdd)
}

#pragma mark - Publice Methods
- (void)scrollToDisplayByCertType:(NSString *)certType CertNumber:(NSString *)certNumber
{
    for (NSDictionary *dic in allPassengers)
    {
        if ([[dic objectForKey:IDTYPENAME] isEqualToString:certType] &&
            [[dic objectForKey:IDNUMBER] isEqualToString:certNumber])
        {
            // 找到匹配人
            NSInteger row = [allPassengers indexOfObject:dic];
            [passengerList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PassengerListVC allPassengers] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return k_cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选择入住人
    static NSString *cellIdentifier = @"cellIdentifier";
    PassengerCell *cell = (PassengerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[PassengerCell alloc] initWithReuseIdentifier:cellIdentifier cellHeight:k_cellHeight] autorelease];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    // 多名乘客
    if (indexPath.row == 0)
    {
        [cell.topSplitView setHidden:NO];
    }
    else
    {
        [cell.topSplitView setHidden:YES];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *dict = [[PassengerListVC allPassengers] safeObjectAtIndex:row];
    if ([[dict safeObjectForKey:k_checked_key] safeBoolValue])
    {
        [cell setChecked:YES];
    }
    else
    {
        [cell setChecked:NO];
    }
    
    [cell setPassengerName:[dict safeObjectForKey:NAME_RESP]];
    
    // 如果是身份证隐藏后4位
    NSString *certType = [dict safeObjectForKey:IDTYPENAME];
    NSString *certNum = [StringEncryption DecryptString:[dict safeObjectForKey:IDNUMBER]];
    if ([certType isEqualToString:@"身份证"] &&
        ![[dict safeObjectForKey:k_new_key] boolValue])
    {
        if ([certNum length] > 4)
        {
            certNum = [certNum stringByReplaceWithAsteriskFromIndex:[certNum length]-4];
        }
    }
    [cell setPassengerCert:[NSString stringWithFormat:@"%@／%@", certType, certNum]];
    
    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    
    NSMutableDictionary *dict = (NSMutableDictionary *)[[PassengerListVC allPassengers] safeObjectAtIndex:indexPath.row];
    BOOL formerChecked = [[dict safeObjectForKey:k_checked_key] boolValue];
    [dict safeSetObject:[NSNumber numberWithBool:!formerChecked] forKey:k_checked_key];
    
    NSInteger count = 0;
    for (NSMutableDictionary *dict in allPassengers)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
            count++;
        }
    }
    
//    if(count > ticketCount)
//    {
//        [Utils alert:[NSString stringWithFormat:@"您一共购买了%d张票，每张票仅需选择一名乘客", ticketCount]];
//        [dict safeSetObject:[NSNumber numberWithBool:NO] forKey:k_checked_key];
//        count --;
//    }
    if(count > kMaxTicketCount)
    {
        [Utils alert:[NSString stringWithFormat:@"您不能购买超过%d个乘客", kMaxTicketCount]];
        [dict safeSetObject:[NSNumber numberWithBool:NO] forKey:k_checked_key];
        count --;
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    // 改变下面的提示文字
    passengerNumberLabel.text = [NSString stringWithFormat:@"已选择%d位乘客", count];
    [passengerNumberLabel setColor:[UIColor whiteColor] fromIndex:0 length:passengerNumberLabel.text.length];
    [passengerNumberLabel setColor:RGBACOLOR(245, 113, 25, 1) fromIndex:3 length:2];
    [passengerNumberLabel setFont:FONT_14 fromIndex:0 length:passengerNumberLabel.text.length];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Post delete
        JDeleteCustomer *jdelCus=[MyElongPostManager deleteCustomer];
        [jdelCus clearBuildData];
        
        int customerId = [[[[PassengerListVC allPassengers] safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Id"] intValue];
        [jdelCus setCustomerId:customerId];
        [Utils request:MYELONG_SEARCH req:[jdelCus requesString:NO] delegate:self];
        
        
        [[PassengerListVC allPassengers] removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        NSInteger count = 0;
        for (NSMutableDictionary *dict in allPassengers)
        {
            if ([[dict safeObjectForKey:k_checked_key] boolValue])
            {
                count++;
            }
        }
        // 改变下面的提示文字
        passengerNumberLabel.text = [NSString stringWithFormat:@"已选择%d位乘客", count];
        [passengerNumberLabel setColor:[UIColor whiteColor] fromIndex:0 length:passengerNumberLabel.text.length];
        [passengerNumberLabel setColor:RGBACOLOR(245, 113, 25, 1) fromIndex:3 length:2];
        [passengerNumberLabel setFont:FONT_14 fromIndex:0 length:passengerNumberLabel.text.length];
        
    }
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    if (util == getCustomerListUtil)
    {
        // 在本页获取到乘客列表的情况
        [smallLoading stopLoading];
        
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root])
        {
            return ;
        }
       
        NSArray *passergers = [root safeObjectForKey:CUSTOMERS];
        for (NSMutableDictionary *customer in passergers)
        {
            if (STRINGHASVALUE([customer safeObjectForKey:NAME_RESP]))
            {
                [customer safeSetObject:[NSNumber numberWithBool:NO] forKey:k_checked_key];
                [customer safeSetObject:[NSNumber numberWithBool:NO] forKey:k_new_key];
                if (PassengerTypeFlight == passageType)
                {
                    // 机票展示全部乘客
                    [[PassengerListVC allPassengers] addObject:customer];
                }
                else if (PassengerTypeTrain == passageType)
                {
                    // 火车票只展示4种类型的证件
                    if ([[customer objectForKey:IDTYPEENUM] isEqualToString:IDCARD] ||
                        [[customer objectForKey:IDTYPEENUM] isEqualToString:GANGAO] ||
                        [[customer objectForKey:IDTYPEENUM] isEqualToString:TAIWAN] ||
                        [[customer objectForKey:IDTYPEENUM] isEqualToString:PASSPORT])
                    {
                        [[PassengerListVC allPassengers] addObject:customer];
                    }
                }
            }
        }
        
        if ([[PassengerListVC allPassengers] count] == 0)
        {
            // 没有乘客给出提示
            m_tipView.hidden = NO;
        }
        else
        {
            [passengerList reloadData];
        }
        
        if ([_delegate respondsToSelector:@selector(passengerListReqIsOver)])
        {
            // 回调通知已经获取到乘客列表
            [_delegate passengerListReqIsOver];
        }
    }
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == getCustomerListUtil)
    {
        // 请求失败时处理同无联系人的情况
        [smallLoading stopLoading];
        m_tipView.hidden = NO;
    }
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (util == getCustomerListUtil)
    {
        // 请求取消时处理同无联系人的情况
        [smallLoading stopLoading];
        m_tipView.hidden = NO;
    }
}


#pragma mark - AddOrEditPassengerDelegate
- (void)didReceiveANewPassenger:(NSDictionary *)passenger
{
    // 获取到一个新乘客后，刷新本页页面
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:passenger];
    [dic setObject:[NSNumber numberWithBool:YES] forKey:k_checked_key];     // 自动勾选
    [dic setObject:[NSNumber numberWithBool:YES] forKey:k_new_key];         // 标记为新乘客，不隐藏身份证号
    [allPassengers insertObject:dic atIndex:0];
    [passengerList reloadData];
    [passengerList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    m_tipView.hidden = YES;
    
    // 改变下面的提示文字
    NSInteger count = 0;
    for (NSMutableDictionary *dict in allPassengers)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
            count++;
        }
    }
    
    passengerNumberLabel.text = [NSString stringWithFormat:@"已选择%d位乘客", count];
    [passengerNumberLabel setColor:[UIColor whiteColor] fromIndex:0 length:passengerNumberLabel.text.length];
    [passengerNumberLabel setColor:RGBACOLOR(245, 113, 25, 1) fromIndex:3 length:2];
    [passengerNumberLabel setFont:FONT_14 fromIndex:0 length:passengerNumberLabel.text.length];
}

- (void)didReceiveAEditPassenger:(NSDictionary *)passenger
{
    // 获取到一个新乘客后，刷新本页页面
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:passenger];
    [dic setObject:[NSNumber numberWithBool:YES] forKey:k_checked_key];     // 自动勾选
    [dic setObject:[NSNumber numberWithBool:NO] forKey:k_new_key];         // 标记为新乘客，不隐藏身份证号
    
//    NSUInteger passengerIndex = 0;
//    for (NSMutableDictionary *editPassenger in allPassengers) {
//        if ([[editPassenger safeObjectForKey:@"Name"] isEqualToString:[passenger safeObjectForKey:@"Name"]]) {
//            break;
//        }
//        passengerIndex++;
//    }
    
    if (_selectedIndex != [allPassengers count]) {
        [allPassengers replaceObjectAtIndex:_selectedIndex withObject:dic];
        
        [passengerList reloadData];
        [passengerList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
    NSInteger count = 0;
    for (NSMutableDictionary *dict in allPassengers)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
            count++;
        }
    }
    // 改变下面的提示文字
    passengerNumberLabel.text = [NSString stringWithFormat:@"已选择%d位乘客", count];
    [passengerNumberLabel setColor:[UIColor whiteColor] fromIndex:0 length:passengerNumberLabel.text.length];
    [passengerNumberLabel setColor:RGBACOLOR(245, 113, 25, 1) fromIndex:3 length:2];
    [passengerNumberLabel setFont:FONT_14 fromIndex:0 length:passengerNumberLabel.text.length];
}

#pragma mark - PassengerCellDelegate
- (void)editPassenger:(PassengerCell *)cell
{
    NSIndexPath *indexPath = [passengerList indexPathForCell:cell];
    self.selectedIndex = indexPath.row;
    
    // 点击新增按钮
    AddOrEditPassengerVC *controller = [[AddOrEditPassengerVC alloc] initWithAllPassengers:allPassengers type:PassengerTypeTrain];
    controller.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    [nav release];
    
//    NSIndexPath *indexPath = [passengerList indexPathForCell:cell];
    NSDictionary *dict = [[PassengerListVC allPassengers] safeObjectAtIndex:indexPath.row];
    NSDictionary *passengerDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [dict safeObjectForKey:NAME_RESP], NAME_RESP,
                                  [dict safeObjectForKey:IDNUMBER], IDNUMBER,
                                  [dict safeObjectForKey:IDTYPENAME], IDTYPENAME,
                                  [dict safeObjectForKey:IDTYPE], IDTYPE, nil];
    
    // 如果本行已经有乘客，变为修改乘客
    [controller setModifyPassenger:passengerDic];
}

@end
