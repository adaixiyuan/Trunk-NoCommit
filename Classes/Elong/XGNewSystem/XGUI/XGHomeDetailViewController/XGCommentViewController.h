//
//  XGCommentViewController.h
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "HotelReview.h"
@interface XGCommentViewController : XGBaseViewController
{
    HotelReview *reviewView;
}
@property (nonatomic,strong) NSDictionary *hotelDic;
- (void) preLoad;
@end
