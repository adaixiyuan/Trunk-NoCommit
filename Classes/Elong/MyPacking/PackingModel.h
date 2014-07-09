//
//  PackingModel.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackingModel : NSObject<NSCoding,NSCopying,NSMutableCopying>{

    NSString *_name;                 //旅行名称
    NSString *_color;                 //旅行背景色
    NSString *_isAlwaysUsed;    //是否设为常用 1为常用
    NSString *_isFix;                  //是否为范例（可修改，不同步服务器）1为范例
    NSMutableArray *_categoryList;//Category集合   //categoryList
    //
    float _progress; //进度
    
}
@property (nonatomic,retain)    NSString *name;                 //旅行名称
@property (nonatomic,retain)    NSString *color;                 //旅行背景色
@property (nonatomic,retain)    NSString *isAlwaysUsed;    //是否设为常用 1为常用
@property (nonatomic,retain)    NSString *isFix;                  //是否为范例（可修改，不同步服务器）1为范例
@property (nonatomic,retain)    NSMutableArray *categoryList;//Category集合
@property (nonatomic,assign)   float progress;

@end
