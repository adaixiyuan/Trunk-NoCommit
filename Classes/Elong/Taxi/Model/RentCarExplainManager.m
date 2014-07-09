//
//  RentCarExplainManager.m
//  ElongClient
//
//  Created by licheng on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarExplainManager.h"
#import "PickupModel.h"
#import "RentCarExpensesModel.h"
@implementation RentCarExplainManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _carTypeArray = [[NSMutableArray alloc]init];
        _explainArray = [[NSMutableArray alloc]init];
    }
    return self;
}

//解析租车列表第一步请求
-(void)parseStep1Reqestdict:(NSDictionary *)root{
    
    NSArray * carTypeListArr=[root safeObjectForKey:@"carTypeList"];
    for (NSDictionary *dict in carTypeListArr) {
        PickupModel *pickup = [[PickupModel alloc]initWithDataDic:dict];
        [_carTypeArray addObject:pickup];
        [pickup release];
    }
    
}
//解析租车列表第二步请求
-(void)parseStep2Reqestdict:(NSDictionary *)root{
    
    
    NSArray *dataArray=[root safeObjectForKey:@"contentList"];
    if (!dataArray || [dataArray count]<1) {
        return;
    }
    NSDictionary *dict = [dataArray objectAtIndex:0];
    
    NSString *dataString  = [dict safeObjectForKey:@"content"];
    
    NSArray *tip1Array = [dataString componentsSeparatedByString:@"||"];
    NSLog(@"tip1==%d",[tip1Array count]);
    
    self.figureRule = [tip1Array safeObjectAtIndex:0];
    
    self.rangeRule = [tip1Array safeObjectAtIndex:1];
    
    NSString *component1 = [tip1Array safeObjectAtIndex:2];

    NSArray *tip2Array=[component1 componentsSeparatedByString:@"&&"];

    NSString *replaceString  = @"<a id=\"seeDetail\" onclick =\"clickme()\" style='color:#0000FF'>城郊界限示例</a>";

    for (NSString *cell1 in tip2Array ) {
        NSArray *contentArray = [cell1 componentsSeparatedByString:@"^"];
        NSLog(@"contetntarray==%d",[contentArray count]);
        if ([contentArray count]==2) {
            NSString *title=[contentArray objectAtIndex:0];
            NSString *content=[contentArray objectAtIndex:1];
            if ([@"空驶费"isEqualToString:title]) {
                content = [content stringByReplacingOccurrencesOfString:@"城郊界限示例" withString:replaceString];
            }

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",content,@"content", nil];
            RentCarExpensesModel * rcemodel = [[RentCarExpensesModel alloc]initWithDataDic:dict];
            [_explainArray addObject:rcemodel];
            [rcemodel release];
        }
    }
    
}

//拼接html 文本
-(NSString *)packageHTML:(NSString *)title tip1Array:(NSArray *)tip1Array figureRule:(NSString *)figureRule rangeRule:(NSString *)rangeRule tip2Array:(NSArray *)tip2Array{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chargesInfo" ofType:@"txt"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlFormat = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];

    NSString* line = @"<tr><td style='text-align:center;font-size: 11px;color:#555555'>%@</td><td style='font-size: 11px;text-align:center;color:#555555'>%@</td><td style='font-size: 11px;text-align:center;color:#555555'>%@</td><td style='font-size: 11px;color:#555555'>%@</td></tr>";
    
    NSString *c = @"";
    for (int i = 0; i<[tip1Array count]; i++) {
        PickupModel* row = [tip1Array objectAtIndex: i];
        NSString *startfee = [NSString stringWithFormat:@"%@%@",row.fee,row.feeUnit];
        NSString* strRow = [NSString stringWithFormat:line, row.carTypeName, startfee,row.startingOffers,row.additionalCosts];
        c = [c stringByAppendingString:strRow];
    }
    //package  其他费用说明
    NSString* line2 = @"<tr><td style='text-align:center;font-size: 11px;color:#555555'>%@</td><td style='font-size: 11px;color:#555555'>%@</td></tr>";

    NSString *c2 = @"";
    for (int i = 0; i<[tip2Array count]; i++) {
        RentCarExpensesModel* row = [tip2Array objectAtIndex: i];
        NSString* strRow = [NSString stringWithFormat:line2, row.title, row.content];
        c2 = [c2 stringByAppendingString:strRow];
    }
    
    NSString* htmlStr = [NSString stringWithFormat:htmlFormat,title,c,figureRule,rangeRule,c2];
    
    [htmlFormat release];
    return htmlStr;
}

-(void)resetself{
    
    _figureRule = @"";
    _rangeRule = @"";
    _title = @"";
    [_carTypeArray removeAllObjects];
    [_explainArray removeAllObjects];

}


-(void)dealloc{
    setFree(_figureRule);
    setFree(_rangeRule);
    setFree(_title);
    setFree(_carTypeArray);
    setFree(_explainArray);
    [super dealloc];
}

@end
