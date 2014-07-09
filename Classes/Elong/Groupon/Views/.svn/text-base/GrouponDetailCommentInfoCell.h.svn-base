//
//  GrouponDetailCommentInfoCell.h
//  ElongClient
//
//  Created by garin on 14-5-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponDetailCommentCellDelegate;

@interface GrouponDetailCommentInfoCell : UITableViewCell
{
    UIView *bgImageView;
    UILabel *tuanCntLabel;     //多少人已团
    UILabel *tuanEclipseLabel; //还剩多少时间
    UIButton *lookCommentSingleHotelBtn;  //单店查看评论
    UIButton *lookCommentMutipleHotelBtn;  //多店查看评论
    
    UIImageView *tuanTimeEclipseIcon; //剩余时间icon
    
    UILabel *tuanCntDespLabel; //人已经团
    UILabel *goodCommentCntLabel; //好评个数
    UILabel *comentCntLabel;  //评论个数
    
    UIView *singleCommentView;  //单店评论
    UIButton *mutipleCommentView; //多店评论
    
    UIActivityIndicatorView *activeView;
    BOOL isMultiple;       //是否多店
    UIImageView *shuSplitView;
    UILabel *goodCommentCntDespLabel;
    UILabel *despLabel2;
    UILabel *noCommentTip;
}

@property (nonatomic,assign) id<GrouponDetailCommentCellDelegate> delegate;

-(void) setTuanCnt:(int) cnt;

-(void) setTimeEclipse:(NSString *) leftTime;

- (void) showCommentLoading;

- (void) hideCommentLoading;

- (void) setGoodCommentNum:(NSInteger)good badCommentNum:(NSInteger)bad;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier multiple:(BOOL) multiple_;

@end


@protocol GrouponDetailCommentCellDelegate <NSObject>
@optional
- (void) grouponDetailCommentCellCommenting:(GrouponDetailCommentInfoCell *)cell;
- (void) grouponDetailCommentCellBooking:(GrouponDetailCommentInfoCell *)cell;
@end
