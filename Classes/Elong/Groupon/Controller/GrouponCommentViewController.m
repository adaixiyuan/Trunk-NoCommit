//
//  GrouponCommentViewController.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#define WAP_FRAME			CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)


#import "GrouponCommentViewController.h"
#import "GDetailRequest.h"
#import "HotelReview.h"

@interface GrouponCommentViewController ()
@property (nonatomic,assign) NSDictionary *detailDic;
@end

@implementation GrouponCommentViewController
@synthesize delegate;
@synthesize detailDic;

- (void) dealloc{
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dictionary hotelId:(NSString *)hotelId{
	if (self = [super init:@"" style:_NavNoTelStyle_]){
        self.detailDic = dictionary;
        
        // 酒店名，星级，分享等
        [self addNavigationBarView];
        
        //
        
        // 预加载评论页面
        HotelReview *reviewView = [[HotelReview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        reviewView.commentDelegate = self;
        [self.view addSubview:reviewView];
        [reviewView release];
        
        [reviewView searchHotelCommentsWithId:hotelId];
    
    }
    return self;
}

- (void) reInit{
    [super init:@"" style:_NavOnlyBackBtnStyle_];
}


#pragma mark -
#pragma mark HotelReviewDelegate
- (void) hotelReview:(HotelReview *)hotelReview didLoadedTotalComent:(NSInteger)totalComment goodComment:(NSInteger)goodComment badComment:(NSInteger)badComment{
    if ([delegate respondsToSelector:@selector(totalCommentLoaded:goodComment:badComment:)]) {
        [delegate totalCommentLoaded:totalComment goodComment:goodComment badComment:badComment];
    }
}

// 构造导航栏和分享按钮
- (void)addNavigationBarView {
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, NAVIGATION_BAR_HEIGHT)];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:topView.bounds];
	titleLabel.backgroundColor	= [UIColor clearColor];
	titleLabel.textAlignment	= UITextAlignmentCenter;
	titleLabel.textColor		= [UIColor blackColor];
    
	titleLabel.text				= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODNAME_GROUPON];
	titleLabel.text = [titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.numberOfLines	= 0;
	titleLabel.minimumFontSize	= 12;
	titleLabel.font				= [UIFont boldSystemFontOfSize:16];
	[topView addSubview:titleLabel];
	[titleLabel release];
    
    //    NSArray *storeArray = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
    //
    //    int statlevel = [[[storeArray  safeObjectAtIndex:0] safeObjectForKey:STAR_RESP] intValue];
    //	if (statlevel < 3) {
    //		statlevel = 0;
    //	}
    //	NSString *imgPath = @"star_ico.png";
    //	if (statlevel > 0) {
    //		// 有星级时，显示星级
    //		BOOL isHalfLevel = NO;			// 是否有半星级的情况,只有艺龙评级会出现
    //		if (statlevel > 10) {
    //			isHalfLevel = statlevel % 10 == 5 ? YES : NO;
    //			statlevel	= round(statlevel / 10.f);
    //			imgPath		= @"elong_star.png";
    //		}
    //
    //		UIView *starBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13.6 * statlevel, 11)];
    //		for (int i = 0; i < statlevel; i ++) {
    //			UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(15 * i, 0, 11, 11)];
    //			starImg.image = [UIImage imageNamed:imgPath];
    //			[starBackView addSubview:starImg];
    //			[starImg release];
    //
    //			if (isHalfLevel && i == statlevel - 1) {
    //				// 换掉最后一张图
    //				starImg.image = [UIImage imageNamed:@"elong_star_half.png"];
    //			}
    //		}
    //
    //		[topView addSubview:starBackView];
    //		titleLabel.frame = CGRectOffset(titleLabel.frame, 0, -6);
    //		titleLabel.numberOfLines = 1;
    //		starBackView.center = CGPointMake(topView.center.x, topView.center.y + 11);
    //		[starBackView release];
    //	}
	
	self.navigationItem.titleView = topView;
	[topView release];
}

@end
