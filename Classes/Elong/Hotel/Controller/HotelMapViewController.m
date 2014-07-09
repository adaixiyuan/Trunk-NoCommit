//
//  HotelMapViewController.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelMapViewController.h"
#import "HotelMap.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "StreetscapeViewController.h"
#import "Reachability.h"


@interface HotelMapViewController ()
@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic,copy) NSString *hotelName;
@end

@implementation HotelMapViewController

- (void) dealloc{
    self.hotelName = nil;
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (UMENG) {
        //酒店地图页面
        [MobClick event:Evnet_HotelMap];
    }
    
    double lat =[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Latitude_D] doubleValue];
    double lng =[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Longitude_D] doubleValue];
    NSString *hotelTitle = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S];
    NSString *hotelSubtitle = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Address_S];
    
    
    // 需要纠偏
    if([PublicMethods needSwitchWgs84ToGCJ_02]){
        [PublicMethods wgs84ToGCJ_02WithLatitude:&lat longitude:&lng];
    }
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 50, 10000);
    CGSize newSize = [hotelSubtitle sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    newSize.height = newSize.height + 6;
    
    
    mapView = [[HotelMap alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - newSize.height) latitude:lat longitude:lng detailEnabled:YES];
    mapView.showsUserLocation = YES;
    mapView.hotelMapDelegate = self;
    mapView.hotelTitle = hotelTitle;
    mapView.hotelSubtitle = hotelSubtitle;
    [self.view addSubview:mapView];
    [mapView release];
    
    
    // 地址提示
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - newSize.height, SCREEN_WIDTH, newSize.height)];
    [self.view addSubview:addressView];
    [addressView release];
    addressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    addressTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, newSize.height)];
    addressTipsLbl.font = [UIFont systemFontOfSize:12.0f];
    addressTipsLbl.textColor = [UIColor whiteColor];
    addressTipsLbl.backgroundColor = [UIColor clearColor];
    addressTipsLbl.lineBreakMode = UILineBreakModeCharacterWrap;
    addressTipsLbl.numberOfLines = 0;
    [addressView addSubview:addressTipsLbl];
    [addressTipsLbl release];
    addressTipsLbl.text = [NSString stringWithFormat:@"   %@",hotelSubtitle];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, newSize.height);
    copyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    copyButton.backgroundColor = [UIColor grayColor];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor colorWithWhite:136.0/255.0f alpha:1] forState:UIControlStateHighlighted];
    [copyButton setTitle:@" 复制" forState:UIControlStateNormal];
    [copyButton setImage:[UIImage noCacheImageNamed:@"map_address_copy.png"] forState:UIControlStateNormal];
    [addressView addSubview:copyButton];
    [copyButton addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) copyButtonClick:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = addressTipsLbl.text;
    
    [PublicMethods showAlertTitle:nil Message:@"酒店地址已复制到剪贴板"];
    
    if (UMENG) {
        //国际酒店地图赋值地址
        [MobClick event:Event_InterCopyMapAddress];
    }
}

- (void) hotelMapShowDetail:(HotelMap *)hotelMap position:(CLLocationCoordinate2D)coordinate2D hotelName:(NSString *)hotelName{
    self.coordinate2D = coordinate2D;
    self.hotelName = hotelName;
    
    UMENG_EVENT(UEvent_Hotel_Map_Streetscape)
    
    NSString *remoteHostName = @"m.elong.com";
    Reachability *reachability = [Reachability reachabilityWithHostName:remoteHostName];
    if (reachability.currentReachabilityStatus == ReachableViaWiFi) {
        StreetscapeViewController *streetscapeVC = [[StreetscapeViewController alloc] initWithCoordinate2D:coordinate2D hotelName:hotelName];
        [self.navigationController pushViewController:streetscapeVC animated:YES];
        [streetscapeVC release];
    }else if(reachability.currentReachabilityStatus == ReachableViaWWAN){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"非wifi环境，是否确认使用街景？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认",nil];
        [alert show];
        [alert release];
    }else if(reachability.currentReachabilityStatus == NotReachable){
        [PublicMethods showAlertTitle:@"您的网络不太给力，请稍候再试" Message:nil];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
        StreetscapeViewController *streetscapeVC = [[StreetscapeViewController alloc] initWithCoordinate2D:self.coordinate2D hotelName:self.hotelName];
        [self.navigationController pushViewController:streetscapeVC animated:YES];
        [streetscapeVC release];
    }
}
@end
