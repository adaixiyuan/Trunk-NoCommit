//
//  CanclePolicyDetailView.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CanclePolicyDetailView.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface CanclePolicyDetailView ()

@property(nonatomic,copy) NSString *cancelPolicyContent;
-(void)closeThePage;

@end

@implementation CanclePolicyDetailView
@synthesize cancelPolicyContent;

- (void)dealloc
{
    [cancelPolicyContent release];
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

-(id)initWithCancelPolicyContent:(NSString *)policyContent{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];

        self.cancelPolicyContent = policyContent;
        
        //Bg
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        bg.backgroundColor = [UIColor blackColor];
        bg.userInteractionEnabled = YES;
        bg.alpha = 0.85;
        [self addSubview:bg];
        [bg release];
        
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePage)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [bg addGestureRecognizer:singleTap];
        [singleTap release];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
        contentView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        [self addSubview:contentView];
        [contentView release];
        
        //Close Btn
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn addTarget:self action:@selector(closeThePage) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(0, 0, 57, 57);
        [self addSubview:closeBtn];
                
        UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 280, SCREEN_SCALE)];
        headerImg.image = [UIImage stretchableImageWithPath:@"dashed.png"];
        headerImg.userInteractionEnabled = YES;
        [contentView addSubview:headerImg];
        [headerImg release];
        
        //Title
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        titleLB.backgroundColor = [UIColor clearColor];
        titleLB.textColor = RGBACOLOR(52, 52, 52, 1);
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = [UIFont boldSystemFontOfSize:16];
        titleLB.text = @"取消政策";
        [contentView addSubview:titleLB];
        [titleLB release];
        
        UILabel *contentLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 260, 200)];
        contentLB.backgroundColor = [UIColor clearColor];
        contentLB.numberOfLines = 0;
        contentLB.lineBreakMode = UILineBreakModeTailTruncation;
        contentLB.font = [UIFont systemFontOfSize:14];
        contentLB.textColor = RGBACOLOR(93, 93, 93, 1);
        contentLB.text = self.cancelPolicyContent;
        [contentView addSubview:contentLB];
        [contentLB release];
                
        //根据内容设置容器的高度
        CGSize size = [contentLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 10000) lineBreakMode:UILineBreakModeTailTruncation];
        contentLB.frame = CGRectMake(10, 64, 260, size.height);
        contentView.frame = CGRectMake(0, 0, 280, size.height+64+40);
        
        [contentView setCenter:CGPointMake(160, SCREEN_HEIGHT/2)];
        [closeBtn setCenter:CGPointMake(contentView.frame.origin.x+contentView.frame.size.width - 2, contentView.frame.origin.y + 2)];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Action Methods
//取消
-(void)closeThePage{
    //Animation
    [UIView beginAnimations:@"EaseOut" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.alpha = 0.0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

@end
