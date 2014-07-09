//
//  DaoDaoRatingView.m
//  Elong_iPad
//
//  Created by Ivan.xu on 13-2-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DaoDaoRatingView.h"

@interface DaoDaoRatingView ()

@end

@implementation DaoDaoRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        for(int i=0; i<5;i++){
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12*i, 0, 12, 12)];
            icon.tag = i+100;
            [self addSubview:icon];
            [icon release];
        }
    }
    return self;
}


-(void)setDaoDaoRateScore:(float)score{
    int score_int = floor(score);
    BOOL isHalf = NO;
    float minus = score-score_int;
    if(minus>0.0){
        isHalf = YES;
    }
    for(int i=0; i<5;i++){
        UIImageView *icon = (UIImageView *)[self viewWithTag:i+100];
        if(score_int==5){
            [icon setImage:[UIImage imageNamed:@"daodaoIcon_1"]];
        }else{
            if(i<score_int){
                [icon setImage:[UIImage imageNamed:@"daodaoIcon_1"]];
            }else if(i==score_int){
                if(isHalf){
                    [icon setImage:[UIImage imageNamed:@"daodaoIcon_2"]];
                }else{
                    [icon setImage:[UIImage imageNamed:@"daodaoIcon_3"]];
                }
            }else{
                [icon setImage:[UIImage imageNamed:@"daodaoIcon_3"]];
            }
        }
    }
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
