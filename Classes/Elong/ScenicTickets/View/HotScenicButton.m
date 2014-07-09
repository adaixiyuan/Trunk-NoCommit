//
//  HotScenicButton.m
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotScenicButton.h"

@implementation HotScenicButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
       
        [self  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont  systemFontOfSize:13];
        if (!self.noRightShowVertical)
        {
            rightVDashView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-SCREEN_SCALE, 0, SCREEN_SCALE, self.frame.size.height)];
            rightVDashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
            [self addSubview:rightVDashView];
            
        }
        if (!self.noLeftShowVertical)
        {
            leftVDashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SCALE, self.frame.size.height)];
            leftVDashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
            [self addSubview:leftVDashView];
            [leftVDashView  release];

        }
        
        if (!self.noTopShowHorizontal)
        {
            TopHDashView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, SCREEN_SCALE)];
            TopHDashView.image = [UIImage noCacheImageNamed:@"dashed.png"];;
            [self addSubview:TopHDashView];
            [TopHDashView release];

        }
        if (!self.noBottomShowHorizontal)
        {
            bottomHDashView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height - SCREEN_SCALE, self.frame.size.width, SCREEN_SCALE)];
            bottomHDashView.image = [UIImage noCacheImageNamed:@"dashed.png"];;
            [self addSubview:bottomHDashView];
            [bottomHDashView release];
            
        }
        
        [self addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)buttonAction
{
    if ([self.delegate  respondsToSelector:@selector(finishClick:withIndex:)])
    {
        [self.delegate finishClick:self withIndex:self.tag];
    }
    if (self.myBlock)
    {
        self.myBlock(self,self.tag);
        
    }
    
}

- (void)setNoRightShowVertical:(BOOL)noRightShowVertical
{
            _noRightShowVertical = noRightShowVertical ;

    //不显示横排的线
    if (_noRightShowVertical)
    {
        if (rightVDashView)
     {
        [rightVDashView  removeFromSuperview];
      }
    }
}

- (void)setNoLeftShowVertical:(BOOL)noLeftShowVertical
{
    if (_noLeftShowVertical != noLeftShowVertical) {
        _noLeftShowVertical  = noLeftShowVertical;
    }
    //不显示竖排的线
    if (leftVDashView)
    {
        
        [leftVDashView removeFromSuperview];
    
    }
    
}

- (void)setNoTopShowHorizontal:(BOOL)noTopShowHorizontal
{
    _noTopShowHorizontal = noTopShowHorizontal;
    if (TopHDashView) {
        [TopHDashView  removeFromSuperview];
    }
}

- (void)setNoBottomShowHorizontal:(BOOL)noBottomShowHorizontal
{
    _noBottomShowHorizontal = noBottomShowHorizontal;
    if (bottomHDashView) {
        [bottomHDashView  removeFromSuperview];
    }
}
- (void)setBText:(NSString *)bText
{
    if (_bText !=  bText)
    {
        [_bText release];
        _bText = [bText  retain];
    }
    [self  setTitle:_bText forState:UIControlStateNormal];
}
- (void)dealloc
{
    
    Block_release(_myBlock);
    [super dealloc];
}
//_dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 2, SCREEN_SCALE, 44 - 4)];
//_dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
//[self.contentView addSubview:_dashView];


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
