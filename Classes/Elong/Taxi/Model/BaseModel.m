//
//  BaseModel.m
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

#define PROPETTY_ENCODE_INT  @"Ti"
#define PROPETTY_ENCODE_FLOAT @"Tf"
#define PROPETTY_ENCODE_DOUBLE @"fd"
#define PROPETTY_ENCODE_CHAR @"Tc"

@implementation BaseModel

-(id)initWithDataDic:(NSDictionary*)data{
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}

-(NSDictionary*)attributeMapDictionary{
	return nil;
}

-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
	NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
	NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
	return NSSelectorFromString(setterSelStr);
}
- (NSString *)customDescription{
	return nil;
}

- (NSString *)description{
	NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
            //            ITTDINFO(@"attributeName %@ value %@", attributeName, valueObj);
			if (valueObj) {
				[attrsDesc appendFormat:@" [%@=%@] ",attributeName, valueObj];
				//[valueObj release];
			}else {
				[attrsDesc appendFormat:@" [%@=nil] ",attributeName];
			}
			
		}
	}
	
	NSString *customDesc = [self customDescription];
	NSString *desc;
	
	if (customDesc && [customDesc length] > 0 ) {
		desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
	}else {
		desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
	}
    
	return desc;
}
//自动赋值
-(void)setAttributes:(NSDictionary*)dataDic{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	if (attrMapDic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        for (NSString *key in dataDic) {
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
	}
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL sel = [self getSetterSelWithAttibuteName:attributeName];
		if ([self respondsToSelector:sel]) {
			NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            
            if (nil == attributeValue || NULL == attributeValue)
            {
                NSLog(@"Model attributeValue is nil -------------  Error");
            }else{
                [self performSelectorOnMainThread:sel
                                       withObject:attributeValue
                                    waitUntilDone:[NSThread isMainThread]];
            }
		}
	}
}
//解归档
- (id)initWithCoder:(NSCoder *)decoder
{
	if( self = [super init] )
    {
		NSArray *attrAr = [[self getPropertyList]  allKeys];
		if (attrAr == nil)
        {
			return self;
		}
		//NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
		id attributeName;
		//while ((attributeName = [keyEnum nextObject]))
        for (attributeName  in  attrAr)
        {
			SEL sel = [self getSetterSelWithAttibuteName:attributeName];
			if ([self respondsToSelector:sel])
            {
				id obj = [decoder decodeObjectForKey:attributeName];
				[self performSelectorOnMainThread:sel
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
			}
		}
       
	}
    
	return self;
}
//对象归档
- (void)encodeWithCoder:(NSCoder *)encoder{
	NSArray *attrAr = [[[self getPropertyList]  allKeys] retain];
	if (attrAr == nil) {
		return;
	}
	//NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	
    for (int  i = 0;i < attrAr.count;i ++)
	{
        id attributeName =  [attrAr  objectAtIndex:i];
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
			
			if (valueObj) {
				[encoder encodeObject:valueObj forKey:attributeName];
			}
		}
	}
    [attrAr  release];
}
- (NSData*)getArchivedData
{
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)cleanString:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    //    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];  
}  
#endif

#pragma mark
#pragma mark ----------- New Methord -----------

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
    return [dict autorelease];
}

//通过字典直接向对象赋值,已过滤值为nil的情况，但是Model的默认值在得不到赋值的情况下仍然为nil，可以通过为Model赋初值的方法解决！
//另：此方法不支持列表套列表的解析，因为无法获取到子列表中的数据指向

//下面的方法 Model与Json 一一对应
- (void)convertObjectFromGievnDictionary:(NSDictionary*) dict{
    
    for (NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        if (value==[NSNull null]) {
            continue;
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            id subObj = [self valueForKey:key];
            if (subObj)
                [subObj convertObjectFromGievnDictionary:value];
            
        }else{
            [self setValue:value forKey:key];
        }
    }
}
//后面的参数 若传YES，则优先Model类中属性，Model可选择自己的数据（JSON数据多于需要） 传NO 同上
-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes{
    if (!yes) {
        [self convertObjectFromGievnDictionary:dict];
    }
    NSDictionary *propertyList = [self getPropertyList];
    for (NSString *key in [propertyList allKeys]) {
        id value = [dict objectForKey:key];
        if (nil == value || value == [NSNull null]) {
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
@end
