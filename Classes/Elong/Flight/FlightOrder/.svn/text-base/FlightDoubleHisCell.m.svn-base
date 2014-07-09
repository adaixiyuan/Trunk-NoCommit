//
//  FlightDoubleHisCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightDoubleHisCell.h"

@implementation FlightDoubleHisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:self.bounds];
    selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
    self.selectedBackgroundView  = selectedBgView;
    [selectedBgView release];
    
    self.priceLabel.textColor = RGBACOLOR(254, 75, 32, 1);
  
    _cellGoView = [[[NSBundle  mainBundle]loadNibNamed:@"FlightOderView" owner:self options:nil]lastObject];
    _cellGoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    [self.contentView  addSubview:_cellGoView];
    
    _cellComeView = [[[NSBundle  mainBundle]loadNibNamed:@"FlightOderView" owner:self options:nil]lastObject];
    _cellComeView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 80);
    [self.contentView addSubview:_cellComeView];
//    [self.contentView  bringSubviewToFront:self.priceLabel];
//    [self.contentView  bringSubviewToFront:self.noPayLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTacketModel:(FlightOrderInfoModel *)tacketModel
{
     self.noPayLabel.hidden = YES;
    
    if (_tacketModel  !=  tacketModel)
    {
        [_tacketModel  release];
        _tacketModel = [tacketModel retain];
    }
    NSArray  *ar = _tacketModel.AirLineInfos;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.tacketModel.TotalPrice  floatValue]] ;
   
    if ([self.tacketModel.IsAllowContinuePay  boolValue])
    {
        self.noPayLabel.hidden = NO;
    }

    for(int i = 0;i < ar.count;i ++)
    {
        AirlineInfoModel  *model = [[AirlineInfoModel  alloc]initWithDataDic:[ar  objectAtIndex:i]];
        if (i == 0)
        {
            self.cellGoView.model = model;
        }
        else  if (i == 1)
        {
            self.cellComeView.model = model;
        }
        [model release];
        
    }
    
    
    
}

- (void)dealloc {
  
    [_doubleAr release];
    [_tacketModel  release];
   
    [_priceLabel release];

    [_noPayLabel release];
    [super dealloc];
}
@end
