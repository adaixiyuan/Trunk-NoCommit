//
//  HotScenicView.m
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotScenicView.h"
#import "HotScenicButton.h"

@implementation HotScenicView
- (void)dealloc
{
    [_textAr release];
    [buttonAr  release];
    [super dealloc ];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame withHorizontalCount:(int  )hcount  withVerticalCount:(int)vcount
          withTextAr:(NSArray *)textAr  andFinish:(clickBlock) finishBlock

{
    self = [super  initWithFrame:frame];
    if (self)
    {
       
        labelWidth = self.frame.size.width/hcount;
        labelHeight = self.frame.size.height/vcount;
        self.backgroundColor = [UIColor  whiteColor];
        
        buttonAr = [[NSMutableArray  alloc]init];
        for (int j = 0;j< vcount;j ++)
        {
            
           
            for (int i = 0;i < hcount;i ++)
            {
               
                    HotScenicButton  *button = [[HotScenicButton  alloc]initWithFrame: CGRectMake(i*labelWidth, j*labelHeight, labelWidth, labelHeight)];
                    button.tag = i + j*4;
                button.noLeftShowVertical = YES;
                button.noTopShowHorizontal = YES;

                    button.myBlock = ^(HotScenicButton  *bt,int  i)
                    {
                        if (finishBlock) {
                            finishBlock(bt,i);
                        }
                    };
                [buttonAr  addObject:button];
                    [self  addSubview:button ];
                    [button release];
                
        
                }
            
        }
    
    }
    
    
    return self;
}

- (id) initWithFrame:(CGRect)frame withHorizontalCount:(int  )hcount  withVerticalCount:(int)vcount
          withTextAr:(NSArray *)textAr  andDelegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        labelWidth = self.frame.size.width/hcount;
        labelHeight = self.frame.size.height/vcount;
        self.backgroundColor = [UIColor  whiteColor];
        
        buttonAr = [[NSMutableArray  alloc]init];
        for (int j = 0;j< vcount;j ++)
        {
            
            
            for (int i = 0;i < hcount;i ++)
            {
                
                HotScenicButton  *button = [[HotScenicButton  alloc]initWithFrame: CGRectMake(i*labelWidth, j*labelHeight, labelWidth, labelHeight)];
                button.tag = i + j*4;
                button.noLeftShowVertical = YES;
                button.noTopShowHorizontal = YES;
                
                button.delegate = delegate;
                [buttonAr  addObject:button];
                [self  addSubview:button ];
                [button release];
                
                
            }
            
        }

    }
    return self;
}

- (void)setTextAr:(NSArray *)textAr
{
    if (_textAr != textAr)
    {
        [_textAr release];
        _textAr = [textAr retain];
    }
    for (int i = 0; i < _textAr.count; i ++)
    {
        HotScenicButton  *bt =  [buttonAr safeObjectAtIndex:i];
        bt.hidden = NO;
        bt.bText = [self.textAr  safeObjectAtIndex:i];
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
