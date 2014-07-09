//
//  GrouponOrderPaymentFlowCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderPaymentFlowCell.h"

@interface GrouponOrderPaymentFlowCell ()

@property (nonatomic,retain) UIImageView *lineImgView;
@property (retain, nonatomic) IBOutlet UIImageView *iconImgView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *despLabel;

@end

@implementation GrouponOrderPaymentFlowCell

-(void)dealloc{
    
    [_iconImgView release];
    [_timeLabel release];
    [_despLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    //-------在XIB中不能添加这条线。否则设置frame.width为0.5时会不显示---特注
    _lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 0, SCREEN_SCALE, 50)];
    self.lineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self.contentView addSubview:self.lineImgView];
    [self.contentView sendSubviewToBack:self.lineImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置支付流程信息
-(void)setFlowInfo:(NSArray *)flowArray ofRow:(int)row{
    NSDictionary *flowInfo = [flowArray objectAtIndex:row];
    NSString *operCN = [flowInfo safeObjectForKey:@"OperCN"];     //操作描述
    operCN = [PublicMethods dealWithStringForRemoveSpaces:operCN];
    
    NSString *timeJsonDate = [flowInfo safeObjectForKey:@"OperTime"];//操作时间点
    NSString *operTimeString =[TimeUtils displayDateWithJsonDate:timeJsonDate formatter:@"HH:mm:ss M月d日"];
    
    self.timeLabel.text = operTimeString;    //赋值时间点
    self.despLabel.text = operCN;      //赋值操作描述
    
    float height = [PublicMethods labelHeightWithString:operCN Width:250 font:[UIFont systemFontOfSize:15]];
    //设置contentLabel的高度
    CGRect frame1 = self.despLabel.frame;
    frame1.size.height = height;
    self.despLabel.frame = frame1;
    
    [self grayStyle];      //默认Cell灰色风格
    int cellHeight = 29 + height;    //计算Cell的高度
    if(row==0){
        //第一行，蓝色风格
        [self blueStye];
        //设置Cell的verticalLine的高度
        CGRect frame = self.lineImgView.frame;
        frame.origin.y = self.iconImgView.frame.origin.y;
        frame.size.height = cellHeight -self.iconImgView.frame.origin.y;
        self.lineImgView.frame = frame;
        
        if(flowArray.count==1){
            //仅一条数据时，隐藏竖线
            self.lineImgView.hidden = YES;
        }
    }else if(row==flowArray.count-1){
        //最后一行,设置线的高度
        CGRect frame = self.lineImgView.frame;
        frame.origin.y = 0;
        frame.size.height = self.iconImgView.frame.origin.y+3;
        self.lineImgView.frame = frame;
    }else{
        CGRect frame = self.lineImgView.frame;
        frame.origin.y = 0;
        frame.size.height = cellHeight;
        self.lineImgView.frame = frame;
    }

}

//灰色风格
-(void)grayStyle{
    _timeLabel.textColor = [UIColor grayColor];
    _despLabel.textColor = [UIColor grayColor];
    _iconImgView.image = [UIImage noCacheImageNamed:@"orderFlowGray_ico.png"];
    
}

//蓝色风格
-(void)blueStye{
    _timeLabel.textColor = RGBACOLOR(35, 119,232, 1);
    _despLabel.textColor = RGBACOLOR(35, 119,232, 1);
    _iconImgView.image = [UIImage noCacheImageNamed:@"orderFlowBlue_ico.png"];

}

@end
