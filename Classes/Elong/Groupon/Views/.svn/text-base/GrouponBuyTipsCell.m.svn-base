//
//  GrouponBuyTipsCell.m
//  ElongClient
//  购买须知新
//  Created by garin on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponBuyTipsCell.h"
#define marrgintopSpan 25.0f //顶部，底部间隔
#define groupSpan 16.f     //每对之间的间隔
//段落
#define itemMarginTop 5.5f  //段落之间的间隔
#define lineHeight 18.f  //段落中行间隔

@implementation GrouponBuyTipsCell

-(void) dealloc
{
    webView.delegate = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        float cellHeight = 45;
        
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
//        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"groupon_dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        webView = [[UIWebView alloc] initWithFrame:bgImageView.bounds];
        webView.delegate = self;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        webView.dataDetectorTypes = UIDataDetectorTypeNone;
        if (IOSVersion_5)
        {
            webView.scrollView.scrollEnabled = NO;
        }
        else
        {
            for (UIView *temView in webView.subviews)
            {
                if ([temView isMemberOfClass:[UIScrollView class]])
                {
                    UIScrollView *curScrowView = (UIScrollView *)temView;
                    if (curScrowView) {
                        curScrowView.scrollEnabled = NO;
                    }
                    break;
                }
            }
        }
//        webView.layer.borderWidth=0.5;
        [bgImageView addSubview:webView];
        [webView release];
        webView.hidden = YES;
        
        downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
        
        activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width / 2 - 10, bgImageView.frame.size.height / 2-10, 20, 20)];
        activeView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [bgImageView addSubview:activeView];
        [activeView release];
        
        [activeView startAnimating];
    }
    return self;
}

-(void) setBuyTipsArray:(NSArray *) tipsArr
{
    NSMutableString *htmlString = [NSMutableString string];
    
    for (int i =0;i<tipsArr.count ; i++)
    {
        NSDictionary *dict=[tipsArr objectAtIndex:i];
        
        if (!DICTIONARYHASVALUE(dict))
        {
            continue;
        }
        
        NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        NSArray *contentArr = [dict objectForKey:@"content"];
        
        if (title)
        {
            [htmlString appendFormat:@"<div style = 'font-size:12px;margin-top:%0.fpx;padding-left:0px;font-weight:bold'>%@</div>",
             i == 0 ? marrgintopSpan : groupSpan ,title];
        }
        
        if (!ARRAYHASVALUE(contentArr))
        {
            continue;
        }
        
        for (int j=0; j<contentArr.count; j++)
        {
            NSString *content = [contentArr safeObjectAtIndex:j];
            
            if (!STRINGHASVALUE(content))
            {
                continue;
            }
            
            [htmlString appendFormat:@"<div style = 'font-size:12px;padding-left:9px;padding-right:12px;line-height:%0.fpx;color:#343434;margin-top:%0.fpx'>%@</div>",
             lineHeight,itemMarginTop ,content];
        }
    }
    
    if (STRINGHASVALUE(htmlString))
    {
        [webView loadHTMLString:htmlString baseURL:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_
{
    // Disable user selection
    [webView_ stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView_ stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    float scrowViewheight_ = 0;
    
    if (IOSVersion_5)
    {
        scrowViewheight_ = [webView_.scrollView contentSize].height;
    }
    else
    {
        for (UIView *temView in webView.subviews)
        {
            if ([temView isMemberOfClass:[UIScrollView class]])
            {
                UIScrollView *curScrowView = (UIScrollView *)temView;
                if (curScrowView) {
                    scrowViewheight_ = [curScrowView contentSize].height;
                }
                break;
            }
        }
    }
    
    webView_.frame = CGRectMake(webView_.frame.origin.x, webView_.frame.origin.y, webView_.frame.size.width,scrowViewheight_ + (marrgintopSpan - lineHeight/2));
    
    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y,bgImageView.frame.size.width,webView.frame.size.height);
    
    downSplitView.frame = CGRectMake(0, bgImageView.frame.size.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    
    if ([_delegate respondsToSelector:@selector(changeCellHeight:cellHeight:)])
    {
        [_delegate changeCellHeight:self cellHeight:bgImageView.frame.size.height];
    }
    
    [activeView stopAnimating];
    webView.hidden = NO;
}

////购买须知
//-(void) addPurchView:(NSArray *) tipsArr
//{
//    float lastLabelHeight = 25;
//    float spiltSpan = 20 ; //大间隔
//    float smallSpan = 10; //小间隔
//    for (int i =0;i<tipsArr.count ; i++)
//    {
//        NSDictionary *dict=[tipsArr safeObjectAtIndex:i];
//        
//        if (!DICTIONARYHASVALUE(dict))
//        {
//            continue;
//        }
//        
//        UILabel *titleLabel = [UILabel new];
//        titleLabel.frame = CGRectMake(6, lastLabelHeight + (i > 0 ? spiltSpan : 0 ), 100, 20);
//        titleLabel.text = [dict safeObjectForKey:@"title"];
//        titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        [titleLabel sizeToFit];
//        [bgImageView addSubview:titleLabel];
//        [titleLabel release];
//        
//        UILabel *contentLabel = [UILabel new];
//        contentLabel.frame = CGRectMake(17, titleLabel.frame.origin.y + titleLabel.frame.size.height + smallSpan, bgImageView.frame.size.width -34, 20);
//        contentLabel.text = [dict safeObjectForKey:@"content"];
//        contentLabel.font = [UIFont systemFontOfSize:12.0f];
//        contentLabel.numberOfLines = 0;
//        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
//        contentLabel.textColor = RGBACOLOR(34, 34, 34, 1);
//        contentLabel.backgroundColor = [UIColor clearColor];
//        contentLabel.textAlignment=NSTextAlignmentLeft;
//        [bgImageView addSubview:contentLabel];
//        [contentLabel release];
//        
//        CGSize size = CGSizeMake(contentLabel.frame.size.width, MAXFLOAT);
//        CGSize newSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
//        contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, newSize.height);
//        lastLabelHeight=contentLabel.frame.origin.y + contentLabel.frame.size.height;
//    }
//    
//    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, lastLabelHeight + 25);
//    
//    downSplitView.frame = CGRectMake(0, bgImageView.frame.size.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
//}

@end
