//
//  InternalHotelCommentCell.h
//  Elong_iPad
//
//  Created by Ivan.xu on 13-2-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InternalHotelCommentDelegate <NSObject>

-(void)postMoreComment:(int)flag;

@end

@interface InternalHotelCommentCell : UITableViewCell

-(void)setRatingScore:(float)score andTitle:(NSString *)title andTime:(NSString *)time;
-(void)setContent:(NSString *)content ;
-(void)moreComment;

@property (nonatomic,assign) id<InternalHotelCommentDelegate> delegate;

@end
