//
//  CountlyEventInfo.h
//  ElongClient
//
//  Created by Dawn on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventBase.h"

@interface CountlyEventInfo : CountlyEventBase
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *channelId;
@property (nonatomic,copy) NSString *appt;
@property (nonatomic,copy) NSNumber *status;

- (void) sendEventCount:(NSInteger)count;
@end
