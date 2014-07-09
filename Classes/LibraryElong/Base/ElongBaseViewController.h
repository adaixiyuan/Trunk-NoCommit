//
//  ElongBaseViewController.h
//  ElongClient
/*  替代原来项目里的DPNav，封装所有viewcontroller公共逻辑部分的代码；
 *  本类默认不实现viewDidUnload方法，由子类继承实现；
 *  默认使用ARC
 */
//
//  Created by 赵 海波 on 13-12-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonView.h"

typedef enum {
	NavBarBtnStyleNormalBtn = 0,
	NavBarBtnStyleNoBackBtn,
	NavBarBtnStyleOnlyBackBtn,
	NavBarBtnStyleOnlyHomeBtn,
	NavBarBtnStyleCalendarBtn,
	NavBarBtnStyleBackShareHomeTel,
	NavBarBtnStyleNoTel,
	NavBarBtnStyleBackShare,
    NavBarBtnStyleOlnyHotel
}NavBarBtnStyle;      // 顶部导航栏样式

@interface ElongBaseViewController : UIViewController<UIActionSheetDelegate, ButtonViewDelegate>
{
    NavBarBtnStyle m_style;
    NSString* teliconstring;
    NSString* telSelectIconstring;
}

// 新版本的初始化方法，只有文字和样式
- (id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style;
- (void)calltel400;

- (void)back;
- (void)backhome;

-(void) addTopImageAndTitle:(NSString *)imgPath andTitle:(NSString *)titleStr;
@end
