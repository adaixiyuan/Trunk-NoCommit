//
//  AddOrEditPassengerVC.m
//  ElongClient
//
//  Created by Zhao Haibo on 13-11-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "AddOrEditPassengerVC.h"
#import "PassengerCell.h"
#import "StringEncryption.h"
#import "Mytrain_submitOrder.h"
#import "TrainFillOrderVC.h"
#import "JAddCustomer.h"
#import "MyElongPostManager.h"
#import "ElongURL.h"

#define k_cellHeight        50

#define ERROR_NAME_TIP		@"请正确输入姓名，姓名不能为空、不能包含数字与符号，请重新输入！"
#define ERROR_IDENTITY_TIP	@"请输入正确的身份证号"
#define ERROR_NUMBER_TIP	@"请正确输入证件号码，证件号码只允许填写英文字母及阿拉伯数字，其它字符请忽略。例: 432432(B) 填写为 432432B"

@interface AddOrEditPassengerVC ()

@property (nonatomic, copy) NSString *customerName;         // 去空字符串后的名字
@property (nonatomic, copy) NSString *customerNumber;       // 去空字符串后的卡号
@property (nonatomic, retain) NSArray *allPassengers;       // 所有的乘客
@property (nonatomic, retain) NSDictionary *modifyPasger;   // 待修改乘客

@end

@implementation AddOrEditPassengerVC


- (void)dealloc
{
    [nameField release];
    [certNumField release];
    [certTypeLabel release];
    [selectTable release];
    [_customerName release];
    [_customerNumber release];
    [_allPassengers release];
    
    [super dealloc];
}


- (id)initWithAllPassengers:(NSArray *)passengers type:(PassengerType)passengerType
{
    if (self = [super init])
    {
        type = passengerType;
        self.allPassengers = passengers;
        
        [self makeUpTopBarWithTitle:@"新增乘客"];
        [self performSelector:@selector(makeUpMainView) withObject:self afterDelay:0];
    }
    
    return self;
}


- (void)setModifyPassenger:(NSDictionary *)modifyDic
{
//    titleLabel.text = @"修改乘客";
    [self setNavTitle:@"编辑乘客"];
    self.modifyPasger = modifyDic;
}

#pragma mark -
#pragma mark Verify Method

- (NSString *)verifyName
{
	if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:nameField.text]) {
		// 中文名校验
		self.customerName = [nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (_customerName.length < 2 || _customerName.length > 10) {
			return @"成人姓名不能超过10个汉字，不少于2个汉字";
		}
		
		return nil;
	}
	else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\\\\s]{1,99}'"] evaluateWithObject:nameField.text])
    {
		// 英文名校验
        if (type == PassengerTypeFlight)
        {
            if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '(^([a-zA-Z\\\\s])+\\/[a-zA-Z\\\\s]+$)'"] evaluateWithObject:nameField.text]) {
                NSString *preStr = [[nameField.text stringByMatching:@".*/"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (!STRINGHASVALUE(preStr) || [preStr isEqualToString:@"/"]) {
                    return ERROR_NAME_TIP;
                }
                NSString *sufStr = [[nameField.text stringByMatching:@"(?<=/).*"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (!STRINGHASVALUE(sufStr)) {
                    return ERROR_NAME_TIP;
                }
                
                self.customerName = [preStr stringByAppendingString:sufStr];
                if (_customerName.length > 27) {
                    return @"成人姓名不能超过27个字符";
                }
                return nil;
            }
            
            return ERROR_NAME_TIP;
        }
    
        self.customerName = [nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (_customerName.length > 27) {
            return @"成人姓名不能超过27个字符";
        }
        return nil;
	}
	else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[a-zA-Z\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:nameField.text]) {
		// 中英文混合校验
		self.customerName = [nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSArray *enStrings = [_customerName componentsMatchedByRegex:@"[a-zA-Z]*"];
		int enLength = 0;			// 英文部分长度
		
		for (NSString *str in enStrings) {
			enLength += str.length;
		}
		
		int totalLength = (_customerName.length - enLength) * 2 + enLength;
		
		if (totalLength < 3 || totalLength > 27) {
			return @"成人姓名不能超过27个字符";
		}
		
		return nil;
	}
	else {
		return ERROR_NAME_TIP;
	}
}


- (NSString *)verifyNumber {
	self.customerNumber = [certNumField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	if ([certTypeLabel.text isEqualToString:@"身份证"]) {
		if (_customerNumber.length == 15) {
			if (NUMBERISRIGHT(_customerNumber)) {
				return nil;
			}
		}
		else if (_customerNumber.length == 18) {
            if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^([0-9]){17}+[xX0-9\\n]'"] evaluateWithObject:_customerNumber])
            {
				return nil;
			}
            else {
                return ERROR_IDENTITY_TIP;
            }
		}
		else {
			return ERROR_IDENTITY_TIP;
		}
	}
	else {
		// 其它证件类型只能包含数字和英文
		if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[A-Za-z0-9\\\\s]{1,99}'"] evaluateWithObject:_customerNumber]) {
			return ERROR_NUMBER_TIP;
		}
	}
	
	return nil;
}


- (BOOL)checkExistType:(NSString *)typeString Number:(NSString *)numberString
{
	for (NSObject *obj in _allPassengers)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = (NSDictionary *)obj;
            // 从乘客列表进入的情况
//            if ([[dic objectForKey:IDTYPENAME] isEqualToString:typeString] &&
//                [[dic objectForKey:IDNUMBER] isEqualToString:numberString])
            if ([[Utils getCertificateType:[dic objectForKey:IDTYPENAME]] isEqualToNumber:[Utils getCertificateType:typeString]] &&
                [[dic objectForKey:IDNUMBER] isEqualToString:numberString])
            {
                // 找到重复的证件
                return YES;
            }
        }
        else if ([obj isKindOfClass:[Passenger class]])
        {
            // 从列车订单填写页直接进入
            Passenger *passenger = (Passenger *)obj;
            if ([[TrainFillOrderVC getCertTypeNameByTypeEnum:passenger.certType] isEqualToString:typeString] &&
                [passenger.certNumber isEqualToString:numberString] &&
                !DICTIONARYHASVALUE(_modifyPasger))
            {
                // 找到重复的证件
                return YES;
            }
        }
    }
    
	return NO;
}


- (NSString *)validateUserInputData
{
	if ([nameField.text length] == 0)
    {
		return @"请输入乘客姓名";
	}
    
    if ([certNumField.text length] == 0)
    {
        return @"请输入证件号";
    }
	
	NSString *errorStr = nil;
	errorStr = [self verifyName];
	if (!errorStr) {
		errorStr = [self verifyNumber];
	}
	if (errorStr) {
		return errorStr;
	}
	
    NSString *modifiedIdNumber = nil;
    if (DICTIONARYHASVALUE(_modifyPasger))
    {
        NSUInteger repeatIndex = 0;
        for (NSObject *obj in _allPassengers)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)obj;
                // 从乘客列表进入的情况
                if ([[dic objectForKey:IDTYPENAME] isEqualToString:certTypeLabel.text] &&
                    [[dic objectForKey:IDNUMBER] isEqualToString:[StringEncryption EncryptString:certNumField.text]])
                {
                    // 找到重复的证件
                    repeatIndex++;
                }
            }
        }
        
        if (repeatIndex == 2) {
            return @"乘客列表中已包含该证件";
        }
        
        modifiedIdNumber = [StringEncryption DecryptString:[NSString stringWithFormat:@"%@", [_modifyPasger objectForKey:IDNUMBER]]];
        if (STRINGHASVALUE(modifiedIdNumber) && ![modifiedIdNumber isEqualToString:certNumField.text] && [self checkExistType:certTypeLabel.text Number:[StringEncryption EncryptString:certNumField.text]]){
            return @"乘客列表中已包含该证件";
        }
        else {
            return nil;
        }
    }
    else {
        if ([self checkExistType:certTypeLabel.text Number:[StringEncryption EncryptString:certNumField.text]]){
            return @"乘客列表中已包含该证件";
        }
        else {
            return nil;
        }
    }
}

#pragma mark - UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
}


- (void)makeUpTopBarWithTitle:(NSString *)title
{
    [self addTopImageAndTitle:nil andTitle:title];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(clickCancelBtn)];
}


- (void)makeUpMainView
{
    // 列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 40 - 20) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.backgroundView = nil;
    table.scrollEnabled = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = [UIColor clearColor];
    [self.view addSubview:table];
    [table release];
    
    // 列表头部
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    table.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
    
    // 列表尾部
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    table.tableFooterView = tableFooterView;
    [tableFooterView release];
    
    // 增加确认按钮
    [tableFooterView addSubview:[UIButton uniformButtonWithTitle:@"确认" ImagePath:@"" Target:self Action:@selector(clickConfirmBtn) Frame:CGRectMake(13, 30, 294, BOTTOM_BUTTON_HEIGHT)]];
}


#pragma mark - Button Methods

- (void)clickCancelBtn
{
    // 点击取消按钮
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)clickConfirmBtn
{
    // 点击确认按钮
    NSString *msg = [self validateUserInputData];
	if (msg)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
    {
        // 会员与非会员的构造区别
        if ([AccountManager instanse].isLogin)
        {
            if (DICTIONARYHASVALUE(_modifyPasger)) {
                JModifyCustomer *jModCus=[MyElongPostManager modifyCustomer];
                [jModCus clearBuildData];
                
                [jModCus setModifyName:_customerName];
                [jModCus setIdType:[Utils getCertificateType:certTypeLabel.text]];
                [jModCus setIdTypeName:certTypeLabel.text];
                [jModCus setIdNumber:[StringEncryption EncryptString:_customerNumber]];
                
                [Utils request:MYELONG_SEARCH req:[jModCus requesString:NO] delegate:self];
            }
            else {
                JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
                [jAddCus clearBuildData];
                [jAddCus setAddName:_customerName];
                [jAddCus setIdType:[Utils getCertificateType:certTypeLabel.text]];
                [jAddCus setIdTypeName:certTypeLabel.text];
                [jAddCus setIdNumber:[StringEncryption EncryptString:_customerNumber]];
                
                [Utils request:MYELONG_SEARCH req:[jAddCus requesString:NO] delegate:self];
            }
        }
        else {
            NSDictionary *passenger = [NSDictionary dictionaryWithObjectsAndKeys:
                                       _customerName, NAME_RESP,
                                       [StringEncryption EncryptString:_customerNumber], IDNUMBER,
                                       [Utils getCertificateType:certTypeLabel.text], IDTYPE,
                                       certTypeLabel.text, IDTYPENAME, nil];
            
            if (DICTIONARYHASVALUE(_modifyPasger)) {
                [_delegate didReceiveAEditPassenger:passenger];
            }
            else {
                [_delegate didReceiveANewPassenger:passenger];
            }
            
            if (IOSVersion_7) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self dismissModalViewControllerAnimated:YES];
            }
        }
	}
}


- (void)clickCertBtn
{
    // 点击证件类型
    if (!selectTable)
    {
        NSArray *certArray = nil;
        NSInteger index = 0;        
        if (type == PassengerTypeTrain)
        {
            // 台湾通行证暂时不支持
            certArray = [NSArray arrayWithObjects:@"身份证", @"护照", @"港澳通行证", nil];
        }
        else if (type == PassengerTypeFlight)
        {
            certArray = [NSArray arrayWithObjects:@"身份证", @"护照", @"军人证", @"回乡证", @"台胞证", @"港澳通行证", @"其它", nil];
        }
        
        if (DICTIONARYHASVALUE(_modifyPasger))
        {
            // 如果是修改联系人的情况，需要选中对应的证件类型
            index = [certArray indexOfObject:[_modifyPasger objectForKey:IDTYPENAME]];
        }
        
		selectTable = [[FilterView alloc] initWithTitle:@"选择证件类型" Datas:certArray];
		selectTable.delegate = self;
        selectTable.currentRow = index;
		[self.view addSubview:selectTable.view];
	}
	
	[selectTable showInView];
	[nameField resignFirstResponder];
	[certNumField resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    if (cell == nil)
    {
        cell = [[[PassengerCell alloc] initWithReuseIdentifier:cellIdentifier cellHeight:k_cellHeight] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = FONT_14;
        cell.textLabel.textColor = COLOR_CELL_TITLE;
        cell.selectImgView.hidden = YES;
        cell.cellEditButton.hidden = YES;
    }
    
    int offX = 85;
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"姓       名：";
        
        if (!nameField)
        {
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(offX, 0, SCREEN_WIDTH-offX, k_cellHeight)];
            nameField.borderStyle = UITextBorderStyleNone;
            nameField.font = FONT_16;
            nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            nameField.delegate = self;
            nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            nameField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [nameField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.];
            
            if (DICTIONARYHASVALUE(_modifyPasger))
            {
                nameField.text = [NSString stringWithFormat:@"%@", [_modifyPasger objectForKey:NAME_RESP]];
            }
        }
        
        [cell.contentView addSubview:nameField];
        
        cell.topSplitView.hidden = NO;
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"证件号码：";
        
        if (!certNumField)
        {
            certNumField = [[CustomTextField alloc] initWithFrame:CGRectMake(offX, 0, SCREEN_WIDTH-offX, k_cellHeight)];
            certNumField.borderStyle = UITextBorderStyleNone;
            certNumField.font = FONT_16;
            certNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            certNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
            certNumField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            certNumField.delegate = self;
            
            if (DICTIONARYHASVALUE(_modifyPasger))
            {
                certNumField.text = [StringEncryption DecryptString:[NSString stringWithFormat:@"%@", [_modifyPasger objectForKey:IDNUMBER]]];
            }
        }
        
        [cell.contentView addSubview:certNumField];
        
        cell.topSplitView.hidden = YES;
    }
    else
    {
        cell.textLabel.text = @"证件类型：";
        
        if (!certTypeLabel)
        {
            certTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 150, 50)];
            certTypeLabel.text = @"身份证";
            certTypeLabel.textColor = [UIColor blackColor];
            certTypeLabel.textAlignment = UITextAlignmentCenter;
            certTypeLabel.font = FONT_16;
            certTypeLabel.backgroundColor = [UIColor clearColor];
            
            if (DICTIONARYHASVALUE(_modifyPasger))
            {
                certTypeLabel.text = [NSString stringWithFormat:@"%@", [_modifyPasger objectForKey:IDTYPENAME]];
            } 
        }
        
        [cell.contentView addSubview:certTypeLabel];
        
        UIImageView *blueArrow = [[UIImageView alloc] initWithFrame:CGRectMake(276,  (k_cellHeight - 8)/2, 12, 8)];
        blueArrow.image = [UIImage noCacheImageNamed:@"ico_downarrow.png"];
        [cell.contentView addSubview:blueArrow];
        [blueArrow release];
        
        UIButton *certBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        certBtn.frame = CGRectMake(offX, 0, SCREEN_WIDTH-offX, k_cellHeight);
        [certBtn addTarget:self action:@selector(clickCertBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:certBtn];
        
        cell.topSplitView.hidden = YES;
    }
    
    return cell;
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([certTypeLabel.text isEqualToString:@"身份证"])
    {
		if (range.location >= 18)
        {
            if (textField == certNumField) {
                textField.text = [textField.text substringToIndex:18];
                return NO;
            }
		}
	}
	
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (selectTable.isShowing)
    {
        [selectTable dismissInView];
    }
    
    if ([textField isKindOfClass:[CustomTextField class]])
    {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == certNumField)
    {
        certNumField.abcEnabled = YES;
        certNumField.numberOfCharacter = 18;
        [certNumField showNumKeyboard];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark Filter delegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView {
	if ([filterStr isEqualToString:@"身份证"])
    {
		[certNumField changeKeyboardStateToSysterm:NO];
		certNumField.numberOfCharacter = 18;
	}
	else
    {
		[certNumField changeKeyboardStateToSysterm:YES];
		certNumField.numberOfCharacter = 60;
	}
	
	certTypeLabel.text = filterStr;
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
    
    NSMutableDictionary *passenger = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               _customerName, NAME_RESP,
                               [StringEncryption EncryptString:_customerNumber], IDNUMBER,
                               [Utils getCertificateType:certTypeLabel.text], IDTYPE,
                               certTypeLabel.text, IDTYPENAME, nil];
    
    if ([passenger safeObjectForKey:IDTYPENAME] == nil) {
        [passenger setValue:certTypeLabel.text forKey:IDTYPENAME];
    }
    
    if ([passenger safeObjectForKey:IDTYPE] == nil) {
        if ([Utils getCertificateType:certTypeLabel.text] == nil && [certTypeLabel.text isEqualToString:@"港澳台通行证"])
        [passenger setValue:[NSNumber numberWithInteger:3] forKey:IDTYPE];
    }

    if (DICTIONARYHASVALUE(_modifyPasger)) {
        [_delegate didReceiveAEditPassenger:passenger];
    }
    else {
        [_delegate didReceiveANewPassenger:passenger];
    }
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
