//
//  UrgentTipModel.m
//  ElongClient
//
//  Created by 赵 海波 on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UrgentTipModel.h"

@implementation UrgentTipModel

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.channel = [json safeObjectForKey:@"channel"];
        self.content = [json safeObjectForKey:@"content"];
        self.tipId = [json safeObjectForKey:@"id"];
        self.tipUrlString = [json safeObjectForKey:@"jumpLink"];
        self.productLine = [json safeObjectForKey:@"productLine"];
        self.positionId = [json safeObjectForKey:@"positionId"];
        self.page = [json safeObjectForKey:@"page"];
    }
    
    return self;
}

@end
