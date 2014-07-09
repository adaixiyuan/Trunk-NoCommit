//
//  PaymentTypeTable.m
//  ElongClient
//  展示用户支付方式选择项
//
//  Created by 赵 海波 on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PaymentTypeTable.h"
#import "PaymentTypeTableCell.h"
#import "AttributedLabel.h"
#import "HotelDetailController.h"
#import "UniformCounterDataModel.h"

#define kPayTypeCount          5      // 支付方式种类数
#define cell_height            45     // cell的高度

@interface PaymentTypeTable ()

@property (nonatomic, strong) NSArray *payTypeArray;     // 记录可支付类型
@property (nonatomic, strong) NSMutableArray *showTypes; // 展示给用户看的支付方式

@end

@implementation PaymentTypeTable
@synthesize payTypeArray;
@synthesize showTypes;
@synthesize paySection = _paySection;
@synthesize ruleBtn;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithPaymentTypes:(NSArray *)types
{
    return [self initWithPaymentTypes:types paySection:UniformPaymentSection];
}

- (id)initWithPaymentTypes:(NSArray *)types paySection:(UniformPaySection)section{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [types count] * cell_height + 70) style:UITableViewStylePlain];
    if (self){
        self.paySection = section;
        self.scrollEnabled = NO;
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.payTypeArray = types;
        self.showTypes = [NSMutableArray arrayWithArray:types];
        _selectedPayType = UniformPaymentTypeCreditCard;
        dataModel = [UniformCounterDataModel shared];
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiCashAccountOpen:)
                                                     name:NOTI_CASHACCOUNT_OPEN
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiCashAccountCancel)
                                                     name:NOTI_CASHACCOUNT_PASSCANCEL
                                                   object:nil];
        
        // 构造主页面
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        headerView.backgroundColor = [UIColor clearColor];
        
        headerTitleLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(0, headerView.bounds.size.height - 22, SCREEN_WIDTH, 20)];
        headerTitleLabel.backgroundColor = [UIColor clearColor];
        
        if (self.paySection == UniformPaymentSection)
        {
            if (dataModel.fromType == UniformFromTypeGroupon)
            {
                NSString *moneyStr = [NSString stringWithFormat:@"%.2f", dataModel.waitingPayMoney];
                headerTitleLabel.text = [NSString stringWithFormat:@"   还需支付%@，请选择支付方式", moneyStr];
                [headerTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:headerTitleLabel.text.length];
                [headerTitleLabel setColor:RGBCOLOR(249, 76, 21, 1) fromIndex:7 length:moneyStr.length];
                [headerTitleLabel setFont:FONT_13 fromIndex:0 length:headerTitleLabel.text.length];
            }
            else
            {
                headerTitleLabel.text = @"   选择支付方式";
                [headerTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:headerTitleLabel.text.length];
                [headerTitleLabel setFont:FONT_13 fromIndex:0 length:headerTitleLabel.text.length];
            }
        }
        else if(self.paySection == UniformGuaranteeSection){
            headerTitleLabel.text = @"   选择担保方式";
            [headerTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:headerTitleLabel.text.length];
            [headerTitleLabel setFont:FONT_13 fromIndex:0 length:headerTitleLabel.text.length];
        }
        [headerView addSubview:headerTitleLabel];
        
        // 担保或者预付规则
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ruleBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 0, 70, 30);
        ruleBtn.titleLabel.font = FONT_13;
        [ruleBtn setTitleColor:RGBACOLOR(40, 141, 242, 1) forState:UIControlStateNormal];
        [ruleBtn setTitleColor:RGBACOLOR(28, 98, 169, 1) forState:UIControlStateHighlighted];
        [ruleBtn setTitle:@"担保规则" forState:UIControlStateNormal];
        [footerView addSubview:ruleBtn];
        [ruleBtn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        ruleBtn.hidden = YES;
        self.tableFooterView = footerView;
        
        [headerView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, headerView.frame.size.height, SCREEN_WIDTH, SCREEN_SCALE)]];
        self.tableHeaderView = headerView;
    }
    
    return self;
}

- (void) setPaySection:(UniformPaySection)paySection{
    _paySection = paySection;
    if (self.paySection == UniformPaymentSection) {
        if (dataModel.fromType == UniformFromTypeGroupon)
        {
            headerTitleLabel.text = [NSString stringWithFormat:@"   还需支付%.2f，请选择支付方式", dataModel.waitingPayMoney];
        }
        else
        {
            headerTitleLabel.text = @"   选择支付方式";
            [headerTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:headerTitleLabel.text.length];
            [headerTitleLabel setFont:FONT_13 fromIndex:0 length:headerTitleLabel.text.length];
        }
    }else if(self.paySection == UniformGuaranteeSection)
    {
        headerTitleLabel.text = @"   选择担保方式";
        [headerTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:headerTitleLabel.text.length];
        [headerTitleLabel setFont:FONT_13 fromIndex:0 length:headerTitleLabel.text.length];
    }
    [self reloadData];
    
}

- (void) ruleBtnClick:(id)sender{
    if ([self.root respondsToSelector:@selector(paymentTypeRuleAction:)]) {
        [self.root paymentTypeRuleAction:self];
    }
}

#pragma mark - NSNotificationCenter

- (void)notiCashAccountOpen:(NSNotification *)noti
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.navigationController.topViewController isKindOfClass:[UniformCounterViewController class]])
    {
        NSDictionary *obj=[noti object];
        
        if (obj==nil) {
            return;
        }
        
        float totalPrice = [[obj safeObjectForKey:@"totalPrice"] floatValue];
        float caPayPrice = [[obj safeObjectForKey:@"caPayPrice"] floatValue];  //返现是人名币，不减汇率
        UniformFromType fromType=[[obj safeObjectForKey:@"fromType"] intValue];
        
        float money=totalPrice-caPayPrice;
        
        NSString *moneyStr = nil;
        float exchangeRate=1;//汇率
        if (fromType==UniformFromTypeHotel)
        {
            NSDictionary *roomTypeDic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
            if (roomTypeDic)
            {
                exchangeRate=[[roomTypeDic safeObjectForKey:@"ExchangeRate"] floatValue];
            }
        }
        
        moneyStr = [NSString stringWithFormat:@"¥%.2f", exchangeRate>0?totalPrice*exchangeRate-caPayPrice:money];
        
        if (!caHeaderTitleLabel)
        {
            caHeaderTitleLabel = [[AttributedLabel alloc] initWithFrame:headerTitleLabel.frame];
            caHeaderTitleLabel.text = [NSString stringWithFormat:@"   还需支付%@，请选择支付方式", moneyStr];
            caHeaderTitleLabel.backgroundColor = [UIColor clearColor];
            [caHeaderTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:caHeaderTitleLabel.text.length];
            [caHeaderTitleLabel setColor:RGBCOLOR(249, 76, 21, 1) fromIndex:7 length:moneyStr.length];
            [caHeaderTitleLabel setFont:FONT_13 fromIndex:0 length:caHeaderTitleLabel.text.length];
            [self.tableHeaderView addSubview:caHeaderTitleLabel];
        }
        
        headerTitleLabel.hidden = YES;
        caHeaderTitleLabel.hidden = NO;
        
        // CA打开时，只存在信用卡一种支付方式，如果CA金额足够支付，不显示其它支付方式
        [showTypes removeAllObjects];
        
        if (money > 0)
        {
            NSMutableArray *payMethods = [[UniformCounterDataModel shared] caSupportPaymethods];
            if ([payMethods count] == 0)
            {
                // 没有使用统一收银台的流程，还是默认选用信用卡
                [showTypes addObject:NUMBER(UniformPaymentTypeCreditCard)];
            }
            else
            {
                [showTypes addObjectsFromArray:payMethods];
            }
            
            if (![showTypes containsObject:NUMBER(_selectedPayType)] ||
                _selectedPayType == UniformPaymentTypeCreditCard)
            {
                // 选择方式不在当前支持的方式集合中，就默认选中信用卡混合支付
                self.selectedPayType = UniformPaymentTypeCreditCard;
            }
        }
        else
        {
            // 选择没有担保方式
            self.tableHeaderView.hidden = YES;
            self.selectedPayType = UniformPaymentTypeNone;
        }
        
        [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)notiCashAccountCancel
{
    headerTitleLabel.hidden = NO;
    caHeaderTitleLabel.hidden = YES;
    
    // CA关闭时，恢复初始时的展示
    [showTypes removeAllObjects];
    [showTypes addObjectsFromArray:payTypeArray];
    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    self.tableHeaderView.hidden = NO;
    
    // 如果订单数据中有CA支付状态，将其置回
    [dataModel cancelCAPayment];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kPayTypeCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    PaymentTypeTableCell *cell = (PaymentTypeTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeTableCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[PaymentTypeTableCell class]]) {
                cell = (PaymentTypeTableCell *)oneObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}
    }
    
    switch (indexPath.row)
    {
        case UniformPaymentTypeCreditCard:
        {
            cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_creditCard_icon.png"];
            if (self.paySection == UniformPaymentSection) {
                cell.payTypeNameLabel.text = @"信用卡支付（推荐）";
            }else if(self.paySection == UniformGuaranteeSection){
                cell.payTypeNameLabel.text = @"信用卡担保（推荐）";
            }
            cell.payTypeDetailLabel.text = @"";//@"推荐有国内信用卡的用户使用";
            NSString *checkIcon = indexPath.row == _selectedPayType ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
            cell.checkBox.image = [UIImage imageNamed:checkIcon];
            cell.clipsToBounds = YES;
        }
            break;
        case UniformPaymentTypeDepositCard:
        {
            cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_depositCard_icon.png"];
            if (self.paySection == UniformPaymentSection) {
                cell.payTypeNameLabel.text = @"储蓄卡支付";
            }else if(self.paySection == UniformGuaranteeSection){
                cell.payTypeNameLabel.text = @"储蓄卡担保";
            }
            cell.payTypeDetailLabel.text = @"";//@"推荐有国内银行储蓄卡的用户使用";
            NSString *checkIcon = indexPath.row == _selectedPayType ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
            cell.checkBox.image = [UIImage imageNamed:checkIcon];
            cell.clipsToBounds = YES;
        }
            break;
        case UniformPaymentTypeWeixin:
        {
            cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_weixin_icon.png"];
            if (self.paySection == UniformPaymentSection) {
                cell.payTypeNameLabel.text = @"微信支付";
            }else if(self.paySection == UniformGuaranteeSection){
                cell.payTypeNameLabel.text = @"微信担保";
            }
            cell.payTypeDetailLabel.text = @"(5.0及以上版本)";//@"推荐安装微信5.0及以上版本的用户使用";
            NSString *checkIcon = indexPath.row == _selectedPayType ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
            cell.checkBox.image = [UIImage imageNamed:checkIcon];
            cell.clipsToBounds = YES;
        }
            break;
        case UniformPaymentTypeAlipay:
        {
            cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_alipay_icon.png"];
            if (self.paySection == UniformPaymentSection) {
                cell.payTypeNameLabel.text = @"支付宝客户端支付";
            }else if(self.paySection == UniformGuaranteeSection){
                cell.payTypeNameLabel.text = @"支付宝客户端担保";
            }
            cell.payTypeDetailLabel.text = @"";//@"推荐安装支付宝客户端的用户使用";
            NSString *checkIcon = indexPath.row == _selectedPayType ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
            cell.checkBox.image = [UIImage imageNamed:checkIcon];
            cell.clipsToBounds = YES;
        }
            break;
        case UniformPaymentTypeAlipayWap:
        {
            cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_alipay_wap_icon.png"];
            if (self.paySection == UniformPaymentSection) {
                cell.payTypeNameLabel.text = @"支付宝网页支付";
            }else if(self.paySection == UniformGuaranteeSection){
                cell.payTypeNameLabel.text = @"支付宝网页担保";
            }
            cell.payTypeDetailLabel.text = @"";//@"推荐有支付宝账户的用户使用";
            NSString *checkIcon = indexPath.row == _selectedPayType ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
            cell.checkBox.image = [UIImage imageNamed:checkIcon];
            cell.clipsToBounds = YES;
        }
            break;
        default:
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([showTypes containsObject:[NSNumber numberWithInt:indexPath.row]])
    {
        return cell_height;
    }
    else
    {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPayType = indexPath.row;
    [UniformCounterViewController setPaymentType:_selectedPayType];
    [tableView reloadData];
    
    if ([_root respondsToSelector:@selector(selectPayment:)])
    {
        [_root selectPayment:_selectedPayType];
    }
}

@end
