//
//  CircleView.m
//  CircleProgressView
//
//  Created by nieyun on 14-1-26.
//  Copyright (c) 2014年 changjian. All rights reserved.
//

#import "CircleView.h"

@interface CircleView(){
@private
    float _radius;              // 绘制半径
    float _lineWidth;           // 线宽
    CGColorRef _trackColorRef;  // 轨迹颜色
    CGColorRef _foreColorRef;   // 前景颜色
    CGColorRef _bgColorRef;     // 画布颜色
    NSTimer *_timer;            // 刷新timer
    float _timerInterval;       // 刷新间隔
    float _timerflow;           // 时间流逝
    float _centerX;             // 圆心X
    float _centerY;             // 圆心Y
    float _duration;            // 计时时长
}
@property (nonatomic,retain) UIColor *bgColor;
@end

@implementation CircleView


- (void) dealloc{
    self.bgColor = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 默认值
        _lineWidth      = 5.0f;
        _radius         = frame.size.width/2 - _lineWidth * 2;
        _trackColorRef  = [UIColor lightGrayColor].CGColor;
        _foreColorRef   =  [UIColor  orangeColor].CGColor;
        _timerInterval  = 0.05;
        _timerflow      = 0.0f;
        _centerX        = self.frame.size.width/2;
        _centerY        = self.frame.size.height/2;
        self.bgColor    = RGBACOLOR(245, 245, 245, 1.0);
        _bgColorRef     = self.bgColor.CGColor;
        
    }
    return self;
}

- (void) timerWork{
    _timerflow += _timerInterval;
    if (_timerflow >= _duration) {
        [self stopAnimation];
    }
    [self setNeedsDisplay];
    
    // 汇报进度
    if([self.delegate respondsToSelector:@selector(circleView:process:)]){
        float process = _timerflow/_duration;
        [self.delegate circleView:self process:process];
    }
}

- (void) startAnimation:(float)duration andTimeFlow:(float)time{
    _timerflow = time;
    _duration = duration;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self setNeedsDisplay];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(timerWork) userInfo:nil repeats:YES];
}

- (void) stopAnimation{
   // _timerflow = _duration;
    [self setNeedsDisplay];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) setPause:(BOOL)pause{
    _pause = pause;
    if (_pause) {
        [_timer invalidate];
        _timer = nil;
    }else{
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(timerWork) userInfo:nil repeats:YES];
    }
}


- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    float process = _timerflow/_duration;
    float theta = -M_PI_2 + process * 2 * M_PI;
    
    // 绘制句柄
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 清空画布
    CGContextSetFillColorWithColor(context, _bgColorRef);
    CGContextFillRect(context,self.bounds);
    
    //track
    CGContextSetStrokeColorWithColor(context, _trackColorRef);
    CGContextSetLineWidth(context, _lineWidth);
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, _centerX, _centerY, _radius, -M_PI_2,  -M_PI_2 + 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //fore
    CGContextSetStrokeColorWithColor(context, _foreColorRef);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextAddArc(context, _centerX, _centerY, _radius, -M_PI_2, theta, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    // dot
    float x = _centerX + cosf(theta) * _radius;
    float y = _centerY + sinf(theta) * _radius;
    CGImageRef image = [UIImage imageNamed:@"elong-icon_cicle.png"].CGImage;
    CGContextSaveGState(context);
    
    // 翻转
    CGContextTranslateCTM(context, 0, 16);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect touchRect = CGRectMake(x - 8, -y + 8, 16, 16);
    CGContextDrawImage(context, touchRect, image);
    CGContextRestoreGState(context);
}
@end
