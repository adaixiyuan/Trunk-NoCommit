//
//  PackingDataSynchronize.m
//  ElongClient
//
//  Created by Ivan.xu on 14-1-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PackingDataSynchronize.h"
#import "PackingDefine.h"
#import "PackingDataSynchronizeConfig.h"
#import "AccountManager.h"
#import "Utils.h"
#import "PackingModel.h"
#import "PackingCategory.h"
#import "PackingItem.h"

@implementation PackingDataSynchronize

#pragma mark - Private Methods

//读取当前用户修改的清单库
-(NSArray *)currentNeedSynchronizedData{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_USER_PACKING_LIST];
    if (data == NULL) {
        NSLog(@"读取用户PackingList列表失败-");
        return nil;
    }
    if(data.length>1024*1024*1){
        //此处PM需求为数据大于1M时，显示同步失败。
        [Utils alert:@"同步失败！"];
        return nil;
    }
    //缓存中读取
    NSArray *packingList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *returnArray = [NSMutableArray array];
    for (PackingModel *model in packingList) {
        if (![model.isFix isEqualToString:@"1"]) {
            [returnArray addObject:model];
        }
    }
    return returnArray;
}

-(void)writeSynchronizedServerData:(NSArray *)thePackingList{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SYSCHRONIED_PACKING_REFRESH object:thePackingList];
    
}

//将Object的格式List转化成Json格式List
-(NSArray *)convertToJsonListWithObjectList:(NSArray *)thePackingList{
    NSMutableArray *jsonList = [NSMutableArray arrayWithCapacity:1];
    for(PackingModel *model in thePackingList){
        NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [aDict safeSetObject:model.name forKey:NAME];
        [aDict safeSetObject:model.color forKey:COLOR];
        [aDict safeSetObject:model.isAlwaysUsed forKey:ISALWAYSUSED];
        [aDict safeSetObject:model.isFix forKey:ISFIX];
        NSMutableArray *categoryList = [NSMutableArray arrayWithCapacity:1];
        
        for(PackingCategory *category in model.categoryList){
            NSMutableDictionary *bDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [bDict safeSetObject:category.name forKey:NAME];
            NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:1];
            for(PackingItem *item in category.itemList){
                NSMutableDictionary *cDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [cDict safeSetObject:item.name forKey:NAME];
                [cDict safeSetObject:item.isChecked forKey:ISCHECKED];
                [itemList addObject:cDict];
            }
            [bDict safeSetObject:itemList forKey:ITEMLIST];
            [categoryList addObject:bDict];
        }
        [aDict safeSetObject:categoryList forKey:CATEGORYLIST];
        
        [jsonList addObject:aDict];
    }
    
    return jsonList;
}

//将Json格式List转换成Object格式的List
-(NSArray *)convertToObjectListWithJsonList:(NSArray *)jsonList{
    NSMutableArray *thePackingList = [NSMutableArray arrayWithCapacity:1];
    for(NSDictionary *aDict in jsonList){
        PackingModel *model = [[PackingModel alloc] init];
        model.name = [aDict safeObjectForKey:NAME];
        model.color = [aDict safeObjectForKey:COLOR];
        model.isAlwaysUsed = [aDict safeObjectForKey:ISALWAYSUSED];
        model.isFix = [aDict safeObjectForKey:ISFIX];
        
        NSMutableArray *categoryList = [NSMutableArray arrayWithCapacity:1];
        NSArray *json_categoryList = [aDict safeObjectForKey:CATEGORYLIST];
        for(NSDictionary *bDict in json_categoryList){
            PackingCategory *category = [[PackingCategory alloc] init];
            category.name = [bDict safeObjectForKey:NAME];
            
            NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:1];
            NSArray *json_itemList = [bDict safeObjectForKey:ITEMLIST];
            for(NSDictionary *cDict in json_itemList){
                PackingItem *item = [[PackingItem alloc] init];
                item.name = [cDict safeObjectForKey:NAME];
                item.isChecked = [cDict safeObjectForKey:ISCHECKED];
                [itemList addObject:item];
                [item release];
            }
            category.itemList = itemList;
            [categoryList addObject:category];
            [category release];
        }
        model.categoryList = categoryList;
        [thePackingList addObject:model];
        [model release];
    }
    return thePackingList;
}

#pragma mark - General Method

-(void)dealloc{

    [_uid release];
    [_needPackingList release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _uid = [@"" copy];
        _needPackingList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

-(NSString *)requestContent{
    //Finishing Data
    _uid = [[[AccountManager instanse] cardNo] copy];
    NSArray *needSynchronizedList =[self currentNeedSynchronizedData];
    if(!needSynchronizedList){
        return nil;
    }
    NSArray *jsonArray = [self convertToJsonListWithObjectList:needSynchronizedList];
    [_needPackingList removeAllObjects];
    [_needPackingList addObjectsFromArray:jsonArray];
    
    //preparing Data
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [jsonDict safeSetObject:_uid forKey:UID];
    [jsonDict safeSetObject:_needPackingList forKey:PACKINGLIST];
    NSString *jsonParam = [jsonDict JSONString];
    
    return jsonParam;
}

-(void)start{
    NSString *jsonParam = [self requestContent];
    if(jsonParam){
        // 发起请求
        [HttpUtil requestURL:[PublicMethods composeNetSearchUrl:@"mtools" forService:@"travelPacket"] postContent:jsonParam delegate:self];
    }                                                                                          
 }


#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]){
        return ;
    }
    
    //处理数据
    NSArray *packingList = [root objectForKey:PACKINGLIST];
    NSArray *objectList = [self convertToObjectListWithJsonList:packingList];
    NSLog(@"%@",objectList);
    [self writeSynchronizedServerData:objectList];
    [Utils alert:@"同步数据已成功！"];
}

-(void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    [Utils alert:@"同步数据失败，请重试！"];
}


@end
