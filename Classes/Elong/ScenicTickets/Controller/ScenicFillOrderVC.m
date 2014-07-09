//
//  ScenicFillOrderVC.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicFillOrderVC.h"
#import "ScenicTicketsPublic.h"
#import "ScenicDetail.h"
#import "AccountManager.h"
#import "LoginManager.h"
#import "CFAndButtonCell.h"
#import "TravelDateCell.h"
#import "ScenicOrderNumCell.h"
#import "SelectRent.h"
#import "ELCalendarViewController.h"
#import "ScenicOrderHeaderCell.h"
#import "ScenicOrderSuccessViewController.h"

@interface ScenicFillOrderVC ()

@end

/*
 realName  字段 为1 实名制 0非实名制
 */

@implementation ScenicFillOrderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tickets_num  = 1;//Default is 1
        headerCell_Height = 120.0f;
        
        self.travelDate = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"yyyy-MM-dd"];
        [self getTheTicketHolerName];
        [self getTheTicketHolderPhone];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    if (customersRequest) {
        [customersRequest cancel];
        SFRelease(customersRequest);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [salePriceLbl release];
    [_tableView release];
    self.priceDetail = nil;
    [super dealloc];
}

#pragma mark
#pragma mark  UI Related

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    //键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisplay:) name:UIKeyboardWillShowNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.priceDetail.realName = @"1";
    
    // Do any additional setup after loading the view.
    if (![AccountManager instanse].isLogin) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"登录" Target:self Action:@selector(goLogin)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessCallBack) name:NOTI_SCENIC_LOGINSUCCESS object:nil];
    }else{
        //预加载 客史
        [self preLoadTheCustomerList];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self.view addSubview:[self createTheFootView]];
}

-(UIView *)createTheFootView{

    // 加入底部工具条
	UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
	bottomBar.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    bottomBar.userInteractionEnabled = YES;
    
    // 现价
    salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 190 ,44)];
    salePriceLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    salePriceLbl.backgroundColor = [UIColor clearColor];
    salePriceLbl.adjustsFontSizeToFitWidth = YES;
    salePriceLbl.textAlignment = NSTextAlignmentLeft;
    salePriceLbl.minimumFontSize = 14.0f;
    salePriceLbl.textColor = [UIColor whiteColor];
    salePriceLbl.text = @"¥ 85";
    [bottomBar addSubview:salePriceLbl];
    
    // 购买按钮
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    nextButton.exclusiveTouch = YES;
	nextButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 44);
	[bottomBar addSubview:nextButton];
    
    return [bottomBar autorelease];
}

#pragma  mark
#pragma  mark  Events
//获取取票人信息
-(void)getTheTicketHolerName{
    NSString *default_string = [[NSUserDefaults standardUserDefaults] objectForKey:SCENIC_ORDER_USER];
    if (STRINGHASVALUE(default_string)) {
        self.t_holder_Name =  default_string;
    }else if ([[SelectRoomer allRoomers] count] > 0) {
        NSDictionary *dic = [[SelectRoomer allRoomers] objectAtIndex:0];
        self.t_holder_Name = [dic objectForKey:@"Name"];
    }else{
        self.t_holder_Name =  @"";
    }
}
//获取取票人电话
-(void)getTheTicketHolderPhone{
    NSString *default_string = [[NSUserDefaults standardUserDefaults] objectForKey:SCENIC_ORDER_PHONE];
    if (STRINGHASVALUE(default_string)) {
        self.t_holder_Phone = default_string;
    }else{
        self.t_holder_Phone = @"";
    }
}
//预加载客史
-(void)preLoadTheCustomerList{

    if (customersRequest) {
        [customersRequest cancel];
        SFRelease(customersRequest);
    }

    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:3];
    
    customersRequest = [[HttpUtil alloc] init];
    [customersRequest connectWithURLString:MYELONG_SEARCH Content:[customer requesString:YES] StartLoading:NO EndLoading:NO AutoReload:NO Delegate:self];
}

-(void)goLogin{
    LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_ScenicOrderFill_Login];
    [self.navigationController pushViewController:login animated:YES];
    [login release];
}

//添加取票人、同游人
-(void)addCustomer{
    if (!requestOver) {
        // 没有获取到入住人时停止本页请求
        [[HttpUtil shared] cancel];
        NSLog(@"You have not the history Customers");
    }
    if ([[SelectRoomer  allRoomers] count] > 0)
    {
        requestOver= YES;
    }
    
    SelectRent  *controller = [[SelectRent  alloc]initRentRequested:requestOver peopleCount:1 andType:SelectType_ScenicTickets];
    controller.delegate =(id<RoomerDelegate>) self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    [nav release];
}

//请求通讯录
-(void)callContact{
    CustomAB *picker = [[CustomAB alloc] initWithContactStyle:3];
    picker.delegate = self;
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:picker];
    if (IOSVersion_7) {
        naviCtr.transitioningDelegate = [ModalAnimationContainer shared];
        naviCtr.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:naviCtr animated:YES completion:nil];
    }else{
        [self presentModalViewController:naviCtr animated:YES];
    }
    
    [picker release];
    [naviCtr release];
}

//提交订单
-(void)nextButtonClick:(id)sender{

    ScenicOrderSuccessViewController *success = [[ScenicOrderSuccessViewController alloc] initWithTitle:@"订单成功" style:NavBarBtnStyleNoTel];
    [self.navigationController pushViewController:success animated:YES];
    [success release];
}

#pragma mark
#pragma mark  CallBack and Delegate

-(void)reduceNum:(UIButton *)sender{
    
    UIButton *btn =(UIButton *)sender;
    --tickets_num;

    if (tickets_num == [self.priceDetail.minT intValue]) {
        btn.enabled = NO;
    }else{
        btn.enabled = YES;
    }

    [_tableView reloadData];
}
-(void)plusNum:(UIButton *)sender{
    UIButton *btn =(UIButton *)sender;
    ++tickets_num;

    if (tickets_num == [self.priceDetail.maxT intValue]){
        btn.enabled = NO;
    }else{
        btn.enabled = YES;
    }
    [_tableView reloadData];
}

-(void)loginSuccessCallBack{
    
    self.navigationItem.rightBarButtonItem = nil;
    //预加载 客史
    [self preLoadTheCustomerList];
}
//客史回调
- (void) selectRoomer:(SelectRoomer *)selectRoomer didSelectedArray:(NSArray *)array
{
    
    for(NSDictionary *dic in  array)
    {
        if ([[dic objectForKey:@"Checked"]boolValue])
        {
            self.t_holder_Name = [dic objectForKey:@"Name"];
            NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}
//通讯录回调
- (void)getSelectedString:(NSString *)selectedStr{

    NSLog(@"selectedStr is %@",selectedStr);
    self.t_holder_Phone = selectedStr;
    NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
}
//日历回调
-(void) ElcalendarViewSelectDay:(ELCalendarViewController *) elViewController checkinDate:(NSDate *) cinDate checkoutDate:(NSDate *) coutDate{

    self.travelDate = [TimeUtils displayDateWithNSDate:cinDate formatter:@"yyyy-MM-dd"];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark
#pragma mark  Http----------Receive
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    if (util == customersRequest) {
        //
        NSArray *customers = [root safeObjectForKey:@"Customers"];
        [[SelectRoomer  allRoomers]removeAllObjects];
        for (NSDictionary *customer in customers) {
            if ([customer safeObjectForKey:@"Name"]!=[NSNull null]) {
                NSString *name = [customer safeObjectForKey:@"Name"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"Name",[NSNumber numberWithBool:NO],@"Checked", nil];
                [[SelectRoomer allRoomers] addObject:dict];
            }
        }
        requestOver = YES;
        
        [self getTheTicketHolerName];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:1];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == customersRequest) {
        requestOver = NO;
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (util == customersRequest) {
        requestOver = NO;
    }
}

#pragma mark
#pragma mark  CustomTextField Adjust  and Scrollow Delegate KeyBoard

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 15;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)keyboardWillDisplay:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘的大小
    CGSize keyboardRect = [aValue CGRectValue].size;
    
    CGFloat height = keyboardRect.height;
    
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH,MAINCONTENTHEIGHT-height)];
    if (currentPath) {
        [_tableView scrollToRowAtIndexPath:currentPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [[UIApplication   sharedApplication] sendAction:@selector(resignFirstResponder) to:nil  from:nil  forEvent:nil];
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH,MAINCONTENTHEIGHT-44)];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isKindOfClass:[CustomTextField class]])
    {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UITableViewCell *cell = (UITableViewCell *)[self superviewWithClass:[UITableViewCell class] child:textField];
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    currentPath = path;
}

- (UIView*)superviewWithClass:(Class)class child:(UIView*)child
{
    UIView *superview =nil;
    superview = child.superview;
    while (superview !=nil && ![superview isKindOfClass:class]) {
        superview = superview.superview;
    }
    return superview;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT-44)];
    [textField  resignFirstResponder];
    return YES;
}

//CellAdjust Delegate
-(void)ajustTheHeaderCellHeight:(CGFloat)height andFlag:(BOOL)yes{

    if (height == 30) {
        headerCell_Height = 120;
    }else{
        headerCell_Height = 120+height-30;
    }
    head_intro_Show = yes;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return ([self.priceDetail.realName isEqualToString:@"1"])?tickets_num+1:2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section != 0) {
        return 15;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        v.backgroundColor    = [UIColor clearColor];
        return [v autorelease];
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return ([self.priceDetail.realName isEqualToString:@"1"])?5:4;
    }else if (section == 0){
        return 1;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return headerCell_Height;
    }else{
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ScenicOrderHeader";
        ScenicOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ScenicOrderHeaderCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell setPriceDetail:self.priceDetail andHeight:headerCell_Height andFlag:head_intro_Show];
        return cell;
    }else if (indexPath.section == 1) {
        static NSString *travelCell = @"TravelCell";
        static NSString *buyNumCell = @"BuyNumCell";
        static NSString *CellIdentifier = @"Cell";
        if (indexPath.row == 0) {
            TravelDateCell *cell = [tableView dequeueReusableCellWithIdentifier:travelCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TravelDateCell" owner:self options:nil] lastObject];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.travelDateLabel.text = self.travelDate;
            return cell;
        }else if (indexPath.row == 1){
            ScenicOrderNumCell *cell = [tableView dequeueReusableCellWithIdentifier:buyNumCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ScenicOrderNumCell" owner:self options:nil] lastObject];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.spanNum.text = [NSString stringWithFormat:@"(%@-%@)",self.priceDetail.minT,self.priceDetail.maxT];
            cell.buyNum.text = [NSString stringWithFormat:@"%d",tickets_num];
            if ([cell.buyNum.text isEqualToString:@"1"]) {
                cell.left.enabled = NO;
            }else{
                cell.left.enabled = YES;
            }
            return cell;
        }else{
            CFAndButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                if (indexPath.row == 2) {
                    cell = [[[CFAndButtonCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier showRight:YES customTF:NO] autorelease];
                    cell.textField.delegate = self;
                    cell.textField.keyboardType = UIKeyboardAppearanceDefault;
                }else{
                    cell = [[[CFAndButtonCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier showRight:YES customTF:YES] autorelease];
                    cell.cf_Field.delegate = self;
                    cell.cf_Field.fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
                }
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            switch (indexPath.row) {
                case 2:
                    cell.title.text = @"取票人";
                    cell.textField.placeholder = @"姓名";
                    cell.textField.text = self.t_holder_Name;
                    [cell.tipBtn setImage:[UIImage imageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
                    [cell.tipBtn addTarget:self action:@selector(addCustomer) forControlEvents:UIControlEventTouchUpInside];
                    if (![AccountManager instanse].isLogin) {
                        [cell adjustTheCellLayoutByShowRight:NO];
                    }else{
                        [cell adjustTheCellLayoutByShowRight:YES];
                    }
                    break;
                case 3:
                    cell.title.text = @"手机号";
                    cell.cf_Field.placeholder = @"请输入手机号或者点击进入通讯录";
                    cell.cf_Field.text = self.t_holder_Phone;
                    [cell.tipBtn setImage:[UIImage imageNamed:@"groupon_order_add.png"] forState:UIControlStateNormal];
                    [cell.tipBtn addTarget:self action:@selector(callContact) forControlEvents:UIControlEventTouchUpInside];
                    [cell adjustTheCellLayoutByShowRight:YES];
                    break;
                case 4:
                    cell.title.text = @"身份证";
                    cell.cf_Field.placeholder = @"请输入您的身份证号码";
                    cell.cf_Field.text = self.t_holder_id;
                    [cell adjustTheCellLayoutByShowRight:NO];
                    break;
                default:
                    break;
            }
            return cell;
        }
    }else{
        //同行人
        static NSString *otherBuyer_TF = @"otherBuyer_TF";
        static NSString *otherBuyer_CF = @"otherBuyer_CF";
        if (indexPath.row == 0) {
            CFAndButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:otherBuyer_TF];
            if (cell == nil) {
                cell = [[[CFAndButtonCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherBuyer_TF showRight:YES customTF:NO] autorelease];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_SCALE)]];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textField.delegate = self;
                cell.textField.keyboardType = UIKeyboardAppearanceDefault;
                [cell.tipBtn setImage:[UIImage imageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
                [cell.tipBtn addTarget:self action:@selector(addCustomer) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.title.text = @"同游人";
            cell.textField.placeholder = @"姓名";
            if (![AccountManager instanse].isLogin) {
                [cell adjustTheCellLayoutByShowRight:NO];
            }
            return cell;
        }else{
            CFAndButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:otherBuyer_CF];
            if (cell == nil) {
                cell = [[[CFAndButtonCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherBuyer_CF showRight:YES customTF:YES] autorelease];
                cell.cf_Field.delegate = self;
                cell.cf_Field.fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
                [cell.tipBtn setImage:[UIImage imageNamed:@"groupon_order_add.png"] forState:UIControlStateNormal];
                [cell.tipBtn addTarget:self action:@selector(callContact) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.title.text = @"手机号";
            cell.cf_Field.placeholder = @"请输入手机号或者点击进入通讯录";
            return cell;
        }
    }
}

#pragma  mark
#pragma  mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 0) {
        //价格日历
        ELCalendarViewController *vc=[[ELCalendarViewController alloc] initWithCheckIn:[NSDate date] checkOut:nil type:UseTaxi];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        
    }
}
@end
