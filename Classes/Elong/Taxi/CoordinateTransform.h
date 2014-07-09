//
//  CoordinateTransform.h
//  ElongClient
//  坐标系转换
//  Created by Jian.Zhao on 14-2-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

/*
 *
 1、  WGS84（地图坐标）
 美国GPS使用的是WGS84的坐标系统。GPS系统获得的坐标系统，基本为标准的国际通用的WGS84坐标系统
 
 2、  GCJ-02（火星坐标）
 GCJ-02是由中国国家测绘局制订的地理信息系统的坐标系统。它是一种对经纬度数据的加密算法，即加入随机的偏差。国内出版的各种地图系统（包括电子形式），出于国家安全考虑，必须至少采用GCJ-02对地理位置进行首次加密。
 
 所有的电子地图所有的导航设备，都需要加入国家保密插件。第一步，地图公司测绘地图，测绘完成后，送到国家测绘局，将真实坐标的电子地图，加密成“火星坐标”，这样的地图才是可以出版和发布的，然后才可以让GPS公司处理。第二步，所有的GPS公司，只要需要汽车导航的，需要用到导航电子地图的，统统需要在软件中加入国家保密算法，将COM口读出来的真实的坐标信号，加密转换成国家要求的保密的坐标，这样，GPS导航仪和导航电子地图就可以完全匹配，GPS也就可以正常工作。
 
 在国内发行的地图都使用GCJ02进行首次加密，
                                                    地图                                  坐标系
                                                 百度地图                           百度坐标（BD-09）
                                                 腾讯搜搜地图                     火星坐标
                                                 图吧MapBar地图                图吧坐标
                                                 高德MapABC地图API         火星坐标
                                                 凯立德地图                         火星坐标（转为K码）
 I、 百度坐标：在GCJ02基础上，进行了BD-09二次加密措施，API支持从WGS/GCJ转换成百度坐标，不支持反转。
 
 II、凯立德K码：
 a) K码将地图分成了四块进行编码，中心点在内蒙的阿拉善左旗境内，该点的K码是7uy1yuy1y。以该点为中心分别在东西方向和南北方向画一条线当横纵（XY）坐标轴，那么第一象限（即东北方向的那块）的K码的第1位全部都是5，第2象限的K码的第一位全是6，第3、4象限的K码的第一位分别全是7、8。并且该点有4个K码，即用四个K码定位都是这一点，这四个K码分别是7uy1yuy1y、80000uy1y、500000000、6uy1y0000。
 b) K码的第2-5位表示东西方向上的坐标，第6-9位代表南北方向上的坐标。实际上K码就是一个凯立德特有的34进制数，（26个字母加10个阿拉伯数字，再去掉不用的小写L和O共34个字符），这个34进制数从左向右从低位向高位排列（我们常用的10进制是从右向左由低位向高位排列），其中第2-5位东西方向上的数每一个单位代表2.5m左右，南北方向上的数每一个单位代表实际距离3米左右。比如80000uy1y向东约2.5米的点的K码就是81000uy1y，向东约34×2.5m的点的K码就是80100uy1y
 
 c)K码与火星坐标可相互转换。
 
 */

#import <Foundation/Foundation.h>

@interface CoordinateTransform : NSObject

// 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法
+(CLLocationCoordinate2D)GoogleCoordinateToBaiDuCoordinate:(CLLocationCoordinate2D)coordinate;
+ (CLLocationCoordinate2D)BaiDuCoordinateToGoogleCoordinate:(CLLocationCoordinate2D) coodiate;

+ (BOOL) adjustIsLogin;

@end
