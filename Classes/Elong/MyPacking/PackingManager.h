//
//  PackingManager.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PackingModel;
@interface PackingManager : NSObject

+(PackingManager *)sharedInstance;

//初始化plist数据
-(void)initThePackingModuleData;
//更新用户的旅行列表
-(void)updateTheUserPackingListDataWithData:(NSMutableArray *)userList;
//获取用户 旅行列表
-(NSMutableArray *)getUserPackingListFromDefaultStore;
//更新用户的模板库
-(void)updateTheUserPackingTemplateWithData:(PackingModel *)model;
//获取用户的模板库
-(NSMutableArray *)getUserPackingTemplateLib;

@end
