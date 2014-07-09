//
//  HomeAdRequest.h
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeAdRequest : NSObject{
@private
    NSMutableDictionary *content;
}
@property (nonatomic,copy) NSString *phoneType;
@property (nonatomic,copy) NSString *dimension;
@property (assign) NSInteger adId;
@property (assign) NSInteger adType;
@property (assign) NSInteger jumpType;
@property (nonatomic,copy) NSString *jumpLink;

- (NSString *) requestForAds;
- (NSString *) requestForClickAds;
@end
