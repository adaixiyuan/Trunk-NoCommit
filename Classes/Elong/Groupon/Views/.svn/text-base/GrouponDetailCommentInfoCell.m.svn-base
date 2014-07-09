//
//  GrouponDetailCommentInfoCell.m
//  ElongClient
//  团购详情评论和倒计时cell
//  Created by garin on 14-5-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponDetailCommentInfoCell.h"

@implementation GrouponDetailCommentInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier multiple:(BOOL) multiple_
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        isMultiple=multiple_;
        
        // Initialization code
        float cellHeight = 75;
        
        // 背景色
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];

        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        [self createLeftView];
        
        if (!isMultiple)
        {
            [self createRightSingleHotelView];
            shuSplitView.hidden=NO;
        }
        else
        {
            [self createRightMutipleHotelCommentView];
            shuSplitView.hidden=YES;
        }
            
        UIImageView *downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, cellHeight- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
        
        //评论loadingview
        activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width / 4 * 3 - 10, bgImageView.frame.size.height / 2-10, 20, 20)];
        activeView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [bgImageView addSubview:activeView];
        [activeView release];
    }
    return self;
}

//左半部分
-(void) createLeftView
{
    //左上
    UIImageView *tuanCntIcon = [[UIImageView alloc] initWithFrame:CGRectMake(9, 11, 24, 24)];
    tuanCntIcon.image=[UIImage noCacheImageNamed:@"tuanCnt.png"];
    [bgImageView addSubview:tuanCntIcon];
    [tuanCntIcon release];
    
    tuanCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 15, 40, 20)];
    tuanCntLabel.textColor= [UIColor redColor];
    tuanCntLabel.font=[UIFont systemFontOfSize:16];
    tuanCntLabel.text=@"1980";
    tuanCntLabel.backgroundColor=[UIColor clearColor];
    [bgImageView addSubview:tuanCntLabel];
    [tuanCntLabel release];
    
    tuanCntDespLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 14, 50, 20)];
    tuanCntDespLabel.textColor= RGBCOLOR(52, 52, 52, 1);
    tuanCntDespLabel.font=[UIFont systemFontOfSize:14];
    tuanCntDespLabel.text=@"人已团";
    tuanCntDespLabel.backgroundColor=[UIColor clearColor];
    [bgImageView addSubview:tuanCntDespLabel];
    [tuanCntDespLabel release];
    
    //左下
    tuanTimeEclipseIcon = [[UIImageView alloc] initWithFrame:CGRectMake(9, 40, 24, 24)];
    tuanTimeEclipseIcon.image=[UIImage noCacheImageNamed:@"tuanTimeEclipse.png"];
    [bgImageView addSubview:tuanTimeEclipseIcon];
    [tuanTimeEclipseIcon release];
    
    tuanEclipseLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 42, 130, 20)];
    tuanEclipseLabel.textColor= RGBCOLOR(118, 118, 118, 1);
    tuanEclipseLabel.font=[UIFont systemFontOfSize:12];
    tuanEclipseLabel.backgroundColor=[UIColor clearColor];
    tuanEclipseLabel.text=@"还剩31天6小时20分";
    [bgImageView addSubview:tuanEclipseLabel];
    [tuanEclipseLabel release];
    
    //分割线
    shuSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 7, 0.55, 60)];
    shuSplitView.image = [UIImage noCacheImageNamed:@"groupon_detail_cell_split.png"];
    [bgImageView addSubview:shuSplitView];
    [shuSplitView release];
}

//右半部分 单店
-(void) createRightSingleHotelView
{
    singleCommentView =[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+1, 0, SCREEN_WIDTH/2-1,75)];
    singleCommentView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:singleCommentView];
    [singleCommentView release];
    
    goodCommentCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 110, 20)];
    goodCommentCntLabel.textColor= RGBCOLOR(187, 187, 187, 1);
    goodCommentCntLabel.font=[UIFont systemFontOfSize:24];
    goodCommentCntLabel.backgroundColor=[UIColor clearColor];
    goodCommentCntLabel.text=@"";
    [singleCommentView addSubview:goodCommentCntLabel];
    [goodCommentCntLabel release];
    
    goodCommentCntDespLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 45, 20)];
    goodCommentCntDespLabel.textColor= RGBCOLOR(52, 52, 52, 1);
    goodCommentCntDespLabel.font=[UIFont systemFontOfSize:16];
    goodCommentCntDespLabel.backgroundColor=[UIColor clearColor];
    goodCommentCntDespLabel.text=@"好评";
    [singleCommentView addSubview:goodCommentCntDespLabel];
    [goodCommentCntDespLabel release];
    
    lookCommentSingleHotelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookCommentSingleHotelBtn.backgroundColor=[UIColor clearColor];
    lookCommentSingleHotelBtn.frame=singleCommentView.bounds;
    [lookCommentSingleHotelBtn addTarget:self action:@selector(lookSingleHotelComment) forControlEvents:UIControlEventTouchUpInside];
    [singleCommentView addSubview:lookCommentSingleHotelBtn];
    
    UILabel *despLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 42, 55, 20)];
    despLabel1.textColor= RGBCOLOR(254, 75, 32, 1);
    despLabel1.font=[UIFont systemFontOfSize:12];
    despLabel1.backgroundColor=[UIColor clearColor];
    despLabel1.text=@"查看全部";
    [lookCommentSingleHotelBtn addSubview:despLabel1];
    [despLabel1 release];
    
    comentCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 42, 38, 20)];
    comentCntLabel.textColor= RGBCOLOR(254, 75, 32, 1);
    comentCntLabel.font=[UIFont systemFontOfSize:16];
    comentCntLabel.textAlignment=NSTextAlignmentLeft;
    comentCntLabel.backgroundColor=[UIColor clearColor];
    comentCntLabel.text=@"";
    [lookCommentSingleHotelBtn addSubview:comentCntLabel];
    [comentCntLabel release];
    
    despLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(101, 42, 36, 20)];
    despLabel2.textColor= RGBCOLOR(254, 75, 32, 1);
    despLabel2.font=[UIFont systemFontOfSize:12];
    despLabel2.backgroundColor=[UIColor clearColor];
    despLabel2.text=@"条评论";
    [lookCommentSingleHotelBtn addSubview:despLabel2];
    [despLabel2 release];
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(singleCommentView.frame.size.width-14, 39/2-8 +36, 5, 9)];
    rightIcon.image=[UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [lookCommentSingleHotelBtn addSubview:rightIcon];
    [rightIcon release];
    
    noCommentTip = [[UILabel alloc] init];
    noCommentTip.frame = CGRectMake(15, 36 + 6, 55, 20);
    noCommentTip.backgroundColor = [UIColor clearColor];
    noCommentTip.text = @"暂无评论";
    noCommentTip.textColor= RGBCOLOR(118, 118, 118, 1);
    noCommentTip.font=[UIFont systemFontOfSize:12];
    noCommentTip.textAlignment = NSTextAlignmentLeft;
    [singleCommentView addSubview:noCommentTip];
    [noCommentTip release];
    noCommentTip.hidden = YES;
}

//右半部分 多店
-(void) createRightMutipleHotelCommentView
{
    mutipleCommentView =[UIButton buttonWithType:UIButtonTypeCustom];
    mutipleCommentView.frame=CGRectMake(SCREEN_WIDTH/2+1, 0, SCREEN_WIDTH/2-1,75);
    mutipleCommentView.backgroundColor = [UIColor clearColor];
    [mutipleCommentView addTarget:self action:@selector(lookMutipleHotelComment) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:mutipleCommentView];
    
    UILabel *multipleHotelLabel = [[UILabel alloc] initWithFrame:CGRectMake(mutipleCommentView.frame.size.width-15-12-68, 75/2-9, 68, 20)];
    multipleHotelLabel.textColor= RGBCOLOR(254, 75, 32, 1);
    multipleHotelLabel.font=[UIFont systemFontOfSize:16];
    multipleHotelLabel.backgroundColor=[UIColor clearColor];
    multipleHotelLabel.text=@"多店评论";
    multipleHotelLabel.textAlignment=NSTextAlignmentRight;
    [mutipleCommentView addSubview:multipleHotelLabel];
    [multipleHotelLabel release];
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(mutipleCommentView.frame.size.width-15, 75/2-4, 5, 9)];
    rightIcon.image=[UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [mutipleCommentView addSubview:rightIcon];
    [rightIcon release];
}

- (void) setGoodCommentNum:(NSInteger)good badCommentNum:(NSInteger)bad
{
    if (isMultiple)
    {
        return;
    }
    
    //好评率
    if (good+bad == 0)
    {
        if (good == 0&&bad==0)
        {
            goodCommentCntLabel.text = @"100%";
        }
        else
        {
            goodCommentCntLabel.text = @"0%";
        }
    }
    else
    {
        goodCommentCntLabel.text = [NSString stringWithFormat:@"%.f%%",ceil((good*100 + 0.0)/(good + bad))];
    }
    CGSize titleSize = [goodCommentCntLabel.text sizeWithFont:goodCommentCntLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    goodCommentCntDespLabel.frame = CGRectMake(goodCommentCntLabel.frame.origin.x+titleSize.width+5, goodCommentCntDespLabel.frame.origin.y, goodCommentCntDespLabel.frame.size.width, goodCommentCntDespLabel.frame.size.height);
    
    //评论数
    if (good+bad == 0)
    {
        noCommentTip.hidden = NO;
        lookCommentSingleHotelBtn.hidden=YES;
        return;
    }
    else
    {
        noCommentTip.hidden = YES;
        lookCommentSingleHotelBtn.hidden = NO;
        comentCntLabel.text = [NSString stringWithFormat:@"%d",good + bad];
    }
    titleSize = [comentCntLabel.text sizeWithFont:comentCntLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    despLabel2.frame=CGRectMake(comentCntLabel.frame.origin.x+titleSize.width, despLabel2.frame.origin.y, despLabel2.frame.size.width, despLabel2.frame.size.height);
}

//查看单店评论
-(void) lookSingleHotelComment
{
    NSLog(@"lookSingleHotelComment");
    
    if ([_delegate respondsToSelector:@selector(grouponDetailCommentCellCommenting:)]) {
        [_delegate grouponDetailCommentCellCommenting:self];
    }
}

//查看多店评论
-(void) lookMutipleHotelComment
{
    NSLog(@"lookMutipleHotelComment");
    
    if ([_delegate respondsToSelector:@selector(grouponDetailCommentCellCommenting:)]) {
        [_delegate grouponDetailCommentCellCommenting:self];
    }
}

//已团人数
-(void) setTuanCnt:(int) cnt
{
    tuanCntLabel.text= [NSString stringWithFormat:@"%d",cnt];
    CGSize titleSize = [tuanCntLabel.text sizeWithFont:tuanCntLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    tuanCntLabel.frame=CGRectMake(tuanCntLabel.frame.origin.x,tuanCntLabel.frame.origin.y, titleSize.width, tuanCntLabel.frame.size.height);
    tuanCntDespLabel.frame=CGRectMake(tuanCntLabel.frame.origin.x+titleSize.width+5, tuanCntDespLabel.frame.origin.y, tuanCntDespLabel.frame.size.width, tuanCntDespLabel.frame.size.height);
}

//团购剩余时间
-(void) setTimeEclipse:(NSString *) leftTime
{
    tuanEclipseLabel.text=leftTime;
    if (STRINGHASVALUE(leftTime))
    {
        tuanTimeEclipseIcon.hidden=NO;
    }
    else
    {
        tuanTimeEclipseIcon.hidden=YES;
    }
}

- (void) showCommentLoading
{
    [activeView startAnimating];
    singleCommentView.hidden = YES;
}

- (void) hideCommentLoading
{
    [activeView stopAnimating];
    singleCommentView.hidden = NO;
}

@end
