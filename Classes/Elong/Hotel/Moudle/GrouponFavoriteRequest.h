//
//  GrouponFavoriteRequest.h
//  ElongClient
//
//  Created by Dawn on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "PostHeader.h"
#import "AccountManager.h"

@interface GrouponFavoriteRequest : NSObject
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger currentIndex; // frome 1 to n

- (void)reset;

- (void)nextPage;

- (NSString *)request;
@end
