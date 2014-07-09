//
//  FlightCashAccountTable.m
//  ElongClient
//
//  Created by 赵 海波 on 14-3-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightCashAccountTable.h"
#import "FlightCashAccountTableViewCell.h"
#import "CashAccountTableCell.h"
#import "CashAccountReq.h"
#import "MBSwitch.h"
#import "CustomTextField.h"
#import "GrouponSharedInfo.h"

#define cell_height            45     // cell的高度
#define kSwitchTag             1135

@implementation FlightCashAccountTable

- (void)dealloc
{
    self.passwordField = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithTotalPrice:(CGFloat)price CashSwitch:(BOOL)canUseCash Frame:(CGRect)rect UniformFromType:(UniformFromType)accessType
{
    self.fromType=accessType;
    
    return [self initWithTotalPrice:price CashSwitch:canUseCash Frame:rect];
}


- (id)initNoMoneyDisplayWithTotalPrice:(CGFloat)price CashSwitch:(BOOL)canUseCash Frame:(CGRect)rect UniformFromType:(UniformFromType)accessType
{
    self.fromType = accessType;
    
    if (self = [self initWithTotalPrice:price CashSwitch:canUseCash Frame:rect])
    {
        needShowMoney = NO;
    }
    
    return self;
}


- (id)initWithTotalPrice:(CGFloat)price CashSwitch:(BOOL)canUseCash Frame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self)
    {
        self.totalPrice = price;
        self.caPayPrice = [[CashAccountReq shared] cashAccountRemain];
        _useCashAccount = NO;
        needShowMoney = YES;
        
        if (canUseCash)
        {
            // 使用CA账户时需要根据是否设置过密码来展示密码输入栏
            self.needCAPassword = [[CashAccountReq shared] needPassword];
            cellNum = 2;
        }
        else
        {
            cellNum = 1;
        }
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}


// 根据cell的行数取出xib上对应的页面
- (CashAccountTableCell *)getCashAccountTableCellByIndex:(NSInteger)index
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CashAccountTableCell" owner:self options:nil];
    for (id oneObject in nib)
    {
        NSInteger oIndex = [nib indexOfObject:oneObject];
        if (oIndex == index &&
            [oneObject isKindOfClass:[CashAccountTableCell class]])
        {
            CashAccountTableCell *cell = (CashAccountTableCell *)oneObject;
            return cell;
        }
    }
    
    return nil;
}


- (void)clickCASwitchBtn
{
    _useCashAccount = !_useCashAccount;
    
    if (_useCashAccount)
    {
        NSMutableArray *rows = [NSMutableArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil];
        
        if (_needCAPassword)
        {
            cellNum = 4;
            [rows addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
        }
        else
        {
            cellNum = 3;
        }
        
        [self insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
        
        NSDictionary *obj=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:_totalPrice],@"totalPrice",[NSNumber numberWithFloat:_caPayPrice],@"caPayPrice",[NSNumber numberWithInt:self.fromType],
                           @"fromType", nil];
        
        // 发送打开CA的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CASHACCOUNT_OPEN object:obj];
    }
    else
    {
        cellNum = 2;
        
        NSMutableArray *rows = [NSMutableArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil];
        
        if (_needCAPassword)
        {
            [rows addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
        }
        
        [self deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
        
        // 发送关闭CA的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CASHACCOUNT_PASSCANCEL object:nil];
        
        // 清空各流程的CA值
        [[HotelPostManager hotelorder] setCashAmount:0];
        
        GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
        gSharedInfo.cashAmount = [NSNumber numberWithInt:0];
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashAccountTableCell *cell = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            // 显示订单总价
            static NSString *identifier = @"FlightCashAccountTableViewCell";
            FlightCashAccountTableViewCell *cell = (FlightCashAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil)
            {
                cell = [FlightCashAccountTableViewCell cellFromNib];
            }
            
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", _totalPrice];
        }
            break;
        case 1:
        {
            // 显示现金支付开关
            static NSString *identifier1 = @"identifier1";
            cell = (CashAccountTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier1];
            
            if (cell == nil)
            {
                cell = [self getCashAccountTableCellByIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (IOSVersion_6)
                {
                    MBSwitch *switchItem = [[MBSwitch alloc] initWithFrame:CGRectMake(255, (cell_height-29) / 2, 51, 29)];
                    switchItem.on = NO;
                    switchItem.tag = kSwitchTag;
                    [switchItem addTarget:self action:@selector(clickCASwitchBtn) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:switchItem];
                }
                else
                {
                    // IOS4、5系统使用系统自带的控件
                    UISwitch *switchItem = [[UISwitch alloc] initWithFrame:CGRectMake(211, (cell_height-28) / 2, 70, 30)];
                    switchItem.on = NO;
                    switchItem.tag = kSwitchTag;
                    [switchItem addTarget:self action:@selector(clickCASwitchBtn) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:switchItem];
                }
            }
            
            UIView *invoiceSwitchBtn = (UIView *)[cell.contentView viewWithTag:kSwitchTag];
            if (IOSVersion_5) {
                ((MBSwitch *)invoiceSwitchBtn).on = _useCashAccount;
            }else{
                ((UISwitch *)invoiceSwitchBtn).on = _useCashAccount;
            }
        }
            break;
        case 2:
        {
            // 显示现金账户余额
            static NSString *identifier2 = @"identifier2";
            cell = (CashAccountTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier2];
            
            if (cell == nil)
            {
                cell = [self getCashAccountTableCellByIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", _caPayPrice];
        }
            break;
        case 3:
        {
            // 支付密码输入、重置
            static NSString *identifier4 = @"identifier4";
            cell = (CashAccountTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier4];
            
            if (cell == nil)
            {
                cell = [self getCashAccountTableCellByIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                self.passwordField = [[CustomTextField alloc] initWithFrame:CGRectMake(98, (cell_height-22) / 2, 120, 30)];
                self.passwordField.borderStyle = UITextBorderStyleNone;
                self.passwordField.delegate = self;
                self.passwordField.placeholder = @"输入支付密码";
                self.passwordField.textAlignment = UITextAlignmentCenter;
                self.passwordField.font = FONT_16;
                [self.passwordField showWordKeyboard];
                self.passwordField.secureTextEntry = YES;
                self.passwordField.abcEnabled = YES;
                self.passwordField.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:self.passwordField];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && needShowMoney == NO)
    {
        return 0;
    }
    
    return cell_height;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.contentInset.bottom != 0)
    {
        [self endEditing:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidActive:(id)sender {
	if (self.contentInset.bottom == 0) {
		self.contentInset = UIEdgeInsetsMake(0, 0, 261, 0);
		[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]
                    atScrollPosition:UITableViewScrollPositionMiddle
                            animated:YES];
	}
}


- (void)textFieldDidEnd:(id)sender {
	if ((self.contentInset.bottom != 0 && [sender isFirstResponder]) ||
		!sender) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		self.contentInset = UIEdgeInsetsZero;
		
		[UIView commitAnimations];
	}
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [(CustomTextField *)textField resetTargetKeyboard];
        [self textFieldDidActive:nil];
    }
    
    return YES;
}


- (void)keyboardWillHide:(NSNotification *)noti {
	[self textFieldDidEnd:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self textFieldDidEnd:nil];
	return [textField resignFirstResponder];
}


@end
