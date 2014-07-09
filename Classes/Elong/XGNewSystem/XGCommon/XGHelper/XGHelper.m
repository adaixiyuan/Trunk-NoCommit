//
//  XGHelper.m
//  ElongClient
//
//  Created by guorendong on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHelper.h"

@implementation XGHelper
+(NSString *)getModelPath
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"modelPath"];
    return path;
}
+(NSString *)getModelFilePath:(NSString *)fileName
{
    return [[XGHelper getModelPath] stringByAppendingPathComponent:fileName];
}
+(void)saveEntityFromEntity:(id<NSCoding>)entity fileName:(NSString *)fileName
{
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:entity];
    [data writeToFile:[XGHelper getModelFilePath:fileName] atomically:YES];
}

+(id<NSCoding>)getEntityFromFileName:(NSString *)fileName
{
    NSData *data =[NSData dataWithContentsOfFile:[self getModelFilePath:fileName]];
    id<NSCoding> entity =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return entity;
}

@end
