//
//  GrouponPackageCell.m
//  ElongClient
//  团购打包的cell
//  Created by garin on 14-2-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponPackageCell.h"

@implementation GrouponPackageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 背景色
        
        float cellHeight = 60;
        
        UIView *bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        UIImageView *downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, cellHeight-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
        
        // 右侧指示箭头
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 9-5, cellHeight/2 - 4.5 , 5, 9)];
        arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [bgImageView addSubview:arrowView];
        [arrowView release];
        
        //房型名字
        roomName = [[UILabel alloc] initWithFrame:CGRectMake(8, 13, 232, 35)];
        roomName.backgroundColor = [UIColor clearColor];
        roomName.font = [UIFont systemFontOfSize:16];
        roomName.textColor = RGBACOLOR(52, 52, 52, 1);
        [bgImageView addSubview:roomName];
        [roomName release];
        
        //团购卖价
        moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 9-5-42, cellHeight/2 - 10, 40, 20)];
        moneyLbl.backgroundColor=[UIColor clearColor];
        moneyLbl.font = [UIFont boldSystemFontOfSize:23.0f];
        moneyLbl.adjustsFontSizeToFitWidth = YES;
        moneyLbl.textAlignment = NSTextAlignmentLeft;
        moneyLbl.minimumFontSize = 14.0f;
        moneyLbl.textColor =  RGBACOLOR(254, 75, 32, 1);
        [bgImageView addSubview:moneyLbl];
        [moneyLbl release];
        
        currencyLbl = [[UILabel alloc] initWithFrame:CGRectMake(moneyLbl.frame.origin.x-3-8, moneyLbl.frame.origin.y+3, 10, 20)];
        currencyLbl.backgroundColor = [UIColor clearColor];
        currencyLbl.text = @"¥";
        currencyLbl.font = [UIFont systemFontOfSize:13.0f];
        currencyLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        currencyLbl.textAlignment=NSTextAlignmentLeft;
        [bgImageView addSubview:currencyLbl];
        [currencyLbl release];
    }
    return self;
}

-(void) setShowPrice:(NSString *) price
{
//    price=@"30000";
    if (STRINGHASVALUE(price))
    {
        moneyLbl.text=price;
        currencyLbl.hidden=NO;
    }
    else
    {
        moneyLbl.text=@"";
        currencyLbl.hidden=YES;
    }
}

-(void) setRoomName:(NSString *) rName
{
    roomName.text=rName;
}

-(void) setUpSplitHidden:(BOOL) hidden
{
    upSplitView.hidden=hidden;
}
@end
