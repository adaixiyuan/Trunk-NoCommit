//
//  FlightOrderHisCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOrderHisCell.h"

@implementation FlightOrderHisCell

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
    [super awakeFromNib];
    self.priceLabel.textColor = RGBACOLOR(254, 75, 32, 1);

    
    UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:self.bounds];
    selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
    self.selectedBackgroundView  = selectedBgView;
    [selectedBgView release];
    
    _cellView = [[[NSBundle  mainBundle]loadNibNamed:@"FlightOderView" owner:self options:nil]lastObject];
    
    _cellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
   
    [self.contentView  addSubview:_cellView];
   
    
  
//    [self.contentView bringSubviewToFront:self.priceLabel];
//    [self.contentView  bringSubviewToFront:self.noPayLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    

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
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.tacketModel.TotalPrice  floatValue]];
    
    AirlineInfoModel  *model= [[AirlineInfoModel  alloc]initWithDataDic:[_tacketModel.AirLineInfos   objectAtIndex:0]];
    
    self.cellView.model = model;
    
    if ([self.tacketModel.IsAllowContinuePay  boolValue])
    {
        self.noPayLabel.hidden = NO;
    }

    
    [model release];
    

}
- (void)dealloc
{
  
    [_priceLabel release];
    [_tacketModel release];
    [_noPayLabel release];
    [super dealloc];
}
@end
