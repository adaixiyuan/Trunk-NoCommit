//
//  RentCarJourneyInfoCell.h
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "LineCell.h"
#import "RentOrderDetailModel.h"

@interface RentCarJourneyInfoCell : UITableViewCell

@property(nonatomic,retain)RentOrderDetailModel *orderDetailModel;

@property(nonatomic,retain)IBOutlet UIImageView *tipImageView;
@property(nonatomic,retain)IBOutlet UILabel *tipLable;  // 填写的标题
@property(nonatomic,retain)IBOutlet UILabel *realContentLabel;  //内容

@property(nonatomic,retain)UIImageView * topLineImgView;

@property(nonatomic,retain)UIImageView * bottomLineImgView;


@end
