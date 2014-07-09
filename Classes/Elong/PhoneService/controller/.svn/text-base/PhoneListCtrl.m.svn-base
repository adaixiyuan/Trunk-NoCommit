//
//  PhoneListCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-6-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PhoneListCtrl.h"
#import "PhoneListCell.h"
#import "PhoneManager.h"
#import "HomeOnlineViewController.h"

@interface PhoneListCtrl ()

@end

@implementation PhoneListCtrl
- (void)dealloc
{
    [listTable release];
    [imageAr release];
    [nameAr release];
    [super dealloc ];
}

- (id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style  phoneType:(PhoneType) type
{
    self = [super initWithTitle:titleStr style:style];
    if (self) {
        
        callType = type;
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style phoneType:(PhoneType)type chanelType:(PhoneChannelType)ctype
{
    chanelType = ctype;
    self = [self initWithTitle:titleStr style:style phoneType:type]
    ;
    if (self)
    {
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageAr = [[NSArray  alloc]initWithObjects:@"contant_tel.png",@"contant_talk.png",@"contant_wx.png", nil];
    nameAr = [[NSArray alloc]initWithObjects:@"电话拨打",@"在线客服",@"微信客服", nil];
    detaileAr = [[NSArray alloc]initWithObjects:@"直接拨打人工客服电话",@"在线客服为您解答疑惑",@"进入微信并关注艺龙客服" ,nil];
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT ) style:UITableViewStylePlain];
    listTable.backgroundColor = [UIColor clearColor];
    listTable.backgroundView = nil;
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTable];
    
    // Do any additional setup after loading the view.
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *str = @"cell";
    PhoneListCell  *cell = [tableView  dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneListCell" owner:self options:nil]lastObject];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    }
    cell.cellImageView.image = [UIImage  noCacheImageNamed:[imageAr  safeObjectAtIndex:indexPath.section]];
    cell.titleLabel.text = [nameAr  safeObjectAtIndex:indexPath.section];
    cell.detaileLabel.text = [detaileAr safeObjectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    if (section == 0) {
        view.height = 30;
    }else
        view.height = 15;
    return [view autorelease];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *str = [self callPhoneStr];
    if (indexPath.section== 0 )
    {
        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"打电话"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:str,nil];
        menu.delegate			= self;
        menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        [menu release];
    }else if (indexPath.section== 1)
    {
       
      
            //        NSString *urlPath = [NSString stringWithFormat:@"http://ali063.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&refer=%@",CHANNELID];        //这是老的在线客服地址，据说是负责该接口维护的人休假，没有对此维护。换下下面的链接
            
            NSString *urlPath = [NSString stringWithFormat:@"http://chat.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&refer=%@",CHANNELID];
            //自助答疑
            //     urlPath = @"http://ali063.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&command=robotChat";
            HomeOnlineViewController *webController = [[HomeOnlineViewController alloc] initWithTitle:@"在线客服" targetUrl:urlPath style:_NavOnlyBackBtnStyle_];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webController];
            [webController release];
            
            if (IOSVersion_7) {
                nav.transitioningDelegate = [ModalAnimationContainer shared];
                nav.modalPresentationStyle = UIModalPresentationCustom;
            }
            if (IOSVersion_7) {
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                [self presentModalViewController:nav animated:YES];
            }
            [nav release];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"打开微信后，请先关注公共账号：艺龙旅行网"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
      
       
    }
}
 - (NSString  *)callPhoneStr
{
    PhoneManager  *manager = [PhoneManager  shareInstance];
    NSString  *phone = nil;
    if (chanelType!= NOChanelType) {
        phone  = [manager  readPhoneType:callType chanelType:chanelType];
    }else
        phone = [manager  readTelePhoneType:callType];
    return phone;
}
 -(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString  *str = [self  callPhoneStr];
    if (buttonIndex==0)
    {
        
        if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:  [self  phoneStr:str]]])
        {
            [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];

        }
    }
}

- (NSString *)phoneStr:(NSString *) string
{
    NSString   *str = [NSString  stringWithFormat:@"tel://%@",string];
    return str;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if(![WXApi isWXAppInstalled]){
            [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"未发现微信客户端，请您先下载微信"]];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"您微信客户端版本过低，请您更新微信版本"]];
            return;
        }
        [WXApi  openWXApp];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
