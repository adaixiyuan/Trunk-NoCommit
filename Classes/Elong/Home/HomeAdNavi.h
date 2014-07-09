//
//  HomeAdNavi.h
//  ElongClient
//
//  Created by Dawn on 14-5-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginManagerDelegate.h"

typedef enum {
    HomeAdNaviFeedback,
    HomeAdNaviComment,
    HomeAdNaviCashAccount,
    HomeAdNaviOrderList,
    HomeAdNaviOrderDetail
}HomeAdNaviType;

@protocol HomeAdNaviDelegate;
@interface HomeAdNavi : NSObject<LoginManagerDelegate>{
    
}
@property (nonatomic,assign) id<HomeAdNaviDelegate> delegate;
@property (nonatomic,assign) HomeAdNaviType homeAdNaviType;
@property (nonatomic,copy) NSString *checkInDate;
@property (nonatomic,copy) NSString *checkOutDate;

- (void) adNaviJumpUrl:(NSString *)jumpLink title:(NSString *)title;
- (void) adNaviJumpUrl:(NSString *)jumpLink title:(NSString *)title active:(BOOL)active;
- (BOOL) adNaviJumpUrl:(NSString *)jumpLink;
- (BOOL) adNaviJumpUrl:(NSString *)jumpLink active:(BOOL) active;
- (BOOL) loginNeeded:(NSString *)jumpLink;
@end

@protocol HomeAdNaviDelegate <NSObject>
@optional
- (void) homeAdNaviOpen:(HomeAdNavi *)homeAdNavi;
- (void) homeAdNaviItems:(HomeAdNavi *)homeAdNavi;
@end