//
//  PackingDefine.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#ifndef ElongClient_PackingDefine_h
#define ElongClient_PackingDefine_h

#define PACKING_BACKCOLOR  RGBACOLOR(248, 248, 248, 1.0)//背景色

#define PACKING_RED         RGBCOLOR(254, 88, 88, 1.0)      //红
#define PACKING_ORANGE  RGBCOLOR(251, 139, 112, 1.0)    //橙
#define PACKING_GREEN     RGBCOLOR(141, 185,125, 1.0)     //绿
#define PACKING_BLUE        RGBCOLOR(132,206,242, 1.0)     //蓝
#define PACKING_GRAY        RGBCOLOR(187,134,200, 1.0)      //灰

/**
 说明
 **/

#define SYSCHRONIED_PACKING_REFRESH @"SyschronizedSuccessfulRefresh"

//修改清单库，用户操作
#define PACKING_LIB_MODIFY @"PACKING_LIB_MODIFY"

//用户数据(所有的用户数据)
#define PACKING_USER_PACKING_LIST @"PACKING_USER_PACKING_LIST"

//模版数据(包含官方的三个和用户自己设置的)
#define PACKING_TEMPLATE @"PACKING_TEMPLATE"

//官方示例  plist文件名
#define PACKING_LIST_PLIST @"PackingList"

//原始清单库 plist文件名
#define PACKING_LIB_PLIST @"PackingLib"

#endif
