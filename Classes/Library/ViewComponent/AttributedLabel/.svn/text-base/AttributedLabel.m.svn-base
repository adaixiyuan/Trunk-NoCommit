//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface AttributedLabel(){
    BOOL lineBreak;
}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation AttributedLabel
@synthesize attString = _attString;
@synthesize textLayer;


- (void)dealloc{
    [_attString release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineBreak = NO;
        _textCenter = NO;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame wrapped:(BOOL)wrapped{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineBreak = wrapped;
        _textCenter = NO;
    }
    return self;
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
    [super setFrame:frameNew];
}

- (void)drawRect:(CGRect)rect{
    if (textLayer) {
        [textLayer removeFromSuperlayer];
    }
    
    textLayer = [CATextLayer layer];
    textLayer.string = _attString;
    textLayer.wrapped = lineBreak;
    textLayer.truncationMode = @"end";
    textLayer.foregroundColor = RGBACOLOR(153, 153, 153, 1).CGColor;
    textLayer.transform = CATransform3DMakeScale(0.5,0.5,1);
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (self.textCenter) {
        textLayer.alignmentMode = @"center";
    }
    [self.layer addSublayer:textLayer];
    
}


- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)color.CGColor
                        range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName,
                                              font.pointSize*2,
                                              NULL);
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)fontRef
                        range:NSMakeRange(location, length)];
    CFRelease(fontRef);
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:style]
                        range:NSMakeRange(location, length)];
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
