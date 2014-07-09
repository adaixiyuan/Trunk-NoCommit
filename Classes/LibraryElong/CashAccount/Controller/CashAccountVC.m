//
//  CashAccountVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountVC.h"
#import "GroupStyleCell.h"
#import "GiftCardRecharge.h"
#import "CashAccountConfig.h"
#import "CashAccountPasswordSetVC.h"
#import "ElongURL.h"
#import "CashAccountDetailController.h"
#import "CashAccountPasswordSetVC.h"
#import "CouponListController.h"
#import "MyElongCenter.h"
#import "RechargeRecordController.h"
#import "CashAccountFaqVC.h"
#import "CashAccountReq.h"
#import "TokenReq.h"
#import "Html5WebController.h"

@implementation CashAccountVC


- (void)dealloc {
    [couponListUtil cancel];
    SFRelease(couponListUtil);
    [cashDespUtil cancel];
    SFRelease(cashDespUtil);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [cashAccountDic release];
    self.cashDesp = nil;
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        self.view = nil;
    }
}


- (id)initWithCashDetail:(NSDictionary *)dic
{
    self = [super initWithTopImagePath:nil andTitle:@"现金账户" style:_NavNoTelStyle_];
    if (self)
    {
        NSLog(@"CashDetail:%@", dic);
        // 充值成功后，接受通知，刷新页面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForRemain:) name:NOTI_CASHACCOUNT_RECHARGE object:nil];
        
        // 设置密码成功后，接受通知，刷新页面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCashAccountState) name:NOTI_CASHACCOUNT_SETPASSWORDSUCCESS object:nil];
        
        // 收到获取token成功的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTokenState) name:NOTI_GET_TOKEN object:nil];
        
        cashAccountRemain = [[dic safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
        cashLockedAccount = [[dic safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
        havePassword = [[dic safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
        SFRelease(cashAccountDic);
        cashAccountDic = [[NSDictionary alloc] initWithDictionary:dic];
        
        [self makeUpHeaderViewForTable:table];
        [self makeUpFooterViewForTable:table];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ============================================================
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table release];
    
    if (cashAccountDic)
    {
        // 内存警告时，如果已经有数据，重新生成HeadeRview和FootView
        [self makeUpHeaderViewForTable:table];
        [self makeUpFooterViewForTable:table];
    }
    
    [self requestCashDescription];
}


// 生成顶部的view
- (void)makeUpHeaderViewForTable:(UITableView *)tableView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    // ============================= 总额部分 ===============================
    int offY = 15;      // 记录各控件的相对y坐标
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, offY, 48, 20)];
    totalLabel.font = FONT_15;
    totalLabel.text = @"总额：";
    totalLabel.textColor = [UIColor darkGrayColor];
    totalLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:totalLabel];
    [totalLabel release];
    
    cashRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, offY , SCREEN_WIDTH-92, 20)];
    cashRemainLabel.backgroundColor = [UIColor clearColor];
    cashRemainLabel.font = FONT_15;
    cashRemainLabel.textColor = RGBACOLOR(254, 75, 32, 1);
    cashRemainLabel.adjustsFontSizeToFitWidth = YES;
    [headView addSubview:cashRemainLabel];
    [cashRemainLabel release];
    cashRemainLabel.text = [NSString stringWithFormat:@"¥ %.f", floor(cashAccountRemain)+floor(cashLockedAccount)];
    
    // ============================= 余额详情部分 ===============================
    cashDetailView = [[UIView alloc] initWithFrame:headView.bounds];
    cashDetailView.backgroundColor = [UIColor clearColor];
    [headView addSubview:cashDetailView];
    [cashDetailView release];

    [self makeUpCashDetailInView:cashDetailView];
    headView.frame = cashDetailView.frame;
    tableView.tableHeaderView = headView;
    [headView release];
}


// 生成底部的view
- (void)makeUpFooterViewForTable:(UITableView *)tableView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    tableView.tableFooterView = footView;
    [footView release];
    
    // table foot view
    UIButton *giftCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giftCardBtn.frame = CGRectMake(190, 0, 130, 44);
    giftCardBtn.titleLabel.font = FONT_13;
    giftCardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    giftCardBtn.exclusiveTouch = YES;
    [giftCardBtn addTarget:self action:@selector(clickGiftCardBtn) forControlEvents:UIControlEventTouchUpInside];
    [giftCardBtn setTitle:@"礼品卡/红包是什么？" forState:UIControlStateNormal];
    [giftCardBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:111/255.0 blue:229/255.0 alpha:1] forState:UIControlStateNormal];
    [footView addSubview:giftCardBtn];
    
    UIButton *passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passBtn.frame = CGRectMake(0, giftCardBtn.frame.origin.y + 44, SCREEN_WIDTH, 44);
    passBtn.exclusiveTouch = YES;
    [passBtn addTarget:self action:@selector(clickPassBtn) forControlEvents:UIControlEventTouchUpInside];
    [passBtn setBackgroundColor:[UIColor whiteColor]];
    [passBtn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
    [footView addSubview:passBtn];
    
    passBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, (passBtn.frame.size.height - 16)/2, 180, 16)];
    passBtnLabel.backgroundColor = [UIColor clearColor];
    passBtnLabel.text = havePassword ? @"重置支付密码" : @"设置支付密码";
    passBtnLabel.textColor = [UIColor blackColor];
    passBtnLabel.font = FONT_16;
    [passBtn addSubview:passBtnLabel];
    [passBtnLabel release];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, (passBtn.frame.size.height - 9)/2, 5, 9)];
    arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [passBtn addSubview:arrow];
    [arrow release];
    
    [self addLineWithFrame:CGPointMake(0, 44) inContainerView:footView];
    [self addLineWithFrame:CGPointMake(0, 87.5) inContainerView:footView];
    
    tipBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, passBtn.frame.origin.y + passBtn.frame.size.height + 12, SCREEN_WIDTH - 20, 60)];
    tipBg.image = [UIImage stretchableImageWithPath:@"yellow_round_bg.png"];
    tipBg.hidden = havePassword ? YES : NO;
    [footView addSubview:tipBg];
    [tipBg release];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tipBg.frame.size.width - 2*5, tipBg.frame.size.height)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"为了安全，建议您设置支付密码。\n设置成功后，使用现金账户支付，需输入正确的支付密码才能生效。";
    tipLabel.font = FONT_13;
    tipLabel.textColor = [UIColor grayColor];
    [tipBg addSubview:tipLabel];
    [tipLabel release];
}

//增加线条
-(void)addLineWithFrame:(CGPoint)point inContainerView:(UIView *)containerView{
    UIImage *lineImg = [UIImage imageNamed:@"dashed.png"];
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 320-point.x, SCREEN_SCALE)];
    lineImgView.image = lineImg;
    [containerView addSubview:lineImgView];
    [lineImgView release];
}


// 生成CA详情页面
- (void)makeUpCashDetailInView:(UIView *)aView
{
    aView.hidden = YES;
    
    // 清空已添加过的组件
    for (UIView *subView in aView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    // 加入分割线
    int offY = 35;
    int extraHeight = 10;           // 有详情时的额外高度
    offY += extraHeight;
    
    // 明细标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, offY, 48, 14)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_15;
    titleLabel.text = @"明细：";
    titleLabel.textColor = [UIColor darkGrayColor];
    [aView addSubview:titleLabel];
    [titleLabel release];
    
    // 金额详情
    int detailCount = 0;            // 一共显示多少项详情，金额为0的不显示
    double lockedAmount = [[cashAccountDic safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
    double backCashAmount = [[cashAccountDic objectForKey:BACK_CASH_AMOUNT] safeDoubleValue];
    double totalCashBackAmount = floor(backCashAmount) + floor(lockedAmount);
    if (totalCashBackAmount > 0)
    {
        NSString *valueStr =[NSString stringWithFormat:@"¥ %.f", totalCashBackAmount];
        if(lockedAmount>0){
            valueStr = [NSString stringWithFormat:@"¥ %.f  ( ¥ %.f冻结中 )",floor(totalCashBackAmount),floor(lockedAmount)];
            
            //取消政策
            cashDespBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cashDespBtn.frame = CGRectMake(280, offY-10, 36, 36);
            [cashDespBtn setImage:[UIImage noCacheImageNamed:@"icon_daiquanwenhao.png"] forState:UIControlStateNormal];
            [cashDespBtn addTarget:self action:@selector(lookDespAboutLockedAmount:) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:cashDespBtn];
            cashDespBtn.hidden = YES;
        }
        
        [self makeUpSubViewOfDetailView:aView
                                   OffY:offY
                                 Height:20
                                  Title:@"返现金额"
                                  Value:valueStr];
        
        detailCount ++;
        offY += 20;
    }
    
    double universalAmount = [[cashAccountDic objectForKey:UNIVERSAL_AMOUNT] safeDoubleValue];
    if (universalAmount > 0)
    {
        [self makeUpSubViewOfDetailView:aView
                                   OffY:offY
                                 Height:20
                                  Title:@"通用礼品卡金额"
                                  Value:[NSString stringWithFormat:@"¥ %.f", floor(universalAmount)]];
        
        detailCount ++;
        offY += 20;
    }
    
    double specifiedAmount = [[cashAccountDic objectForKey:SPECIFIED_AMOUNT] safeDoubleValue];
    if (specifiedAmount > 0)
    {
        [self makeUpSubViewOfDetailView:aView
                                   OffY:offY
                                 Height:20
                                  Title:@"专用礼品卡金额"
                                  Value:[NSString stringWithFormat:@"¥ %.f", floor(specifiedAmount)]];
        
        detailCount ++;
        offY += 20;
    }
    
    double giftcardAmount = [[cashAccountDic objectForKey:GIFTCARD_AMOUNT] safeDoubleValue];
    if (giftcardAmount) {
        [self makeUpSubViewOfDetailView:aView
                                   OffY:offY
                                 Height:20
                                  Title:@"红包余额"
                                  Value:[NSString stringWithFormat:@"¥ %.f", floor(giftcardAmount)]];
        detailCount ++;
    }
    
    if (detailCount > 0){
        // 有任意项时显示详情
        aView.hidden = NO;
        
        // 调整整体控件的高度
        CGRect rect = cashDetailBg.frame;
        rect.size.height += extraHeight;
        cashDetailBg.frame = rect;
        
        rect = cashDetailView.frame;
        rect.size.height += extraHeight;
        cashDetailView.frame = rect;
    }
}


// 生成具体的金额详情项
- (void)makeUpSubViewOfDetailView:(UIView *)detailView OffY:(CGFloat)offY Height:(CGFloat)height Title:(NSString *)titleStr Value:(NSString *)valueStr
{
    CGSize detailSize = [titleStr sizeWithFont:FONT_13];
    
    UILabel *detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, offY, detailSize.width, 16)];
    detailTitleLabel.backgroundColor = [UIColor clearColor];
    detailTitleLabel.font = FONT_13;
    detailTitleLabel.text = titleStr;
    detailTitleLabel.textColor = [UIColor lightGrayColor];
    [detailView addSubview:detailTitleLabel];
    [detailTitleLabel release];
    
    
    UILabel *detailValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailSize.width+65, offY, 255-detailSize.width, 16)];
    detailValueLabel.backgroundColor = [UIColor clearColor];
    detailValueLabel.font = FONT_13;
    detailValueLabel.text = valueStr;
    detailValueLabel.textColor = [UIColor colorWithRed:121/255 green:121/255 blue:121/255 alpha:1];
    [detailView addSubview:detailValueLabel];
    [detailValueLabel release];
    
    // 调整整体控件的高度
    CGRect rect = cashDetailBg.frame;
    rect.size.height += height;
    cashDetailBg.frame = rect;
    
    rect = cashDetailView.frame;
    rect.size.height += height;
    cashDetailView.frame = rect;
    //NSLog(@"%@", NSStringFromCGRect(table.tableHeaderView.frame));
}


// 刷新现金账户余额数据
- (void)refreshForRemain:(NSNotification *)noti
{
    NSDictionary *root = (NSDictionary *)[noti object];
    
    cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
    cashLockedAccount = [[root safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
    table.tableHeaderView = nil;
    SFRelease(cashAccountDic);
    cashAccountDic = [[NSDictionary alloc] initWithDictionary:root];
    
    [self makeUpHeaderViewForTable:table];
}


- (void)refreshCashAccountState
{
    havePassword = YES;
    tipBg.hidden = YES;
    passBtnLabel.text = @"重置支付密码";
}


- (void)refreshTokenState
{
    switch (withDrawType)
    {
        case WithDrawTypeBank:
            // 点击提现选项
            [Utils request:OTHER_SEARCH
                       req:[TokenReq getAppConfigWithAppKey:@"iphone_withdrawurl"]
                  delegate:self];
            break;
        case 1:
            // 点击充值选项
            [Utils request:OTHER_SEARCH
                       req:[TokenReq getAppConfigWithAppKey:@"iphone_phonerechargeurl"]
                  delegate:self];
            break;
        default:
            break;
    }
}


// 点击礼品卡是什么
- (void)clickGiftCardBtn
{
    CashAccountFaqVC *controller = [[CashAccountFaqVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    if (UMENG) {
        //礼品卡说明
        [MobClick event:Event_CAPrepaidCardInfo];
    }
    
    UMENG_EVENT(UEvent_UserCenter_CA_GiftCard)
}


// 点击密码按钮
- (void)clickPassBtn
{
    // 点击设置支付密码按钮
    CashAccountPasswordSetVC *controller = nil;
    
    if (havePassword)
    {
        controller = [[CashAccountPasswordSetVC alloc] initWithType:ECashAccountSetTypeReset];
    }
    else
    {
        controller = [[CashAccountPasswordSetVC alloc] initWithType:ECashAccountSetTypeSet];
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    UMENG_EVENT(UEvent_UserCenter_CA_ResetPwd)
}

-(void)lookDespAboutLockedAmount:(id)sender{
    UIButton *despBtn = (UIButton *)sender;
    despBtn.userInteractionEnabled = NO;
    if(despBgImgView==nil){
        despBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, despBtn.frame.origin.y+15, 310, 40)];
        UIImage *despBg = [UIImage  noCacheImageNamed:@"lockedAmountDespBg.png"];
        despBgImgView.image = [despBg stretchableImageWithLeftCapWidth:despBg.size.width/10 topCapHeight:despBg.size.height-despBg.size.height/5];
        [self.view addSubview:despBgImgView];
        [despBgImgView release];
        
        UILabel *despLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300,30)];
        despLabel.backgroundColor = [UIColor clearColor];
        despLabel.font = FONT_12;
        despLabel.tag = 99;
        despLabel.numberOfLines = 0;
        despLabel.lineBreakMode = UILineBreakModeWordWrap;
        despLabel.textColor = [UIColor whiteColor];
        [despBgImgView addSubview:despLabel];
        [despLabel release];
    }else{
        despBgImgView.alpha = 1.0;
    }
    UILabel *despLabel = (UILabel *)[despBgImgView viewWithTag:99];
    despLabel.text = self.cashDesp;
    CGSize cashDespSize = [self.cashDesp sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(300, 10000)];
    despLabel.frame = CGRectMake(10, 10, 300, cashDespSize.height+10);
    despBgImgView.frame = CGRectMake(10, despBtn.frame.origin.y+15, 310, cashDespSize.height+20);
    
    [despBtn performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:3.0];
    [UIView beginAnimations:@"Hidden" context:nil];
    [UIView setAnimationDelay:3.0];
    [UIView setAnimationDuration:0.5];
    despBgImgView.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)requestCashDescription{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setObject:@"Iphone" forKey:@"productLine"];
    [jsonDictionary setObject:@"MyElong" forKey:@"channel"];
    [jsonDictionary setObject:@"ReturnCashList" forKey:@"page"];
    [jsonDictionary setObject:@"ReturnCashDescription" forKey:@"positionId"];
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools" forService:@"contentResource" andParam:paramJson];
    
    
    if (cashDespUtil) {
        [cashDespUtil cancel];
        SFRelease(cashDespUtil);
    }
    if (STRINGHASVALUE(url)) {
        cashDespUtil = [[HttpUtil alloc] init];
        [cashDespUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    }
}


// 怎么花掉账户余额，暂时不弄了
//- (void)clickHowUseCashBtn
//{
//
//}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    withDrawType = buttonIndex;
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        TokenReq *token = [TokenReq shared];
        // 有accesstoken就使用，没有的情况重新请求新的accesstoken
        if (STRINGHASVALUE([token accessToken]))
        {
            [self refreshTokenState];
        }
        else
        {
            [token requestTokenWithLoading:YES];
        }
    }
    
    if (buttonIndex == 0) {
        if (UMENG) {
            //提现到银行卡
            [MobClick event:Event_CACashToBank];
        }
    }else if(buttonIndex == 1){
        if (UMENG) {
            //提现到手机号
            [MobClick event:Event_CACashToPhone];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18, 5, 9)];
        rightArrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        cell.accessoryView =rightArrow;
        [rightArrow release];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];

        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
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
        
        cell.textLabel.font = FONT_15;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"余额详情";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"礼品卡/红包充值";
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"提现";
        cell.detailTextLabel.text = @"仅返现金额可提现";
        cell.detailTextLabel.font = FONT_13;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"阳光网提现";
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView =[[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    return [headView autorelease];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            // 点击账户余额详情
            CashAccountDetailController *controller = [[[CashAccountDetailController alloc] init] autorelease];
            controller.balance = [NSString stringWithFormat:@"¥%.f", cashAccountRemain];
            [self.navigationController pushViewController:controller animated:YES];
            
            if (UMENG) {
                //余额详情
                [MobClick event:Event_CABalanceDetail];
            }
            
            UMENG_EVENT(UEvent_UserCenter_CA_RemainingDetail)
        }
            break;
        case 1:
        {
            // 点击礼品卡充值
            if (!havePassword)
            {
                // 没有设置密码时需要先进入密码设置页
                CashAccountPasswordSetVC *controller = [[CashAccountPasswordSetVC alloc] initWithType:ECashAccountSetTypeSet];
                controller.nextToRecharge = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else
            {
                // 有密码时，直接进入充值页
                GiftCardRecharge *controller = [[GiftCardRecharge alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            
            UMENG_EVENT(UEvent_UserCenter_CA_Recharge)
        }
            break;
        case 2:
        {
            if ([[ServiceConfig share] monkeySwitch])
            {
                // 开着monkey时不发生事件
                return;
            }
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"银行卡提现", @"为手机充值", nil];
            sheet.delegate			= self;
            sheet.actionSheetStyle	= UIBarStyleBlackTranslucent;
            [sheet showInView:self.view];
            [sheet release];
            
            UMENG_EVENT(UEvent_UserCenter_CA_Cash)
        }
            break;
        case 3:
        {
            NSString *title = @"阳光网提现" ;
            NSString *html5Link = @"https://secure.sunnychina.com/member/elongapplogin.html";
            Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:title Html5Link:html5Link];
            [self.navigationController pushViewController:html5Ctr animated:YES];
            [html5Ctr release];
        }
            break;
        default:
            break;
    }
}


#pragma mark - HttpUtil Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    if(util==cashDespUtil){
        if([Utils checkJsonIsErrorNoAlert:root]){
            return;
        }
    }else{
        if ([Utils checkJsonIsError:root]) {
            return;
        }
    }
    
    if (util == couponListUtil) {
        NSArray *mCouponArray = [root safeObjectForKey:@"CouponList"];
        [[MyElongCenter allCouponInfo] removeAllObjects];
        if (ARRAYHASVALUE(mCouponArray)) {
            [[MyElongCenter allCouponInfo] addObjectsFromArray:mCouponArray];
        }
        
        CouponListController *mCoupon = [[[CouponListController alloc] init] autorelease];
        mCoupon.detailList = [MyElongCenter allCouponInfo];
        [self.navigationController pushViewController:mCoupon animated:YES];
    }else if(util==cashDespUtil){
        self.cashDesp = @"";
        NSArray *contentList = [root objectForKey:@"contentList"];
        if(ARRAYHASVALUE(contentList)){
            NSString *content = [[contentList safeObjectAtIndex:0] safeObjectForKey:@"content"];
            if(content.length>3){
                double lockedAmount = [[cashAccountDic safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
                content = [content stringByReplacingOccurrencesOfString:@"{0}" withString:[NSString stringWithFormat:@"¥ %.f ",lockedAmount]];
                self.cashDesp= content;
                cashDespBtn.hidden = NO;
            }
        }
    }
    else
    {   
        NSString *html5Link = [root objectForKey:APP_VALUE];
        html5Link = [[TokenReq shared] getCashAccountHtml5LinkFromString:html5Link];
        
        NSString *title = withDrawType == 0 ? @"银行卡提现" : @"为手机充值";
        Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:title Html5Link:html5Link FromType:CASH_BACK];
        [self.navigationController pushViewController:html5Ctr animated:YES];
        [html5Ctr release];
    }
}


@end
