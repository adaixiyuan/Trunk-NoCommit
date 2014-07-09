//
//  CashAccountPasswordSetVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountPasswordSetVC.h"
#import "CheckcodeView.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "Utils.h"
#import "ElongURL.h"
#import "GiftCardRecharge.h"

#define CELL_HEIGHT         50

//#define CHECKCODE_BUTTON_TITLE   @"获取验证码"
//#define CHECKCODE_BUTTON_IMAGE   [UIImage stretchableImageWithPath:@"checkcode_btn.png"]

#define NET_TYPE_CHECKCODE      101     // 检测校验码
#define NET_TYPE_PASSWORD       102     // 检测密码

@interface CashAccountPasswordSetVC ()

@end

@implementation CashAccountPasswordSetVC

- (void)dealloc
{
    [checkcodeUtil cancel];
    SFRelease(checkcodeUtil);
    
    [checkcodeBtn release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil)
    {
        self.view = nil;
    }
}


- (id)initWithType:(ECashAccountSetType)type
{
    passwordType = type;
    NSString *title = nil;
    switch (type) {
        case ECashAccountSetTypeSet:
            title = @"设置支付密码";
            break;
        case ECashAccountSetTypeReset:
            title = @"重置支付密码";
            break;
            
        default:
            break;
    }
    
    self = [super initWithTopImagePath:nil andTitle:title style:_NavNormalBtnStyle_];
    if (self)
    {
        self.nextToRecharge = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // table view
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = [UIColor clearColor];
    table.backgroundView = nil;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table release];

    // table header view
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    int offY = 15;
    if (passwordType == ECashAccountSetTypeSet)
    {
        // 新设置密码时需要增加一行文字提示
        CGRect rect = headView.frame;
        rect.size.height += 46;
        headView.frame = rect;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 36)];
        tipLabel.text = @"发现您从未设置过“支付密码”，为了安全，充值礼品卡前需先设置支付密码";
        tipLabel.font = FONT_14;
        tipLabel.numberOfLines = 0;
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor grayColor];
        [headView addSubview:tipLabel];
        [tipLabel release];
        
        offY += 46;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, offY, SCREEN_WIDTH - 20, 15)];
    label.text = @"验证码将通过短信发到您的手机";
    label.font = FONT_14;
    label.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = headView;
    [headView addSubview:label];
    [label release];
    [headView release];
    
    // table footer view
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
    UIButton *rechargeBtn = [UIButton yellowWhitebuttonWithTitle:@"确  定"
                                                          Target:self
                                                          Action:@selector(clickNextButton)
                                                           Frame:CGRectMake(22, 20, SCREEN_WIDTH - 44, BOTTOM_BUTTON_HEIGHT)];
    [footView addSubview:rechargeBtn];
    table.tableFooterView = footView;
    [footView release];
    
    // 验证码按钮
    if (!checkcodeBtn)
    {
        checkcodeBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        checkcodeBtn.frame = CGRectMake(220, (CELL_HEIGHT - 29) / 2, 75, 29);
        checkcodeBtn.titleLabel.font = FONT_B13;
        [checkcodeBtn addTarget:self action:@selector(clickCheckcodeButton) forControlEvents:UIControlEventTouchUpInside];
        [checkcodeBtn setImage:[UIImage noCacheImageNamed:@"ico_getCheckcode.png"] forState:UIControlStateNormal];
//        [checkcodeBtn setBackgroundImage:CHECKCODE_BUTTON_IMAGE forState:UIControlStateNormal];
//        [checkcodeBtn setTitle:CHECKCODE_BUTTON_TITLE forState:UIControlStateNormal];
//        [checkcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


// 输入规则校验
- (NSString *)checkInput
{
    // 校验手机号码
    if (phoneField.text.length == 0)
    {
        return @"请输入手机号码";
    }
    else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '(1[0-9])\\\\d{9}'"] evaluateWithObject:phoneField.text])
    {
        return _string(@"s_phonenum_iserror");
    }
    
    // 校验验证码
    if (checkcodeField.text.length == 0)
    {
        return @"请输入验证码";
    }
    
    // 验证密码
    if (passwordField.text.length == 0)
    {
        return @"请输入密码";
    }
    
    if (passwordField.text.length < 6 ||
        passwordField.text.length > 30)
    {
        return @"密码长度不合要求（要求：6－30位）";
    }
    
    if (!ENANDNUMISRIGHT(passwordField.text))
    {
        return @"新密码包含不合要求字符(要求：只允许有大小写字符和数字)";
    }
    
    if (rePasswordField.text.length == 0)
    {
        return @"请再次输入密码";
    }
    if (![passwordField.text isEqualToString:rePasswordField.text])
    {
        return @"两次输入的新密码不同，请重新输入";
    }
    
    NSString *phoneNo = [[AccountManager instanse] phoneNo];
    NSString *email = [[AccountManager instanse] email];
    if(phoneNo && [phoneNo rangeOfString:passwordField.text].length>0){
        return @"密码是手机号码一部分（要求：密码不能是手机号一部分）";
    }else if(email && [email rangeOfString:passwordField.text].length>0){
        return @"密码是邮箱一部分（要求：密码不能是邮箱一部分）";
    }
    
    if([passwordField.text isEqualToString:[[AccountManager instanse] password]]){
        return @"现金账户密码不能与登录密码相同";
    }
    
    
    return nil;
}


// 点击确定按钮
- (void)clickNextButton
{
    [self.view endEditing:YES];
    
    NSString *errorMsg = [self checkInput];
    if (STRINGHASVALUE(errorMsg)) {
        [PublicMethods showAlertTitle:errorMsg Message:nil];
        return;
    }
    
    net_type = NET_TYPE_CHECKCODE;
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq verifySmsCheckCodeWithMobileNo:phoneField.text Code:checkcodeField.text] delegate:self];
    
    if (UMENG) {
        //重置支付密码
        [MobClick event:Event_CAResetPassword];
    }
    
    UMENG_EVENT(UEvent_UserCenter_CA_ResetPwdAction)
}


// 点击获取校验码按钮
- (void)clickCheckcodeButton
{
    // 先校验手机号码是否正确
    if (phoneField.text.length == 0)
    {
        [PublicMethods showAlertTitle:@"请输入手机号码" Message:nil];
        return;
    }
    else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '(1[0-9])\\\\d{9}'"] evaluateWithObject:phoneField.text])
    {
        [PublicMethods showAlertTitle:_string(@"s_phonenum_iserror") Message:nil];
        return;
    }
    
    // 改变按钮状态
//    [checkcodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    [checkcodeBtn setTitle:nil forState:UIControlStateNormal];
    [checkcodeBtn startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    checkcodeBtn.userInteractionEnabled = NO;
    
    // 发起请求
    if (checkcodeUtil) {
        [checkcodeUtil cancel];
        SFRelease(checkcodeUtil);
    }
    
    checkcodeUtil = [[HttpUtil alloc] init];
    [checkcodeUtil connectWithURLString:GIFTCARD_SEARCH
                                Content:[CashAccountReq sendCheckCodeSmsWithMobileNo:phoneField.text]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
}


#pragma mark -
#pragma mark UITextField(Cell) Delegate

- (void)cellTextFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == phoneField || textField == checkcodeField) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    if (textField == passwordField || textField == rePasswordField) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    GroupStyleCell *cell = (GroupStyleCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[GroupStyleCell alloc] initWithStyle:GroupCellStyleTextField reuseIdentifier:cellIdentifier cellHeight:CELL_HEIGHT] autorelease];
        cell.delegate = self;
        cell.needHighLighted = NO;
        
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
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
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
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    bottomLine.frame = CGRectMake(0, CELL_HEIGHT-SCREEN_SCALE, 320, SCREEN_SCALE);
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 )
        {
            cell.titleLabel.text = @"手机号：";
            cell.inputField.abcEnabled = NO;
            cell.inputField.placeholder = @"请输入手机号码";
            cell.inputField.numberOfCharacter = 11;
            cell.inputField.fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
            phoneField = cell.inputField;
            
            // 如果账户存在手机号且没有手动更改过时，显示之，并且存在的手机号码不能修改
            if (STRINGHASVALUE([[AccountManager instanse] phoneNo]) &&
                               phoneField.text.length == 0)
            {
                phoneField.text = [[AccountManager instanse] phoneNo];
                phoneField.enabled = NO;
            }
        }
        else if(indexPath.row == 1)
        {
            cell.titleLabel.text = @"验证码：";
            cell.inputField.abcEnabled = YES;
            cell.inputField.numberOfCharacter = 30;
            CGRect rect = cell.inputField.frame;
            rect.size.width = 100;
            cell.inputField.frame = rect;
            checkcodeField = cell.inputField;
            
            [cell.contentView addSubview:checkcodeBtn];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.titleLabel.text = @"支付密码：";
            cell.inputField.placeholder = @"不能与登录密码相同";
            cell.inputField.abcEnabled = YES;
            cell.inputField.secureTextEntry = YES;
            cell.inputField.numberOfCharacter = 30;
            cell.inputField.fieldKeyboardType = CustomTextFieldKeyboardTypeDefault;
            passwordField = cell.inputField;
        }
        else if(indexPath.row == 1)
        {
            cell.titleLabel.text = @"确认支付密码：";
            cell.inputField.placeholder = @"请再次输入支付密码";
            cell.inputField.numberOfCharacter = 30;
            cell.inputField.abcEnabled = YES;
            cell.inputField.secureTextEntry = YES;
            cell.inputField.fieldKeyboardType = CustomTextFieldKeyboardTypeDefault;
            rePasswordField = cell.inputField;
        }
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    return [headView autorelease];
}


#pragma mark - HttpUtil Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    [checkcodeBtn endLoading];
//    [checkcodeBtn setBackgroundImage:CHECKCODE_BUTTON_IMAGE forState:UIControlStateNormal];
//    [checkcodeBtn setTitle:CHECKCODE_BUTTON_TITLE forState:UIControlStateNormal];
    checkcodeBtn.userInteractionEnabled = YES;
    
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    // 处理验证码请求
    if (util == checkcodeUtil)
    {
        // 改变按钮状态
        if ([[root safeObjectForKey:IS_SUCCESS] safeIntValue] == 0)
        {
            [PublicMethods showAlertTitle:@"发送失败，请重试" Message:nil];
        }
        
        return;
    }
    
    // 处理修改密码请求
    if (net_type == NET_TYPE_CHECKCODE)
    {
        if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
        {
            // 校验成功，发起校验密码请求
            net_type = NET_TYPE_PASSWORD;
        
            [Utils request:GIFTCARD_SEARCH req:[CashAccountReq setCashAccountPwdWithPwd:passwordField.text NewPwd:nil SetType:passwordType] delegate:self];
        }
        else
        {
            [PublicMethods showAlertTitle:@"验证码校验失败" Message:@"请检查"];
        }
    
        return;
    }
    
    if (net_type == NET_TYPE_PASSWORD)
    {
        if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CASHACCOUNT_SETPASSWORDSUCCESS object:nil];
            if (_nextToRecharge)
            {
                // 跳入礼品卡充值页面
                GiftCardRecharge *controller = [[GiftCardRecharge alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else
            {
                [PublicMethods showAlertTitle:@"密码设置成功" Message:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [PublicMethods showAlertTitle:@"密码设置失败" Message:@"请重试"];
        }
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    [checkcodeBtn endLoading];
    checkcodeBtn.userInteractionEnabled = YES;
    
    [Utils alert:@"网络错误"];
}


@end
