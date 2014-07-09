//
//  TaxiFillCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiFillCtrl.h"
#import "UIViewExt.h"
#import "UseTaxiCell.h"
#import "TaxiPersonCell.h"
#import "SelectRoomer.h"
#import "OnlyTextFieldCell.h"
#import "Login.h"
#import "TaxiFillManager.h"
#import "RentSuccessController.h"
#import "SelectRent.h"
#import "TaxiUtils.h"

@interface TaxiFillCtrl ()

@end

@implementation TaxiFillCtrl
- (void)dealloc
{
    if (getPersonUtil)
    {
        [getPersonUtil cancel];
        SFRelease(getPersonUtil);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_typeModel release];
    [_eModel  release];
    [_table  release];
    [headAr  release];
    [commitBt  release];
    [newPayControl  release];

    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)back
{
    [NSObject  cancelPreviousPerformRequestsWithTarget:self];
    [super back];
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    manager = [TaxiFillManager  shareInstance];
    
    self.hasDistination = manager.hasDestination;
    
    _invoiceCellHeight = 44;
    
    headAr = [[NSArray alloc]initWithObjects:@"   用车信息",@"   预估信息",@"",@"",@"", nil];
    
    needAirPort = YES;
    
    [self  tableViewASet];
    
    //底部footview设置
    
    [self  footViewSet];
    
    [self  commitViewSet];
    
    reClick = 0;
    
    
    if (![self adjustIsLogin])
    {
         [self  initLoginButton];
    }
    //如果登录了，预加载客史
    if ([self  adjustIsLogin])
    {    //拿到客史里的第一个姓名
        [self requestForRoomer ];
        
    }else
    {
        if (STRINGISNULL([[ElongUserDefaults  sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON]))
        {
            [self getHotelName];
        }
    }
   
    //停留时间超过20分钟退出
    [self  performSelector:@selector(adjustTimeiInterval) withObject:nil afterDelay:OUTTIME];
	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NOTI_RENTTAXI_LOGINSUCCESS object:nil];
    
    [self  intFillMessage];
    
}

- (void) initPassengerName
{
    //第一步：取userdefault里的姓名
    if ([[ElongUserDefaults  sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON])
    {
        manager.fillRqModel.passengerName = [[ElongUserDefaults sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON];

    }
//    //第二步：区别会员和非会员拿姓名
//    else  if (![[ElongUserDefaults  sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON]||![[[ElongUserDefaults  sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON]  isEqual:[NSNull  null]])
//    {
//        
//        if (STRINGISNULL([[ElongUserDefaults  sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON]))
//        {    //拿到酒店非会员填的第一个姓名,先为其model赋值
//           [self  getHotelName];
//        }
//    }
//    
    

}
- (void)getHotelName
{
    NSArray *names = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CHECKINPEPEOS];
    NSString  *name =  [names safeObjectAtIndex:0];
    //非会员的情况下，将酒店的name值存在userdefault里
    [[ElongUserDefaults  sharedInstance]setObject:name forKey:USERDEFAULT_TAXI_PERSON];
   
    manager.fillRqModel.passengerName = [names safeObjectAtIndex:0];
    
    [_table  reloadData];
    
}

#pragma mark - 登录成功的回调
- (void)loginSuccess
{
    //登陆成功传卡号
    NSString  *card =   [[AccountManager  instanse] cardNo];
       manager.fillRqModel.uid =   card;
    //针对登录成功对电话信息做的修改
    telField.text =[[AccountManager instanse] phoneNo];
      [_table reloadData];
    //针对登录成功姓名信息做的修改
    if (STRINGISNULL(personField.text))
    {
        [self  requestForRoomer];
    }
  
    
     [[ElongUserDefaults sharedInstance]setObject:telField.text  forKey:USERDEFAULT_TAXI_TEL];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) adjustTimeiInterval
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"停留时间太长！"
                                                   delegate:self
                                          cancelButtonTitle:_string(@"确定")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
- (void)tableViewASet
{
    _table = [[UITableView  alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT- 44-20) style:UITableViewStylePlain];
    _table.backgroundView.backgroundColor = [UIColor  clearColor];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:_table];
    
    offset = _table.contentOffset.y;
}
//TODO:底部的设置
- (void)footViewSet
{
    UIView *foot = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    AttributedLabel   *footLabel = [[AttributedLabel  alloc]initWithFrame:CGRectMake(8, 20, 0, 0)];
    footLabel.backgroundColor = [UIColor  clearColor];
    footLabel.text =  [NSString  stringWithFormat:@"%@%@",CANCEL_TIP,self.eModel.notice];

    NSRange  range = [footLabel.text rangeOfString:CANCEL_TIP];
   
    [footLabel  setFont:[UIFont  systemFontOfSize:13] fromIndex:0 length:footLabel.text.length];
    [footLabel  setFont:[UIFont  systemFontOfSize:16] fromIndex:0 length:range.length-1];
    [footLabel setColor:[UIColor  darkGrayColor] fromIndex:0 length:footLabel.text.length];
    [footLabel  setColor:[UIColor  blackColor] fromIndex:0 length:range.length];
    footLabel.numberOfLines = 0;
    footLabel.textAlignment = NSTextAlignmentLeft;
   
    footLabel.frame = CGRectMake(12, 20, 280, foot.height);
    foot.backgroundColor = [UIColor clearColor];
    [foot  addSubview:footLabel];
    [footLabel release];
    _table.tableFooterView = foot;
    [foot  release];
    
}

- (void)commitViewSet
{
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, 320, 50)];
	bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
	[self.view addSubview:bottomView];
    [bottomView release];
    
    NSString  *oderText = [NSString  stringWithFormat:@"¥%@",self.typeModel.fee];
    CGSize  size = [oderText  sizeWithFont:FONT_B18];
    UILabel *orgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (bottomView.height - 44)/2, size.width ,44)];
    orgPriceLabel.textColor =  [UIColor whiteColor];
    orgPriceLabel.font = FONT_B18;
    orgPriceLabel.textAlignment = NSTextAlignmentLeft;
    orgPriceLabel.backgroundColor = [UIColor clearColor];
    orgPriceLabel.adjustsFontSizeToFitWidth = YES;
    orgPriceLabel.minimumFontSize = 10.0f;
    orgPriceLabel.text = oderText;
    [bottomView addSubview:orgPriceLabel];
    [orgPriceLabel release];
    
//    UIButton  *bt = [UIButton  uniformButtonWithTitle:@"提交订单" ImagePath:nil Target:self Action:@selector(commitAction) Frame:CGRectMake(SCREEN_WIDTH - 120-10, (bottomView.height - 40)/2, 120, 40)];
    
    
    commitBt = [UIButton  yellowWhitebuttonWithTitle:@"提交订单" Target:self Action:@selector(commitAction) Frame:CGRectMake(SCREEN_WIDTH - 120-10, (bottomView.height - 40)/2, 120, 40)];
    
    commitBt.userInteractionEnabled = YES;
   
    [bottomView  addSubview:commitBt];
    
    [commitBt  retain];

}

- (void) initLoginButton
{
    UIButton  *favBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    favBtn.exclusiveTouch = YES;
    favBtn.adjustsImageWhenDisabled = NO;
    favBtn.titleLabel.font = FONT_B15;
	[favBtn setTitle:@"登录" forState:UIControlStateNormal];
    [favBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [favBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[favBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:favBtn] autorelease];
}
#pragma mark - 初始化下单信息
- (void) intFillMessage
{
    manager.fillRqModel.orderAmount =    [NSNumber  numberWithFloat:[self.typeModel.fee  floatValue]];
    manager.fillRqModel.mapSupporter = [ NSString  stringWithFormat:@"%d",MapSurppot];
    if ([self  adjustIsLogin])
    {
        manager.fillRqModel.uid =   [[AccountManager  instanse] cardNo];
    }else
    {
        manager.fillRqModel.uid =  [PublicMethods  macaddress] ;
    }
    
    
        NSString  *jsonStr = [self.eModel.estimatedAmountDetail  JSONString];
        manager.fillRqModel.orderAmountDetail = jsonStr;
  
   
    manager.fillRqModel.carTypeName = self.typeModel.carTypeName;
    manager.fillRqModel.passengerNum = [NSString  stringWithFormat:@"%d",1];
    manager.fillRqModel.isAsap = @"";
    
    //为姓名赋初值
    [self  initPassengerName];
    
    //电话的默认值
    manager.fillRqModel.passengerPhone = [self  firstGetPassengerPhone];
}
#pragma mark - 初始化联系人电话的信息

- (NSString  *) firstGetPassengerPhone
{
    NSLog(@"%@",[[AccountManager instanse] phoneNo]);
    //第一步：取卡号
    if (!STRINGISNULL([[AccountManager instanse] phoneNo]))
   
        return [[AccountManager instanse] phoneNo];
      //第二步：取上次租车输入过的号码
        if (!STRINGISNULL([[ElongUserDefaults  sharedInstance] objectForKey:USERDEFAULT_TAXI_TEL]))
       
            return [[ElongUserDefaults  sharedInstance] objectForKey:USERDEFAULT_TAXI_TEL];
       //第三步：取酒店模块
       return [[ElongUserDefaults  sharedInstance]objectForKey:NONMEMBER_PHONE];

}

#pragma mark- 下单
- (void) commitAction
{
    [_table reloadData];
    
    commitBt.userInteractionEnabled = NO;
   
    
    
    [self  performSelector:@selector(again) withObject:nil afterDelay:0.1];
}
- (void) again
{
    commitBt.userInteractionEnabled = YES;
    if (reClick >1)
    {
        return;
    }
    if ([manager  checkAll])
    {
        NSDictionary  *dic = [manager  changeModelDic];
        NSLog(@"%@",dic);
        NSString *jsonString = [dic  JSONString];
        NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/createOrder"]; 
        HttpUtil *util = [HttpUtil shared];
        [util  requestWithURLString:url Content:jsonString Delegate:self];
        
        reClick = 0;
    }

}
 - (void)loginAction
{
    LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:RentTaxiFill];
    [self.navigationController pushViewController:login animated:YES];
    [login release];
}

#pragma mark - 判定是否登录的方法

- (BOOL)  adjustIsLogin
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin)
    {
        if (appDelegate.isNonmemberFlow )
        {
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }

}
#pragma mark - alertviewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController  popViewControllerAnimated:YES];
}
#pragma mark- tableviewDelegate

- (NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TAXI_FILLTYPE)
    {
        return 2;
    }

//    else  if  (section == TAXI_AIRTYPE)
//    {
//        if (needAirPort)
//        {
//            return 2;
//        }else
//            return 1;
//    }
        return 1;

}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *useTaxiCell = @"useTaxiCell";
    static  NSString  *evaluteCell = @"evaluteCell";
    static  NSString  *taxiFillCellPerson = @"taxiFillCellPerson";
    static  NSString  *taxiFillCellTel = @"taxiFillCellTel";
    static NSString  *invoceCell = @"TaxiInvoceCell";
    switch (indexPath.section)
    {
        case TAXI_USERTYPE:
        { 
            UseTaxiCell  *cell = (UseTaxiCell  *)[tableView  dequeueReusableCellWithIdentifier:useTaxiCell];
            if (!cell)
            {
                cell = [[[NSBundle  mainBundle]loadNibNamed:@"UseTaxiCell" owner:self options: Nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taxiTypeModel  = self.typeModel;
            return cell;
        }
            break;
        case TAXI_EVALUTETYPE:
        {
            EvaluteCell  *cell  = [tableView  dequeueReusableCellWithIdentifier:evaluteCell];
            if (!cell)
            {
                cell =[[[NSBundle  mainBundle]loadNibNamed:@"EvaluteCell" owner:self  options: Nil]lastObject];
               
                cell.delegate = self;
            }
            cell.spread = isSpread;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model  =self.eModel;
            if (self.eModel.estimatedPrice)
            {
                manager.fillRqModel.estimatedAmount = self.eModel.estimatedPrice;
            }else
            {
                //manager.fillRqModel.estimatedAmount = [NSString  stringWithFormat:@"%f",0.0];
                manager.fillRqModel.estimatedAmount = [NSNumber  numberWithFloat:0.0];
            }
            return cell;
        }
            break;
            
        case TAXI_FILLTYPE:
        {
            if (indexPath.row == 0)
            {
                TaxiPersonCell  *cell1=  [tableView  dequeueReusableCellWithIdentifier:taxiFillCellPerson];
                if(!cell1)
                {
                    cell1 =[[[TaxiPersonCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taxiFillCellPerson]autorelease];
                    cell1.textField.delegate = self;
                    cell1.textField.tag = 101;
                    cell1.delegate = self;
                    personField = cell1.textField;
                    //判定是否是会员
                    //放在外面有问题
                    if ([[NSUserDefaults  standardUserDefaults]objectForKey:USERDEFAULT_TAXI_PERSON])
                    {
                        cell1.textField.text = [[ElongUserDefaults sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON] ;
                    }
                    
                }
                //mark：之前是放在cell创建的里面
               
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([self  adjustIsLogin])
                {
                    cell1.isMember = YES;
                }else
                {
                    cell1.isMember = NO;
                }
                
                manager.fillRqModel.passengerName = cell1.textField.text;
                NSLog(@"%@",cell1.textField.text);
                return cell1;
            }
            else
            {
                //联系人手机
                TaxiFillCell  *cell2 = [tableView  dequeueReusableCellWithIdentifier:taxiFillCellTel];
                if (!cell2)
                {
                    cell2 =[[[TaxiFillCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taxiFillCellTel]autorelease];
                    cell2.textField.delegate = self;
                    cell2.textField.keyboardType = CustomTextFieldKeyboardTypeNumber;
                    cell2.textField.tag = 102;
                    cell2.delegate = self;
                    telField = cell2.textField;
                    //*******************联系人手机********************//
                    cell2.textField.text = [self firstGetPassengerPhone];
                }
                manager.fillRqModel.passengerPhone = cell2.textField.text;
                manager.fillRqModel.receiptPhone = cell2.textField.text;
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell2;
            }
        }
        case TAXI_INVOICETYPE:
        {
            UITableViewCell  *cell;
            cell = [tableView  dequeueReusableCellWithIdentifier:invoceCell];
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:invoceCell] autorelease];
                _invoiceView = [[SelectInvoiceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _invoiceCellHeight) cellHeight:44 invoiceTypes:[NSArray  arrayWithObjects:@"服务费",@"旅游服务费",@"服务费（租车）" ,nil]];
                _invoiceView.delegate = self;
                [cell addSubview:_invoiceView];
                [_invoiceView release];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //为发票赋值
            manager.fillRqModel.needReceipt = [NSString  stringWithFormat:@"%d",_invoiceView.needInvoice];
            manager.fillRqModel.receiptTitle = _invoiceView.invoiceTitle;
            manager.fillRqModel.receiptContent = _invoiceView.invoiceType;
            manager.fillRqModel.receiptAddress = [_invoiceView.invoice  objectForKey:@"AddressContent"];
            manager.fillRqModel.receiptPerson = [_invoiceView.invoice  objectForKey:@"Name"];
            manager.fillRqModel.receiptPostCode = @"";
            manager.fillRqModel.receiptType = _invoiceView.invoiceType;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
        case TAXI_USERTYPE:
            return 181;
        case TAXI_EVALUTETYPE:
            //每一行为25，基数是50
            if (isSpread)
            {
                int  count = self.eModel.estimatedAmountDetail.count;
                NSLog(@"%d",count);
                evaluteHeight =115 + 25*(count/2 + count%2);
                return evaluteHeight;
            }else
            {
                return 88;
            }
                
        case TAXI_INVOICETYPE:
            return _invoiceCellHeight;
        default:
            return 44;
    }
}

- (UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == TAXI_EVALUTETYPE)
//    {
//         return  [self  tipSet:section];
//    }else
//    {
        return  [self  nomalSectionLabel:section];
  //  }
}

//预加载联系人
- (void)requestForRoomer
{
   
    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:3];
    
    if (getPersonUtil) {
        [getPersonUtil cancel];
        SFRelease(getPersonUtil);
    }
    getPersonUtil = [[HttpUtil alloc] init];
    [getPersonUtil connectWithURLString:MYELONG_SEARCH
                                Content:[customer requesString:NO]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
}

- (UIView  *) nomalSectionLabel:(NSInteger) section
{
    UILabel  *label = [[UILabel  alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
    label.backgroundColor = [UIColor  clearColor];
    label.font = [UIFont  systemFontOfSize:15];
    label.textColor = RGBCOLOR(93, 93, 93, 1);
    label.text = headAr[section];
    label.clipsToBounds = YES;
    return [label autorelease];
}


- (UIView  *)  tipSet:(NSInteger  )section
{
    UIView  *view = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    view.backgroundColor = [UIColor  clearColor];
    
    UILabel  *label = [[UILabel  alloc]initWithFrame:CGRectMake(0, 20, 100, 30)];
    label.backgroundColor = [UIColor  clearColor];
    label.font = [UIFont  systemFontOfSize:15];
    label.textColor = [UIColor  darkGrayColor];
    label.text = [headAr  objectAtIndex:section];
    [view  addSubview:label];
    [label release];
    
    UILabel   *tipLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:11];
    tipLabel.textColor = [UIColor colorWithRed:1.000 green:0.092 blue:0.257 alpha:1.000];
    tipLabel.text  = TIP;
    [view  addSubview:tipLabel];
    [tipLabel release];
    view.clipsToBounds = YES;
   
    return  [view autorelease];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    switch (section)
//    {
//        case TAXI_EVALUTETYPE:
//           
//          return 55;
//                  default:
    if (section == TAXI_EVALUTETYPE||section == TAXI_USERTYPE)
    {
        return 0;
    }
            return 18;
          
  //  }
  
}

#pragma mark- keyboardNotifacation
- (void)keyBoardAction:(NSNotification *)noti
{
//   [UIView  animateWithDuration:0.25 animations:^{
//       _table.contentOffset = CGPointMake(0,216+44);
//   }];
    
  
}
#pragma mark - switchDelegate
- (void)chooseInvoceAction:(TaxiInvoceCell  *)cell
{
   // [_table reloadData];
    if ([_table  indexPathForCell:cell].section== TAXI_INVOICETYPE)
    {
        needInvoce = !needInvoce;
       
        [_table  reloadData] ;
        
    }
    else if ([_table  indexPathForCell:cell].section == TAXI_AIRTYPE)
    {
        needAirPort = !needAirPort;
        [_table  reloadData];
        
    }
    
}

#pragma mark - scrow
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _table)
    {
        CGFloat sectionHeaderHeight;

             sectionHeaderHeight = [self tableView:_table heightForHeaderInSection:0];
     
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     [[UIApplication   sharedApplication] sendAction:@selector(resignFirstResponder) to:nil  from:nil  forEvent:nil];
}

#pragma mark- textFieldDelegate


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([textField isKindOfClass:[CustomTextField class]])
    {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }

    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
      if (textField.tag == 103)
    
    {
           [_table scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:1 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:YES];
     
        
    }else
    {
        [_table scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:0 inSection:2] atScrollPosition: UITableViewScrollPositionTop animated:YES];
        
    }
   
    field = textField;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        [[ElongUserDefaults sharedInstance]setObject:textField.text  forKey:USERDEFAULT_TAXI_PERSON];
        [_table  reloadData];
    }else  if  (textField.tag == 102)
    {
        [[ElongUserDefaults sharedInstance]setObject:textField.text forKey:USERDEFAULT_TAXI_TEL];
        [_table  reloadData];
    }
   
   [textField  resignFirstResponder];
    
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        [[ElongUserDefaults sharedInstance]setObject:textField.text  forKey:USERDEFAULT_TAXI_PERSON];
        
    }else  if  (textField.tag == 102)
    {
        [[ElongUserDefaults sharedInstance]setObject:textField.text forKey:USERDEFAULT_TAXI_TEL];
        [_table  reloadData];
    }
    
    [textField  resignFirstResponder];
    
    return YES;
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 101)
    {
        
        if (range.location >=  100)
        {
            textField.text = [textField.text  substringFromIndex:100];
            return NO;
        }
     
    }else if  (textField.tag == 102)
    {
        if (range.location >=11)
        {
            textField.text = [textField.text substringToIndex:11];
            return NO;
        }
    
    }
    return YES;

}
#pragma mark - 选择客史信息
- (void)personChooseAction
{
    if (field)
    {
        if (![field  resignFirstResponder])
        {
            [field  resignFirstResponder];
        }
        

    }
    
    if (!requestOver) {
        // 没有获取到入住人时停止本页请求
        [getPersonUtil cancel];
        SFRelease(getPersonUtil);
    }
    if ([[SelectRoomer  allRoomers] count] > 0)
    {
        requestOver= YES;
    }
   
   SelectRent  *controller = [[SelectRent  alloc]initRentRequested:requestOver peopleCount:1 andType:SelectType_RentCar];
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

#pragma mark - 进入电话薄
- (void)addressChooseAction:(UIButton  *)bt
{
    keyType = PERSONTYPETEL;
    
    if (![field  resignFirstResponder])
    {
        [field  resignFirstResponder];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - roomDelegate
- (void) selectRoomer:(SelectRoomer *)selectRoomer didSelectedArray:(NSArray *)array
{
    
   for(NSDictionary *dic in  array)
   {
       if ([[dic objectForKey:@"Checked"]boolValue])
       {
           
           [[ElongUserDefaults sharedInstance]setObject:[dic  objectForKey:@"Name"]forKey:USERDEFAULT_TAXI_PERSON];
           NSLog(@"%@",[[ElongUserDefaults sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON]);
           personField.text =  [dic  objectForKey:@"Name"];
          
       }
   }
    
}

#pragma mark - SelectInvoiceViewDelegate
- (void) selectInvoiceView:(SelectInvoiceView *)selectInvoiceView didSelectAtIndex:(NSInteger)index
{
    if (index == 1)
    {
        [_table scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else
    {
        [[UIApplication   sharedApplication] sendAction:@selector(resignFirstResponder) to:nil  from:nil  forEvent:nil];
    }
    //
    if (_invoiceView.needInvoice)
    {
    
    }
    manager.fillRqModel.receiptTitle = selectInvoiceView.invoiceTitle;
   
    if (selectInvoiceView.invoice )
    {
        NSLog(@"%@",selectInvoiceView.invoice);
    }
    
}

- (void) selectInvoiceView:(SelectInvoiceView *)selectInvoiceView didResizedToFrame:(CGRect)frame{
    _invoiceCellHeight = frame.size.height;
    [_table reloadData];
}


- (void)getSelectedString:(NSString *)selectedStr
{
    
   /// [[ElongUserDefaults  sharedInstance] setObject:selectedStr forKey:USERDEFAULT_TAXI_TEL];
    
    telField.text =  [selectedStr stringByReplacingOccurrencesOfString:@"-" withString:@""];

    [_table  reloadData];
   // [_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath  indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - httpDelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
   
    //预加载联系人
    if (util == getPersonUtil)
    {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return ;
        }
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
        
        // 联系人加载成功之后，如果发现用户上次没有保存联系人信息，加载用户联系人组中第一位
       

        if (STRINGISNULL([[ElongUserDefaults  sharedInstance]objectForKey:USERDEFAULT_TAXI_PERSON]))
        {
            if (customers.count)
            {
                NSDictionary *customer = [customers objectAtIndex:0];
                if ([customer safeObjectForKey:@"Name"] != [NSNull null]) {
                    NSString *name = [customer safeObjectForKey:@"Name"];
                    [[ElongUserDefaults  sharedInstance]setObject:name forKey:USERDEFAULT_TAXI_PERSON];
                    //处理tableview还没滑到姓名格的情况
                    manager.fillRqModel.passengerName = name;
                    //如果拿不到客史里的信息，那酒店非登录情况下的第一个
                    personField.text = name;
                    [_table reloadData];
                }
             }

        }
   }else
      {   /***************************  下单    **************************************/
          NSDictionary  *root = [PublicMethods  unCompressData:responseData];
          NSLog(@"%@",root);
        if ([Utils checkJsonIsError:root])
        {
            return ;
        }
    //取消在页面停留太久的perform
        [NSObject  cancelPreviousPerformRequestsWithTarget:self];
        [manager  saveMessage];
      
        //新流程修改 去掉下单成功页面的展示，直接跳到支付 By Jian.zhao
//          
//        RentSuccessController  *ctrl = [[RentSuccessController   alloc]initWithTitle:@"订单成功" style:NavBarBtnStyleOnlyHomeBtn];
//        ctrl.orderDic = root;
//        [self.navigationController  pushViewController:ctrl animated:YES];
//        [ctrl  release];
          
          
          TaxiFillManager  *manager_ = [TaxiFillManager shareInstance];
          manager_.gorderIdt = [root  objectForKey:@"gorderId"];
          manager_.orderId = [root  objectForKey:@"orderId"];
          manager_.payMentToeken = [root  objectForKey:@"payMentToeken"];
          
          [self payAction];
          
      }
}

- (void) payAction
{
     newPayControl = [[NewPayMethodCtrl  alloc]init];
    
    NSString  *total =  [NSString  stringWithFormat:@"%d",[[TaxiFillManager shareInstance].fillRqModel.orderAmount  intValue]];
    
    [newPayControl  goChannel:RENT_TYPE andDic:[NSDictionary  dictionaryWithObjectsAndKeys:total,@"totalPrice",[NSNumber  numberWithInt:RENT_TYPE],@"sourceType",[TaxiUtils getOrderRentInfoHeaderShowSuccess:YES],@"detaile", nil]];
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == getPersonUtil) {
        requestOver = NO;
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (util == getPersonUtil)
    {
        requestOver = NO;
    }
}
#pragma mark - spreadDelegate
- (void)spreadAction:(BOOL)flag
{
    isSpread = flag;
    //[_table  reloadData];
    
    
//    EvaluteCell *cell = (EvaluteCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    if (isSpread) {
//        [UIView  animateWithDuration:0.3 animations:^{
//            cell.bolangImgaV.top = 170;
//        }];
//    }else{
//        [UIView  animateWithDuration:0.3 animations:^{
//            cell.bolangImgaV.top = 0;
//        }];
//    }
    [_table  reloadData];
    //[_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
}
@end
