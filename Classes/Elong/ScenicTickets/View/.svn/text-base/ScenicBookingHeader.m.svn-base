//
//  ScenicBookingHeader.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicBookingHeader.h"

@implementation ScenicBookingHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor     = [UIColor whiteColor];
        
        _policyName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        _policyName.textAlignment = NSTextAlignmentLeft;
        _policyName.backgroundColor = [UIColor clearColor];
        _policyName.text = @"成人票";
        _policyName.font = FONT_B15;
        [self addSubview:_policyName];
        
        UILabel *rmb = [[UILabel alloc] initWithFrame:CGRectMake(210, 15, 15, 15)];
        rmb.text = @"￥";
        rmb.font = FONT_16;
        rmb.textColor = RGBACOLOR(254, 75, 42, 1);
        rmb.backgroundColor = [UIColor clearColor];
        [self addSubview:rmb];
        [rmb release];
        
        _lowestPrice = [[UILabel alloc] initWithFrame:CGRectMake(rmb.frame.origin.x+rmb.frame.size.width, 10, 40, 20)];
        _lowestPrice.font = FONT_B18;
        _lowestPrice.textColor = RGBACOLOR(254, 75, 42, 1);
        _lowestPrice.text = @"40";
        _lowestPrice.textAlignment = NSTextAlignmentCenter;
        _lowestPrice.adjustsFontSizeToFitWidth = YES;
        _lowestPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:_lowestPrice];
        
        UILabel *qi = [[UILabel alloc] initWithFrame:CGRectMake(_lowestPrice.frame.origin.x+_lowestPrice.bounds.size.width, 15, 15, 15)];
        qi.text = @"起";
        qi.font = FONT_12;
        qi.backgroundColor = [UIColor clearColor];
        qi.textColor = RGBACOLOR(153, 153, 153, 1);
        [self addSubview:qi];
        [qi release];
        
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 20,9,5)];
        _arrow.backgroundColor   = [UIColor clearColor];
        [self addSubview:_arrow];
                
    }
    return self;
}

-(void)refreshTheArrowWithReavel:(BOOL)yes{
    
    if (yes) {
        _arrow.image = [UIImage imageNamed:@"packing_arrow_down.png"];
    }else{
        _arrow.image = [UIImage imageNamed:@"packing_arrow_up.png"];
    }
    
}

-(void)dealloc{

    [_policyName release];
    [_lowestPrice release];
    [_arrow release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
