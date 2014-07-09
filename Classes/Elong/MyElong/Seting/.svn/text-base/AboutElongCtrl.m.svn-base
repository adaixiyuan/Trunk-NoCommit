//
//  AboutElongCtrl.m
//  ElongClient
//
//  Created by Ivan.xu on 13-12-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "AboutElongCtrl.h"

@interface AboutElongCtrl ()

@end

@implementation AboutElongCtrl

- (id)init {
    if (self = [super initWithTopImagePath:@"" andTitle:@"关于艺龙" style:_NavOnlyBackBtnStyle_])
    {
    }
	
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *topimage = [UIImage noCacheImageNamed:@"AboutUsTop.png"];
    UIImageView *topimageview = [[UIImageView alloc] initWithImage: topimage];
    topimageview.contentMode = UIViewContentModeCenter;
    topimageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleVersionKey];
    NSString *versionstring = [NSString stringWithFormat:@"版本号:%@",version];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = versionstring;
    label.textColor = RGBACOLOR(52, 52, 52, 1);
    label.font = [UIFont systemFontOfSize:14];
    [topimageview addSubview:label];
    label.frame = CGRectMake(120, 140, 80, 22.5);
    [label release];
    
    [self.view addSubview:topimageview];
    [topimageview release];
    
    //add despLabel
    UILabel *despLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, SCREEN_WIDTH-20, 200)];
    despLabel.backgroundColor = [UIColor clearColor];
    despLabel.numberOfLines = 0;
    despLabel.font = FONT_15;
    despLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    despLabel.text = @"艺龙旅行网 (NASDAQ: LONG)是中国领先的在线旅行服务提供商之一， 致力于为消费者打造专注专业、 物超所值、 智能便捷的旅行预订平台。  通过网站（ eLong.com） 、 24小时预订热线（ 400-666-1166） 以及手机艺龙网（ m.eLong.com） 、 艺龙iPhone、 Android和windows phone无线客户端等平台， 为消费者提供酒店、 机票及旅行团购产品等预订服务。";
    [self.view addSubview:despLabel];
    [despLabel release];
    
    //add noteLabel
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-40, SCREEN_WIDTH, 30)];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.text = @"订酒店，用艺龙";
    noteLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    noteLabel.font = FONT_B15;
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noteLabel];
    [noteLabel release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
