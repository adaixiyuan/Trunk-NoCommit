//
//  GiftCardRecharge.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GiftCardRecharge.h"
#import "ElongURL.h"
#import "CashAccountVC.h"
#import "CashAccountReq.h"
#import "GroupStyleCell.h"
#import "CheckcodeView.h"
#import "CashAccountConfig.h"

#define CELL_HEIGHT         50
#define CELL_CHECKCODE_TAG 1001

#define NET_TYPE_CHECKCODE          101     // 检测校验码
#define NET_TYPE_PASSWORD           102     // 检测密码
#define NET_TYPE_CASHACCOUNTDETAIL  103     // 刷新CA账户余额

@interface GiftCardRecharge ()

@property (retain, nonatomic) UITableView *mainTable;

@end

@implementation GiftCardRecharge


- (void)dealloc
{
    [checkcodeUtil cancel];
    SFRelease(checkcodeUtil);
    
    [checkcodeImg release];
    
    [_mainTable release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil)
    {
        self.view = nil;
    }
}


- (void)back
{
    // 优先跳入CashAccountVC
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CashAccountVC class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [super back];
}

- (id)init
{
    self = [super initWithTopImagePath:nil andTitle:@"礼品卡/红包充值" style:_NavOnlyBackBtnStyle_];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    _mainTable.backgroundColor = [UIColor clearColor];
    _mainTable.backgroundView = nil;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
    
    // 充值按钮
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *rechargeBtn = [UIButton yellowWhitebuttonWithTitle:@"充  值"
                                                          Target:self
                                                          Action:@selector(clickNextButton)
                                                           Frame:CGRectMake(22, 20, SCREEN_WIDTH - 44, BOTTOM_BUTTON_HEIGHT)];
    [footView addSubview:rechargeBtn];
    _mainTable.tableFooterView = footView;
    [footView release];
}


// 点击充值按钮
- (void)clickNextButton
{
    NSString *errorMsg = [self checkInput];
    if (STRINGHASVALUE(errorMsg)) {
        [PublicMethods showAlertTitle:errorMsg Message:nil];
        return;
    }
    else
    {
        net_type = NET_TYPE_PASSWORD;
        [Utils request:GIFTCARD_SEARCH req:[CashAccountReq newGiftCardRecharge:cardNOField.text GiftCardPwd:passwordField.text GraphCode:checkcodeField.text] delegate:self];
        
        if (UMENG) {
            //礼品卡充值
            [MobClick event:Event_CAPrepaidCardSubmit];
        }
    }
}


- (void)clickCheckcodeBtn:(UIButton *)sender
{
    checkcodeImg.image = nil;
    [checkcodeImg startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    
    // 请求验证码
    if (checkcodeUtil) {
        [checkcodeUtil cancel];
        SFRelease(checkcodeUtil);
    }
    checkcodeUtil = [[HttpUtil alloc] init];
    [checkcodeUtil connectWithURLString:GIFTCARD_SEARCH
                                Content:[CashAccountReq getRechargeVCode]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
    
}


// 校验输入数据的正确性
- (NSString *)checkInput
{
    if (cardNOField.text.length < 16) {
		return @"请输入16位数字的卡号";
	}
    
    if (passwordField.text.length == 0) {
		return @"请输入密码";
	}
    
    if (checkcodeField.text.length == 0) {
        return @"请输入验证码";
    }
    
	if (checkcodeField.text.length < 4 || checkcodeField.text.length > 6) {
		return @"验证码必须在4-6个字符之间";
	}
    
    return nil;
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    GroupStyleCell *cell = (GroupStyleCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[GroupStyleCell alloc] initWithStyle:GroupCellStyleTextField reuseIdentifier:cellIdentifier cellHeight:CELL_HEIGHT] autorelease];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - SCREEN_SCALE , 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            cell.titleLabel.text = @"礼品卡号：";
            cell.inputField.placeholder = @"请输入16位数字";
            cell.inputField.abcEnabled = NO;
            cell.inputField.numberOfCharacter = 16;
            cell.inputField.fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
            cardNOField = cell.inputField;
        }
        else if(indexPath.row == 1)
        {
            cell.titleLabel.text = @"密       码：";
            cell.inputField.placeholder = @"请注意密码大小写";
            cell.inputField.abcEnabled = YES;
            cell.inputField.secureTextEntry = YES;
            cell.inputField.numberOfCharacter = 12;
            cell.inputField.fieldKeyboardType = CustomTextFieldKeyboardTypeDefault;
            passwordField = cell.inputField;
        }
    }
    else if (indexPath.section == 1)
    {
        cell.titleLabel.text = @"验证码：";
        cell.inputField.numberOfCharacter = 6;
        cell.inputField.abcEnabled = YES;
        CGRect rect = cell.inputField.frame;
        rect.size.width = 90;
        cell.inputField.frame = rect;
        cell.inputField.autocorrectionType = UITextAutocorrectionTypeNo;

        CheckcodeView *codeView = [[CheckcodeView alloc] initWithFrame:CGRectMake(209, 0, 87, CELL_HEIGHT)
                                                          checkcodeURL:[CashAccountReq getRechargeVCode]];
        codeView.tag = CELL_CHECKCODE_TAG;
        checkcodeField = cell.inputField;
        [cell.contentView addSubview:codeView];
        [codeView release];
    }
    
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    bottomLine.frame = CGRectMake(0, CELL_HEIGHT - SCREEN_SCALE, 320, SCREEN_SCALE);
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    return [headView autorelease];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - HttpUtil Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        if(net_type == NET_TYPE_PASSWORD){
            //充值失败时刷新验证码
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            GroupStyleCell *cell = (GroupStyleCell *)[self.mainTable cellForRowAtIndexPath:indexPath];
            if(cell){
                CheckcodeView *codeView = (CheckcodeView *)[cell.contentView viewWithTag:CELL_CHECKCODE_TAG];
                [codeView requestForRefresh];
            }
        }
        return;
    }
    
    // 处理修改密码请求
    if (net_type == NET_TYPE_PASSWORD)
    {
        if ([[root safeObjectForKey:RESULT] safeIntValue] == 1)
        {
            // 充值成功，刷新当前账户CA余额
            net_type = NET_TYPE_CASHACCOUNTDETAIL;
            
            [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeMyelong] delegate:self];
        }
        else
        {
            //刷新验证码
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            GroupStyleCell *cell = (GroupStyleCell *)[self.mainTable cellForRowAtIndexPath:indexPath];
            if(cell){
                CheckcodeView *codeView = (CheckcodeView *)[cell.contentView viewWithTag:CELL_CHECKCODE_TAG];
                [codeView requestForRefresh];
            }

            [PublicMethods showAlertTitle:@"充值失败" Message:nil];
        }
    }
    else if (net_type == NET_TYPE_CASHACCOUNTDETAIL)
    {
        // 发送充值成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CASHACCOUNT_RECHARGE object:root];
        
        [PublicMethods showAlertTitle:@"充值成功！" Message:nil];
        
        // 跳转回CA账户页
        [self back];
    }
}

@end
