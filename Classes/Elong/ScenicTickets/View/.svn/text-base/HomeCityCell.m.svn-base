//
//  HomeCityCell.m
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HomeCityCell.h"
#import "HotScenicView.h"
#import "HotScenicButton.h"
#import "HotModel.h"
#import "ScenicListViewController.h"
#import "ScenicTicketsPublic.h"
#import "JScenicListRequest.h"
#import "SceneryList.h"

@implementation HomeCityCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
    }
    return self;
}


- (void)awakeFromNib
{
    [super  awakeFromNib];
    
    vertical = 3;
    horizontal = 3;
    
        self.selectionStyle  =UITableViewCellSelectionStyleNone;
}

- (void)setModelAr:(NSArray *)modelAr
{
    if (_modelAr != modelAr) {
        [_modelAr  release];
        _modelAr = [modelAr retain];
    }
    if (!cityView)
    {
        cityView = [[UIView alloc]initWithFrame:CGRectMake(self.nearImageV.right+10, self.nearImageV.top, SCREEN_WIDTH-self.nearImageV.right - 10-10, self.nearImageV.height )];//计算
        float  width = (cityView.width- (horizontal-1)*HInterval)/horizontal;
        float   height = (cityView.height - (vertical - 1)*VInterVal)/vertical;
        
        [self.contentView  addSubview:cityView];
        for (int  i = 0;i < vertical;i ++ )
        {
            for (int  j = 0 ;j < horizontal;j ++)
            {
                HotScenicButton  *button = [[HotScenicButton alloc]initWithFrame:CGRectMake(j*HInterval + j*width, i*height + i*VInterVal, width, height)];
                if (j + i*horizontal <= self.textAr.count)
                {
                    button.bText = [self.textAr  safeObjectAtIndex:j + i *horizontal ];
                }
                button.delegate = delegate;
               
                button.myBlock = ^(HotScenicButton  *button,int i)
                {
                };
                button.tag = 100 + j + i*horizontal ;//竖排的个数乘以横排的总个数
                [cityView  addSubview:button];
                [button release];
            }
        }

    }
   
}


- (void)setDelegate:(id)dele
{
    delegate = dele;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_nearImageV release];
    [cityView  release];
    [_textAr  release];
    [super dealloc];
}
@end
