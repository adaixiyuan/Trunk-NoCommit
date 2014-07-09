//
//  EvaluteCell.h
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluteModel.h"
#import "LineCell.h"
#import "AttributedLabel.h"
#define LABELWIDTH  145
#define INTERVAL   15
#define LABELHEIGHT  20
@protocol SPreadDelegate <NSObject>

- (void)spreadAction:(BOOL) flag ;

@end

@interface EvaluteCell :UITableViewCell
{
    BOOL  spread;
}
@property (nonatomic,assign) BOOL spread;
@property  (nonatomic,retain)EvaluteModel *model;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *menLabel;
- (IBAction)isSpread:(id)sender;
@property (nonatomic,assign) id< SPreadDelegate > delegate;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImage;
@property (retain, nonatomic) IBOutlet UILabel *meanLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bolangImgaV;
@end

