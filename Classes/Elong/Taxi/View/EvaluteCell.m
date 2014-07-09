//
//  EvaluteCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "EvaluteCell.h"
#import "UIViewExt.h"
#import "AttributedLabel.h"
#import "TaxiFillManager.h"
static NSMutableArray  *labelAr = nil;
@implementation EvaluteCell
@synthesize spread;
- (void)dealloc
{
    [_model release];
    [_priceLabel release];
    [_distanceLabel release];
    [_menLabel release];
    [_bgView release];
    [_arrowImage release];
    [_meanLabel release];
    [_bolangImgaV release];
    [super dealloc];
}
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
    [super  awakeFromNib];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)layoutSubviews
{
    [super  layoutSubviews];
    
    if (self.model)
    {
        self.priceLabel.text =   [NSString  stringWithFormat:@"%@",self.model.estimatedPrice] ;
        CGSize  size = [self.priceLabel.text  sizeWithFont:[UIFont boldSystemFontOfSize:23] constrainedToSize:CGSizeMake(10000, 20)];
        
        self.priceLabel.width = size.width;
        
        self.priceLabel.right = self.distanceLabel.right;
        
        self.meanLabel.right = self.priceLabel.left;
        
        if ([TaxiFillManager shareInstance].hasDestination) {
            self.distanceLabel.text = [NSString stringWithFormat:@"预估行驶%@公里，%d分钟",self.model.estimatedDistance ,[self.model.estimatedTime   intValue]/60] ;
           
            
          
        }else{
            self.menLabel.hidden = YES;
            self.distanceLabel.text = @"填写完整用车信息，即可预估车费";
        }
        
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    
   
    
}

- (void)setModel:(EvaluteModel *)model
{
    if (_model !=  model)
    {
        [_model  release];
        _model = [model  retain];
        //根据model决定有几个项目
        //中间的大空隙
        float  middleWidth = self.width - LABELWIDTH*2 - INTERVAL*2;
        //NSArray  *ar = self.model.estimatedAmountDetail;
        NSArray *ar = model.estimatedAmountDetail;
        int i ;
        
        if (_model)
        {
            
            labelAr = [NSMutableArray  arrayWithCapacity:ar.count];
            for ( i = 0; i <ar.count ; i ++)
            {
                
                UIView  *labelView = [[UIView  alloc]initWithFrame:CGRectMake( INTERVAL+INTERVAL*(i%2)+ middleWidth *(i%2) ,self.distanceLabel.bottom + 5*(i/2) + 20*(i/2) + 32, LABELWIDTH, LABELHEIGHT)];
        
                
                labelView.width = LABELWIDTH;
                
                labelView.top = self.distanceLabel.bottom + 5*(i/2+ 1) + LABELHEIGHT*(i/2)+ 32;
                //有两个label。每个label长度
                //
                UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,labelView.width*3/4/2, labelView.height)];
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor  clearColor];
                UILabel  *feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelView.width*3/4/2, label.height)];
                feeLabel.backgroundColor = [UIColor clearColor];
                feeLabel.textAlignment = NSTextAlignmentRight;
                //label.textColor =[UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
                label.textColor = [UIColor  darkGrayColor];
                label.font  = [UIFont  systemFontOfSize:13];
                feeLabel.textColor = [UIColor  blackColor];
                feeLabel.font = label.font;
                if (i %2 == 0)
                {
                    labelView.left = INTERVAL;
                    // feeLabel.left = label.left + label.width+labelView.width/8;
                    feeLabel.left = label.left + label.width-20;
                    
                    
                }else
                {
                    labelView.right = SCREEN_WIDTH-20 ;
                    label.left = 60;
//                    label.left =  labelView.width/8;
                    feeLabel.right = labelView.width;
                   
                }
                
                
                
                // label.backgroundColor = [UIColor  clearColor];
                NSDictionary  *dic  =[ar  objectAtIndex:i];
                label.text = [NSString stringWithFormat:@"%@",[dic  objectForKey:@"estimatedAmountType"]];
                
                if (![[dic objectForKey:@"estimatedFee"] isEqualToString:@"-"])
                {
                    
                    feeLabel.text =  [NSString  stringWithFormat:@"%@元",[dic objectForKey:@"estimatedFee"]];
                    
                    
                }else
                {
                    feeLabel.text =  [NSString  stringWithFormat:@"%@",[dic objectForKey:@"estimatedFee"]];
                }
                //                [label  setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:label.text.length];
                //                [label  setFont:[UIFont  systemFontOfSize:13] fromIndex:0 length:label.text.length];
                //                [label  setColor:[UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1]  fromIndex: 0 length:lenthType];
                [self.bgView  addSubview:labelView];
                [labelView  addSubview:feeLabel];
                [labelView  addSubview:label];
                [feeLabel release];
                [label  release];
                [labelView  release];
                
            }
            
            
        }
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (IBAction)isSpread:(id)sender
{
       spread = !spread;
   
    self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
    
    if (spread)
    {
        [(( UIButton  *)sender)  setTitle:@"   收起" forState:UIControlStateNormal];

    }else
    {
        [(( UIButton  *)sender)  setTitle:@"   展开" forState:UIControlStateNormal];
    }
    if ([self.delegate  respondsToSelector:@selector(spreadAction:) ])
    {
        [self.delegate spreadAction:spread];
    }
    
}
@end
