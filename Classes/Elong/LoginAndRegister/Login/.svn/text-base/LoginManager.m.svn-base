    //
//  LoginManager.m
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "LoginManager.h"
#import "MessageManager.h"

static LoginNextState nextState;


@implementation LoginManager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	SFRelease(loginVC);
}


- (void)dealloc {
    self.delegate = nil;
	[tabViewController1 release];
	[tabViewController2 release];
	[tabViewController3 release];
	[tabItemsArray release];
	[loginVC release];
	[viewControllersArray release];
    
    [_messageBoxCtrl release];
    [_notification release];
    [_adviceAndFeedBack release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATE_MESSAGECOUNT object:nil];
    [super dealloc];
}

- (id)init:(NSString *)name style:(NavBtnStyle)style state:(LoginNextState)state {
	nextState = state;
	
	if (self = [super initWithTopImagePath:@"" andTitle:name style:style]) {
		UIBarButtonItem *settingBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"设置" Target:self Action:@selector(goSettingPage)];
        self.navigationItem.rightBarButtonItem = settingBarItem;
	}
	
	return self;
}

+(LoginNextState)nextState{
	return nextState;
}


-(void)loadView{
	[super loadView];
	
	loginVC = [[Login alloc] init];
    loginVC.delegate = self;
	[self.view addSubview:loginVC.view];
    
    // 消息盒子
    _messageBoxCtrl = [[MessageBoxController alloc] init];
    [self.view addSubview:_messageBoxCtrl.view];
    _messageBoxCtrl.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -44);
    [_messageBoxCtrl updateUIWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
    _messageBoxCtrl.view.hidden = YES;      //默认隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageCount) name:UPDATE_MESSAGECOUNT object:nil];
    
    // 活动公告
    _notification = [[Notification alloc] init];
    [self.view addSubview:_notification.view];
    _notification.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    [_notification updateUIWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
    _notification.view.hidden = YES;        //默认隐藏
    
    // 意见反馈
    _adviceAndFeedBack = [[AdviceAndFeedback alloc] initWithTopImagePath:@"" andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
    [self.view addSubview:_adviceAndFeedBack.view];
    _adviceAndFeedBack.view.hidden = YES;       //默认隐藏
    
    //判断状态
    LoginNextState state = [LoginManager nextState];
   
    if(state == _MyElong_){
        //进入个人中心的，显示BottomBar
        [self addBottomBarUI];      //增加新的底部导航栏
    }
}


-(void)addBottomBarUI{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    // 个人中心
    BaseBottomBarItem *elongCenterBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"个人中心"
                                                                           titleFont:[UIFont systemFontOfSize:12.0f]
                                                                               image:@"elongCenter_myelong_N.png"
                                                                     highligtedImage:@"elongCenter_myelong_H.png"];
    //消息盒子
    BaseBottomBarItem *messageBoxBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"消息"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"elongCenter_messageBox_N.png"
                                                                    highligtedImage:@"elongCenter_messageBox_H.png"];
    
    // 活动公告
    BaseBottomBarItem  *notificationBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"活动"
                                                                             titleFont:[UIFont systemFontOfSize:12.0f]
                                                                                 image:@"elongCenter_notificationIcon_N.png"
                                                                       highligtedImage:@"elongCenter_notificationIcon_H.png"];
    
    // 意见反馈
    BaseBottomBarItem  *feedbackBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"反馈"
                                                                         titleFont:[UIFont systemFontOfSize:12.0f]
                                                                             image:@"elongCenter_feedback_N.png"
                                                                   highligtedImage:@"elongCenter_feedback_H.png"];
    
    elongCenterBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    messageBoxBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    notificationBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    feedbackBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    
    NSArray *items = [NSArray arrayWithObjects:elongCenterBarItem,messageBoxBarItem,notificationBarItem, feedbackBarItem,nil];
    bottomBar.baseBottomBarItems = items;
    [elongCenterBarItem changeStateToPressed:YES];
    bottomBar.selectedItem = elongCenterBarItem;    //默认选中
    
    [self.view addSubview:bottomBar];
    [elongCenterBarItem release];
    [messageBoxBarItem release];
    [notificationBarItem release];
    [feedbackBarItem release];
    [bottomBar release];
    
    //add badgeBgImgView
    _badgeBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 5, 11, 11)];
    _badgeBgImgView.image = [UIImage stretchableImageWithPath:@"elongCenter_message_badgeBg.png"];
    [bottomBar addSubview:_badgeBgImgView];
    [_badgeBgImgView release];
    _badgeBgImgView.hidden = YES;       //默认隐藏
    
    _badgeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
    _badgeNumLabel.backgroundColor = [UIColor clearColor];
    _badgeNumLabel.textAlignment = NSTextAlignmentCenter;
    _badgeNumLabel.textColor = [UIColor whiteColor];
    _badgeNumLabel.font = [UIFont systemFontOfSize:9];
    _badgeNumLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_badgeBgImgView addSubview:_badgeNumLabel];
    [_badgeNumLabel release];
    
    [self updateMessageCount];
}

-(void)updateMessageCount{
    int unreadCount = [[MessageManager sharedInstance] unreadMessageCount];
    if(unreadCount>0){
        _badgeBgImgView.hidden = NO;
        _badgeNumLabel.text = [NSString stringWithFormat:@"%d",unreadCount];
    }else{
        //清除消息显示
        _badgeBgImgView.hidden = YES;
        _badgeNumLabel.text = @"";
    }
}


-(void)goSettingPage{
    ElongClientSetting *setting = [[ElongClientSetting alloc] initWithTopImagePath:@"" andTitle:@"设置" style:_NavNoTelStyle_];
    
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
}

#pragma mark - BaseBottomBar Delegate
-(void)submitAdviceFeedback{
    [_adviceAndFeedBack clickConfirm];  //点确认
}

-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if(index==0){
        //登陆
        loginVC.view.hidden = NO;
        _messageBoxCtrl.view.hidden = YES;
        _notification.view.hidden = YES;
        _adviceAndFeedBack.view.hidden = YES;
        
        [self setNavTitle:@"登  录"];
        
        //设置入口
        UIBarButtonItem *settingBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"设置" Target:self Action:@selector(goSettingPage)];
        self.navigationItem.rightBarButtonItem = settingBarItem;
    }else if(index==1){
        //消息盒子
        loginVC.view.hidden = YES;
        _messageBoxCtrl.view.hidden = NO;
        _notification.view.hidden = YES;
        _adviceAndFeedBack.view.hidden = YES;
        
        [self setNavTitle:@"消息盒子"];
        self.navigationItem.rightBarButtonItem = nil;
    }else if(index==2){
        //活动公告
        loginVC.view.hidden = YES;
        _messageBoxCtrl.view.hidden = YES;
        _notification.view.hidden = NO;
        _adviceAndFeedBack.view.hidden = YES;
        
        [self setNavTitle:@"活动公告"];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        //意见反馈
        loginVC.view.hidden = YES;
        _messageBoxCtrl.view.hidden = YES;
        _notification.view.hidden = YES;
        _adviceAndFeedBack.view.hidden = NO;
        
        [self setNavTitle:@"意见反馈"];
        //提交入口
        UIBarButtonItem *settingBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"提交" Target:self Action:@selector(submitAdviceFeedback)];
        self.navigationItem.rightBarButtonItem = settingBarItem;;
    }
}

#pragma mark -
#pragma mark LoginDelegate

- (void) login:(id)login didLogin:(NSDictionary *)dict{
    if ([self.delegate respondsToSelector:@selector(loginManager:didLogin:)]) {
        [self.delegate loginManager:self didLogin:dict];
    }
}

- (void) loginDidLoginNonmember:(Login *)login{
    if ([self.delegate respondsToSelector:@selector(loginManagerDidLoginNonmember:)]) {
        [self.delegate loginManagerDidLoginNonmember:self];
    }
}
@end
