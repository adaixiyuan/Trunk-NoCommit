//
//  UseTaxiCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UseTaxiCell.h"
#import "TaxiFillManager.h"

@implementation UseTaxiCell

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
    self.carBrandName.adjustsFontSizeToFitWidth = YES;
    self.dislLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)  layoutSubviews
{
    [super layoutSubviews];
    self.carTypeName.text = self.taxiTypeModel.carTypeName;
    self.carPrice.text =  [NSString  stringWithFormat:@"%@",self.taxiTypeModel.fee  ] ;
    
    CGSize  size = [self.carPrice.text  sizeWithFont:[UIFont boldSystemFontOfSize:23] constrainedToSize:CGSizeMake(10000, 32)];
    
    self.carPrice.width = size.width;
    
    self.carPrice.right = self.dislLabel.right;
    
    self.meanLabel.right = self.carPrice.left;
    
    self.carBrandName.text = self.taxiTypeModel.carTypeBrand;
    
    self.dislLabel.text =
    
    [NSString  stringWithFormat:@"(含%d小时,%d公里)",[self.taxiTypeModel.timeLength  intValue],[self.taxiTypeModel.distance  intValue]];
    
    self.dislLabel.textAlignment = NSTextAlignmentRight;
    
    self.aboardPositon.text = [TaxiFillManager shareInstance].evalueRqModel.fromAddress;
    
     self.getOffPositon.text = ([TaxiFillManager shareInstance].hasDestination)?[TaxiFillManager shareInstance].evalueRqModel.toAddress:@"暂无";
    //自适应
    
    [self  fitLabel:self.aboardPositon.text andLabel:self.aboardPositon];
    
    [self  fitLabel:self.getOffPositon.text andLabel:self.getOffPositon];
    
    UIImageView  *bottomLineView1  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    [self.bgView  addSubview:bottomLineView1];
    bottomLineView1.image = [UIImage  noCacheImageNamed:@"dashed.png"];
    [bottomLineView1  release];

    
    self.useTime.text = [TaxiFillManager shareInstance].evalueRqModel.startTime;
}

- (void)fitLabel:(NSString *)text andLabel:(UILabel  *)label
{
    
    CGSize  size = [text  sizeWithFont:self.aboardPositon.font constrainedToSize:CGSizeMake(label.width, 1000)];
   
    float singal = 17.0;
    if (size.height>singal*2 )
    {
        label.height= singal*2;
        label.adjustsFontSizeToFitWidth = YES;
    }else
    {
        label.height = size.height;
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_carTypeName release];
    [_carBrandName release];
    [_carPrice release];
    [_aboardPositon release];
    [_getOffPositon release];
    [_useTime release];
    [_dislLabel release];
    [_bgView release];
    [super dealloc];
}
@end
