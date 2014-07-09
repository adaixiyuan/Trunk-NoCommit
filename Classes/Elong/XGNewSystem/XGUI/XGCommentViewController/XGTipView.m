//
//  XGTipView.m
//  ElongClient
//
//  Created by guorendong on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGTipView.h"

@implementation XGTipView
-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self doInit];
    }
    return self;
}
-(id)init
{
    if (self =[super init]) {
        [self doInit];
    }
    return self;
}
-(void)doInit
{
    [self addSubview:self.disBackView];
    [self addSubview:self.disInfoImage];
    [self addSubview:self.disTipLabel];
    self.backgroundColor=[UIColor clearColor];
}

@synthesize disBackView=_disBackView;

-(UIView *)disBackView
{
    if (_disBackView==nil) {
        _disBackView =[[UIView alloc] init];
        _disBackView.frame=CGRectMake(0, 0, 110, 110);
        _disBackView.layer.cornerRadius=5;
        _disBackView.backgroundColor=[UIColor blackColor];
        _disBackView.alpha=.7;
    }
    return _disBackView;
}

@synthesize disInfoImage=_disInfoImage;
-(UIImageView *)disInfoImage
{
    if (_disInfoImage ==nil) {
        _disInfoImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 47, 34)];
        _disInfoImage.backgroundColor =[UIColor clearColor];
        _disInfoImage.image =[UIImage imageNamed:@"XG_Comment_Done"];
    }
    return _disInfoImage;
}

@synthesize disTipLabel=_disTipLabel;
-(UILabel *)disTipLabel
{
    if (_disTipLabel ==nil) {
        _disTipLabel =[[UILabel alloc] init];
        _disTipLabel.text =@"评价成功";
        _disTipLabel.textColor=[UIColor whiteColor];
        _disTipLabel.backgroundColor =[UIColor clearColor];
        _disTipLabel.font=[UIFont boldSystemFontOfSize:17];
    }
    return _disTipLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.disTipLabel sizeToFit];
    self.disBackView.frame =CGRectMake(self.width/2-self.disBackView.width/2,self.height/2-self.disBackView.width/2, self.disBackView.width, self.disBackView.height);
    self.disInfoImage.frame=CGRectMake(self.width/2-self.disInfoImage.width/2, self.height/2-self.disInfoImage.height+4, self.disInfoImage.width, self.disInfoImage.height);
    self.disTipLabel.frame=CGRectMake(self.disBackView.left+(self.disBackView.width/2-self.disTipLabel.width/2), self.height/2+20, self.disTipLabel.width, self.disTipLabel.height);
    
}

@end
