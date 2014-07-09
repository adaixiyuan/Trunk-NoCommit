//
//  InterHotelLocationRequest.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterHotelLocationRequest : NSObject

+ (id)shared;

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *countryId;
@property (nonatomic, retain) NSString *stateId;
@property (nonatomic, retain) NSString *countryCode;

@property (nonatomic, retain) NSArray *locationList;

- (NSString *)request;

@end
