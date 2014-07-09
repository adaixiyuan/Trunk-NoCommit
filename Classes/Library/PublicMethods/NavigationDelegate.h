//
//  NavigationProtocol.h
//  ElongClient
//
//  Created by Dawn on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AutoMapNavigation,              // 高德地图
    BaiduMapNavigation,             // 百度地图
    GoogleMapNavigation,            // 谷歌地图
    AppleMapNavigation              // 系统地图
}NavigationMapType;

@protocol NavigationDelegate <NSObject>
@required
- (void) navigationWithMap:(NavigationMapType)mapType;
@end
