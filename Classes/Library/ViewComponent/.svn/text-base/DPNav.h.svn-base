//
//  DPNav.h
//  ElongClient
//
//  Created by bin xing on 11-1-31.
//  Copyright 2011 DP. All rights reserved.
//

typedef enum {
	_NavNormalBtnStyle_ = 0,
	_NavNoBackBtnStyle_,
	_NavOnlyBackBtnStyle_,
	_NavOnlyHomeBtnStyle_,
	_NavCalendarBtnStyle_,
	_NavBackShareHomeTelStyle_,
	_NavNoTelStyle_,
	_NavBackShareStyle_,
    _NavOlnyHotelBookmark_
} NavBtnStyle;


typedef enum {
	_NavLeftBtnImageStyle_ = 0,
	_NavLeftBtnTextStyle_
} NavLeftBtnStyle;

#import <UIKit/UIKit.h>
#import "ButtonView.h"
#import "ElongClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@protocol DPNAVProtocal;
@interface DPNav : UIViewController<UIActionSheetDelegate, ButtonViewDelegate> {
    NSString* teliconstring;
    NSString* telSelectIconstring;
    NavBtnStyle m_style;
}

- (void)headerView:(NSString *)backicon backSelectIcon:(NSString *)backSelectIcon
		   telicon:(NSString *)telicon telSelectIcon:(NSString *)telSelectIcon
		  homeicon:(NSString *)homeicon homeSelectIcon:(NSString *)homeSelectIcon;

- (id)init:(NSString *)name btnname:(NSString *)btnname navLeftBtnStyle:(NavLeftBtnStyle)navLeftBtnStyle;
- (id)init:(NSString *)name style:(NavBtnStyle)style navShadowHidden:(BOOL)hidden;
- (id)init:(NSString *)name style:(NavBtnStyle)style;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTitle:(NSString *)title style:(NavBtnStyle)style;
- (id)initWithTopImagePath:(NSString *)imgPath andTitle:(NSString *)titleStr style:(NavBtnStyle)style navShadowHidden:(BOOL)hidden;
- (id)initWithTopImagePath:(NSString *)imgPath andTitle:(NSString *)titleStr style:(NavBtnStyle)style;		// 设置顶部图片－文字形式的标题

-(void)calltel400;
-(void)back ;
-(void)backhome;
//add new
-(void) setNavTitle:(NSString *)title;
-(NSString *) getNavTitle;
-(void) setShowBackBtn:(BOOL)flag;
-(void) setShowBackBtnWithNoHomeBtn:(BOOL)flag;
-(void) setshowHome;
-(void) setshowTelAndHome;
-(void) setshowShareAndHome;
-(void) setshowNormaltpyewithouthtel;
-(void) addTopImageAndTitle:(NSString *)imgPath andTitle:(NSString *)titleStr;
@end

