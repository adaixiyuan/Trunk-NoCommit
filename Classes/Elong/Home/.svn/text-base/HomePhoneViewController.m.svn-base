//
//  HomePhoneViewController.m
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HomePhoneViewController.h"
#import "HomePhoneCell.h"
#import "HomeOnlineViewController.h"
#import "HomeViewController.h"

@interface HomePhoneViewController ()
@property (nonatomic,retain) NSMutableArray *itemArray;
@property (nonatomic,assign) NSInteger index;
@end

@implementation HomePhoneViewController

- (void) dealloc{
    self.itemArray = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IOSVersion_7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    self.itemArray = [NSMutableArray array];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"国内拨打",@"title",@"随时拨打，艺龙客服24小时为您服务",@"detail",@"InnerPhone",@"type",@"400-666-1166",@"num",@"tel://4006661166",@"tel", nil];
    [self.itemArray addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"国外拨打",@"title",@"当您身在国外，艺龙为您提供方便、快捷的服务",@"detail",@"InterPhone",@"type",@"+86 10-6432-9999",@"num",@"tel://+861064329999",@"tel", nil];
    [self.itemArray addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"火车票售后服务",@"title",@"火车票售后服务",@"detail",@"TrainPhone",@"type",@"400-689-9617",@"num",@"tel://4006899617",@"tel", nil];
    [self.itemArray addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"在线客服",@"title",@"在线为您解决问题，无需拨打电话",@"detail",@"Online",@"type",@"",@"num", nil];
    [self.itemArray addObject:dict];
    
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    self.view.clipsToBounds = YES;
    
  
    
    //
    UIImageView *navBgView = nil;
    if (IOSVersion_7) {
        navBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT)];
        navBgView.image = [UIImage noCacheImageNamed:@"bg_header_gray.png"];
        navBgView.userInteractionEnabled = YES;
        [self.view addSubview:navBgView];
        [navBgView release];
        
        UIImageView *dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        dashLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [navBgView addSubview:dashLine];
        [dashLine release];
    }else{
        navBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        navBgView.image = [UIImage noCacheImageNamed:@"bg_header.png"];
        navBgView.userInteractionEnabled = YES;
        [self.view addSubview:navBgView];
        [navBgView release];
    }
    //navBgView.alpha = 0.4;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.adjustsImageWhenDisabled = NO;
    cancelBtn.titleLabel.font = FONT_B15;
    cancelBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateDisabled];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    if (IOSVersion_7) {
        cancelBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 60, NAVIGATION_BAR_HEIGHT);
    }else{
        cancelBtn.frame = CGRectMake(0, 0, 60, NAVIGATION_BAR_HEIGHT);
    }
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLbl.backgroundColor	= [UIColor clearColor];
    titleLbl.font				= FONT_B18;
    titleLbl.textColor			= COLOR_NAV_TITLE;
    titleLbl.text				= @"艺龙客服";
    titleLbl.textAlignment		= UITextAlignmentCenter;
    titleLbl.adjustsFontSizeToFitWidth = YES;
    titleLbl.minimumFontSize = 14.0f;
    [self.view addSubview:titleLbl];
    [titleLbl release];
    if (IOSVersion_7) {
        titleLbl.frame= CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 44);
    }else{
        titleLbl.frame= CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }
    

    
    
    // 国内拨打
    dict = [self.itemArray objectAtIndex:0];
    UIButton *innerPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    innerPhoneBtn.frame = CGRectMake(10, 25 + navBgView.frame.size.height, SCREEN_WIDTH - 20, 108);
    [innerPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
    [innerPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
    
    UIImageView *innerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 108, 108)];
    innerIcon.image = [UIImage noCacheImageNamed:@"home_innerphone.png"];
    innerIcon.contentMode = UIViewContentModeCenter;
    [innerPhoneBtn addSubview:innerIcon];
    [innerIcon release];
    
    UILabel *innerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(101 - 20, 20, innerPhoneBtn.frame.size.width - 101 + 20, 30)];
    innerTitleLbl.font = [UIFont boldSystemFontOfSize:24.0f];
    innerTitleLbl.textColor = [UIColor whiteColor];
    innerTitleLbl.backgroundColor = [UIColor clearColor];
    [innerPhoneBtn addSubview:innerTitleLbl];
    [innerTitleLbl release];
    innerTitleLbl.text = [dict objectForKey:@"num"];
    
    UILabel *innerTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(130 - 20, 60, innerPhoneBtn.frame.size.width - 130 + 20, 30)];
    innerTipLbl.font = [UIFont systemFontOfSize:20.0f];
    innerTipLbl.textColor = [UIColor whiteColor];
    innerTipLbl.backgroundColor = [UIColor clearColor];
    [innerPhoneBtn addSubview:innerTipLbl];
    [innerTipLbl release];
    innerTipLbl.text = [dict objectForKey:@"title"];
    
    [self.view addSubview:innerPhoneBtn];
    innerPhoneBtn.tag = 1000;
    [innerPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 国外拨打
    dict = [self.itemArray objectAtIndex:1];
    UIButton *interPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    interPhoneBtn.frame = CGRectMake(10, innerPhoneBtn.frame.origin.y + innerPhoneBtn.frame.size.height + 10, (SCREEN_WIDTH - 30)/2, 108);
    [interPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
    [interPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
    
    UILabel *interTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, interPhoneBtn.frame.size.width, 30)];
    interTitleLbl.font = [UIFont boldSystemFontOfSize:18.0f];
    interTitleLbl.textColor = [UIColor whiteColor];
    interTitleLbl.textAlignment = UITextAlignmentCenter;
    interTitleLbl.backgroundColor = [UIColor clearColor];
    [interPhoneBtn addSubview:interTitleLbl];
    [interTitleLbl release];
    interTitleLbl.text = [dict objectForKey:@"title"];
    
    UILabel *interTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, interPhoneBtn.frame.size.width, 30)];
    interTipLbl.font = [UIFont systemFontOfSize:16.0f];
    interTipLbl.textColor = [UIColor whiteColor];
    interTipLbl.textAlignment = UITextAlignmentCenter;
    interTipLbl.backgroundColor = [UIColor clearColor];
    [interPhoneBtn addSubview:interTipLbl];
    [interTipLbl release];
    interTipLbl.text = [dict objectForKey:@"num"];
    
    [self.view addSubview:interPhoneBtn];
    interPhoneBtn.tag = 1001;
    [interPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //火车票售后服务
    dict = [self.itemArray objectAtIndex:2];
    UIButton *trainPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trainPhoneBtn.frame = CGRectMake(20 + (SCREEN_WIDTH - 30)/2, innerPhoneBtn.frame.origin.y + innerPhoneBtn.frame.size.height + 10, (SCREEN_WIDTH - 30)/2, 108);
    [trainPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
    [trainPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
    
    UILabel *trainTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, trainPhoneBtn.frame.size.width, 30)];
    trainTitleLbl.font = [UIFont boldSystemFontOfSize:18.0f];
    trainTitleLbl.textColor = [UIColor whiteColor];
    trainTitleLbl.textAlignment = UITextAlignmentCenter;
    trainTitleLbl.backgroundColor = [UIColor clearColor];
    [trainPhoneBtn addSubview:trainTitleLbl];
    [trainTitleLbl release];
    trainTitleLbl.text = [dict objectForKey:@"title"];
    
    UILabel *trainTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, trainPhoneBtn.frame.size.width, 30)];
    trainTipLbl.font = [UIFont systemFontOfSize:16.0f];
    trainTipLbl.textColor = [UIColor whiteColor];
    trainTipLbl.textAlignment = UITextAlignmentCenter;
    trainTipLbl.backgroundColor = [UIColor clearColor];
    [trainPhoneBtn addSubview:trainTipLbl];
    [trainTipLbl release];
    trainTipLbl.text = [dict objectForKey:@"num"];
    
    [self.view addSubview:trainPhoneBtn];
    trainPhoneBtn.tag = 1002;
    [trainPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 在线客服
    dict = [self.itemArray objectAtIndex:3];
    UIButton *onlinePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onlinePhoneBtn.frame = CGRectMake(10, trainPhoneBtn.frame.origin.y + trainPhoneBtn.frame.size.height + 10, SCREEN_WIDTH - 20, 80);
    [onlinePhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
    [onlinePhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
    
    UIImageView *onlineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 80, 80)];
    onlineIcon.image = [UIImage noCacheImageNamed:@"home_online.png"];
    onlineIcon.contentMode = UIViewContentModeCenter;
    [onlinePhoneBtn addSubview:onlineIcon];
    [onlineIcon release];
    
    UILabel *onlineTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, innerPhoneBtn.frame.size.width - 120, 80)];
    onlineTitleLbl.font = [UIFont systemFontOfSize:20.0f];
    onlineTitleLbl.textColor = [UIColor whiteColor];
    onlineTitleLbl.backgroundColor = [UIColor clearColor];
    [onlinePhoneBtn addSubview:onlineTitleLbl];
    [onlineTitleLbl release];
    onlineTitleLbl.text = [dict objectForKey:@"title"];
    
    [self.view addSubview:onlinePhoneBtn];
    onlinePhoneBtn.tag = 1003;
    [onlinePhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *footerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, onlinePhoneBtn.frame.origin.y + onlinePhoneBtn.frame.size.height + 70, SCREEN_WIDTH, 120)];
    footerView.image = [UIImage noCacheImageNamed:@"home_phone_footer.png"];
    footerView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:footerView];
    [footerView release];
    if (SCREEN_4_INCH) {
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, onlinePhoneBtn.frame.origin.y + onlinePhoneBtn.frame.size.height + 20, SCREEN_WIDTH, 95)];
        headerView.image = [UIImage noCacheImageNamed:@"home_phone_header.png"];
        headerView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:headerView];
        [headerView release];
    }else{
        footerView.frame = CGRectMake(0, onlinePhoneBtn.frame.origin.y + onlinePhoneBtn.frame.size.height, SCREEN_WIDTH, 100);
    }
}

- (void) phoneBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dict = [self.itemArray objectAtIndex:btn.tag - 1000];
    if([[dict objectForKey:@"type"] isEqualToString:@"Online"]){
        NSString *title = @"在线客服";
//        NSString *urlPath = [NSString stringWithFormat:@"http://ali063.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&refer=%@",CHANNELID];        //这是老的在线客服地址，据说是负责该接口维护的人休假，没有对此维护。换下下面的链接
        
        NSString *urlPath = [NSString stringWithFormat:@"http://chat.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&refer=%@",CHANNELID];
        //自助答疑
//     urlPath = @"http://ali063.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&command=robotChat";
        HomeOnlineViewController *webController = [[HomeOnlineViewController alloc] initWithTitle:title targetUrl:urlPath style:_NavOnlyBackBtnStyle_];
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
        
        // 首页客服入口
        if (UMENG) {
            [MobClick event:Event_Home_Phone label:@"在线客服"];
        }
        
        UMENG_EVENT(UEvent_Service_Online)
    }else{
        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:[dict objectForKey:@"title"]
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:[dict objectForKey:@"num"],nil];
        menu.delegate			= self;
        menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        [menu release];
        self.index = btn.tag - 1000;
    }
}

- (void) cancelBtnClick:(id)sender{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    if ([self.delegate respondsToSelector:@selector(homePhoneVCDismiss:)]) {
        [self.delegate homePhoneVCDismiss:self];
    }
    
   
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        NSDictionary *dict = [self.itemArray objectAtIndex:self.index];
        if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:[dict objectForKey:@"tel"]]]) {
            [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        }else{
            // 首页客服入口
            if (UMENG) {
                [MobClick event:Event_Home_Phone label:[dict objectForKey:@"tel"]];
            }
            if ([[dict objectForKey:@"title"] isEqualToString:@"国内拨打"]) {
                UMENG_EVENT(UEvent_Service_Inner)
            }else if ([[dict objectForKey:@"title"] isEqualToString:@"国外拨打"]){
                UMENG_EVENT(UEvent_Service_International)
            }else if ([[dict objectForKey:@"title"] isEqualToString:@"火车票售后服务"]){
                UMENG_EVENT(UEvent_Service_Train)
            }
        }
    }

}




@end
