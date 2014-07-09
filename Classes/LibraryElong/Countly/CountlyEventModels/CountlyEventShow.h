//
//  CountEventShow.h
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountlyEventBase.h"


@interface CountlyEventShow : CountlyEventBase

@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *ch;
@property (nonatomic,copy) NSString *channelId;
@property (nonatomic,copy) NSString *appt;
@property (nonatomic,copy) NSNumber *status;

- (void) sendEventCount:(NSInteger)count;
@end
