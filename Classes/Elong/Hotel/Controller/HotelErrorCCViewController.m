//
//  HotelErrorCCViewController.m
//  ElongClient
//
//  Created by garin on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelErrorCCViewController.h"
#import "CountlyEventClick.h"

#define ErrorHotelNameTag 6394
#define ErrorHotelAddressTag 6395
#define ErrorHotelPhoneTag 6396
#define ErrorUserNameTag 6398
#define ErrorUserPhoneTag 6399

@implementation HotelErrorCCViewController

-(void) dealloc
{
    if(httpUtil)
    {
        httpUtil.delegate=nil;
        [httpUtil cancel];
        [httpUtil release],httpUtil = nil;
    }
    
    self.hotelName=nil;
    self.hotelAddress=nil;
    self.hotelPhone=nil;
    self.userName=nil;
    self.userPhone=nil;
    self.cInitHotelName=nil;
    self.cInitHotelAddress=nil;
    self.cInitHotelPhone=nil;
    self.lastPostParms=nil;
    
    self.hotelDic=nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(commitData:)];
}

-(void) setUI
{
    [self initObjects];
    
    contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.separatorColor =[UIColor clearColor];
    contentView.backgroundView = nil;
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.view addSubview:contentView];
    [contentView release];
    
    UIButton *headerView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    headerView.backgroundColor=[UIColor clearColor];
    [headerView addTarget:self action:@selector(closeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    contentView.tableHeaderView=headerView;
    [headerView release];
    
    UIButton *footerView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    footerView.backgroundColor=[UIColor clearColor];
    [footerView addTarget:self action:@selector(closeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    contentView.tableFooterView=footerView;
    [footerView release];
}

-(void) initObjects
{
    if (self.hotelDic==nil)
    {
        self.hotelDic=[HotelDetailController hoteldetail];
    }
    
    self.cInitHotelName=[self.hotelDic safeObjectForKey:RespHD_HotelName_S];
    self.cInitHotelPhone=[self.hotelDic safeObjectForKey:RespHD_Phone_S];
    self.cInitHotelAddress=[self.hotelDic safeObjectForKey:RespHD_Address_S];
    
    if (STRINGHASVALUE(self.cInitHotelName)) {
        self.cInitHotelName=[self.cInitHotelName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (STRINGHASVALUE(self.cInitHotelPhone)) {
        self.cInitHotelPhone=[self.cInitHotelPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (STRINGHASVALUE(self.cInitHotelAddress)) {
        self.cInitHotelAddress=[self.cInitHotelAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    self.hotelName=self.cInitHotelName;
    self.hotelPhone=self.cInitHotelPhone;
    self.hotelAddress=self.cInitHotelAddress;
}

- (void) closeKeyBoard
{
    [curtextField resignFirstResponder];
    
    [contentView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                       atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//提交数据
-(void) commitData:(id) sender
{
    if ([self checkData]==NO) {
        return;
    }
    
    [self closeKeyBoard];
    
    NSString *hotelId=[self.hotelDic safeObjectForKey:RespHD_HotelId_S];
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    
    if (STRINGHASVALUE(self.hotelName)) {
        self.hotelName=[self.hotelName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (STRINGHASVALUE(self.hotelAddress)) {
        self.hotelAddress=[self.hotelAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (STRINGHASVALUE(self.hotelPhone)) {
        self.hotelPhone=[self.hotelPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (STRINGHASVALUE(self.userPhone)) {
        self.userPhone=[self.userPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (STRINGHASVALUE(self.userName)) {
        self.userName=[self.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    [param safeSetObject:self.hotelName forKey:@"CorrectHotelName"];
    [param safeSetObject:self.hotelAddress forKey:@"CorrectHotelAddress"];
    [param safeSetObject:self.hotelPhone forKey:@"CorrectHotelPhone"];
    [param safeSetObject:self.userPhone forKey:@"MobileNo"];
    [param safeSetObject:self.userName forKey:@"UserName"];
    [param safeSetObject:hotelId forKey:@"HotelId"];
    
    
    NSString *url = [PublicMethods composeNetSearchUrl:@"hotel"
                                            forService:@"updateHotelInfo"
                     andParam:[param JSONString]];
    
    if ([self.lastPostParms isEqualToString:url])
    {
        [PublicMethods showAlertTitle:nil Message:@"请不要重复提交，谢谢！"];
        return;
    }
    
    if(httpUtil)
    {
        [httpUtil cancel];
        [httpUtil release],httpUtil = nil;
    }
    httpUtil = [[HttpUtil alloc] init];
    httpUtil.JavaApiRequstMethod=@"PUT";
    
    [httpUtil requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
    
    // countly correct
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILDISCRIBEPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CORRECT;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

//校验数据
-(BOOL) checkData
{
    if (!STRINGHASVALUE(self.hotelName)&&!STRINGHASVALUE(self.hotelAddress)&&!STRINGHASVALUE(self.hotelPhone)) {
        [PublicMethods showAlertTitle:nil Message:@"酒店名，酒店地址，酒店电话，必须填写一个。"];
        return NO;
    }
    
    if (![self checkData:self.hotelName cnt:100 isMustHaveValue:NO]) {
        [PublicMethods showAlertTitle:nil Message:@"酒店名不能超过100个字符。"];
        return NO;
    }
    
    if (![self checkData:self.hotelAddress cnt:200 isMustHaveValue:NO]) {
        [PublicMethods showAlertTitle:nil Message:@"酒店地址不能超过200个字符。"];
        return NO;
    }
    
    if (![self checkData:self.hotelPhone cnt:25 isMustHaveValue:NO]) {
        [PublicMethods showAlertTitle:nil Message:@"酒店电话不能超过25个字符。"];
        return NO;
    }
    
    if (![self checkData:self.userName cnt:30 isMustHaveValue:NO]) {
        [PublicMethods showAlertTitle:nil Message:@"用户姓名不能超过30个字符。"];
        return NO;
    }
    
    if (![self checkData:self.userPhone cnt:11 isMustHaveValue:NO]) {
        [PublicMethods showAlertTitle:nil Message:@"用户手机号不能超过11个字符。"];
        return NO;
    }
    
    return YES;
}

-(BOOL) checkData:(NSString *) data cnt:(int) cnt isMustHaveValue:(BOOL) isMustHaveValue
{
    if (isMustHaveValue)
    {
        if (!STRINGHASVALUE(data)) {
            return NO;
        }
        
        if (data.length>cnt) {
            return NO;
        }
    }
    else
    {
        if (!STRINGHASVALUE(data)&&data.length>cnt) {
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark -UITableView datasource,delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3) {
        return 53;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //中间分割的提示
    if (indexPath.row==3)
    {
        static NSString *cellIdentifier1 = @"SplitCell";
        UITableViewCell *splitCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!splitCell) {
            splitCell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1] autorelease];
            splitCell.selectionStyle=UITableViewCellSelectionStyleNone;
            splitCell.backgroundColor=[UIColor clearColor];
            
            UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame=splitCell.bounds;
            closeBtn.backgroundColor=[UIColor clearColor];
            [splitCell addSubview:closeBtn];
            [closeBtn addTarget:self action:@selector(closeKeyBoard) forControlEvents:UIControlEventTouchUpInside];

            UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 53-25, SCREEN_WIDTH-20, 25)];
            lbl.text=@"感谢您的反馈，艺龙欢迎您留下联系方式";
            lbl.textColor=RGBACOLOR(153, 153, 153, 1);
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont boldSystemFontOfSize:13];
            [splitCell addSubview:lbl];
            [lbl release];
        }
        
        return splitCell;
    }
    else
    {
        static NSString *cellIdentifier0 = @"ErrorCCCell";
        HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
        if (!cell)
        {
            cell = [[[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setDetail:@""];
            [cell setCustomerHidden:YES];
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.delegate = self;
            cell.textField.hidden=NO;
            cell.textField.textAlignment=NSTextAlignmentLeft;
            [cell setArrowHidden:YES];
            cell.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
            
            if (indexPath.row==0)
            {
                cell.textField.text=self.cInitHotelName;
            }
            else if (indexPath.row==1)
            {
                cell.textField.text=self.cInitHotelAddress;
            }
            else if (indexPath.row==2)
            {
                cell.textField.text=self.cInitHotelPhone;
            }

        }
        
        cell.cellType=CellTypeBottom;
        cell.textField.tag=ErrorHotelNameTag+indexPath.row;
        cell.textField.returnKeyType=UIReturnKeyDone;
        cell.textField.placeholder=@"";
        if (indexPath.row==0)
        {
            [cell setTitle:@"酒店名称"];
            cell.cellType=CellTypeTop;
//            cell.textField.placeholder=@"必填";
        }
        else if (indexPath.row==1)
        {
            [cell setTitle:@"酒店地址"];
//            cell.textField.placeholder=@"必填";
        }
        else if (indexPath.row==2)
        {
            [cell setTitle:@"酒店电话"];
//            cell.textField.placeholder=@"必填";
            cell.textField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        }
        else if (indexPath.row==4)
        {
            [cell setTitle:@"姓名"];
            cell.cellType=CellTypeTop;
//            cell.textField.placeholder=@"选填";
        }
        else if (indexPath.row==5)
        {
            [cell setTitle:@"手机"];
//            cell.textField.placeholder=@"选填";
            cell.textField.keyboardType=UIKeyboardTypeNumberPad;
        }
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    curtextField=textField;
    
    int scrowIndex=textField.tag-ErrorHotelNameTag;
    
    [contentView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrowIndex inSection:0]
                         atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"textField.tag:%d",textField.tag);
    if (textField.tag==ErrorHotelNameTag)
    {
        if (range.location >= 100) {
            textField.text = [textField.text substringToIndex:100];
            self.hotelName = textField.text;
            return NO;
        }
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.hotelName = tagStr;
    }
    else if (textField.tag==ErrorHotelAddressTag)
    {
        if (range.location >= 200) {
            textField.text = [textField.text substringToIndex:200];
            self.hotelAddress = textField.text;
            return NO;
        }
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.hotelAddress = tagStr;
    }
    else if (textField.tag==ErrorHotelPhoneTag)
    {
        if (range.location >= 25) {
            textField.text = [textField.text substringToIndex:25];
            self.hotelPhone = textField.text;
            return NO;
        }
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.hotelPhone = tagStr;
    }
    else if (textField.tag==ErrorUserNameTag)
    {
        if (range.location >= 30) {
            textField.text = [textField.text substringToIndex:30];
            self.userName = textField.text;
            return NO;
        }
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.userName = tagStr;
    }
    else if (textField.tag==ErrorUserPhoneTag)
    {
        if (range.location >= 11) {
            textField.text = [textField.text substringToIndex:11];
            self.userPhone = textField.text;
            return NO;
        }
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.userPhone = tagStr;
    }

    
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag==ErrorHotelNameTag)
    {
        self.hotelName=nil;
    }
    else if (textField.tag==ErrorHotelAddressTag)
    {
        self.hotelAddress=nil;
    }
    else if (textField.tag==ErrorHotelPhoneTag)
    {
        self.hotelPhone=nil;
    }
    else if (textField.tag==ErrorUserNameTag)
    {
        self.userName=nil;
    }
    else if (textField.tag==ErrorUserPhoneTag)
    {
        self.userPhone=nil;
    }
    
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==ErrorHotelNameTag)
    {
        self.hotelName=textField.text;
    }
    else if (textField.tag==ErrorHotelAddressTag)
    {
        self.hotelAddress=textField.text;
    }
    else if (textField.tag==ErrorHotelPhoneTag)
    {
        self.hotelPhone=textField.text;
    }
    else if (textField.tag==ErrorUserNameTag)
    {
        self.userName=textField.text;
    }
    else if (textField.tag==ErrorUserPhoneTag)
    {
        self.userPhone=textField.text;
    }
}

#pragma mark -
#pragma mark http

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
//    [PublicMethods showAlertTitle:nil Message:@"网络有问题哦，请重试，谢谢。"];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    [PublicMethods showAlertTitle:nil Message:@"提交成功，谢谢。"];
    
    //不存post的参数
    self.lastPostParms=util.currentReq.URL.absoluteString;
}


@end
