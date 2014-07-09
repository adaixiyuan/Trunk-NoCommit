//
//  GrouponUserGuideView.m
//  ElongClient
//
//  Created by bruce on 13-10-8.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponUserGuideView.h"

// 控件尺寸
#define kGuideViewExperienceControlWidth                    160
#define kGuideViewExperienceControlHeight                   42
#define kGuideViewSkipControlWidth                          75
#define kGuideViewSkipControlHeight                         37

// 间隔
#define kGuideViewExperienceControlVMargin                  22
#define kGuideViewExperienceControlVMargin4Inch             45
#define kGuideViewSkipControlHMargin                        12
#define kGuideViewSkipControlVMargin                        10

// 偏移量
#define	kGuideViewScrollOffset                          2

#define isIPhone5        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

// 控件Tag值
enum  {
	kGuideViewExperienceControlTag = 100,
	kGuideViewSkipControlTag,
};

@implementation GrouponUserGuideView

@synthesize delegate = _delegate;


- (void)dealloc
{
    SFRelease(_delegate);
	
    [super dealloc];
}

// 移除
- (void)dismiss
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_delegate guideViewFinish];
                     }];
}

// 页面动作
- (void)goViewDismissAction
{
    if ((_delegate != nil) && ([_delegate respondsToSelector:@selector(guideViewFinish)] == YES))
    {
        [self dismiss];
        
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 父窗口的尺寸
        CGRect parentFrame = [self frame];
        
        // 创建scrollView
        UIScrollView *scrollViewGuideTmp = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [scrollViewGuideTmp setFrame:[self bounds]];
        [scrollViewGuideTmp setBackgroundColor:[UIColor clearColor]];
        [scrollViewGuideTmp setOpaque:YES];
        [scrollViewGuideTmp setPagingEnabled:YES];
        [scrollViewGuideTmp setScrollEnabled:YES];
        [scrollViewGuideTmp setShowsVerticalScrollIndicator:NO];
        [scrollViewGuideTmp setShowsHorizontalScrollIndicator:NO];
        [scrollViewGuideTmp setDelegate:self];
        [self addSubview:scrollViewGuideTmp];
        
        // 添加图片
        UIImage *guideImage01 =  [UIImage imageNamed:@"groupon_userguide01.png"];
        UIImage *guideImage02 =  [UIImage imageNamed:@"groupon_userguide02.png"];
        UIImage *guideImage03 =  [UIImage imageNamed:@"groupon_userguide03.png"];
        
        if (isIPhone5)
        {
            guideImage01 = [UIImage imageNamed:@"groupon_userguide4inch01.png"];
            guideImage02 = [UIImage imageNamed:@"groupon_userguide4inch02.png"];
            guideImage03 = [UIImage imageNamed:@"groupon_userguide4inch03.png"];
        }
        
        // 纵向位移偏量
        NSInteger spaceYStart = 0;
        
        if (guideImage01 != nil)
        {
            UIImageView *imageViewGuide01 = [[UIImageView alloc] initWithFrame:CGRectZero];
            [imageViewGuide01 setFrame:CGRectMake(0, spaceYStart, guideImage01.size.width, guideImage01.size.height)];
            [imageViewGuide01 setImage:guideImage01];
            [scrollViewGuideTmp addSubview:imageViewGuide01];
            [imageViewGuide01 release];
            
            // 控件大小
            spaceYStart += guideImage01.size.height;
        }
        
        if (guideImage02 != nil)
        {
            UIImageView *imageViewGuide02 = [[UIImageView alloc] initWithFrame:CGRectZero];
            [imageViewGuide02 setFrame:CGRectMake(0, spaceYStart, guideImage02.size.width, guideImage02.size.height)];
            [imageViewGuide02 setImage:guideImage02];
            [scrollViewGuideTmp addSubview:imageViewGuide02];
            [imageViewGuide02 release];
            
            // 控件大小
            spaceYStart += guideImage01.size.height;
        }
        
        if (guideImage03 != nil)
        {
            UIImageView *imageViewGuide03 = [[UIImageView alloc] initWithFrame:CGRectZero];
            [imageViewGuide03 setFrame:CGRectMake(0, spaceYStart, guideImage03.size.width, guideImage03.size.height)];
            [imageViewGuide03 setImage:guideImage03];
            [scrollViewGuideTmp addSubview:imageViewGuide03];
            [imageViewGuide03 release];
            
            // 控件大小
            spaceYStart += guideImage01.size.height;
        }
        
        
        [scrollViewGuideTmp setContentSize:CGSizeMake(guideImage01.size.width, spaceYStart)];
        [scrollViewGuideTmp release];
        
        
        // 创建跳过事件control
        CGSize controlSkipSize = CGSizeMake(kGuideViewSkipControlWidth, kGuideViewSkipControlHeight);
        UIControl *controlSkip = [[UIControl alloc] initWithFrame:CGRectMake(parentFrame.size.width-kGuideViewSkipControlHMargin-controlSkipSize.width, kGuideViewSkipControlVMargin, controlSkipSize.width, controlSkipSize.height)];
        [controlSkip addTarget:self action:@selector(goViewDismissAction) forControlEvents:UIControlEventTouchUpInside];
        [controlSkip setBackgroundColor:[UIColor clearColor]];
        [controlSkip setHidden:NO];
        [controlSkip setTag:kGuideViewSkipControlTag];
        [self addSubview:controlSkip];
        [controlSkip release];
        
        
        // 创建立即体验事件Control
        CGSize controlGuideSize = CGSizeMake(kGuideViewExperienceControlWidth, kGuideViewExperienceControlHeight);
        CGFloat controlXStart = (parentFrame.size.width - kGuideViewExperienceControlWidth)/2;
        CGFloat controlYStart = parentFrame.size.height - kGuideViewExperienceControlVMargin - kGuideViewExperienceControlHeight;
        
        if (isIPhone5)
        {
            controlYStart = parentFrame.size.height - kGuideViewExperienceControlVMargin4Inch - kGuideViewExperienceControlHeight;
        }
        
        UIControl *controlExperience = [[UIControl alloc] initWithFrame:CGRectMake(controlXStart, controlYStart, controlGuideSize.width, controlGuideSize.height)];
        [controlExperience addTarget:self action:@selector(goViewDismissAction) forControlEvents:UIControlEventTouchUpInside];
        [controlExperience setBackgroundColor:[UIColor clearColor]];
        [controlExperience setHidden:YES];
        [controlExperience setTag:kGuideViewExperienceControlTag];
        [self addSubview:controlExperience];
        [controlExperience release];

        
    }
    return self;
}

// =======================================================================
#pragma mark - UIScrollViewDelegate代理函数
// =======================================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight = scrollView.frame.size.height;
    NSInteger pageIndex = floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    // 跳过事件Control
    UIControl *controlSkip = (UIControl *)[self viewWithTag:kGuideViewSkipControlTag];
    if (controlSkip != nil)
    {
        if (pageIndex == 0)
        {
            [controlSkip setHidden:NO];
        }
        else
        {
            [controlSkip setHidden:YES];
        }
    }
    
    // 立即体验事件Control
    UIControl *controlGuide = (UIControl *)[self viewWithTag:kGuideViewExperienceControlTag];
    if (controlGuide != nil)
    {
        if (pageIndex == 2)
        {
            [controlGuide setHidden:NO];
        }
        else
        {
            [controlGuide setHidden:YES];
        }
    }
}



@end
