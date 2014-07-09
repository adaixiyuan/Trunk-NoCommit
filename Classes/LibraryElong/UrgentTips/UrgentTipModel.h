//
//  UrgentTipModel.h
//  ElongClient
//  紧急文案提示数据对象
//
//  Created by 赵 海波 on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrgentTipModel : NSObject

@property (nonatomic,copy) NSString *channel;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSNumber *tipId;
@property (nonatomic,copy) NSString *tipUrlString;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *positionId;
@property (nonatomic,copy) NSString *productLine;

-(id)initWithJson:(NSDictionary *)json;

@end
