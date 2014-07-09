//
//  TaxiListCell.m
//  ElongClient
//
//  Created by nieyun on 14-1-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiListCell.h"

@implementation TaxiListCell

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

    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
}
- (void) layoutSubviews
{
    [super layoutSubviews];
      
    self.taxiLabel.text = self.model.orderTitle;

    if (![self.model.fromAddress isEqual:[NSNull  null]])
    {
         self.startLabel.text = self.model.fromAddress;
    }
    if (![self.model.toAddress  isEqual:[NSNull  null]]) {
        self.endLabel.text = self.model.toAddress;
    }
    
    self.orderTimeLabel.text = self.model.useTime;
    self.stateLabel.text = self.model.orderStatusDesc;
}

- (NSString  *)  checkTime:(NSString  *) str  andMutableStr:(NSMutableString *)mStr
{
    NSRange range = [mStr  rangeOfString:@" "];
    NSLog(@"%d",range.location);
    if (range.location != NSNotFound)
    {
        NSRange  range2 = NSMakeRange(range.location , mStr.length - range.location);
        
        [mStr  deleteCharactersInRange:range2];
    }
    return (NSString *) mStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_taxiLabel release];
    [_orderTimeLabel release];
    [_stateLabel release];
    [_model  release];
    [_startLabel release];
    [_endLabel release];
    [super dealloc];
}
@end
