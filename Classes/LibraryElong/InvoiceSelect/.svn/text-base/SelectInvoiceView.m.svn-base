//
//  SelectInvoiceView.m
//  ElongClient
//
//  Created by Dawn on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SelectInvoiceView.h"
#import "HotelOrderCell.h"
#import "MBSwitch.h"
#import "AccountManager.h"
#import "MyElongPostManager.h"
#import "ElongURL.h"
#import "HotelOrderInvoiceCell.h"
#import "FlightDataDefine.h"
#import "AddAddress.h"

@interface SelectInvoiceView(){
    UITableView *_invoiceList;
    BOOL _addressEnabled;
    HttpUtil *_addressUtil;
    FilterView *_invoiceTypeSelect;
}
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGFloat cellWidth;
@property (nonatomic,retain) NSMutableArray *invoiceAddresses;
@property (nonatomic,retain) NSArray *invoiceTypes;
@property (nonatomic,assign) NSInteger invoiceIndex;
@property (nonatomic,assign) BOOL loginStatus;


@end

@implementation SelectInvoiceView

- (void) dealloc{
    self.delegate = nil;
    _invoiceList.delegate = nil;
    _invoiceList.dataSource = nil;
    self.invoiceAddresses = nil;
    self.invoiceTypes = nil;
    if (_addressUtil) {
        [_addressUtil cancel];
        [_addressUtil release];
        _addressUtil = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame cellHeight:(CGFloat)cellHeight invoiceTypes:(NSArray *)types{
    if (self = [super initWithFrame:frame]) {
        // 准备数据
        self.cellHeight = cellHeight;
        self.cellWidth = frame.size.width;
        self.invoiceTypes = types;
        if (_invoiceType) {
            [_invoiceType release];
            _invoiceType = [self.invoiceTypes objectAtIndex:0];
            [_invoiceType retain];
        }
        _needInvoice = NO;
        if (types) {
            if (types.count) {
                [_invoiceType release];
                _invoiceType = [types objectAtIndex:0];
                [_invoiceType retain];
            }
        }
        
        _invoiceList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, cellHeight) style:UITableViewStylePlain];
        _invoiceList.delegate = self;
        _invoiceList.scrollEnabled = NO;
        _invoiceList.dataSource = self;
        [self addSubview:_invoiceList];
        [_invoiceList release];
        
        if (IOSVersion_7 || (IOSVersion_4 && !IOSVersion_5)) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressInfo:) name:ADDRESS_ADD_NOTIFICATION object:nil];
    }
    return self;
}

- (NSDictionary *)invoice{
    if (self.invoiceAddresses) {
        if (self.invoiceAddresses.count > self.invoiceIndex) {
            return [self.invoiceAddresses objectAtIndex:self.invoiceIndex];
        }
    }
    return nil;
}


- (void) setFrame:(CGRect)frame{
    if (frame.size.height != self.frame.size.height) {
        if ([self.delegate respondsToSelector:@selector(selectInvoiceView:didResizedToFrame:)]) {
            [self.delegate selectInvoiceView:self didResizedToFrame:frame];
        }
    }
    [super setFrame:frame];
}

- (void)invoiceSwitchBtnClick:(id)sender{
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (self.invoiceAddresses == nil) {
        self.invoiceAddresses = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    }
    if (islogin && self.invoiceAddresses.count == 0 && !_needInvoice) {
        // 已经登录并且尚未请求到地址信息
        _addressEnabled = NO;
        JGetAddress *jads=[MyElongPostManager getAddress];
        [jads clearBuildData];
        
        if (_addressUtil) {
            [_addressUtil cancel];
            SFRelease(_addressUtil);
        }
        
        _addressUtil = [[HttpUtil alloc] init];
        [_addressUtil connectWithURLString:MYELONG_SEARCH Content:[jads requesString:YES] StartLoading:NO EndLoading:NO  Delegate:self];
    }else{
        _addressEnabled = YES;
    }
    
    
    _needInvoice = !_needInvoice;
    [_invoiceList reloadData];
    self.loginStatus = islogin;
    
    
}

- (void) reloadData{
    // 处理中途登录的情况
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (!self.loginStatus && islogin && _needInvoice) {
        self.loginStatus = islogin;
        if (self.invoiceAddresses == nil) {
            self.invoiceAddresses = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        }
        if (self.loginStatus && self.invoiceAddresses.count == 0) {
            // 已经登录并且尚未请求到地址信息
            _addressEnabled = NO;
            JGetAddress *jads=[MyElongPostManager getAddress];
            [jads clearBuildData];
            
            if (_addressUtil) {
                [_addressUtil cancel];
                SFRelease(_addressUtil);
            }
            
            _addressUtil = [[HttpUtil alloc] init];
            [_addressUtil connectWithURLString:MYELONG_SEARCH Content:[jads requesString:YES] StartLoading:NO EndLoading:NO  Delegate:self];
        }else{
            _addressEnabled = YES;
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    cellNum = 1;
    if (self.needInvoice)
    {
        cellNum = 4 + (self.invoiceAddresses.count ? self.invoiceAddresses.count + 1 : 0);
    }else{
        cellNum = 1;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cellNum * self.cellHeight);
    _invoiceList.frame = self.bounds;
    
    return cellNum;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1|| indexPath.row == 2 || indexPath.row == 3 || indexPath.row == [self tableView:tableView numberOfRowsInSection:2] - 1) {
        static NSString *cellIdentifier = @"InvoiceCell";
        HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            if (IOSVersion_6){
                MBSwitch *invoiceSwitchBtn = [[MBSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (44-30) / 2, 50, 30)];
                invoiceSwitchBtn.on = NO;
                invoiceSwitchBtn.tag = 1011;
                
                invoiceSwitchBtn.on = self.needInvoice;
                [cell addSubview:invoiceSwitchBtn];
                [invoiceSwitchBtn release];
                invoiceSwitchBtn.hidden = YES;
                [invoiceSwitchBtn addTarget:self action:@selector(invoiceSwitchBtnClick:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:invoiceSwitchBtn];
            }
            else{
                // IOS4系统使用系统自带的控件
                UISwitch *invoiceSwitchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(211, (44-28) / 2, 70, 33)];
                invoiceSwitchBtn.on = NO;
                invoiceSwitchBtn.tag = 1011;
                invoiceSwitchBtn.on = self.needInvoice;
                [cell addSubview:invoiceSwitchBtn];
                [invoiceSwitchBtn release];
                invoiceSwitchBtn.hidden = YES;
                [invoiceSwitchBtn addTarget:self action:@selector(invoiceSwitchBtnClick:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:invoiceSwitchBtn];
            }
            
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.frame = CGRectMake(SCREEN_WIDTH - 30, 12, 20, 20);
            activityView.tag = 1012;
            [cell addSubview:activityView];
            [activityView release];
            activityView.hidden = YES;
            
        }
        if (indexPath.row == 0) {
            cell.cellType = -1;
        }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1){
            cell.cellType = 1;
        }else{
            cell.cellType = 0;
        }
        
        [cell setArrowHidden:YES];
        cell.textField.hidden = YES;
        [cell setCustomerHidden:YES];
        [cell setTitle:@""];
        [cell setDetail:@""];
        
        UIView *invoiceSwitchBtn = (UIView *)[cell viewWithTag:1011];
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[cell viewWithTag:1012];
        invoiceSwitchBtn.hidden = YES;
        activityView.hidden = YES;
        if (indexPath.row == 0) {
            if (IOSVersion_5) {
                ((MBSwitch *)invoiceSwitchBtn).on = self.needInvoice;
            }else{
                ((UISwitch *)invoiceSwitchBtn).on = self.needInvoice;
            }
            
            invoiceSwitchBtn.hidden = NO;
            [cell setTitle:@"需要发票"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.needInvoice) {
                if (_addressEnabled) {
                    [activityView stopAnimating];
                    activityView.hidden = YES;
                    invoiceSwitchBtn.hidden = NO;
                }else{
                    [activityView startAnimating];
                    activityView.hidden = NO;
                    invoiceSwitchBtn.hidden = YES;
                }
            }else{
                [activityView stopAnimating];
                activityView.hidden = YES;
                invoiceSwitchBtn.hidden = NO;
            }
            
        }else if(indexPath.row == 1){
            [cell setTitle:@"抬头"];
            cell.textField.hidden = NO;
            cell.textField.placeholder = @"输入发票抬头";
            cell.textField.delegate = self;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.frame = CGRectMake(100 + 12 - 60, 0, 170 + 80 , 44);
            if (self.invoiceTitle) {
                
                cell.textField.text = self.invoiceTitle;
            }
        }else if(indexPath.row == 2){
            [cell setTitle:@"选择发票类型"];
            [cell setArrowHidden:NO];
            [cell setDetail:self.invoiceType];
        }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:2] - 1){
            [cell setTitle:@"新增邮寄地址"];
            [cell setArrowHidden:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }else if(indexPath.row == 3){
            [cell setTitle:@"选择邮寄地址"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            [cell setTitle:[NSString stringWithFormat:@"地址%d",indexPath.row - 4]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"InvoiceAddressCell";
        HotelOrderInvoiceCell *cell = (HotelOrderInvoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[HotelOrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *addressDict = [self.invoiceAddresses objectAtIndex:indexPath.row - 4];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",[addressDict objectForKey:KEY_NAME],[addressDict objectForKey:KEY_ADDRESS_CONTENT]];
        if (indexPath.row - 4 == self.invoiceIndex) {
            cell.checked = YES;
        }else{
            cell.checked = NO;
        }
        return cell;
    }
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 发票抬头属于输入框，不在此触发
    if (indexPath.row != 1) {
        if ([self.delegate respondsToSelector:@selector(selectInvoiceView:didSelectAtIndex:)]) {
            [self.delegate selectInvoiceView:self didSelectAtIndex:indexPath.row];
        }
    }
    if (indexPath.row == 2) {
        // 发票类型选择
        if (!_invoiceTypeSelect) {
            if([self.delegate isKindOfClass:[UIViewController class]]){
                UIViewController *baseVC = (UIViewController *)self.delegate;
                _invoiceTypeSelect = [[FilterView alloc] initWithTitle:@"发票类型"
                                                                 Datas:self.invoiceTypes];
                [baseVC.view addSubview:_invoiceTypeSelect.view];
            }
            
        }
        _invoiceTypeSelect.delegate = self;
        [_invoiceTypeSelect showInView];
    }else if(self.needInvoice   && indexPath.row == [self tableView:tableView numberOfRowsInSection:2] - 1){
        // 邮寄地址选择
        if (self.delegate) {
            if([self.delegate isKindOfClass:[UIViewController class]]){
                AddAddress *controller = [[AddAddress alloc] init];
                [((UIViewController *)self.delegate).navigationController pushViewController:controller animated:YES];
                [controller release];
            }
        }
    }else if (indexPath.row - 4 >= 0) {
        // 选择发票
        self.invoiceIndex = indexPath.row - 4;
        [_invoiceList reloadData];
    }
    
    
}

#pragma mark -
#pragma mark FilterViewDelegate
- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView{
    if(filterView == _invoiceTypeSelect){
        if (_invoiceType) {
            [_invoiceType release];
            _invoiceType = nil;
        }
        _invoiceType = filterStr;
        [_invoiceType retain];
        [_invoiceList reloadData];
    }
}

#pragma mark -
#pragma mark AddressNotification
- (void)addressInfo:(NSNotification *)noti {
	// 接收新加入的地址信息
	NSDictionary *dDictionary = (NSDictionary *)[noti object];
    
    NSDictionary *addressDict = [NSDictionary dictionaryWithObjectsAndKeys:[dDictionary safeObjectForKey:KEY_NAME],KEY_NAME,[dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT],KEY_ADDRESS_CONTENT, nil];
	
	[self.invoiceAddresses addObject:addressDict];
    self.invoiceIndex = self.invoiceAddresses.count - 1;
    [_invoiceList reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(selectInvoiceView:didSelectAtIndex:)]) {
        [self.delegate selectInvoiceView:self didSelectAtIndex:1];
    }
    
    // 隐藏发票抬头选择
    if (_invoiceTypeSelect) {
        [_invoiceTypeSelect dismissInView];
    }
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 发票抬头
    NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // 发票抬头
    if (_invoiceTitle) {
        [_invoiceTitle release];
    }
    _invoiceTitle = tagStr;
    [_invoiceTitle retain];
    return YES;
}

- (void) textFieldDidChange:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    if (textField.delegate != self) {
        return;
    }
    
    // 发票抬头
    if (_invoiceTitle) {
        [_invoiceTitle release];
    }
    _invoiceTitle = textField.text;
    [_invoiceTitle retain];
}

#pragma mark -
#pragma mark NetDelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
    if(util == _addressUtil){
        // 请求邮寄地址
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        for (NSDictionary *dict in [root safeObjectForKey:KEY_ADDRESSES]) {
            NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
            [self.invoiceAddresses addObject:dDictionary];
            [dDictionary release];
        }
        _addressEnabled = YES;
        [_invoiceList reloadData];
    }
}
@end
