//
//  HotelOrderFlowCell.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelOrderFlowCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UIImageView *verticalLineImgView;      //竖线
@property(nonatomic,retain) IBOutlet UIImageView *roundIconImgView;     //圆图标
@property(nonatomic,retain) IBOutlet UILabel *timeLabel;        //时间点
@property(nonatomic,retain) IBOutlet UILabel *contentLabel; //内容

-(void)grayStyle;       //灰色风格
-(void)blueStye;        //蓝色风格

@end
