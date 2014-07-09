//
//  RatingView.m
//  Elong_iPad
//
//  酒店评级显示
//
//  Created by elong lide on 12-3-8.
//  Copyright 2012 elong. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

// 初始化基础数据
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		float xwidth = (self.bounds.size.width - 4*2 + 0.0f)/5;
		float ywidth = self.bounds.size.height;
		starWidth =  MIN(xwidth,ywidth);
		self.backgroundColor = [UIColor clearColor];
		realStar = YES;
		starColor = [UIColor blueColor];
        [starColor retain];
    }
    return self;
}

// 初始化基础数据，可设置星星颜色
- (id) initWithFrame:(CGRect)frame starColor:(UIColor *)color{
	self = [super initWithFrame:frame];
	if (self) {
		float xwidth = (self.bounds.size.width - 4*2 + 0.0f)/5;
		float ywidth = self.bounds.size.height;
		starWidth =  MIN(xwidth,ywidth);
		self.backgroundColor = [UIColor clearColor];
		realStar = YES;
		starColor = color;
        [starColor retain];
	}
	return self;
}


// 设置星级
-(NSInteger) setRating:(float) count{
	
	if (count<10) {
		realStar = YES;
	}else {
		realStar = NO;
		count = count/10.0f;
	}

	if (count<1) {
		count = 0;
	}
	starNum = floor(count);
	starNumf = count - starNum;
	//重绘
	[self setNeedsDisplay];
    if (starNumf > 0) {
        return starNum + starNumf;
    }else{
        return starNum;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画五角星
    //清空画布
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, self.bounds);
    
    // 设置颜色
    CGContextSetFillColorWithColor(context, starColor.CGColor);
    CGContextSetStrokeColorWithColor(context, starColor.CGColor);
    CGContextSetLineWidth(context, 1);
    
    if (realStar) {
        // 真星，绘制五角星
        float radius = 0.0f;
        float dig = M_PI / 5;
        float movex = starWidth/2;
        float movey = starWidth/2 + 1;
        float x = 0.0f;
        float y = 0.0f;
        float degree = 36 * M_PI / 180;
        float R = starWidth/(1 + cosf(degree));
        float r = R/2;//R*sinf(degree/2)/cosf(degree);
        
        CGContextBeginPath(context);
        
        for (int j = 0; j < starNum; j++) {
            CGContextMoveToPoint(context,movex, movey);
            for (int i = 0; i <= 10; i++) {
                if (i % 2) {
                    radius = R;
                }else{
                    radius = r;
                }
                x = movex + sinf(i * dig) * radius;
                y = movey + cosf(i * dig) * radius;
                if (i == 0) {
                    CGContextMoveToPoint(context, x, y);
                }
                else {
                    CGContextAddLineToPoint(context, x, y);
                }
            }
            movex += (starWidth + 2);
            movey += 0;
        }
        CGContextFillPath(context);
        
        // 处理半星级情况
        if (starNumf > 0) {
            // 绘制五角星的边框
            CGContextMoveToPoint(context,movex, movey);
            for (int i = 0; i <= 10; i++) {
                if (i % 2) {
                    radius = R - 1;
                }else{
                    radius = r - .5;
                }
                
                x = movex + sinf(i * dig) * radius;
                y = movey + cosf(i * dig) * radius;
                if (i == 0) {
                    CGContextMoveToPoint(context, x, y);
                }
                else {
                    CGContextAddLineToPoint(context, x, y);
                }
                
            }
            CGContextStrokePath(context);
            // 填充五角星的一半
//            CGContextMoveToPoint(context,movex, movey);
//            for (int i = 5; i <= 10; i++) {
//                if (i % 2) {
//                    radius = R;
//                }else{
//                    radius = r;
//                }
//
//                x = movex + sinf(i * dig) * radius;
//                y = movey + cosf(i * dig) * radius;
//                if (i == 0) {
//                    CGContextMoveToPoint(context, x, y);
//                }
//                else {
//                    CGContextAddLineToPoint(context, x, y);
//                }
//                
//            }
//            CGContextFillPath(context);
            
        }
    }else{
        // 准星，绘制钻石
        float movex = starWidth/2;
        float movey = starWidth/2-1;
        float x = 0.0f;
        float y = 0.0f;
        float degree = 40*M_PI / 180;
        CGContextBeginPath(context);
        for (int j = 0; j < starNum; j++) {
            x = movex - sinf(degree) * cosf(degree) * starWidth/2;
            y = movey - sinf(degree) * sinf(degree) *starWidth/2;
            CGContextMoveToPoint(context, x, y);
            x = movex +  sinf(degree) * cosf(degree) * starWidth/2;
            y = movey - sinf(degree) * sinf(degree) *starWidth/2;
            CGContextAddLineToPoint(context, x, y);
            x = movex + starWidth/2;
            y = movey;
            CGContextAddLineToPoint(context, x, y);
            x = movex;
            y = movey  + starWidth/2;
            CGContextAddLineToPoint(context, x, y);
            x = movex - starWidth/2;
            y = movey;
            CGContextAddLineToPoint(context, x, y);
            x = movex - sinf(degree) * cosf(degree) * starWidth/2;
            y = movey - sinf(degree) * sinf(degree) *starWidth/2;
            CGContextAddLineToPoint(context, x, y);
            
            movex += (starWidth + 2);
            
        }
        CGContextFillPath(context);
        
        if (starNumf > 0) {
            // 绘制钻石的边框
            CGContextBeginPath(context);
            x = movex - sinf(degree) * cosf(degree) * (starWidth/2 - 1);
            y = movey - sinf(degree) * sinf(degree) * (starWidth/2 - 1);
            CGContextMoveToPoint(context, x, y);
            x = movex +  sinf(degree) * cosf(degree) * (starWidth/2 - 1);
            y = movey - sinf(degree) * sinf(degree) * (starWidth/2 - 1);
            CGContextAddLineToPoint(context, x, y);
            x = movex + starWidth/2 - .5;
            y = movey;
            CGContextAddLineToPoint(context, x, y);
            x = movex;
            y = movey  + starWidth/2 - .5;
            CGContextAddLineToPoint(context, x, y);
            x = movex - starWidth/2 + .5;
            y = movey;
            CGContextAddLineToPoint(context, x, y);
            x = movex - sinf(degree) * cosf(degree) * (starWidth/2 - 1);
            y = movey - sinf(degree) * sinf(degree) * (starWidth/2 - 1);
            CGContextAddLineToPoint(context, x, y);
            CGContextStrokePath(context);
            
            // 填充钻石的一半
            CGContextBeginPath(context);
            x = movex - sinf(degree) * cosf(degree) * starWidth/2;
            y = movey - sinf(degree) * sinf(degree) *starWidth/2;
            CGContextMoveToPoint(context, x, y);
            x = movex;
            y = movey - sinf(degree) * sinf(degree) *starWidth/2;
            CGContextAddLineToPoint(context, x, y);
            x = movex;
            y = movey  + starWidth/2;
            CGContextAddLineToPoint(context, x, y);
            x = movex - starWidth/2;
            y = movey;
            CGContextAddLineToPoint(context, x, y);
            x = movex - sinf(degree) * cosf(degree) * starWidth/2;
            y = movey - sinf(degree) * sinf(degree) *starWidth/2;
            CGContextAddLineToPoint(context, x, y);
            CGContextFillPath(context);
        }
    }
}


- (void)dealloc {
    [starColor release];
    [super dealloc];
}


@end
