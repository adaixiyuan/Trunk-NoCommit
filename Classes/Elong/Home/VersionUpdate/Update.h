//
//  Update.h
//  ElongClient
//
//  Created by elong lide on 11-11-3.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCityUpdate.h"
#import "HotelCityUpdater.h"

@class LoadingView;

@interface Update : UIView {
	NSString* m_downLoadUrl; //更新地址
	int m_halfupdate;  //点击了更新按钮，但是没有下载
	
    HttpUtil *cacheManageUtil;
    HttpUtil *updateUtil;
    HttpUtil *checkUpdateUtil;
    
    TrainCityUpdate *trainCityUpdate;
}

- (void)initData;
-(void)checkUpdateFromServer;

@end
