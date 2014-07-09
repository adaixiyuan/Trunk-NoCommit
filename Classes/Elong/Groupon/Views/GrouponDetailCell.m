//
//  GrouponDetailCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponDetailCell.h"

@implementation GrouponDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];
        
        UIImage *stretchImg = [UIImage noCacheImageNamed:@"fillorder_cell_stretch.png"];
        UIImage *newImg = [stretchImg stretchableImageWithLeftCapWidth:14
                                               topCapHeight:14];
        
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
        [self.contentView addSubview:bgImageView];
        bgImageView.image = newImg;
        [bgImageView release];
        
        // title
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300 - 24, 32)];
        titleLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        titleLbl.textColor = [UIColor blackColor];//[UIColor colorWithRed:32.0/255.0f green:32.0/255.0f blue:32.0/255.0f alpha:1];
        titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLbl];
        [titleLbl release];
        
        // 分割线
        UIImageView *splitImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        [self.contentView addSubview:splitImageView];
        splitImageView.frame = CGRectMake(12, 33, 300 - 24, 1);
        [splitImageView release];

        
        if(IOSVersion_5){
            // detail
            detailLbl = [[UIWebView alloc] initWithFrame:CGRectMake(12, 32 + 10, 300-24, 50)];
            detailLbl.scalesPageToFit = NO;
            detailLbl.scrollView.scrollEnabled = NO;
            detailLbl.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
            [self.contentView addSubview:detailLbl];
            detailLbl.delegate = self;
            [detailLbl release];
        }else{
            detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,32 + 10,300 - 24,50)];
            detailLabel.font = [UIFont systemFontOfSize:14.0f];
            detailLabel.numberOfLines = 0;
            detailLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            detailLabel.textColor = [UIColor colorWithRed:52.0f/255.0f green:52.0f/255.0f blue:52.0f/255.0f alpha:1];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.adjustsFontSizeToFitWidth = YES;
            detailLabel.minimumFontSize = 12.0f;
            [self.contentView addSubview:detailLabel];
            [detailLabel release];
        }

        [UIView setAnimationsEnabled:YES];
    }
    return self;
}


// 设置左侧标题
- (void) setTitle:(NSString *)title{
    titleLbl.text = title;
    
}

// 设置右标题
- (void) setDetail:(NSString *)detail{
    
    if (IOSVersion_5) {
        CGSize size = CGSizeMake(detailLbl.frame.size.width, 100000);
        CGSize newSize = [detail sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        detailLbl.frame = CGRectMake(detailLbl.frame.origin.x, detailLbl.frame.origin.y, detailLbl.frame.size.width, newSize.height);
        bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, 32 + newSize.height + 10 + 10);
        //detailLbl.text = detail;
        NSArray *dateArray = [detail componentsMatchedByRegex:@"[\\d]{4}/[\\d]{1,2}/[\\d]{1,2}"];
        for (NSString *dateStr in dateArray) {
            detail = [detail stringByReplacingOccurrencesOfString:dateStr withString:[dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
        }
        NSString *htmlStr = [NSString stringWithFormat:@"<html><head><link href='content.css' rel='stylesheet' type='text/css' /></head><body style='padding:0px;margin:0px;background-color:#f9f9f9'><div style = 'font-size:14px;line-height:18px;color:#525252;padding:0px;margin:0px;'>%@</div></body></html>",detail];
        [detailLbl loadHTMLString:htmlStr baseURL:nil];
    }else{
        CGSize size = CGSizeMake(detailLabel.frame.size.width, 100000);
        CGSize newSize = [detail sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width, newSize.height);
        bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, 32 + newSize.height + 10 + 10);
        detailLabel.text = detail;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL absoluteString];
    if([urlStr hasPrefix:@"about:"]||[urlStr hasPrefix:@"tel:"]){
        return YES;
    }else{
        [[UIApplication sharedApplication] newOpenURL:request.URL];
        return NO;
    }
}
@end
