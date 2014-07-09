//
//  InterHotelOrderHistoryRequest.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-27.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    InterHotelOrderConfirmed,
    InterHotelOrderCanceled,
}InterHotelOrderType;

@interface InterHotelOrderHistoryRequest : NSObject

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger countPerPage;
@property (nonatomic, assign) NSUInteger totalPage;

@property (nonatomic, assign) InterHotelOrderType type;

- (void)nextPage;

- (NSString *)request;

@end
