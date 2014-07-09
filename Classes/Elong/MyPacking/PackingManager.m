//
//  PackingManager.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PackingManager.h"
#import "PackingDefine.h"
#import "PackingModel.h"
#import "PackingCategory.h"
#import "PackingItem.h"

@implementation PackingManager

-(id)init{
    if (self = [super init]) {
        //        
    }
    return self;
}

+(PackingManager *)sharedInstance{
    static PackingManager *_instance;
    static  dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        _instance = [[PackingManager alloc] init];
    });
    return _instance;
}

/*
 *初始化plist文件，其一为官方示例 其二为清单库
 主要是将上述文件 实体化并存储在缓存中，以后供后续页面使用
 */
-(void)initThePackingModuleData{
    //清单库
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_LIB_MODIFY];
    if (data == NULL) {
        //从Plist读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:PACKING_LIB_PLIST ofType:@"plist"];
        NSFileManager  *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:plistPath]) {
            NSLog(@"Cannot find the plist file !");
            return;
        }
        NSMutableArray *plistData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        //最终结果(已转化为实体的数组)
        NSMutableArray *category_Array = [self getEntitysFromGivenCategoryArrays:plistData];
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:category_Array];
        [plistData release];
        [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_LIB_MODIFY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //官方示例(模版)
    NSData *offical = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
    if (offical == NULL) {
        //从Plist读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:PACKING_LIST_PLIST ofType:@"plist"];
        NSFileManager  *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:plistPath]) {
            NSLog(@"Cannot find the plist file !");
            return;
        }
        NSMutableArray *plistData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        //最终结果(已转化为实体的数组)
        NSMutableArray *travels_array = [[NSMutableArray alloc] initWithCapacity:[plistData count]];
        for (NSDictionary *dic in plistData) {
            PackingModel *travel = [[PackingModel alloc] init];
            NSArray *keys = [dic allKeys];
            for (NSString *key in keys) {
                if ([dic objectForKey:key] != nil) {
                    [travel setValue:[dic objectForKey:key] forKey:key];
                }
            }
            //解析嵌套的Categorylist
            NSMutableArray *category_Array = [self getEntitysFromGivenCategoryArrays:travel.categoryList];
            [travel.categoryList removeAllObjects];
            [travel.categoryList addObjectsFromArray:category_Array];
            [travels_array addObject:travel];
            [travel release];
        }
        [plistData release];
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:travels_array];
        [travels_array release];
        [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_TEMPLATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

//从Categorylist到最小的item
-(NSMutableArray *)getEntitysFromGivenCategoryArrays:(NSMutableArray *)array{
    //初始化数据，转换成实体对象!
    NSMutableArray *category_Array = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dic in array) {
        PackingCategory *category = [[PackingCategory alloc] init];
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            if ([dic objectForKey:key] != nil) {
                [category setValue:[dic objectForKey:key] forKey:key];
            }
        }
        //解析得到 Category 继续解析 得到Item
        NSMutableArray *item_array = [[NSMutableArray alloc] initWithCapacity:[category.itemList count]];
        for (NSDictionary *object in category.itemList) {
            PackingItem *item = [[PackingItem alloc] init];
            NSArray *keys = [object allKeys];
            for (NSString *key in keys) {
                if ([object objectForKey:key] != nil) {
                    [item setValue:[object objectForKey:key] forKey:key];
                }
            }
            //得到Item
            [item_array addObject:item];
            [item release];
        }
        //解析完毕
        [category.itemList removeAllObjects];
        [category.itemList addObjectsFromArray:item_array];
        [item_array release];
        
        [category_Array addObject:category];
        [category release];
    }
    return [category_Array autorelease];
}


-(void)updateTheUserPackingListDataWithData:(NSMutableArray *)userList{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userList];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:PACKING_USER_PACKING_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getUserPackingListFromDefaultStore{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_USER_PACKING_LIST];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}

//刷新常用模版库
-(void)updateTheUserPackingTemplateWithData:(PackingModel *)model{
    
    NSData *offical = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
    if (offical == nil) {
        NSLog(@"常用模版-数据错误-");
        return;
    }
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:offical];
    if ([model.isAlwaysUsed isEqualToString:@"1"]) {
        //添加
        PackingModel *m_model = [model mutableCopy];
        [array addObject:m_model];
        [m_model     release];
        
    }else{
        //移除
        int index = 0;
        for (PackingModel *p_model in array) {
            if ([p_model.name isEqualToString:model.name]) {
                index = [array indexOfObject:p_model];
            }
        }
        [array removeObjectAtIndex:index];
    }
    NSData *save = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_TEMPLATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getUserPackingTemplateLib{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}


@end
