//
//  ScenicListCell.m
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicListCell.h"
#import "RoundCornerView+WebCache.h"

@implementation ScenicListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.listImageV.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void) awakeFromNib
{
    [super  awakeFromNib];
    self.listImageV.fillColor = [UIColor  whiteColor];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listImageV  setImageWithURL:[NSURL  URLWithString:[NSString  stringWithFormat:@"%@",self.model.imgPath]]];
   
    self.scenicNameLabel.text = self.model.sceneryName;
    self.scoreLabel.text =[NSString  stringWithFormat:@"%@",self.model.score];
    self.themeLabel.text = self.model.scenerySummary;
    self.starLabel.text = self.model.gradeName;
    self.priceLabel.text = self.model.elongPrice;
    self.originalPrice.text = self.model.price;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_listImageV release];
    [_model release];
    [_themeLabel release];
    [_scenicNameLabel  release];
    [_scoreLabel release];
    [_starLabel release];
    [_priceLabel release];
    [_originalPrice release];
    [super dealloc];
}
@end
