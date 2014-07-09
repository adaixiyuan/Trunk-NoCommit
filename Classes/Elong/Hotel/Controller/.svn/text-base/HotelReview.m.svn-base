//
//  TestTableView4ViewController.m
//  TestTableView4
//
//  Created by bin xing on 11-1-22.
//  Copyright 2011 DP. All rights reserved.
//
#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 5.0f
#define CONTENT_WIDTH	280

#define GOOD 0
#define MIDDLE 1
#define BAD 2
#define UNKNOWN 3
#define ALL	4

#define kSeperatorLineTag   1024
#define kGoodImageViewTag   (kSeperatorLineTag + 1)
#define kBadImageViewTag    (kSeperatorLineTag + 2)

#import "HotelReview.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "ReviewCell.h"
#import "RateBarView.h"
#import "HotelDetailController.h"

typedef enum {
    CommentTypeAll,
    CommentTypeGood,
    CommentTypeBad
}CommentType;

@interface HotelReview()

@property (nonatomic, retain) CustomSegmented *segmentedView;

@end

@implementation HotelReview
@synthesize morebutton;
@synthesize hotelId;
@synthesize totalCount;
@synthesize goodCount;
@synthesize badCount;
@synthesize commentDelegate;


- (void)dealloc {
    if (commentReq) {
        [commentReq cancel];
        SFRelease(commentReq);
    }
    
    if (goodCommentReq) {
        [goodCommentReq cancel];
        SFRelease(goodCommentReq);
    }
    
    if (badCommentReq) {
        [badCommentReq cancel];
        SFRelease(badCommentReq);
    }
    
	self.morebutton = nil;
    self.hotelId = nil;
    
    [allCommentHeights release];
	[goodCommentHeights release];
	[badCommentHeights release];
	[reviewlist release];
	[goodreviewlist release];
	[badreviewlist release];
    [smallLoading release];
    [footView release];
    
    self.segmentedView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	if (self = [super initWithFrame:frame style:style]) {
		reviewlist = [[NSMutableArray alloc] init];
		goodreviewlist = [[NSMutableArray alloc] init];
		badreviewlist = [[NSMutableArray alloc] init];
		self.backgroundColor=RGBACOLOR(248, 248, 248, 1);
		self.delegate=self;
		self.dataSource=self;
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
		
        allCommentHeights = [[NSMutableArray alloc] initWithCapacity:2];
        goodCommentHeights = [[NSMutableArray alloc] initWithCapacity:2];
        badCommentHeights = [[NSMutableArray alloc] initWithCapacity:2];
        
        // 添加更多按钮
		[self makeMoreLoadingView];
        
        smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (self.frame.size.height-50) / 2, 50, 50)];
        [self addSubview:smallLoading];
        
        [smallLoading startLoading];
	}
	
	return self;
}


- (void)makeMoreLoadingView {
	footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 47)];
	
	UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiView.center = footView.center;
    [aiView startAnimating];
	[footView addSubview:aiView];
    [aiView release];
    
    self.morebutton = [[[UIButton alloc] initWithFrame:footView.frame] autorelease];
    morebutton.titleLabel.font = FONT_14;
    morebutton.adjustsImageWhenHighlighted = NO;
    [morebutton setTitle:@"点击加载更多评论" forState:UIControlStateNormal];
    [morebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
}


-(int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width{
	
    
    CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
    if (IOSVersion_7) {
        return expectedLabelSize.height + 10;
    }
    return expectedLabelSize.height;
}


- (void)clickMoreButton {
    isRequstMore = NO;
    self.tableFooterView = footView;
    [self morecomments];
}


-(void)clearDataSource{
	[reviewlist removeAllObjects];
}


- (void)requestCommontByType:(CommentType)type {
    switch (type) {
        case CommentTypeAll: {
            JHotelComments *hotelcomments = [HotelPostManager hotelcomments];
            [hotelcomments setCommentsTpye:0];
            currentIndex = -1;
            [hotelcomments clearBuildData];
            [hotelcomments setGrouponHotelId:self.hotelId];
            
            [self searchHotelComments];
        }
            
            break;
        case CommentTypeGood: {
            JHotelComments *hotelcomments = [HotelPostManager hotelgoodcomments];
            [hotelcomments setCommentsTpye:1];
            currentIndex = 0;
            [hotelcomments clearBuildData];
            [hotelcomments setGrouponHotelId:self.hotelId];
            
            [self searchHotelCommentsbygood];
        }
            
            break;
        case CommentTypeBad: {
            JHotelComments *hotelcomments = [HotelPostManager hotelbadcomments];
            [hotelcomments setCommentsTpye:2];
            currentIndex = 1;
            [hotelcomments clearBuildData];
            [hotelcomments setGrouponHotelId:self.hotelId];
            
            [self searchHotelCommentsbybad];
        }
            
            break;
        default:
            break;
    }
    
    [smallLoading startLoading];
    [self bringSubviewToFront:smallLoading];
}

- (void) searchHotelCommentsWithId:(NSString *)pid{
    self.hotelId = pid;
    // 全部评论
	[self clearDataSource];
    [self requestCommontByType:CommentTypeAll];
}

- (void) breakRequest{
    if (commentReq) {
        [commentReq cancel];
        SFRelease(commentReq);
    }
    if (goodCommentReq) {
        [goodCommentReq cancel];
        SFRelease(goodCommentReq);
    }
    if (badCommentReq) {
        [badCommentReq cancel];
        SFRelease(badCommentReq);
    }

}

-(void)searchHotelComments{
    // 显示所有评论
    [self breakRequest];
    
    commentReq = [[HttpUtil alloc] init];
    [commentReq connectWithURLString:HOTELSEARCH
                             Content:[[HotelPostManager hotelcomments] requesString:YES]
                        StartLoading:NO
                          EndLoading:NO
                          AutoReload:YES
                            Delegate:self];
}

-(void)searchHotelCommentsbygood{
    // 显示好评
    [self breakRequest];
    
    goodCommentReq = [[HttpUtil alloc] init];
    [goodCommentReq connectWithURLString:HOTELSEARCH
                             Content:[[HotelPostManager hotelgoodcomments] requesString:YES]
                        StartLoading:NO
                          EndLoading:NO
                          AutoReload:YES
                            Delegate:self];
}

-(void)searchHotelCommentsbybad{
    // 显示差评
     [self breakRequest];
    
    badCommentReq = [[HttpUtil alloc] init];
    [badCommentReq connectWithURLString:HOTELSEARCH
                                 Content:[[HotelPostManager hotelbadcomments] requesString:YES]
                            StartLoading:NO
                              EndLoading:NO
                              AutoReload:YES
                                Delegate:self];
}

-(void)morecomments{
    JHotelComments *hotelcomments;
    switch (currentIndex) {
        case -1: {
            hotelcomments = [HotelPostManager hotelcomments];
            [hotelcomments setCommentsTpye:(0)];
            [hotelcomments nextPage];
            
            [self searchHotelComments];
        }
            break;
        case 0: {
            hotelcomments = [HotelPostManager hotelgoodcomments];
            [hotelcomments setCommentsTpye:(1)];
            [hotelcomments nextPage];
            
            [self searchHotelCommentsbygood];
        }
            break;
        case 1: {
            hotelcomments = [HotelPostManager hotelbadcomments];
            [hotelcomments setCommentsTpye:(2)];
            [hotelcomments nextPage];
            
            [self searchHotelCommentsbybad];
        }
            break;
    }
    
    self.tableFooterView = footView;
}


- (void)dealNetErrorStats {
    [smallLoading stopLoading];
    
    if (([reviewlist count] == 0 && currentIndex == -1 ) ||
        ([goodreviewlist count] == 0 && currentIndex == 0) ||
        ([badreviewlist count] == 0 && currentIndex == 1)) {
        // 如果什么数据都没有获取到的情况下，提示未能获取数据
//        m_tipView = [Utils addView:@"未能获取评论数据"];
//        CGRect oldframe=m_tipView.frame;
//        oldframe.origin.y=168;
//        m_tipView.frame=oldframe;
//        
//        [self addSubview:m_tipView];
    }
    else {
        // 只是更多数据请求失败时，切换更多按钮
        isRequstMore = YES;
        self.tableFooterView = morebutton;
    }
}

/// <summary>
/// 计算评分
/// </summary>
/// <param name="badComm"></param>
/// <param name="goodComm"></param>
/// <returns></returns>
- (NSString *) getHotelRating{
    float rating = 4.2;
    if (badCount != 0 && goodCount != 0)
        rating = 2.0 + 3.0 * goodCount / (goodCount + badCount);
    return [NSString stringWithFormat:@"%.1f",rating];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 更改评分和好差评分段的层次, 返回数量都-1
    switch (currentIndex) {
        case -1:{
            NSInteger count = [reviewlist count];
            if (count) {
                return count;
            }else{
                return 0;
            }
            break;
        }
        case 0:{
            NSInteger count = [goodreviewlist count];
            if (count) {
                return count;
            }else{
                return 0;
            }
            break;
        }
        case 1:{
            NSInteger count = [badreviewlist count];
            if (count) {
                return count;
            }else{
                return 0;
            }
            break;
        }
        default:{
            NSInteger count = [reviewlist count];
            if (count) {
                return count;
            }else{
                return 0;
            }
            break;
        }
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger count = [reviewlist count];
    if (count) {
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    // 更改评分和好差评分段的层次, 加入评分
    return 44 + 72;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    sectionView.userInteractionEnabled = YES;
    sectionView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    NSArray *titleArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"好评(%d条)",goodCount], [NSString stringWithFormat:@"差评(%d条)",badCount], nil];
    
    if (_segmentedView == nil) {
        CustomSegmented *commentSeg = [[CustomSegmented alloc] initSegmentedWithFrame:CGRectMake(10, 7 + 72, 300, 30) titles:titleArray normalIcons:nil highlightIcons:nil];
        commentSeg.selectedIndex = currentIndex;
        commentSeg.delegate = self;
        self.segmentedView = commentSeg;
        
        UIImageView *goodView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 7.0f, 16.0f, 16.0f)];
        goodView.image = [UIImage noCacheImageNamed:@"ico_smile_blue.png"];
        goodView.highlightedImage = [UIImage noCacheImageNamed:@"ico_smile_white.png"];
        goodView.highlighted = YES;
        goodView.tag = kGoodImageViewTag;
        [commentSeg addSubview:goodView];
        [goodView release];
        
        UIImageView *badView = [[UIImageView alloc] initWithFrame:CGRectMake(277.0f, 7.0f, 16.0f, 16.0f)];
        badView.image = [UIImage noCacheImageNamed:@"ico_cry_blue.png"];
        badView.highlightedImage = [UIImage noCacheImageNamed:@"ico_cry_white.png"];
        badView.highlighted = NO;
        badView.tag = kBadImageViewTag;
        [commentSeg addSubview:badView];
        [badView release];
        
        [commentSeg release];
    }
    [sectionView addSubview:_segmentedView];
    
    
    UIImageView *dashLineView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE + 72, SCREEN_WIDTH, SCREEN_SCALE)];
    dashLineView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [sectionView addSubview:dashLineView0];
    [dashLineView0 release];
    
    // 更改评分和好差评分段的层次, 加入评分
    // 计算好评率 四舍五入
    NSInteger favRate = 0;
    NSInteger goodComment = goodCount; //[[[HotelDetail hoteldetail] safeObjectForKey:RespHL__GoodCommentCount_I] intValue];
    NSInteger badComment = badCount;   //[[[HotelDetail hoteldetail] safeObjectForKey:RespHL__BadCommentCount_I] intValue];
    
    if (goodComment + badComment == 0) {
        favRate = 0;
    }else{
        favRate = ceil(goodComment * 100/ (goodComment + badComment + 0.0f));
    }
    
    UILabel *praiseRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 72)];
    UILabel *tLabel_3 = [[UILabel alloc] init];
    UILabel *tLabel_1 = [[UILabel alloc] init];
    NSString *favRateString = nil;
    
    if ([[HotelDetailController hoteldetail] safeObjectForKey:@"CommentPoint"]&&[[HotelDetailController hoteldetail] safeObjectForKey:@"CommentPoint"]!=[NSNull null])
    {
        float commentPoint = [[[HotelDetailController hoteldetail] safeObjectForKey:@"CommentPoint"] floatValue];
        
        if (commentPoint>0)
        {
            favRateString = [NSString stringWithFormat:@"%.0f",commentPoint*100];
        }
        else
        {
            praiseRateLabel.hidden=YES;
            tLabel_1.hidden=YES;
            tLabel_3.hidden=YES;
        }
    }
    
    praiseRateLabel.backgroundColor = [UIColor clearColor];
    praiseRateLabel.text = favRateString?favRateString:[NSString stringWithFormat:@"%d", favRate];
    praiseRateLabel.textColor = RGBACOLOR(254, 75, 32, 1);
    praiseRateLabel.textAlignment = UITextAlignmentLeft;
    praiseRateLabel.font = [UIFont boldSystemFontOfSize:35];
    [sectionView addSubview:praiseRateLabel];
    [praiseRateLabel release];
    
    CGSize praiseSize=[praiseRateLabel.text sizeWithFont:praiseRateLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 72)];
    praiseRateLabel.frame=CGRectMake(praiseRateLabel.frame.origin.x, praiseRateLabel.frame.origin.y, praiseSize.width, praiseRateLabel.frame.size.height);
    
    
    tLabel_3.frame=CGRectMake(praiseRateLabel.frame.origin.x+praiseRateLabel.frame.size.width, 30, 20, 20);
    tLabel_3.backgroundColor = [UIColor clearColor];
    tLabel_3.text = @"%";
    tLabel_3.textColor = RGBACOLOR(254, 75, 32, 1);
    tLabel_3.font = FONT_20;
    [sectionView addSubview:tLabel_3];
    [tLabel_3 release];
    
    tLabel_1.frame=CGRectMake(tLabel_3.frame.origin.x+tLabel_3.frame.size.width, 32, 50, 20);
    tLabel_1.backgroundColor = [UIColor clearColor];
    tLabel_1.text = @"客户好评";
    tLabel_1.font = [UIFont systemFontOfSize:11];
    tLabel_1.textColor = RGBACOLOR(103, 103, 103, 1);
    [sectionView addSubview:tLabel_1];
    [tLabel_1 release];
    
    
    // 右半部分
    
    UILabel *goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 18, 160, 20)];
    goodLabel.backgroundColor = [UIColor clearColor];
    goodLabel.text = [NSString stringWithFormat:@"好评"];
    goodLabel.textColor = [UIColor grayColor];
    goodLabel.adjustsFontSizeToFitWidth = YES;
    goodLabel.font = FONT_11;
    [sectionView addSubview:goodLabel];
    [goodLabel release];
    
    UILabel *badLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 42, 160, 20)];
    badLabel.backgroundColor = [UIColor clearColor];
    badLabel.text = [NSString stringWithFormat:@"差评"];
    badLabel.textColor = [UIColor grayColor];
    badLabel.adjustsFontSizeToFitWidth = YES;
    badLabel.font = FONT_11;
    [sectionView addSubview:badLabel];
    [badLabel release];
    
    RateBarView *goodCommentBar = [[RateBarView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 108 - 15, 20, 108, 15) Rate:favRate/100.0];
    [sectionView addSubview:goodCommentBar];
    [goodCommentBar release];
    goodCommentBar.backColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    goodCommentBar.rateColor = [UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1];
    
    RateBarView *badCommentBar = [[RateBarView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 108 - 15, 45, 108, 15) Rate:(1 - favRate/100.0)];
    [sectionView addSubview:badCommentBar];
    [badCommentBar release];
    badCommentBar.backColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    badCommentBar.rateColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
    
    UIImageView *dashLineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 72 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    dashLineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [sectionView addSubview:dashLineView1];
    [dashLineView1 release];

    
    return [sectionView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 更改评分和好差评分段的层次, 使用-1不进入
    if (indexPath.row == -1) {
        return 72;
    }else{
        int cellHeight = 0;

        // 更改评分和好差评分段的层次, 动态不-1
        switch (currentIndex) {
            case -1:
                cellHeight = [[allCommentHeights safeObjectAtIndex:indexPath.row] intValue];
                break;
            case 0:
                cellHeight = [[goodCommentHeights safeObjectAtIndex:indexPath.row] intValue];
                break;
            case 1:
                cellHeight = [[badCommentHeights safeObjectAtIndex:indexPath.row] intValue];
                break;
                
            default:
                break;
        }
        
        return cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 更改评分和好差评分段的层次, 使用-1不进入
	if (indexPath.row == -1) {
        static NSString *cellIdentifier = @"headercell";
        UITableViewCell *cell = (UITableViewCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            // 计算好评率 四舍五入
            NSInteger favRate = 0;
            NSInteger goodComment = goodCount; //[[[HotelDetail hoteldetail] safeObjectForKey:RespHL__GoodCommentCount_I] intValue];
            NSInteger badComment = badCount;   //[[[HotelDetail hoteldetail] safeObjectForKey:RespHL__BadCommentCount_I] intValue];
            
            if (goodComment + badComment == 0) {
                favRate = 0;
            }else{
                favRate = ceil(goodComment * 100/ (goodComment + badComment + 0.0f));
            }
            
            NSString *favRateString = nil;
            UILabel *praiseRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 72)];
            UILabel *tLabel_3 = [[UILabel alloc] init];
            UILabel *tLabel_1 = [[UILabel alloc] init];
            
            if ([[HotelDetailController hoteldetail] safeObjectForKey:@"CommentPoint"]&&[[HotelDetailController hoteldetail] safeObjectForKey:@"CommentPoint"]!=[NSNull null])
            {
                float commentPoint = [[[HotelDetailController hoteldetail] safeObjectForKey:@"CommentPoint"] floatValue];
                
                if (commentPoint>0)
                {
                    favRateString = [NSString stringWithFormat:@"%.0f",commentPoint*100];
                }
                else
                {
                    praiseRateLabel.hidden=YES;
                    tLabel_3.hidden=YES;
                    tLabel_1.hidden=YES;
                }
            }
            
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            praiseRateLabel.backgroundColor = [UIColor clearColor];
            praiseRateLabel.text = favRateString?favRateString:[NSString stringWithFormat:@"%d", favRate];
            praiseRateLabel.textColor = RGBACOLOR(254, 75, 32, 1);
            praiseRateLabel.textAlignment = UITextAlignmentLeft;
            praiseRateLabel.font = [UIFont boldSystemFontOfSize:35];
            [cell addSubview:praiseRateLabel];
            [praiseRateLabel release];
            
            CGSize praiseSize=[praiseRateLabel.text sizeWithFont:praiseRateLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 72)];
            praiseRateLabel.frame=CGRectMake(praiseRateLabel.frame.origin.x, praiseRateLabel.frame.origin.y, praiseSize.width, praiseRateLabel.frame.size.height);
            
            tLabel_3.frame=CGRectMake(praiseRateLabel.frame.origin.x+praiseRateLabel.frame.size.width, 30, 20, 20);
            tLabel_3.backgroundColor = [UIColor clearColor];
            tLabel_3.text = @"%";
            tLabel_3.textColor = RGBACOLOR(254, 75, 32, 1);
            tLabel_3.font = FONT_20;
            [cell addSubview:tLabel_3];
            [tLabel_3 release];
            
            tLabel_1.frame=CGRectMake(tLabel_3.frame.origin.x+tLabel_3.frame.size.width, 32, 50, 20);
            tLabel_1.backgroundColor = [UIColor clearColor];
            tLabel_1.text = @"客户好评";
            tLabel_1.font = [UIFont systemFontOfSize:11];
            tLabel_1.textColor = RGBACOLOR(103, 103, 103, 1);
            [cell addSubview:tLabel_1];
            [tLabel_1 release];
            
            
            // 右半部分
            
            UILabel *goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 18, 160, 20)];
            goodLabel.backgroundColor = [UIColor clearColor];
            goodLabel.text = [NSString stringWithFormat:@"好评"];
            goodLabel.textColor = [UIColor grayColor];
            goodLabel.adjustsFontSizeToFitWidth = YES;
            goodLabel.font = FONT_11;
            [cell addSubview:goodLabel];
            [goodLabel release];
            
            UILabel *badLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 42, 160, 20)];
            badLabel.backgroundColor = [UIColor clearColor];
            badLabel.text = [NSString stringWithFormat:@"差评"];
            badLabel.textColor = [UIColor grayColor];
            badLabel.adjustsFontSizeToFitWidth = YES;
            badLabel.font = FONT_11;
            [cell addSubview:badLabel];
            [badLabel release];
            
            RateBarView *goodCommentBar = [[RateBarView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 108 - 15, 20, 108, 15) Rate:favRate/100.0];
            [cell addSubview:goodCommentBar];
            [goodCommentBar release];
            goodCommentBar.backColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            goodCommentBar.rateColor = [UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1];
            
            RateBarView *badCommentBar = [[RateBarView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 108 - 15, 45, 108, 15) Rate:(1 - favRate/100.0)];
            [cell addSubview:badCommentBar];
            [badCommentBar release];
            badCommentBar.backColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            badCommentBar.rateColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
            
            
            UIImageView *dashLineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 72 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            dashLineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell addSubview:dashLineView1];
            [dashLineView1 release];
            ///73

        }
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"reviewcell";
        // 更改评分和好差评分段的层次, 使用-1不进入
//        NSInteger index = indexPath.row - 1;
        NSInteger index = indexPath.row;
        
        ReviewCell *cell = (ReviewCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:self options:nil];
            cell = [nib safeObjectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.clipsToBounds = NO;
            cell.contentLable.textColor = RGBACOLOR(87, 87, 87, 1);
            cell.contentLable.numberOfLines = 0;
            cell.contentLable.lineBreakMode = UILineBreakModeCharacterWrap;
            cell.timeLable.textColor = RGBACOLOR(87, 87, 87, 1);
            cell.contentLable.font = [UIFont systemFontOfSize:14.0];
            cell.nameLabel.textColor = RGBACOLOR(87, 87, 87, 1);
        }
        NSDictionary *dic;
        switch (currentIndex) {
            case -1:
                dic = [reviewlist safeObjectAtIndex:index];
                cell.timeLable.text = [TimeUtils displayDateWithJsonDate:[[reviewlist safeObjectAtIndex:index] safeObjectForKey:RespHC__CommentDateTime_ED] formatter:@"yyyy-MM-dd"];
                
                break;
            case 0:
                dic = [goodreviewlist safeObjectAtIndex:index];
                cell.timeLable.text = [TimeUtils displayDateWithJsonDate:[[goodreviewlist safeObjectAtIndex:index] safeObjectForKey:RespHC__CommentDateTime_ED] formatter:@"yyyy-MM-dd"];
                
                break;
            case 1:
                dic = [badreviewlist safeObjectAtIndex:index];
                cell.timeLable.text = [TimeUtils displayDateWithJsonDate:[[badreviewlist safeObjectAtIndex:index] safeObjectForKey:RespHC__CommentDateTime_ED] formatter:@"yyyy-MM-dd"];
                
                break;
            default:
                dic = [reviewlist safeObjectAtIndex:index];
                break;
        }
        
		
        NSString *txt	= [dic safeObjectForKey:RespHC__Content_S];
        int height		= [self labelHeightWithNSString:cell.contentLable.font string:txt width:CONTENT_WIDTH];
        
        cell.cellheight = 64 + height;
        cell.contentLable.text=txt;
        int recommendType=[[dic safeObjectForKey:RespHC__RecommendType_I] intValue];
        switch (recommendType) {
            case GOOD:
            case MIDDLE:
            case UNKNOWN:
            case ALL:
            {
                // 好评
                cell.flagImageView.frame	= CGRectMake(SCREEN_WIDTH - 30, height + 30, 25, 25);
                cell.flagImageView.image	= [UIImage imageNamed:@"ico_good.png"];
                
                cell.nameLabel.frame			= CGRectMake(CONTENT_WIDTH - 260, height + 20, 280, 12);
                cell.nameLabel.textAlignment	= UITextAlignmentLeft;
                
                cell.bubbleView.frame		= CGRectMake(64 - 20, 10, CONTENT_WIDTH + 32, height + 34);
                cell.bubbleView.image		= [UIImage stretchableImageWithPath:@"bubble_right_bg.png"];
                
                cell.contentLable.frame	= CGRectMake(76 - 55, 18, CONTENT_WIDTH, height);
                
                cell.timeLable.frame		= CGRectMake(CONTENT_WIDTH - 40, height + 14, 64, 20);
                
            }
                break;
            case BAD:
            {
                // 差评
                cell.flagImageView.frame	= CGRectMake(5, height + 30, 25, 25);
                cell.flagImageView.image	= [UIImage imageNamed:@"ico_bad.png"];
                
                cell.nameLabel.frame			= CGRectMake(CONTENT_WIDTH - 260, height + 20, 280, 12);
                cell.nameLabel.textAlignment	= UITextAlignmentLeft;
                
                cell.bubbleView.frame		= CGRectMake(13 + 20, 10, CONTENT_WIDTH + 32, height + 34);
                cell.bubbleView.image		= [UIImage stretchableImageWithPath:@"bubble_left_bg.png"];
                
                cell.contentLable.frame	= CGRectMake(21, 18, CONTENT_WIDTH, height);
                
                cell.timeLable.frame		= CGRectMake(CONTENT_WIDTH - 40, height + 14, 64, 20);
            }
                break;
            default:
                break;
        }
        
//        cell.nameLabel.text = @"";//[dic safeObjectForKey:RespHC__UserName_S];
        cell.nameLabel.text = [dic safeObjectForKey:RespHC__UserName_S];
        
        int cellHeight = 0;
        // 更改评分和好差评分段的层次, 动态不-1
        switch (currentIndex) {
            case -1:
                cellHeight = [[allCommentHeights safeObjectAtIndex:indexPath.row] intValue];
                break;
            case 0:
                cellHeight = [[goodCommentHeights safeObjectAtIndex:indexPath.row] intValue];
                break;
            case 1:
                cellHeight = [[badCommentHeights safeObjectAtIndex:indexPath.row] intValue];
                break;
                
            default:
                break;
        }
        UIImageView *seperatorLine = (UIImageView *)[cell viewWithTag:kSeperatorLineTag];
        if (seperatorLine == nil) {
            seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, cellHeight - 0.51f, 280.0f, 0.51f)];
            seperatorLine.image = [UIImage imageNamed:@"dashed"];
            seperatorLine.tag = kSeperatorLineTag;
            [cell addSubview:seperatorLine];
            [seperatorLine release];
        }
        else {
            seperatorLine.frame = CGRectMake(20.0f, cellHeight - 0.51f, 280.0f, 0.51f);
        }
        
        return cell;
    }
}


#pragma mark -
#pragma mark UIScroll Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tableFooterView && !isRequstMore) {
        // 当还有更多酒店时在滑到倒数第3行时发起请求
		NSArray *array = [self visibleCells];
        NSIndexPath *cellIndex = [self indexPathForCell:[array lastObject]];
        
        NSArray *currentComments = nil;
        
        switch (currentIndex) {
            case -1:
                currentComments = reviewlist;
                break;
            case 0:
                currentComments = goodreviewlist;
                break;
            case 1:
                currentComments = badreviewlist;
                break;
            default:
                currentComments = reviewlist;
        }
        
        if (cellIndex.row >= [currentComments count] - 2) {
            isRequstMore = YES;
            [self morecomments];
        }
	}
}

#pragma mark 
#pragma mark CustomSegmentedDelegate
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index{
    currentIndex = index;
    
    UIImageView *goodView = (UIImageView *)[segView viewWithTag:kGoodImageViewTag];
    UIImageView *badView = (UIImageView *)[segView viewWithTag:kBadImageViewTag];
    switch (index) {
        case -1:
        {
            if (![reviewlist count]) {
                self.hotelId = (NSString *)[[HotelPostManager hoteldetailer] getObject:RespHD_HotelId_S];
                // 全部评论
                [self clearDataSource];
                [self requestCommontByType:CommentTypeAll];
            }
            else {
                [smallLoading stopLoading];
            }
            
            if (0 == [reviewlist count] || totalCount <= [reviewlist count]) {
                self.tableFooterView = nil;
            }
            else {
                self.tableFooterView = footView;
            }
            [allreviewBtn setBackgroundImage:[UIImage noCacheImageNamed:@"bg_review_selected.png"] forState:UIControlStateNormal];
            [goodreviewBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [badreviewBtn setBackgroundImage:nil forState:UIControlStateNormal];
        }
            break;
        case 0:
        {
            if (![goodreviewlist count]) {
                [self requestCommontByType:CommentTypeGood];
            }
            else {
                [smallLoading stopLoading];
            }
            
            if (0 == [goodreviewlist count] || goodCount <= [goodreviewlist count]) {
                self.tableFooterView = nil;
            }
            else {
                self.tableFooterView = footView;
            }
            [allreviewBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [goodreviewBtn setBackgroundImage:[UIImage noCacheImageNamed:@"bg_review_selected.png"] forState:UIControlStateNormal];
            [badreviewBtn setBackgroundImage:nil forState:UIControlStateNormal];
            
            [goodreviewBtn removeFromSuperview];
            
            UMENG_EVENT(UEvent_Hotel_Detail_CommentGood)
        }
            break;
        case 1:
        {
            if (![badreviewlist count]) {
                [self requestCommontByType:CommentTypeBad];
            }
            else {
                [smallLoading stopLoading];
            }
            
            if (0 == [badreviewlist count] || badCount <= [badreviewlist count]) {
                self.tableFooterView = nil;
            }
            else {
                self.tableFooterView = footView;
            }
            [allreviewBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [goodreviewBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [badreviewBtn setBackgroundImage:[UIImage noCacheImageNamed:@"bg_review_selected.png"] forState:UIControlStateNormal];
            
            UMENG_EVENT(UEvent_Hotel_Detail_CommentBad)
        }
            break;
    }
    
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    [self reloadData];
    goodView.highlighted = !goodView.highlighted;
    badView.highlighted = !badView.highlighted;
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    [smallLoading stopLoading];
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[[footView subviews] safeObjectAtIndex:0];
    if (activityIndicator) {
        [activityIndicator stopAnimating];
    }
    
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:root]) {
        isRequstMore = NO;
		return;
	}
    
    NSArray *comments = [root safeObjectForKey:RespHC_Comments_A];
    if (!ARRAYHASVALUE(comments) && [reviewlist count] > 0) {
        // 评论数据返回为空时也报错
        isRequstMore = NO;
        return;
    }
    
    // 统计数量
    if (totalCount==0) {
        totalCount = [[root safeObjectForKey:RespHC_TotalCount_I] intValue];
    }
    if (goodCount == 0) {
        goodCount = [[root safeObjectForKey:@"GoodCount"] intValue];
    }
    if(badCount == 0){
        badCount = [[root safeObjectForKey:@"BadCount"] intValue];
    }
    
    
    
    NSMutableArray *commentHeightsArray = [NSMutableArray arrayWithCapacity:2];
    for (NSDictionary *dic in comments) {
        NSString *txt	= [dic safeObjectForKey:RespHC__Content_S];
        int height		= [self labelHeightWithNSString:FONT_14 string:txt width:CONTENT_WIDTH];
        [commentHeightsArray addObject:[NSNumber numberWithInt:height + 44]];
    }
    
    if (util == commentReq) {
        if ([commentDelegate respondsToSelector:@selector(hotelReview:didLoadedTotalComent:goodComment:badComment:)]) {
            [commentDelegate hotelReview:self didLoadedTotalComent:totalCount goodComment:goodCount badComment:badCount];
        }
        
        [allCommentHeights addObjectsFromArray:commentHeightsArray];    // 添加评论高度
        
        //totalCount = [[root safeObjectForKey:RespHC_TotalCount_I] intValue];
        [reviewlist addObjectsFromArray:comments];
        if (totalCount <= [reviewlist count]) {
            self.tableFooterView = nil;
        }
        else {
            self.tableFooterView = footView;
        }
        if ([reviewlist count] == 0) {
            m_tipView = [Utils addView:@"该酒店目前没有评论"];
            CGRect oldframe=m_tipView.frame;
            oldframe.origin.y=168;
            m_tipView.frame=oldframe;
            
            [self addSubview:m_tipView];
            //self.tableHeaderView = nil;
            self.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        }
        
        // 加载好评
        [self requestCommontByType:CommentTypeGood];
        
    }else if(util == goodCommentReq){
        [goodCommentHeights addObjectsFromArray:commentHeightsArray];   // 添加好评高度
        
        //goodCount = [[root safeObjectForKey:@"GoodCount"] intValue];
        [goodreviewlist addObjectsFromArray:[root safeObjectForKey:RespHC_Comments_A]];
        if (goodCount <= [goodreviewlist count]) {
            self.tableFooterView = nil;
        }
        else {
            self.tableFooterView = footView;
        }
        if ([goodreviewlist count] == 0&&[reviewlist count] != 0) {
            m_tipView = [Utils addView:@"该酒店目前没有好评"];
            CGRect oldframe=m_tipView.frame;
            oldframe.origin.y=168;
            m_tipView.frame=oldframe;
            
            [self addSubview:m_tipView];
            //self.tableHeaderView = nil;
            self.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        }
    }else if(util == badCommentReq){
        [badCommentHeights addObjectsFromArray:commentHeightsArray];    // 添加差评高度
        
        //badCount = [[root safeObjectForKey:@"BadCount"] intValue];
        [badreviewlist addObjectsFromArray:[root safeObjectForKey:RespHC_Comments_A]];
        if (badCount <= [badreviewlist count]) {
            self.tableFooterView = nil;
        }
        else {
            self.tableFooterView = footView;
        }
        if ([badreviewlist count] == 0&&[reviewlist count] != 0) {
            m_tipView = [Utils addView:@"该酒店目前没有差评"];
            CGRect oldframe=m_tipView.frame;
            oldframe.origin.y=168;
            m_tipView.frame=oldframe;
            
            [self addSubview:m_tipView];
            // self.tableHeaderView = nil;
            self.backgroundColor=RGBACOLOR(248, 248, 248, 1);
        }
    }
    
    [self reloadData];
    
    isRequstMore = NO;
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == commentReq) {
        [self dealNetErrorStats];
    }
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[[footView subviews] safeObjectAtIndex:0];
    if (activityIndicator) {
        [activityIndicator stopAnimating];
    }
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == commentReq) {
        [self dealNetErrorStats];
    }
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[[footView subviews] safeObjectAtIndex:0];
    if (activityIndicator) {
        [activityIndicator stopAnimating];
    }
}


@end
