//
//  DigitalWatch.h
//  ElongClient
//  模拟电子表
//
//  Created by haibo on 11-11-11.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	WatchTypeNoDay,			// 没有天数显示，有3位数的小时
	WatchTypeHaveDay		// 有天数显示,有2位数小时
}WatchType;


@protocol DigitalWatchDelegate;

@interface DigitalWatch : UIView {
@private
	UIImageView *hundredHour;
	UIImageView *tensHour;
	UIImageView *unitHour;
	UIImageView *tensMinute;
	UIImageView *unitMinute;
	UIImageView *tensSecond;
	UIImageView *unitSecond;
    UIImageView *tensDay;
	UIImageView *unitDay;
	
	UILabel *dayWrodLabel;
	
	NSThread *timeThread;
	
	WatchType watchType;
	
	NSInteger styleType;
	
	BOOL refreshBlock;			// 屏幕更新锁
}

@property (nonatomic, assign) id <DigitalWatchDelegate> delegate;

- (id)initBlueBoardWithFrame:(CGRect)frame;				// 蓝色底板效果
- (id)initWithFrame:(CGRect)frame Type:(WatchType)type;	// 黑色液晶字效果

- (void)startTimeFromZero;								// 从零开始计时
- (void)startCountDownFromTime:(NSInteger)seconds;		// 从指定秒数开始倒计时
- (void)stopTimer;										// 停止计时

@end


@protocol DigitalWatchDelegate <NSObject>

@optional
- (void)timeFired;				// 到时

@end
