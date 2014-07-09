//
//  CountlyEventHomePageBlock.h
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountlyEventClick.h"


@interface CountlyEventHomePageBlock : CountlyEventClick
@property (nonatomic,copy) NSNumber *blockId;
@property (nonatomic,copy) NSString *blockName;
@end
