//
//  RoomReview.h
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"

@protocol HotelReviewDelegate;
@interface HotelReview : UITableView <UITableViewDelegate,UITableViewDataSource,CustomSegmentedDelegate> {
	NSMutableArray *reviewlist;
	NSMutableArray *goodreviewlist;
	NSMutableArray *badreviewlist;
    NSMutableArray *allCommentHeights;
	NSMutableArray *goodCommentHeights;
	NSMutableArray *badCommentHeights;
    
	int totalCount;
    int goodCount;
    int badCount;
    
	UIView *m_tipView;
    UIView *footView;
    
    UIButton *allreviewBtn;
    UIButton *goodreviewBtn;
    UIButton *badreviewBtn;
    
    HttpUtil *commentReq;
    HttpUtil *goodCommentReq;
    HttpUtil *badCommentReq;
    SmallLoadingView *smallLoading;
    
    BOOL isRequstMore;
    id commentDelegate;
    NSInteger currentIndex;
}

@property (nonatomic, retain) UIButton *morebutton;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,readonly) NSInteger totalCount;
@property (nonatomic,readonly) NSInteger goodCount;
@property (nonatomic,readonly) NSInteger badCount;
@property (nonatomic,assign) id<HotelReviewDelegate> commentDelegate;

- (void)searchHotelComments;

- (void)searchHotelCommentsbygood;
- (void)searchHotelCommentsbybad;
- (void) searchHotelCommentsWithId:(NSString *)pid;
-(void)clearDataSource;
@end


@protocol HotelReviewDelegate <NSObject>
@optional
- (void) hotelReview:(HotelReview *)hotelReview didLoadedTotalComent:(NSInteger)totalComment goodComment:(NSInteger)goodComment badComment:(NSInteger)badComment;

@end