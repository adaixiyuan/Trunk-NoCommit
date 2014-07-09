//
//  PhoneHeadView.m
//  ElongClient
//
//  Created by nieyun on 14-6-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PhoneHeadView.h"
#import "PhoneListCtrl.h"

@implementation PhoneHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
      
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_hotelNameLabel release];
    [_roomLabel release];
    [super dealloc];
}
@end
