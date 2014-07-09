//
//  CoordinateTransform.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-2-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CoordinateTransform.h"
#import "AccountManager.h"

#define  x_pi  M_PI * 3000.0 / 180.0

@implementation CoordinateTransform

// 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法
+(CLLocationCoordinate2D)GoogleCoordinateToBaiDuCoordinate:(CLLocationCoordinate2D)coordinate{
    double x = coordinate.longitude;
    double y = coordinate.latitude;
    double z = sqrt(x*x+y*y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake(z*sin(theta) + 0.006,z*cos(theta) + 0.0065);
}
//百度转火星
+ (CLLocationCoordinate2D )BaiDuCoordinateToGoogleCoordinate:(CLLocationCoordinate2D) coodiate
{
    double  x = coodiate.longitude - 0.0065;
    double  y = coodiate.latitude- 0.006;
    double  z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double    bd_lon = z * cos(theta) + 0.0065;
    double    bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

+ (BOOL) adjustIsLogin
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin)
    {
        if (appDelegate.isNonmemberFlow )
        {
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }
    
}

@end
