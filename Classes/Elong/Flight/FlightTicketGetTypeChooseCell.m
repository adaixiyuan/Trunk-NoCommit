//
//  FlightTicketGetTypeChooseCell.m
//  ElongClient
//
//  Created by 赵 海波 on 14-1-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightTicketGetTypeChooseCell.h"

@implementation FlightTicketGetTypeChooseCell

- (void)dealloc {
    
    
    SFRelease(_selfGetButton);
    SFRelease(_selfGetIcon);
    SFRelease(_selfGetLabel);
    SFRelease(_invoiceTipLabel);
    SFRelease(_invoiceContent);
    SFRelease(_postIcon);
    SFRelease(_postLabel);
    
    [super dealloc];
}



+ (id)cellFromNib
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlightTicketGetTypeChooseCell" owner:self options:nil];
    
    FlightTicketGetTypeChooseCell *cell = nil;
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[FlightTicketGetTypeChooseCell class]])
        {
            cell = (FlightTicketGetTypeChooseCell *)oneObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}


- (IBAction)clickPostBtn
{
    if (!_postIcon.highlighted)
    {
        [_root clickPostButton];
        
        _selfGetIcon.image = [UIImage imageNamed:@"btn_checkbox.png"];
        _postIcon.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    }
}


- (IBAction)clickSelfGetBtn
{
    if (!_selfGetIcon.highlighted)
    {
        [_root clickSelfGetButton];
        
        _postIcon.image = [UIImage imageNamed:@"btn_checkbox.png"];
        _selfGetIcon.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    }
}


- (void)startLoading
{
    if (!coverView)
    {
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 2)];
        coverView.backgroundColor = [UIColor whiteColor];
        [self addSubview:coverView];
    }
    
    coverView.hidden = NO;
    [coverView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
}


- (void)endLoading
{
    coverView.hidden = YES;
    [coverView endLoading];
}

@end
