//
//  GrouponCommentViewController.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "HotelReview.h"

@protocol GrouponCommentViewControllerDelegate;
@interface GrouponCommentViewController : DPNav<HotelReviewDelegate>{
    id delegate;
}

@property (nonatomic,assign) id<GrouponCommentViewControllerDelegate> delegate;
- (id)initWithDictionary:(NSDictionary *)dictionary hotelId:(NSString *)hotelId;
- (void) reInit;
@end


@protocol GrouponCommentViewControllerDelegate <NSObject>

@optional
- (void) totalCommentLoaded:(NSInteger)totalComment goodComment:(NSInteger)goodComment badComment:(NSInteger)badComment;

@end