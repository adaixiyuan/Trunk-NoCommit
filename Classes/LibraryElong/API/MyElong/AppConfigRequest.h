//
//  AppConfigRequest.h
//  ElongClient
//
//  Created by Dawn on 13-10-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfigRequest : NSObject{
    
}

@property (nonatomic,retain) NSString *appKey;
@property (nonatomic,retain) NSMutableDictionary *config;
+ (id)shared;
- (NSString *)getAppConfigRequest;
@end
