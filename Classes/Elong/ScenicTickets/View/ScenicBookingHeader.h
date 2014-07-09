//
//  ScenicBookingHeader.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScenicBookingHeader : UIView
@property (nonatomic,retain) UILabel *policyName;
@property (nonatomic,retain) UILabel *lowestPrice;
@property (nonatomic,retain) UIImageView *arrow;
-(void)refreshTheArrowWithReavel:(BOOL)yes;
@end
