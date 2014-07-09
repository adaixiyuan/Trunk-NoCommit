//
//  RentCarExplainManager.h
//  ElongClient
//
//  Created by licheng on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentCarExplainManager : NSObject
@property(nonatomic,retain)NSMutableArray *carTypeArray;  //车型-起租价-起租套餐-计费标准 数组
@property(nonatomic,retain)NSMutableArray *explainArray;  //费用项-费用说明 数组
@property(nonatomic,copy)NSString *title; //北京-接机
@property(nonatomic,copy)NSString *figureRule;//计算规则
@property(nonatomic,copy)NSString *rangeRule; //范围规则规则


-(void)parseStep1Reqestdict:(NSDictionary *)root;
-(void)parseStep2Reqestdict:(NSDictionary *)root;
//拼接html 文本
-(NSString *)packageHTML:(NSString *)title tip1Array:(NSArray *)tip1Array figureRule:(NSString *)figureRule rangeRule:(NSString *)rangeRule tip2Array:(NSArray *)tip2Array;
//重置
-(void)resetself;
@end
