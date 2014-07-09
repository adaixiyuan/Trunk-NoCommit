//
//  TrainOrderListCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-11-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderListCell.h"

@implementation TrainOrderListCell

- (void)dealloc {
	SFRelease(_trainNOLabel);
    SFRelease(_dateLabel);
    SFRelease(_priceLabel);
    SFRelease(_seatLabel);
    SFRelease(_departTimeLabel);
    SFRelease(_arriveTimeLabel);
    SFRelease(_stateView);
    SFRelease(_stateLabel);
    SFRelease(_fromStation);
    SFRelease(_toStation);
    
    [super dealloc];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.canClick = NO;
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 78)];
        bgView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bgView;
        [bgView release];
        
        UIView *b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 78)];
		b_view.backgroundColor = [UIColor clearColor];
		UIButton* b_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		b_btn.backgroundColor = [UIColor clearColor];
		b_btn.frame = CGRectMake(0, 0, 320, 78);
		[b_btn setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
		[b_view addSubview:b_btn];
		self.selectedBackgroundView = b_view;
		[b_view release];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

@end
