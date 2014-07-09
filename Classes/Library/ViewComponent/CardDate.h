//
//  CardDate.h
//  ElongClient
//  信用卡有效期弹出框
//
//  Created by bin xing on 11-2-23.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewTopBarDelegate.h"
#import "DPViewTopBar.h"
#import "Utils.h"
@class DPViewTopBar;
@protocol CardDateDelegate;
@interface CardDate : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,DPViewTopBarDelegate> {
	NSMutableArray *realmonths;
	NSMutableArray *containYears;
	NSMutableArray *currentMouths;
	NSMutableArray *allMouths;
	DPViewTopBar *dpViewTopBar;
	UIPickerView *viewPickerView;
	
    id delegate;
}
@property (nonatomic,assign) id<CardDateDelegate> delegate;
-(id)initWithDate:(NSString *)date;
-(void) initStatus;
- (void)dpViewLeftBtnPressed ;
- (void)showInView;
- (void)dismissInView;
@end

@protocol CardDateDelegate <NSObject>
@optional
    - (void) cardDate:(CardDate *)cardDate didSelectedDate:(NSString *)date;
@end
