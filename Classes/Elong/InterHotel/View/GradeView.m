//
//  GradeView.m
//  ElongClient
//
//  Created by nieyun on 14-6-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GradeView.h"

@implementation GradeView
- (void)dealloc
{
    [buttonAr release];
    [lightImagePath release];
    [grayImagePath  release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame defaultScore:(float)score lightImage:(NSString *)limage  grayImage:(NSString *)gimage count:(int )count
{
    self  = [super  initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor  clearColor];
        allCount = count;
        buttonAr = [[NSMutableArray  alloc]init];
        lightImagePath = [[NSString  alloc]initWithString:limage];
        grayImagePath = [[NSString alloc]initWithString:gimage];
        defaultScore = score;
        for (int i = 0; i < count;i ++)
        {
            float interval = self.width*0.2/(count -1);
            float  width = self.width*0.8/count;
            UIButton  *button  = [[UIButton alloc]initWithFrame:CGRectMake(interval*i+width*i, self.height*0.1,width, self.height*0.8)];
            button.tag = 300+i;
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
         
            [buttonAr addObject:button];
            [button release];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib ];
    
}
- (void) setDefaultScore:(float)score lightImage:(NSString *)limage  grayImage:(NSString *)gimage count:(int )count
{
    allCount = count;
    buttonAr = [[NSMutableArray  alloc]init];
    lightImagePath = [[NSString  alloc]initWithString:limage];
    grayImagePath = [[NSString alloc]initWithString:gimage];
    defaultScore = score;
    for (int i = 0; i < count;i ++)
    {
        float interval = self.width*0.2/(count -1);
        float  width = self.width*0.8/count;
        UIButton  *button  = [[UIButton alloc]initWithFrame:CGRectMake(interval*i+width*i, self.height*0.1,width, self.height*0.8)];

        button.tag = 300+i;
        button.highlighted = NO;
        
        if (i <= score)
        {
            [button  setImage:[UIImage  noCacheImageNamed:lightImagePath] forState:UIControlStateNormal];
        }else
        {
            [button setImage:[UIImage  noCacheImageNamed:grayImagePath] forState:UIControlStateNormal];
        
        }
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
     
        [buttonAr addObject:button];
        [self addSubview:button];
        [button release];
    }
    
   
}

- (void)selectAction:(UIButton *)button
{
//    switch (button.tag - 300) {
//           case 0:
//                {
//                
//                }
//            break;
//            case 1:
//                {}
//            break;
//            case 2:
//                {}
//            break;
//            case 3:
//                {}
//            break;
//            case 4:
//                 {}
//            break;
//        default:
//            break;
//    }
    
    for (int i = 0;i <allCount;i ++ )
    {
        UIButton  *bt = [buttonAr  safeObjectAtIndex:i];
         bt.highlighted = NO;
        if (i <= button.tag -300)
        {
            
            [bt  setImage:[UIImage  noCacheImageNamed:lightImagePath] forState:UIControlStateNormal];
           
           
        }else
        {
            [bt setImage:[UIImage  noCacheImageNamed:grayImagePath] forState:UIControlStateNormal];
        }
          
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedButton:)])
    {
        [self.delegate  didSelectedButton:button.tag - 300];
    }
}

- (void) lightSomePic:(int) count
{
    
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