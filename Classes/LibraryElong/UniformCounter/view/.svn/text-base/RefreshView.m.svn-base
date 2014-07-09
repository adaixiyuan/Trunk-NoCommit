//
//  RefreshView.m
//  ElongClient
//
//  Created by 赵 海波 on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

- (id)initWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString *)tipString andIcon:(UIImage *)icon
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        // button
        actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = self.bounds;
        [actionBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionBtn];
        
        CGSize tipSize = [tipString sizeWithFont:FONT_13 constrainedToSize:CGSizeMake(300, 20)];
        int contentLength = tipSize.width + icon.size.width + 7;
        
        // label
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - contentLength) / 2, 0, tipSize.width + 7, self.frame.size.height)];
        tipLabel.font = FONT_13;
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = RGBACOLOR(53, 53, 53, 1);
        tipLabel.text = tipString;
        [self addSubview:tipLabel];
        
        // imageView
        tipIcon = [[UIImageView alloc] initWithFrame:CGRectMake(tipLabel.frame.origin.x + tipLabel.frame.size.width, (self.frame.size.height - icon.size.height) / 2, icon.size.width, icon.size.height)];
        tipIcon.image = icon;
        [self addSubview:tipIcon];
    }
    
    return self;
}


- (void)loadingStarWithStyle:(UIActivityIndicatorViewStyle *)style
{
    tipLabel.hidden = YES;
    tipIcon.hidden = YES;
    actionBtn.hidden = YES;
    
    [self startLoadingByStyle:style];
}


- (void)loadingEnd
{
    tipLabel.hidden = NO;
    tipIcon.hidden = NO;
    actionBtn.hidden = NO;
    
    [self endLoading];
}


@end
