//
//  XGHotelInfoViewController.m
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHotelInfoViewController.h"
#import "HotelErrorCCViewController.h"
@interface XGHotelInfoViewController ()

@end

@implementation XGHotelInfoViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHotelErrorCC) name:NOTI_HotelJiuCuo object:nil];
    
    // Do any additional setup after loading the view.
}

-(void) setHotelInfoWebByData:(NSDictionary *) detailDict type:(HotelInfoType) type
{
    self.hotelDic = detailDict;
    
    HotelInfoWeb *web = [[HotelInfoWeb alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    web.hotelDic=detailDict;
    [web reloadDataByType:type];
    [self.view addSubview:web];
}

-(void) goToHotelErrorCC
{
    HotelErrorCCViewController *cc=[[HotelErrorCCViewController alloc] initWithTopImagePath:@"" andTitle:@"标识正确的酒店信息" style:_NavOnlyBackBtnStyle_];
    cc.hotelDic=self.hotelDic;
    [cc setUI];
    [self.navigationController pushViewController:cc animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
