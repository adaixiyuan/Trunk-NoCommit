//
//  UnderLineLabel.m
//  ElongClient
//
//  Created by garin on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UnderLineLabel.h"

@implementation UnderLineLabel

- (id)initWithFrame:(CGRect)frame leftTitleLabel_:(UILabel *) leftTitleLabel_
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (leftTitleLabel_) {
            [self addSubview:leftTitleLabel_];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    const CGFloat* colors = CGColorGetComponents(self.textColor.CGColor);
    
    CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0); // RGBA
    
    CGContextSetLineWidth(ctx, SCREEN_SCALE);
    CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 9999)];
    
    int height = tmpSize.height;
    
    int lineHeight = self.font.pointSize+2;
    
    int maxCount = height/lineHeight;
    
    float totalWidth = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(1000, 9999)].width;
    
    for(int i=1;i<=maxCount;i++)
    {
        
        float width=0.0;
        if((i*self.frame.size.width-totalWidth)<=0)
        {
            if (IOSVersion_7) {
                width = self.frame.size.width-10;
            }
            else
            {
                width = self.frame.size.width-2;
            }
        }
        else
        {
            if (maxCount==1)
            {
                width = self.frame.size.width - (i* self.frame.size.width - totalWidth);
            }
            else if(maxCount>1)
            {
                if (IOSVersion_7)
                {
                    width = self.frame.size.width - (i* self.frame.size.width - totalWidth)+10;
                }
                else
                {
                    width = self.frame.size.width - (i* self.frame.size.width - totalWidth)+5;
                }
            }
        }
        
        if (i==1)
        {
            if (self.firstRowStartPoint>0&&width>self.firstRowStartPoint)
            {
                CGContextMoveToPoint(ctx, self.firstRowStartPoint, lineHeight*i- SCREEN_SCALE);
                CGContextAddLineToPoint(ctx, width, lineHeight*i- SCREEN_SCALE);
            }
            else
            {
                CGContextMoveToPoint(ctx, 0, lineHeight*i- SCREEN_SCALE);
                CGContextAddLineToPoint(ctx, width, lineHeight*i- SCREEN_SCALE);
            }
        }
        else
        {
            CGContextMoveToPoint(ctx, 0, lineHeight*i- SCREEN_SCALE);
            CGContextAddLineToPoint(ctx, width, lineHeight*i- SCREEN_SCALE);
        }
    }
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
}

@end
