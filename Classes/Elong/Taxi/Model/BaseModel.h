//
//  BaseModel.h
//  ElongClient
//  打车类模块 Model基类
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding>
{
    
}


-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;//赋值Model
- (NSString *)customDescription;
- (NSString *)description;  //打印Model
- (NSData*)getArchivedData;
- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串
- (NSDictionary *)convertDictionaryFromObjet;//将model类转换为字典
- (void)convertObjectFromGievnDictionary:(NSDictionary*) dict;
-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes;
@end
