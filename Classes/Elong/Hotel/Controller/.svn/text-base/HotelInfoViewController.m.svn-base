//
//  HotelInfoViewController.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelInfoViewController.h"
#import "TimeUtils.h"
#import "ElongClientAppDelegate.h"


@interface HotelInfoViewController ()

@end

@implementation HotelInfoViewController

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.hotelDic=nil;
    [super dealloc];
}


- (void) makeKeyWindow {
    ElongClientAppDelegate * appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window makeKeyAndVisible];
}



- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (UMENG) {
        // 酒店简介页面
        [MobClick event:Event_HotelInfo];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 避免apple的一个bug
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeKeyWindow) name:UIWindowDidBecomeKeyNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHotelErrorCC) name:NOTI_HotelJiuCuo object:nil];
}

-(void) setHotelInfoWebByData:(NSDictionary *) detailDict type:(HotelInfoType) type
{
    self.hotelDic=detailDict;
    HotelInfoWeb *web = [[HotelInfoWeb alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    web.hotelDic=detailDict;
    [web reloadDataByType:type];
    [self.view addSubview:web];
    [web release];
}

-(void) goToHotelErrorCC
{
    HotelErrorCCViewController *cc=[[HotelErrorCCViewController alloc] initWithTopImagePath:@"" andTitle:@"标识正确的酒店信息" style:_NavOnlyBackBtnStyle_];
    cc.hotelDic=self.hotelDic;
    [cc setUI];
    [self.navigationController pushViewController:cc animated:YES];
    [cc release];
}

@end
