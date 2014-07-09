//
//  RentComfirmController.h
//  ElongClient
//
//  Created by nieyun on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtil.h"

#define PAY_SUCCESS  1
#define PAY_FAILE     0
#define PAY_WAIT     -1
@interface RentComfirmController : UIViewController <HttpUtilDelegate>
{
    NSMutableDictionary *creditCardContents;
    HttpUtil  *util;
}
- (void)setCardMessage:(NSDictionary *)card;

- (void) requestUrl;
@end
