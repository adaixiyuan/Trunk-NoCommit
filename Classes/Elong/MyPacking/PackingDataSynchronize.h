//
//  PackingDataSynchronize.h
//  ElongClient
//
//  Created by Ivan.xu on 14-1-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUtil.h"

@interface PackingDataSynchronize : NSObject <HttpUtilDelegate>{
    NSString *_uid;
    NSMutableArray *_needPackingList;
}

-(void)start;

@end
