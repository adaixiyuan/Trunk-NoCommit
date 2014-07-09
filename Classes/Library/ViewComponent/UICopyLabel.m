//
//  UICopyLabel.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UICopyLabel.h"

@interface UICopyLabel()
@property (nonatomic,retain) UIColor *origionColor;
@end

@implementation UICopyLabel
@synthesize realText;
@synthesize origionColor;

- (void) dealloc{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.realText = nil;
    self.origionColor = nil;
    
    [super dealloc];
}

//绑定事件
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

// default is NO
- (BOOL)canBecomeFirstResponder{
    return YES;
}

// 实现接口
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

//针对于copy的实现
-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.realText;
    
}

// 菜单消失事件
- (void) menuWillHide{
    float red,blue,green,alpha;
    [self.origionColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    self.origionColor = nil;
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (BOOL)resignFirstResponder{
    return YES;
}

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.numberOfTapsRequired = 0;
    [self addGestureRecognizer:longPress];
    [longPress release];
    
}

// 从xib调用
-(void)awakeFromNib{
    [super awakeFromNib];
    [self attachTapHandler];
}


// 长按手势事件
-(void)longPress:(UIGestureRecognizer*) recognizer{
   
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self];
    [menu setMenuVisible:YES animated:YES];

    float red,blue,green,alpha;
    [self.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
   
    self.origionColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    //self.textColor = [UIColor colorWithRed:16.0f/255.0f green:139.0f/255.0f blue:201.0/255.0f alpha:1];
    
    // 监听UIMenuControllerWillHideMenuNotification
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];
}

@end
