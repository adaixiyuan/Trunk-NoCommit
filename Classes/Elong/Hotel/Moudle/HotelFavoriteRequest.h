//
//  JFavorite.h
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "PostHeader.h"
#import "AccountManager.h"

@interface HotelFavoriteRequest : NSObject

@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger currentIndex; // frome 1 to n
@property (nonatomic, retain) NSString *cityId;
@property (nonatomic,assign) BOOL category;
- (void)reset;

- (void)nextPage;

- (NSString *)request;

@end
