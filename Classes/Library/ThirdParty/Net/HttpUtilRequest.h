//
//  HttpUtilRequest.h
//  ElongClient
//
//  Created by 赵 海波 on 12-11-22.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpUtilRequestDelegate;

@interface HttpUtilRequest : NSOperation<NSURLConnectionDelegate,NSURLConnectionDataDelegate> {
    
}

@property (nonatomic, retain) id <HttpUtilRequestDelegate> delegate;
@property (nonatomic, retain) NSMutableURLRequest *currentReq;      // 当前正在进行的请求

- (id)initWithRequest:(NSMutableURLRequest *)request;

@end


@protocol HttpUtilRequestDelegate <NSObject>

@required
- (void)receviceData:(NSData *)data;             // 成功获取数据
- (void)receviceError:(NSError *)error;          // 请求失败回调

@end
