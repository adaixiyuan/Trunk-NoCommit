//
//  ScenicOrderHeaderCell.h
//  ElongClient
//
//  Created by jian.zhao on 14-5-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdjustHeaderHeightDelegate <NSObject>

-(void)ajustTheHeaderCellHeight:(CGFloat)height andFlag:(BOOL)yes;

@end

@class ScenicPrice;
@interface ScenicOrderHeaderCell : UITableViewCell{

    BOOL show;//是否展开显示，默认NO
}

@property(nonatomic,assign) id<AdjustHeaderHeightDelegate>delegate;
@property (retain, nonatomic) IBOutlet UILabel *ticketName;
@property (retain, nonatomic) IBOutlet UILabel *payType;
@property (retain, nonatomic) IBOutlet UILabel *ticketInro;
@property (retain, nonatomic) IBOutlet UIButton *tapBtn;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImage;

-(void)setPriceDetail:(ScenicPrice *)priceDetail andHeight:(CGFloat)height andFlag:(BOOL)yes;

@end
