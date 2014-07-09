//
//  LineView.m
//  ElongClient
//
//  Created by nieyun on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
        if (!self.noRightShowVertical)
        {
            rightVDashView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-SCREEN_SCALE, 0, SCREEN_SCALE, self.frame.size.height)];
            rightVDashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
            [self addSubview:rightVDashView];
            [rightVDashView release];
            
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
    

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    [super drawRect:rect];
//    
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetLineWidth(context, 1);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor  grayColor].CGColor);
//    
//    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
//    
//    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
//    
//    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
//    
//    CGContextAddLineToPoint(context,rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
//    
//    CGContextStrokePath(context);
//}


@end
