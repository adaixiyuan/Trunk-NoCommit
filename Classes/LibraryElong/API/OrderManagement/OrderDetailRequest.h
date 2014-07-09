//
//  OrderDetailRequest.h
//  ElongClient
//
//  Created by 赵岩 on 13-8-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailRequest : NSObject

@property (nonatomic, retain) NSString *cardNo;

- (NSString *)request;

@end
