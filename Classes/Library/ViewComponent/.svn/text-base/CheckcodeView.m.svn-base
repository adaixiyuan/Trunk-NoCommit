//
//  CheckcodeView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-8-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CheckcodeView.h"
#import "ElongURL.h"

#define BUTTON_BG_FRAME     CGRectMake(0, (self.frame.size.height - 31)/2 + 1, self.frame.size.width, 31)
#define BUTTON_TITLE_FRAME  CGRectMake(0, (self.frame.size.height - 14)/2, self.frame.size.width, 14)    
#define CODE_IMG_FRAME      CGRectMake(0, 4, self.frame.size.width, 28)
#define CODE_TITLE_FRAME    CGRectMake(0, 34, self.frame.size.width, 14)


@implementation CheckcodeView

- (void)dealloc
{
    [checkcodeUtil cancel];
    SFRelease(checkcodeUtil);
    
    [requestURL release];
    [buttonImg release];
    [checkCodeImg release];
    [titleLabel release];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame checkcodeURL:(NSString *)URL
{
    self = [super initWithFrame:frame];
    if (self) {
        isLoading = NO;
        requestURL = [[NSString alloc] initWithString:URL];
        
        buttonImg = [[UIImageView alloc] initWithFrame:BUTTON_BG_FRAME];
        buttonImg.image = [UIImage stretchableImageWithPath:@"checkcode_btn.png"];
        [self addSubview:buttonImg];
        
        checkCodeImg = [[UIImageView alloc] initWithFrame:CODE_IMG_FRAME];
        [self addSubview:checkCodeImg];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:titleLabel];
        
        // 初始直接开始loading
        [self requestForRefresh];
    }
    return self;
}


// 刷新验证码
- (void)requestForRefresh
{
    buttonImg.hidden = YES;
    checkCodeImg.hidden = YES;
    titleLabel.text = nil;
    [self startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    
    // 请求验证码
    if (checkcodeUtil)
    {
        [checkcodeUtil cancel];
        SFRelease(checkcodeUtil);
    }
    checkcodeUtil = [[HttpUtil alloc] init];
    [checkcodeUtil connectWithURLString:GIFTCARD_SEARCH
                                Content:requestURL
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
    
    isLoading = YES;
}


// 变回按钮状态
- (void)changeStateToButton
{
    isLoading = NO;
    [self endLoading];
    
    buttonImg.hidden = NO;
    checkCodeImg.hidden = YES;
    
    titleLabel.text = @"获取验证码";
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = BUTTON_TITLE_FRAME;
}

#pragma mark - HttpUtil Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (util == checkcodeUtil)
    {
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            // 出错时，变回按钮状态
            [self changeStateToButton];
        }
        else
        {
            if (STRINGHASVALUE([root safeObjectForKey:U_R_L]))
            {
                isLoading = NO;
                
                // 验证码图片地址有效
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *url = [NSURL URLWithString:[root safeObjectForKey:U_R_L]];
                    NSData *responseData = [NSData dataWithContentsOfURL:url];
                    UIImage *avatarImage = [UIImage imageWithData:responseData];

                    if (avatarImage) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self endLoading];
                            
                            buttonImg.hidden = YES;
                            checkCodeImg.hidden = NO;
                            checkCodeImg.image = avatarImage;
                            
                            titleLabel.text = @"看不清，换一个";
                            titleLabel.textColor = [UIColor blackColor];
                            titleLabel.font = [UIFont boldSystemFontOfSize:12];
                            titleLabel.frame = CODE_TITLE_FRAME;
                        });
                    }
                    else {
                        [self changeStateToButton];
                    }
                });
            }
            else
            {
                // 验证码图片地址无效
                [self changeStateToButton];
            }
        }
    }
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == checkcodeUtil) {
        [self changeStateToButton];
    }
}


#pragma mark - UITouchDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!isLoading) {
        [self requestForRefresh];
    }
}

@end
