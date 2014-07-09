//
//  TaxiTypeCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiTypeCell.h"
#import "UIImageView+WebCache.h"

@implementation TaxiTypeCell

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
     self.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIImageView  *topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
//    topLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
//    [self.contentView  addSubview:topLineView];
//    [topLineView release];
//
    
    UIImageView  *bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
    [self.contentView  addSubview:bottomLineView];
    [bottomLineView  release];
    
    self.carPrice.adjustsFontSizeToFitWidth = YES;
}

- (void)layoutSubviews
{
    [super  layoutSubviews];
    if (self.model)
    {
        self.carTypeName.text = self.model.carTypeName;
        self.carBrandName.text = [NSString  stringWithFormat:@"%@等",self.model.carTypeBrand];
        self.timeAndDistance.text = [NSString  stringWithFormat:@"含%@，%@",self.model.distance,self.model.timeLength];
        NSURL  *url = [NSURL  URLWithString:self.model.carPic];
        
        [self.picImageV  setImageWithURL:url placeholderImage:[UIImage  imageNamed:@"bg_nohotelpic"] options:SDWebImageCacheMemoryOnly ];
        
        self.carPrice.text =   [NSString  stringWithFormat:@"¥ %d",[self.model.fee intValue]] ;

    }
     self.picImageV.layer.cornerRadius = 3;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [_model release];
    [_picImageV release];
    [_carTypeName release];
    [_carBrandName release];
    [_timeAndDistance release];
    [_carPrice release];
    [super dealloc];
}
@end
