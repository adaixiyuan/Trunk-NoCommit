//
//  GrouponDetailOrderCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponDetailOrderCell.h"

@implementation GrouponDetailOrderCell

-(void) dealloc
{
    [shortString release];
    
    [allString release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier detail:(NSString *) detail curDelegate:(id)curDelegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _delegate=curDelegate;
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, 45- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
        
        // 详情
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
        
        [self setStringValue:detail];
        
        [self setWebHtmlString:NO];
        
        //更多按钮
        if (shortString)
        {
            moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.frame= bgImageView.bounds;
            moreButton.backgroundColor=[UIColor clearColor];
            [moreButton setTitleColor:RGBACOLOR(27, 99, 220, 1) forState:UIControlStateNormal];
            [moreButton setTitle:@"更多" forState:UIControlStateNormal];
            moreButton.titleLabel.font= [UIFont systemFontOfSize:13.0];
            [moreButton addTarget:self action:@selector(showMoreContent) forControlEvents:UIControlEventTouchUpInside];
            [bgImageView addSubview:moreButton];
            moreButton.hidden = YES;
        }
    }
    
    return self;
}

-(float) getDetailLabelHeight
{
    return bgImageView.frame.size.height;
}

//显示更多
-(void) showMoreContent
{
    if (isShowAllState)
    {
        return;
    }
    
    [self setWebHtmlString:YES];
    
    isShowAllState = YES;
    
    if ([_delegate respondsToSelector:@selector(changeCellHeight:cellHeight:)])
    {
        [_delegate changeCellHeight:self cellHeight:bgImageView.frame.size.height];
    }
}

//设置短字符串
-(void) setStringValue:(NSString *) detail
{
    if (STRINGHASVALUE(detail))
    {
        detail = [detail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    detail = [detail stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    detail = [detail stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    allString = [detail copy];
    
    NSString *maxTxt = @"酒店座落于东城区东直门外酒店座落于东城区东直门外外酒店座落于东外酒店";
    
    CGSize maxTxtSize = [maxTxt sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGSize detailSize = [detail sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    if (detailSize.width>maxTxtSize.width)
    {
        for (int i=0; i<detail.length; i++)
        {
            NSString *temString = [detail substringToIndex:i+1];
            
            CGSize temStringSize = [temString sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
            
            if (temStringSize.width>=maxTxtSize.width)
            {
                shortString= temString;
                break;
            }
        }
        
        if (shortString)
        {
            shortString = [[NSString stringWithFormat:@"%@...",shortString] retain];
        }
        else
        {
            shortString = [[NSString stringWithFormat:@"%@...",allString] retain];
        }
    }
    else
    {
        shortString = [[NSString stringWithFormat:@"%@...",allString] retain];
    }
}

-(void) setWebHtmlString:(BOOL) isLongString
{
    NSMutableString *htmlString = [NSMutableString string];
    //默认缩略图
    if (!isLongString)
    {
        [htmlString appendFormat:@"<div style = 'font-size:13px;padding-left:0px;line-height:22px;color:#343434;margin-top:5px'>%@</div>",
         shortString];
    }
    else
    {
        [htmlString appendFormat:@"<div style = 'font-size:13px;padding-left:0px;line-height:22px;color:#343434;margin-top:5px'>%@</div>",
         allString];
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
    
    webView_.frame = CGRectMake(webView_.frame.origin.x, webView_.frame.origin.y, webView_.frame.size.width,scrowViewheight_);
    
    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y,bgImageView.frame.size.width,webView.frame.size.height);
    
    downSplitView.frame = CGRectMake(0, bgImageView.frame.size.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    
    if (isShowAllState)
    {
        moreButton.hidden = YES;
    }
    else
    {
        [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(bgImageView.frame.size.height - 37, 278, 0, 0)];
        moreButton.hidden = NO;
        moreButton.frame= bgImageView.bounds;
    }
    
    if ([_delegate respondsToSelector:@selector(changeCellHeight:cellHeight:)])
    {
        [_delegate changeCellHeight:self cellHeight:bgImageView.frame.size.height];
    }
    
    webView.hidden = NO;
}

@end
