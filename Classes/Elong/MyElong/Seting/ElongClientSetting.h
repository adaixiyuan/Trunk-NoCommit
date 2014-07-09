//
//  ElongClientSetting.h
//  ElongClient
//
//  Created by Ivan.xu on 13-12-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "UMengUFPViewController.h"
#import "WeixinOuthor.h"

@interface ElongClientSetting : DPNav<UITableViewDataSource,UITableViewDelegate,UMengUFPViewControllerDelegate,WeixinOuthorDelegate>{
    UITableView *_tableView;
    UMengUFPViewController *umengUFPVC;
    Update *m_update;   //版本更新
    WeixinOuthor *weixinOuthor;
    
    BOOL cacheStateIsDoing;      // 标记缓存处理状态，default＝NO
    unsigned long long imageCacheSize;          // 程序中所有图片缓存的大小，默认数量为0
}

@end
