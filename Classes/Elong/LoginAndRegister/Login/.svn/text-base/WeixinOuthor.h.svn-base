//
//  WeixinOuthor.h
//  ElongClient
//
//  Created by Dawn on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeixinLogin.h"

@protocol WeixinOuthorDelegate;
@interface WeixinOuthor : NSObject<WeixinLoginDelegate>

@property (nonatomic,assign) id<WeixinOuthorDelegate> delegate;
- (void) outhor;
@end


@protocol WeixinOuthorDelegate <NSObject>

- (void) weixinOuthor:(WeixinOuthor *)weixinOuthor didGetToken:(NSDictionary *)token;

@end