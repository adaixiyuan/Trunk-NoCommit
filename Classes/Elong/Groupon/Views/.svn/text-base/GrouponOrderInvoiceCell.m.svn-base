//
//  GrouponOrderInvoiceCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponOrderInvoiceCell.h"

#define GridHeight 45

@implementation GrouponOrderInvoiceCell
@synthesize isNeedVoiceChecked;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        
        bgSwichViewBg=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SCALE, SCREEN_WIDTH, GridHeight)];
        bgSwichViewBg.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:bgSwichViewBg];
        [bgSwichViewBg release];
        
        // 单价
        UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, GridHeight)];
        priceTipsLbl.textColor = [UIColor blackColor];
        priceTipsLbl.backgroundColor = [UIColor clearColor];
        priceTipsLbl.font = [UIFont systemFontOfSize:16.0f];
        [bgSwichViewBg addSubview:priceTipsLbl];
        [priceTipsLbl release];
        priceTipsLbl.text = @"需要发票";
        priceTipsLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        
        if (IOSVersion_6) {
            faPiaoSwitch = [[MBSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 50, 7, 50, GridHeight)];
        }
        else if (IOSVersion_4 && !IOSVersion_5) {
            faPiaoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 93, 7, 50, GridHeight)];
        }
        else
        {
            faPiaoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 78, 9, 50, GridHeight)];
        }
        
        [bgSwichViewBg addSubview:faPiaoSwitch];
        [faPiaoSwitch addTarget:self action:@selector(faPiaoSwitchClick:) forControlEvents:UIControlEventValueChanged];
        [faPiaoSwitch release];
        
        UIImageView *splitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        splitView.frame = CGRectMake(0, GridHeight - SCREEN_SCALE-1, SCREEN_WIDTH, SCREEN_SCALE);
        splitView.contentMode=UIViewContentModeScaleToFill;
        [bgSwichViewBg addSubview:splitView];
        [splitView release];
        
    }
    return self;
}

//发票显示
-(void) faPiaoSwitchClick:(id) sender
{
    if ([delegate respondsToSelector:@selector(orderInvoiceCell:invoiceChoised:)])
    {
        if ([faPiaoSwitch isMemberOfClass:[MBSwitch class]])
        {
            MBSwitch *mb=(MBSwitch *)faPiaoSwitch;
            [delegate orderInvoiceCell:self invoiceChoised:mb.on];
        }
        else if ([faPiaoSwitch isMemberOfClass:[UISwitch class]])
        {
            UISwitch *us=(UISwitch *)faPiaoSwitch;
            [delegate orderInvoiceCell:self invoiceChoised:us.on];
        }
    }
}

//是否艺龙开发票
-(void) setPaPiaoState:(BOOL) isElongFaPiao
{
    if (isElongFaPiao)
    {
        bgSwichViewBg.hidden=NO;
    }
    else
    {
        bgSwichViewBg.hidden=YES;
    }
}

@end
