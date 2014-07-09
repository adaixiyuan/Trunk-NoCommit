//
//  HomeItemRequest.h
//  ElongClient
//
//  Created by Dawn on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeItemRequest : NSObject{
@private
    NSMutableDictionary *content;
}

@property (nonatomic,copy) NSString *logRecordStatus;
@property (nonatomic,retain) NSArray *logRecords;

- (NSString *) requestForLog;
@end
