//
//  CityUpdater.h
//  ElongClient
//  城市列表更新基类
//  Created by garin on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CityDataDirectoryPath @"CityListData"           //城市列表文件夹

@interface CityUpdater : NSObject<HttpUtilDelegate>
{
    HttpUtil *cityListRequest;
    NSString *apiCityVersion;    //api城市版本
    NSString *localCityVersion;  //本地城市版本
}

//初始化，传入api当前城市版本
-(id) init:(NSString *) apiCityVersion_;

//发送更新请求,自动释放自己
-(void) sendUpdateReqThenDealloc;

//是否需要更新检测,子类去实现
-(BOOL) isNeedUpdate;

@end
