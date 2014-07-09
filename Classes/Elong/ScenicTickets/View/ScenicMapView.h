//
//  ScenicMapView.h
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBarView.h"
#import "BaseBottomBar.h"
#import "HttpUtil.h"
#define MAP_ZOOM_LEVEL			0.05
@protocol ScenicMapDelegate <NSObject>

- (void) longpress:(CLLocationCoordinate2D)cood;

@end

@interface ScenicMapView : UIView<UISearchBarDelegate,MKMapViewDelegate,BaseBottomBarDelegate>
{
    MKMapView  *map;
    NSMutableArray  *allAnnotionAr;
    int  addFlag;
    BaseBottomBar  *mapFooterView;
    HttpUtil  *moreUtil;
    
}
- (id)initWithFrame:(CGRect)frame  withAnnotionAr:(NSArray *)annotionAr;

- (void) parserAnnotion:(NSArray  *)ar;

@property  (nonatomic,assign) id <ScenicMapDelegate> delegate;

@end

