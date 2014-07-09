//
//  HotelOrderIsNomListRst.h
//  ElongClient
//
//  Created by nieyun on 14-6-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol   HotelOrderIsNomListDelegate <NSObject>

- (void) exceluteGetIsNoNomResult:(NSArray *)array;

@end


@interface HotelOrderIsNomListRst : NSObject <HttpUtilDelegate>
{
    id <HotelOrderIsNomListDelegate> mdelegate;
}
- (void)startRequestIsNoNomListWithDelegate:(id<HotelOrderIsNomListDelegate>) delegate;
@property (nonatomic,retain) NSMutableArray  *localOrderArray;
@end

