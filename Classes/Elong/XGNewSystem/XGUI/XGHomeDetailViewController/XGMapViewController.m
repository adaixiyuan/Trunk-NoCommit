//
//  XGMapViewController.m
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGMapViewController.h"

#import "DefineHotelResp.h"
#import "DefineHotelReq.h"

#define ROOMSEVENDAY  40012
@interface XGMapViewController ()

@end

@implementation XGMapViewController

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
    double lat =[self.lat doubleValue];
    double lng =[self.lng doubleValue];
    NSString *hotelTitle = self.hotelName;
    NSString *hotelSubtitle = self.hotelSubtitle;
    
    
    // 需要纠偏
    if([PublicMethods needSwitchWgs84ToGCJ_02]){
        [PublicMethods wgs84ToGCJ_02WithLatitude:&lat longitude:&lng];
    }
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 50, 10000);
    CGSize newSize = [hotelSubtitle sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    newSize.height = newSize.height + 6;
    
    
    mapView = [[HotelMap alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - newSize.height) latitude:lat longitude:lng];
    mapView.showsUserLocation = YES;
    mapView.hotelTitle = hotelTitle;
    mapView.hotelSubtitle = hotelSubtitle;
    [self.view addSubview:mapView];
    
    // 地址提示
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - newSize.height, SCREEN_WIDTH, newSize.height)];
    [self.view addSubview:addressView];
    addressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    addressTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, newSize.height)];
    addressTipsLbl.font = [UIFont systemFontOfSize:12.0f];
    addressTipsLbl.textColor = [UIColor whiteColor];
    addressTipsLbl.backgroundColor = [UIColor clearColor];
    addressTipsLbl.lineBreakMode = UILineBreakModeCharacterWrap;
    addressTipsLbl.numberOfLines = 0;
    [addressView addSubview:addressTipsLbl];
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
