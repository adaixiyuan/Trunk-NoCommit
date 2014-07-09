//
//  XGMapInfoCell.h
//  ElongClient
//
//  Created by 李程 on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MapActionBlock)(void);

@interface XGMapInfoCell : UITableViewCell

@property(nonatomic,strong)MapActionBlock mapActionBlock;

@property(nonatomic,strong)UIImageView * topLineImgView;

@property(nonatomic,strong)UIImageView * bottomLineImgView;

@property(nonatomic,strong)NSDictionary *hoteldetailDict;

@end
