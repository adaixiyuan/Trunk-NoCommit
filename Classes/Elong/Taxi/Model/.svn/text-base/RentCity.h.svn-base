//
//  RentCity.h
//  ElongClient
//  租车覆盖城市
//  Created by Jian.Zhao on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

/*说明
 *RentCity->Airport->Terminal
 *(只有接送机产品有,非接送机此列表为null)
 *
 */

/*
@interface Terminal : BaseModel

@property(nonatomic,copy) NSString *termCode;//航站楼代码(eg:T1)
@property(nonatomic,copy) NSString *termLng;//航站楼经度
@property(nonatomic,copy) NSString *termLat;//航站楼纬度
@property(nonatomic,copy) NSString *termName;//航站楼名称
 
@end

@interface Airport : BaseModel

@property(nonatomic,copy) NSString *airPortCode;//机场三字码
@property(nonatomic,copy) NSString *airPortName;//机场名称
@property(nonatomic,copy) NSString *airPortLng;//机场经度坐标
@property(nonatomic,copy) NSString *airPortLat;//机场纬度坐标
@property(nonatomic,copy) NSArray *terminalList;//航站楼列表

@end

*/

@interface RentCity : BaseModel

@property(nonatomic,copy) NSString *cityCode;//城市ID(艺龙定义,后台去对服务商做映射)
@property(nonatomic,copy) NSString *cityName;//城市名称
@property (nonatomic,retain) NSArray *airPortLst;//覆盖机场列表

@end

/*
 * -----------------上面是API返回的数据结构，与客户端需要展现的数据结构不太一致，因此此处根据客户端需求重新组织数据，将数据结构抽离出来(TaxiUtils类中)
 *------------------ 若业务上修改变更，可扩展或修改此Model
 */

@interface CustomAirportTerminal : BaseModel

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *cityName;//机场所在城市
@property (nonatomic,copy)NSString *cityCode;//机场所在城市ID
@property (nonatomic,copy)NSString *airPortCode;//机场三字码！
//机场若有航站楼 经纬度为航站楼经纬度，若无，则是机场经纬度
@property(nonatomic,copy) NSString *longitude;//机场经度坐标
@property(nonatomic,copy) NSString *latitude;//机场纬度坐标


@end

