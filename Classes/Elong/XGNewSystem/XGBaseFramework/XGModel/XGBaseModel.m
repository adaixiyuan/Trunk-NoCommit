//
//  XGBaseModel.m
//  ElongClient
//
//  Created by guorendong on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseModel.h"

#import <objc/runtime.h>

#define PROPETTY_ENCODE_INT  @"Ti"
#define PROPETTY_ENCODE_FLOAT @"Tf"
#define PROPETTY_ENCODE_DOUBLE @"fd"
#define PROPETTY_ENCODE_CHAR @"Tc"
@implementation XGBaseModel

- (NSMutableDictionary *)getPropertyList{
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionary];
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        const char* propertyType = property_getAttributes(properties[i]);
        [propertyDic setObject:[NSString stringWithUTF8String:propertyType] forKey:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertyDic;
}
//后面的参数 若传YES，则优先Model类中属性，Model可选择自己的数据（JSON数据多于需要） 传NO 同上
-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict{
    self.jsonDict=[NSMutableDictionary dictionaryWithDictionary:dict];
    NSDictionary *propertyList = [self getPropertyList];
    for (NSString *key in [propertyList allKeys]) {
        id value = [dict objectForKey:key];
        if (nil == value || value == [NSNull null]) {
            continue;
        }
        if ([value isKindOfClass:[NSDictionary class]]||[value isKindOfClass:[NSMutableDictionary class]]) {
            id subObj = [self valueForKey:key];
            if (subObj)
                [subObj convertObjectFromGievnDictionary:value];
        }else{
            [self setValue:value forKey:key];
        }
    }
}

//下面的方法 Model与Json 一一对应
- (void)convertObjectFromGievnDictionary:(NSDictionary*) dict  relySelf:(BOOL)yes{
    
    if (yes) {
        [self convertObjectFromGievnDictionary:dict];
    }
    else
    {
        self.jsonDict=[NSMutableDictionary dictionaryWithDictionary:dict];

        for (NSString *key in [dict allKeys]) {
            id value = [dict objectForKey:key];
            if (value==[NSNull null]) {
                continue;
            }
            if ([value isKindOfClass:[NSDictionary class]]) {
                
                id subObj = [self valueForKey:key];
                if (subObj)
                    [subObj convertObjectFromGievnDictionary:value relySelf:yes];
                
            }else{
                [self setValue:value forKey:key];
            }
        }
    }
}


//2. 把一个实体对象，封装成字典Dictionary
- (NSDictionary *)convertDictionaryFromObjet
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDictionary *propertyList = [self getPropertyList];
    for (NSString *key in [propertyList allKeys]) {
        
        id value = [self valueForKey:key];
        if (value == nil) {
            value = [NSNull null];
        }
        //判断属性的类型，若为object对象，直接setObject 其他封装再set
        NSString *p_typep = [propertyList objectForKey:key];
        if ([p_typep rangeOfString:@"@"].location == NSNotFound) {
            //
            NSString *sign = [p_typep substringWithRange:NSMakeRange(0, 2)];
            if ([sign isEqualToString:PROPETTY_ENCODE_INT]) {
                //int
                value = [NSNumber   numberWithInt:(int)value];
            }else if ([sign isEqualToString:PROPETTY_ENCODE_FLOAT]){
                //float
                if (![value respondsToSelector:@selector(floatValue)]) {
                    continue;
                }
                value = [NSNumber numberWithFloat:[value floatValue]];
                
            }else if ([sign isEqualToString:PROPETTY_ENCODE_DOUBLE]){
                //double
                if (![value respondsToSelector:@selector(doubleValue)]) {
                    continue;
                }
                value = [NSNumber numberWithDouble:[value doubleValue]];
                
            }else if ([sign isEqualToString:PROPETTY_ENCODE_CHAR]){
                //char
                value = [NSNumber numberWithChar:[value charValue]];
            }
        }
        [dict setObject:value forKey:key];
    }
    return dict;
}



@end
