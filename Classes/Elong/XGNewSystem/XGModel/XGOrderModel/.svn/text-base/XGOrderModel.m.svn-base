//
//  XGOrderModel.m
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGOrderModel.h"

@implementation XGOrderActionModel

@end

@implementation XGOrderButton

@end

@implementation XGOrderStatusModel

-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes
{
    [super convertObjectFromGievnDictionary:dict relySelf:yes];
    self.Actions=[[NSMutableArray alloc] initWithCapacity:0];
    self.ActionsEntity=[[NSMutableArray alloc] initWithCapacity:0];
    [self.Actions addObjectsFromArray:dict[@"Actions"]];
    for (NSDictionary *actiondic in self.Actions){
        XGOrderActionModel *action =[[XGOrderActionModel alloc] init];
        [action convertObjectFromGievnDictionary:actiondic relySelf:YES];
        [self.ActionsEntity addObject:action];
    }
}

@end

@implementation XGOrderModel
-(id)init
{
    if (self =[super init]) {
        [self RightButton];
        [self BelowButton];
    }
    return self;
}

+(NSArray *)comvertModelForJsonArray:(NSArray *)array
{
    NSMutableArray *dataArray =[[NSMutableArray alloc] init];
    for (NSDictionary *cd in array) {
        XGOrderModel *model =[[XGOrderModel alloc] init];
        [model convertObjectFromGievnDictionary:cd relySelf:YES];
        if ([model.PayType intValue]==1&&(model.RelationOrderId==nil ||[model.RelationOrderId longLongValue]<=0)) {

            continue;
        }
        [dataArray addObject:model];
    }
    return dataArray;
}

-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes
{
    [super convertObjectFromGievnDictionary:dict relySelf:yes];
    
    self.OrderNo=self.OrderId;
    
    self.CreateTime = self.ReserveTime;
    
    [self.jsonDict safeSetObject:self.RelationOrderId forKey:@"OrderNo"];
    [self.jsonDict safeSetObject:self.CreateTime forKey:@"CreateTime"];
    
    
}

-(XGOrderButton *)RightButton
{
    if (_RightButton ==nil) {
        _RightButton =[[XGOrderButton alloc] init];
    }
    return _RightButton;
}

-(XGOrderButton *)BelowButton
{
    if (_BelowButton ==nil) {
        _BelowButton =[[XGOrderButton alloc] init];
    }
    return _BelowButton;
}

@end
