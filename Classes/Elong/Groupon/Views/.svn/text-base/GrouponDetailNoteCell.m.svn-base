//
//  GrouponDetailNoteCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponDetailNoteCell.h"

@implementation GrouponDetailNoteCell

-(void) dealloc
{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.55);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
//        UIView *upSplitView = [[UIView alloc] init];
//        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//        upSplitView.backgroundColor=[UIColor colorWithPatternImage:[UIImage noCacheImageNamed:@"tuan_dotline.png"]];
//        [bgImageView addSubview:upSplitView];
//        [upSplitView release];
        
        downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, 45 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
        
        hotelServiceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 9 , bgImageView.frame.size.width - 20,20)];
        hotelServiceLbl.font = [UIFont systemFontOfSize:14.0f];
        hotelServiceLbl.numberOfLines = 0;
        hotelServiceLbl.lineBreakMode = UILineBreakModeCharacterWrap;
        hotelServiceLbl.textColor = RGBACOLOR(34, 34, 34, 1);
        hotelServiceLbl.backgroundColor = [UIColor clearColor];
        [bgImageView addSubview:hotelServiceLbl];
        hotelServiceLbl.hidden=YES;
        [hotelServiceLbl release];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9 , bgImageView.frame.size.width - 20,50)];
        detailLabel.font = [UIFont systemFontOfSize:12.0f];
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        detailLabel.textColor = RGBACOLOR(34, 34, 34, 1);
        detailLabel.backgroundColor = [UIColor whiteColor];
        detailLabel.adjustsFontSizeToFitWidth = YES;
        detailLabel.minimumFontSize = 12.0f;
        [bgImageView addSubview:detailLabel];
        [detailLabel release];
        
        //预约按钮
        UILabel *leftTitleLabel;
        if (IOSVersion_7) {
            leftTitleLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, -2, 73, 18)] autorelease];
        }
        else
        {
            leftTitleLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, -2, 71, 18)] autorelease];
        }
        leftTitleLabel.backgroundColor=[UIColor whiteColor];
        leftTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        leftTitleLabel.textColor = RGBACOLOR(34, 34, 34, 1);
        leftTitleLabel.text = @"在线预约：";
        leftTitleLabel.textAlignment=NSTextAlignmentLeft;
        
        bookOnlineLbl = [[UnderLineLabel alloc] initWithFrame:CGRectMake(10, 59, bgImageView.frame.size.width - 20, 20) leftTitleLabel_:leftTitleLabel];
        bookOnlineLbl.font = [UIFont systemFontOfSize:12.0f];
        bookOnlineLbl.textColor = [UIColor colorWithRed:254.0/255.0 green:75.0/255.0f blue:32/255.0f alpha:1];
        bookOnlineLbl.text = @"";
        bookOnlineLbl.numberOfLines = 0;
        bookOnlineLbl.firstRowStartPoint=60;
        bookOnlineLbl.lineBreakMode = UILineBreakModeWordWrap;
        bookOnlineLbl.backgroundColor = [UIColor whiteColor];
        bookOnlineLbl.userInteractionEnabled=YES;
        [bgImageView addSubview:bookOnlineLbl];
        [bookOnlineLbl release];
        
        UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame=bookOnlineLbl.bounds;
        phoneBtn.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        phoneBtn.backgroundColor=[UIColor clearColor];
        [bookOnlineLbl addSubview:phoneBtn];
        [phoneBtn addTarget:self action:@selector(onlineBookingClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self makeButtomUI];
    }
    return self;
}

-(void) makeButtomUI
{
    buttomView=[[UIView alloc] initWithFrame:CGRectMake(0, detailLabel.frame.origin.y+detailLabel.frame.size.height+9, SCREEN_WIDTH, 20)];
    buttomView.backgroundColor=[UIColor whiteColor];
    [bgImageView addSubview:buttomView];
    [buttomView release];
    
    //下边的两个提示
    UILabel *firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
    firstLabel.backgroundColor=[UIColor whiteColor];
    firstLabel.font=[UIFont systemFontOfSize:12];
    firstLabel.textColor=RGBACOLOR(34, 34, 34, 1);
    firstLabel.textAlignment=NSTextAlignmentLeft;
    firstLabel.text=@"支持随时退款";
    [buttomView addSubview:firstLabel];
    [firstLabel release];
    
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 10, 20)];
    icon.image=[UIImage noCacheImageNamed:@"tuan_duigou.png"];
    icon.contentMode=UIViewContentModeCenter;
    icon.backgroundColor=[UIColor whiteColor];
    [buttomView addSubview:icon];
    [icon release];
    
    UILabel *secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(102, 0, 80, 20)];
    secondLabel.backgroundColor=[UIColor whiteColor];
    secondLabel.font=[UIFont systemFontOfSize:12];
    secondLabel.textColor=RGBACOLOR(34, 34, 34, 1);
    secondLabel.textAlignment=NSTextAlignmentLeft;
    secondLabel.text=@"支持过期退款";
    [buttomView addSubview:secondLabel];
    [secondLabel release];
    
    UIImageView *icon1=[[UIImageView alloc] initWithFrame:CGRectMake(177, 0, 10, 20)];
    icon1.image=[UIImage noCacheImageNamed:@"tuan_duigou.png"];
    icon1.contentMode=UIViewContentModeCenter;
    [buttomView addSubview:icon1];
    [icon1 release];
}

-(void) setHotelServiceLblTxt:(NSString *) hotelServiceLblTxt
{
    if (STRINGHASVALUE(hotelServiceLblTxt))
    {
        hotelServiceLbl.text=hotelServiceLblTxt;
        CGSize size = CGSizeMake(hotelServiceLbl.frame.size.width, 100000);
        CGSize newSize = [hotelServiceLbl.text sizeWithFont:hotelServiceLbl.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        hotelServiceLbl.frame=CGRectMake(hotelServiceLbl.frame.origin.x, hotelServiceLbl.frame.origin.y,hotelServiceLbl.frame.size.width,newSize.height);
        detailLabel.frame=CGRectMake(detailLabel.frame.origin.x, hotelServiceLbl.frame.origin.y+hotelServiceLbl.frame.size.height+4, detailLabel.frame.size.width, detailLabel.frame.size.height);
        hotelServiceLbl.hidden=NO;
    }
    else
    {
        hotelServiceLbl.hidden=YES;
        detailLabel.frame=CGRectMake(detailLabel.frame.origin.x, 9, detailLabel.frame.size.width, detailLabel.frame.size.height);
    }
    
    buttomView.frame=CGRectMake(0, detailLabel.frame.origin.y+detailLabel.frame.size.height+9, SCREEN_WIDTH, buttomView.frame.size.height);
}

//在线预约
-(void) onlineBookingClick:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TuanOnlineAppoint object:nil];
}

// 设置右标题
- (void) setDetail:(NSString *)detail qianDianUrl:(NSString *) qianDianUrl
{
    CGSize size = CGSizeMake(detailLabel.frame.size.width, 100000);
    CGSize newSize = [detail sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    if (IOSVersion_7&&!STRINGHASVALUE(qianDianUrl))
    {
        int theHeight=newSize.height;
        theHeight+=1;
        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width, theHeight);
    }
    else
    {
        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width, newSize.height);
    }
    
    buttomView.frame=CGRectMake(0, detailLabel.frame.origin.y+detailLabel.frame.size.height+9, SCREEN_WIDTH, buttomView.frame.size.height);
    
    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, detailLabel.frame.origin.y+newSize.height + 9 + buttomView.frame.size.height+5);
    detailLabel.text = detail;
    downSplitView.frame = CGRectMake(0, bgImageView.frame.size.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    
    if (STRINGHASVALUE(qianDianUrl))
    {
        NSRange range = [detail rangeOfString:@"在线预约： "];
        if(range.length>0)
        {
            NSString *topStr = [detail substringToIndex:range.location];
            
            bookOnlineLbl.text=qianDianUrl;
            
            //top Str的高度
            CGSize temSize = CGSizeMake(detailLabel.frame.size.width, 100000);
            CGSize topStrNewSize = [topStr sizeWithFont:detailLabel.font constrainedToSize:temSize lineBreakMode:UILineBreakModeCharacterWrap];
            //在线预约的高度
            CGSize onlineBookNewSize = [bookOnlineLbl.text sizeWithFont:bookOnlineLbl.font constrainedToSize:temSize lineBreakMode:UILineBreakModeCharacterWrap];
            //小于15会出现横线
            if (onlineBookNewSize.height<15)
            {
                bookOnlineLbl.frame = CGRectMake(bookOnlineLbl.frame.origin.x, detailLabel.frame.origin.y+topStrNewSize.height, bookOnlineLbl.frame.size.width, 15);
            }
            else
            {
                bookOnlineLbl.frame = CGRectMake(bookOnlineLbl.frame.origin.x, detailLabel.frame.origin.y+topStrNewSize.height, bookOnlineLbl.frame.size.width, onlineBookNewSize.height);
            }

            bookOnlineLbl.hidden=NO;
        }
        else
        {
            bookOnlineLbl.hidden=YES;
        }
    }
    else
    {
        bookOnlineLbl.hidden=YES;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL absoluteString];
    if([urlStr hasPrefix:@"about:"]||[urlStr hasPrefix:@"tel:"]){
        return YES;
    }else{
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
}

@end
