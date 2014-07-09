//
//  TaxiInvoceCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiInvoceCell.h"
#import "MBSwitch.h"

@implementation TaxiInvoceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
        self.contentView.backgroundColor = [UIColor whiteColor];
        if (IOSVersion_6)
        {

            MBSwitch *invoiceSwitchBtn = [[MBSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (44-30) / 2, 50, 30)];
           // invoiceSwitchBtn.on = YES;
            invoiceSwitchBtn.tag = 1011;
            [self.contentView addSubview:invoiceSwitchBtn];
          
            [invoiceSwitchBtn addTarget:self action:@selector(invoiceSwitchBtnClick) forControlEvents:UIControlEventValueChanged];
              [invoiceSwitchBtn release];
        }
        else{
            // IOS4系统使用系统自带的控件
            UISwitch *invoiceSwitchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(211, (44-28) / 2, 70, 33)];
            //invoiceSwitchBtn.on = NO;
            invoiceSwitchBtn.tag = 1011;
            //rinvoiceSwitchBtn.on = needInvoice;
            [self.contentView addSubview:invoiceSwitchBtn];
            [invoiceSwitchBtn release];
            [invoiceSwitchBtn addTarget:self action:@selector(invoiceSwitchBtnClick) forControlEvents:UIControlEventValueChanged];
           
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setNeedInvoice:(BOOL)needInvoice
{
    if (needInvoice!= _needInvoice)
    {
        _needInvoice = needInvoice;
    }
    if (IOSVersion_6)
    {
        MBSwitch  *swith = (MBSwitch  *)[self.contentView  viewWithTag:1011];
        swith.on = needInvoice;
        
    }
    else if (IOSVersion_4)
    {
        UISwitch *swith = (UISwitch  *)[self.contentView  viewWithTag:1011];
        swith.on = needInvoice;
    }
    
}
- (void)invoiceSwitchBtnClick
{
 
    if ([self.delegate  respondsToSelector:@selector(chooseInvoceAction:)])
    {
        [self.delegate  chooseInvoceAction:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
