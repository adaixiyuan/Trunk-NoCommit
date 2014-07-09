//
//  AIMTableViewIndexBar.m
//  AIMTableViewIndexBar
//
//  Created by Marek Kotewicz on 07.09.2013.
//  Copyright (c) 2013 AllInMobile. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <QuartzCore/QuartzCore.h>
#import "AIMTableViewIndexBar.h"

#if !__has_feature(objc_arc)
#error AIMTableViewIndexBar must be built with ARC.
// You can turn on ARC for only AIMTableViewIndexBar files by adding -fobjc-arc to the build phase for each of its files.
#endif

#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

@interface AIMTableViewIndexBar (){
    BOOL isLayedOut;
    CAShapeLayer *shapeLayer;
    CGFloat letterHeight;
}

@end


@implementation AIMTableViewIndexBar

- (id)init{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (void)setup{
    
    NSArray *letters = @[@"A", @"B", @"C",
                         @"D", @"E", @"F", @"G",
                         @"H", @"I", @"J", @"K",
                         @"L", @"M", @"N", @"O",
                         @"P", @"Q", @"R", @"S",
                         @"T", @"U", @"V", @"W",
                         @"X", @"Y", @"Z"];
    
    [self setLetters:letters];
    
}

- (void)setLetters:(NSArray *)letters
{
    if (letters != nil && [letters count] > 0)
    {
        // 保存
        _letters = letters;
        
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeEnd = 1.0f;
        self.layer.masksToBounds = NO;
    }
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
	[super setFrame:frameNew];
	
	// 刷新
	[self layoutSubviews];
}

- (void)setIndexes:(NSArray *)idxs{
    _indexes = idxs;
    isLayedOut = NO;
    
    [self layoutSubviews];
}

- (CGFloat)getViewWidth:(NSArray *)idxs
{
    CGFloat viewWidth = 0;
    if (idxs != nil)
    {
        for (NSInteger i=0; i<[idxs count]; i++)
        {
            NSString *indexName = [idxs objectAtIndex:i];
            if (indexName != nil && [indexName length] > 0)
            {
                CGSize nameSize = [indexName sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
                if (nameSize.width > viewWidth)
                {
                    viewWidth = nameSize.width;
                }
            }
        }
    }
    
    return viewWidth;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    if (!isLayedOut){
        
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        shapeLayer.frame = (CGRect) {.origin = CGPointZero, .size = self.layer.frame.size};
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointZero];
        [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
        letterHeight = self.frame.size.height / [_letters count];
        CGFloat fontSize = 12;
        if (letterHeight < 14){
            fontSize = 11;
        }
        
        [_letters enumerateObjectsUsingBlock:^(NSString *letter, NSUInteger idx, BOOL *stop) {
            CGFloat originY = idx * letterHeight;
            CATextLayer *ctl = [self textLayerWithSize:fontSize
                                                string:letter
                                              andFrame:CGRectMake(0, originY, self.frame.size.width, letterHeight)];
            [self.layer addSublayer:ctl];
            [bezierPath moveToPoint:CGPointMake(0, originY)];
            [bezierPath addLineToPoint:CGPointMake(ctl.frame.size.width, originY)];
        }];
        
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        isLayedOut = YES;
    }
}

- (CATextLayer*)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *tl = [CATextLayer layer];
    [tl setFont:@"Helvetica-Bold"];
    [tl setFontSize:size];
    [tl setFrame:frame];
    [tl setAlignmentMode:kCAAlignmentCenter];
    [tl setContentsScale:[[UIScreen mainScreen] scale]];
//    [tl setForegroundColor:RGB(168, 168, 168, 1).CGColor];
    [tl setForegroundColor:RGB(11, 96, 254, 1).CGColor];
    [tl setString:string];
    return tl;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
	[self sendEventToDelegate:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
	[self sendEventToDelegate:event];
}

- (void)sendEventToDelegate:(UIEvent*)event{
    UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
    NSInteger indx = (NSInteger) floorf(fabs(point.y) / letterHeight);
    indx = indx < [_letters count] ? indx : [_letters count] - 1;
    
    [self animateLayerAtIndex:indx];
    
    __block NSInteger scrollIndex;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, indx+1)];
    [_letters enumerateObjectsAtIndexes:indexSet options:NSEnumerationReverse usingBlock:^(NSString *letter, NSUInteger idx, BOOL *stop) {
        scrollIndex = [_indexes indexOfObject:letter];
        *stop = scrollIndex != NSNotFound;
    }];
    
    [_delegate tableViewIndexBar:self didSelectSectionAtIndex:scrollIndex];
}

- (void)animateLayerAtIndex:(NSInteger)index{
    if ([self.layer.sublayers count] - 1 > index){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        animation.toValue = (id)[RGB(180, 180, 180, 1) CGColor];
        animation.duration = 0.5f;
        animation.autoreverses = YES;
        animation.repeatCount = 1;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.layer.sublayers[index] addAnimation:animation forKey:@"myAnimation"];
    }
}


@end













