//
//  FlightOnlineViewController.m
//  ElongClient
//
//  Created by Will Lucky on 13-1-11.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DragonVIP.h"
#import "MyElongCenter.h"
@implementation DragonVIP

- (id)initWithLongCui:(BOOL)isVIP {
    if (isVIP) {
        if (self = [super initWithTopImagePath:@"" andTitle:@"龙萃会员权益介绍" style:_NavOnlyBackBtnStyle_])
        {
            
            [self addmidview];

            UIImageView *Longcuisignright = [[UIImageView alloc] initWithFrame:CGRectMake(180, 38, 21, 13)];
            [Longcuisignright setImage:[UIImage imageNamed:@"Longcuisignleft.png"]];
            [self.view addSubview:Longcuisignright];
            [Longcuisignright release];
            
            UILabel *labelone = [[UILabel alloc] initWithFrame:CGRectMake(44, 32, 140, 20)];
            labelone.text = @"尊贵的龙萃会员";
            labelone.backgroundColor = [UIColor clearColor];
            labelone.font = [UIFont systemFontOfSize:18];
            labelone.textAlignment = NSTextAlignmentCenter;
            labelone.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
            [self.view addSubview:labelone];
            [labelone release];
            
            
            UILabel *labeltwo = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, 220, 30)];
            labeltwo.text = @"您好！请了解您的专享权益:";
            labeltwo.backgroundColor = [UIColor clearColor];
            labeltwo.font = [UIFont systemFontOfSize:14];
            labeltwo.textAlignment = NSTextAlignmentLeft;
            labeltwo.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
            [self.view addSubview:labeltwo];
            [labeltwo release];
        }
        return self;
    }
    else {
        if (self = [super initWithTopImagePath:@"" andTitle:@"邀请加入龙萃计划" style:_NavOnlyBackBtnStyle_])
        {
            
            [self addmidview];

            UIImageView *Longcuisignright = [[UIImageView alloc] initWithFrame:CGRectMake(275, 38, 21, 13)];
            [Longcuisignright setImage:[UIImage imageNamed:@"Longcuisignleft.png"]];
            [self.view addSubview:Longcuisignright];
            [Longcuisignright release];
            
            UILabel *labelone = [[UILabel alloc] initWithFrame:CGRectMake(44, 32, 230, 20)];
            labelone.text = @"龙萃会员:艺龙最尊贵、最高级别会员";
            labelone.backgroundColor = [UIColor clearColor];
            labelone.font = [UIFont systemFontOfSize:14];
            labelone.textAlignment = NSTextAlignmentCenter;
            labelone.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
            [self.view addSubview:labelone];
            [labelone release];
            
            
            UILabel *labeltwo = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, 220, 30)];
            labeltwo.text = @"龙萃会员专享权益:";
            labeltwo.backgroundColor = [UIColor clearColor];
            labeltwo.font = [UIFont systemFontOfSize:14];
            labeltwo.textAlignment = NSTextAlignmentLeft;
            labeltwo.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
            [self.view addSubview:labeltwo];
            [labeltwo release];
            
            
            
            UILabel *labelsix = [[UILabel alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-85, 320, 30)];
            labelsix.text = @"如何开启龙萃之旅";
            labelsix.backgroundColor = [UIColor clearColor];
            labelsix.font = [UIFont boldSystemFontOfSize:16];
            labelsix.textAlignment = NSTextAlignmentCenter;
            labelsix.textColor = [UIColor colorWithRed:58/255.0 green:178/255.0 blue:105/255.0 alpha:1.0];
            [self.view addSubview:labelsix];
            [labelsix release];

            UILabel *labelseven = [[UILabel alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-57, 320, 30)];
            labelseven.text = @"订购四星以上酒店(每间每夜≥400元)";
            labelseven.backgroundColor = [UIColor clearColor];
            labelseven.font = [UIFont systemFontOfSize:14];
            labelseven.textAlignment = NSTextAlignmentCenter;
            labelseven.textColor = [UIColor colorWithRed:58/255.0 green:178/255.0 blue:105/255.0 alpha:1.0];
            [self.view addSubview:labelseven];
            [labelseven release];

            UILabel *labeleig = [[UILabel alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-37, 320, 30)];
            labeleig.text = @"您将在2周内受邀成为龙萃会员";
            labeleig.backgroundColor = [UIColor clearColor];
            labeleig.font = [UIFont systemFontOfSize:14];
            labeleig.textAlignment = NSTextAlignmentCenter;
            labeleig.textColor = [UIColor colorWithRed:58/255.0 green:178/255.0 blue:105/255.0 alpha:1.0];
            [self.view addSubview:labeleig];
            [labeleig release];

        }
        return self;
    }
}

- (void)setvip:(BOOL)isVIP
{
    
}

- (void) addmidview
{
    int highplus  = 0;
    if (SCREEN_4_INCH) 
        highplus = 0;
    else
        highplus = -25;
    UIImage *bgImage = [UIImage imageNamed:@"Longcuiback.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];

    UIImageView *Longcuitop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 320, 8)];
    [Longcuitop setImage:[UIImage imageNamed:@"Longcuitop.png"]];
    [self.view addSubview:Longcuitop];
    [Longcuitop release];
    
    UIImageView *Longcuimid = [[UIImageView alloc] initWithFrame:CGRectMake(0, 24, 320, MAINCONTENTHEIGHT-172)];
    [Longcuimid setImage:[UIImage stretchableImageWithPath:@"Longcuimid.png"]];
    [self.view addSubview:Longcuimid];
    [Longcuimid release];
    
    UIImageView *Longcuibot = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-164, 320, 164)];
    [Longcuibot setImage:[UIImage imageNamed:@"Longcuibot.png"]];
    [self.view addSubview:Longcuibot];
    [Longcuibot release];

    UIImageView *Longcuisignleft = [[UIImageView alloc] initWithFrame:CGRectMake(23, 38, 21, 13)];
    [Longcuisignleft setImage:[UIImage imageNamed:@"Longcuisignright.png"]];
    [self.view addSubview:Longcuisignleft];
    [Longcuisignleft release];

    UIImageView *Longcuilline0 = [[UIImageView alloc] initWithFrame:CGRectMake(23, 60, 274, 1)];
    [Longcuilline0 setImage:[UIImage imageNamed:@"Longcuiline0.png"]];
    [self.view addSubview:Longcuilline0];
    [Longcuilline0 release];

    
    UILabel *labeltre = [[UILabel alloc] initWithFrame:CGRectMake(115, 132+highplus, 220, 30)];
    labeltre.text = @"更优价格 免费升房";
    labeltre.backgroundColor = [UIColor clearColor];
    labeltre.font = [UIFont boldSystemFontOfSize:16];
    labeltre.textAlignment = NSTextAlignmentLeft;
    labeltre.textColor = [UIColor blackColor];
    [self.view addSubview:labeltre];
    [labeltre release];
    
    UILabel *labeltreex = [[UILabel alloc] initWithFrame:CGRectMake(150, 160+highplus, 220, 30)];
    labeltreex.text = @"指定房间";
    labeltreex.backgroundColor = [UIColor clearColor];
    labeltreex.font = [UIFont systemFontOfSize:16];
    labeltreex.textAlignment = NSTextAlignmentLeft;
    labeltreex.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
    [self.view addSubview:labeltreex];
    [labeltreex release];
    
    UIImageView *Longcuilline1 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 140+highplus, 165, 21)];
    [Longcuilline1 setImage:[UIImage imageNamed:@"Longcuiline1.png"]];
    [self.view addSubview:Longcuilline1];
    [Longcuilline1 release];
    
    
    UILabel *labelfor = [[UILabel alloc] initWithFrame:CGRectMake(88, 200+highplus, 220, 30)];
    labelfor.text = @"专组客服 直线人工服务";
    labelfor.backgroundColor = [UIColor clearColor];
    labelfor.font = [UIFont boldSystemFontOfSize:16];
    labelfor.textAlignment = NSTextAlignmentLeft;
    labelfor.textColor = [UIColor blackColor];
    [self.view addSubview:labelfor];
    [labelfor release];
    
    UILabel *labelforex = [[UILabel alloc] initWithFrame:CGRectMake(150, 225+highplus, 220, 30)];
    labelforex.text = @"龙萃专组";
    labelforex.backgroundColor = [UIColor clearColor];
    labelforex.font = [UIFont systemFontOfSize:16];
    labelforex.textAlignment = NSTextAlignmentLeft;
    labelforex.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
    [self.view addSubview:labelforex];
    [labelforex release];
    
    UIImageView *Longcuilline2 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 210+highplus, 194, 20)];
    [Longcuilline2 setImage:[UIImage imageNamed:@"Longcuiline3.png"]];
    [self.view addSubview:Longcuilline2];
    [Longcuilline2 release];
    
    UILabel *labelfiv = [[UILabel alloc] initWithFrame:CGRectMake(150, 272+highplus, 220, 30)];
    labelfiv.text = @"订单双倍积分";
    labelfiv.backgroundColor = [UIColor clearColor];
    labelfiv.font = [UIFont boldSystemFontOfSize:16];
    labelfiv.textAlignment = NSTextAlignmentLeft;
    labelfiv.textColor = [UIColor blackColor];
    [self.view addSubview:labelfiv];
    [labelfiv release];
    
    
    UIImageView *Longcuilline3 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 280+highplus, 128, 20)];
    [Longcuilline3 setImage:[UIImage imageNamed:@"Longcuiline2.png"]];
    [self.view addSubview:Longcuilline3];
    [Longcuilline3 release];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)back:(int)_index
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [super dealloc];
}
@end
