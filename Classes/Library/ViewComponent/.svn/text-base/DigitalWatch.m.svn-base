//
//  DigitalWatch.m
//  ElongClient
//  模拟电子表
//
//  Created by haibo on 11-11-11.
//  Copyright 2011 elong. All rights reserved.
//

#import "DigitalWatch.h"

#define MAX_SECONDS (WatchTypeNoDay == watchType ? 3600000 : 8640000)	// 最大1000小时或者100天

static NSInteger currentTime;

typedef enum {
	StyleTypeBlue,
	StyleTypeCommon
}StyleType;


@implementation DigitalWatch

@synthesize delegate;


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self stopTimer];
	
    [super dealloc];
}


- (id)initBlueBoardWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		styleType = StyleTypeBlue;
		refreshBlock = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(getAdditonTime:) 
													 name:NOTI_TIME_ADDITION
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(pauseTime) 
													 name:NOTI_TIME_PAUSE
												   object:nil];
		
		UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
		backView.image = [UIImage stretchableImageWithPath:@"number_board_bg.png"];
		[self addSubview:backView];
		[backView release];
		
		int additionOffX = 0;
		for (int i = 0; i < 6; i ++) {
			int offX = frame.size.width / 7.3;  // 背景元素图起始位置
			if (i > 0 && i % 2 == 0) {
				// 添加间隔符
				UIImageView *hm_separator = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 29.0 - 1 + offX * i + additionOffX + frame.size.width / 43,
																						  frame.size.height / 2.65,
																						  0.6 / 29.0 * frame.size.width,
																						  frame.size.height * 2 / 7.0)];
				hm_separator.image = [UIImage imageNamed:@"blue_separator.png"];
				[backView addSubview:hm_separator];
				[hm_separator release];
				
				additionOffX += frame.size.width / 15;
			}
			
			UIImageView *elementView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 29.0 - 1 + offX * i + additionOffX, 
																					  frame.size.height / 8.0,
																					  4 / 29.0 * frame.size.width,
																					  frame.size.height * 4 / 5.0)];
			elementView.image = [UIImage imageNamed:@"blue_num_bg.png"];
			[backView addSubview:elementView];
			[elementView release];
			
			CGRect rect = CGRectOffset(CGRectInset(elementView.frame, 5, 10), -0.5, -2);
			switch (i) {
				case 0: {
					tensHour = [[UIImageView alloc] initWithFrame:rect];
					tensHour.image		 = [UIImage imageNamed:@"num_0.png"];
					[backView addSubview:tensHour];
					[tensHour release];
				}
					break;
				case 1: {
					unitHour = [[UIImageView alloc] initWithFrame:rect];
					unitHour.image		 = [UIImage imageNamed:@"num_0.png"];
					[self addSubview:unitHour];
					[unitHour release];
				}
					break;
				case 2: {
					tensMinute = [[UIImageView alloc] initWithFrame:rect];
					tensMinute.image	   = [UIImage imageNamed:@"num_0.png"];
					[self addSubview:tensMinute];
					[tensMinute release];
				}
					break;
				case 3: {
					unitMinute = [[UIImageView alloc] initWithFrame:rect];
					unitMinute.image	   = [UIImage imageNamed:@"num_0.png"];
					[self addSubview:unitMinute];
					[unitMinute release];
				}
					break;
				case 4: {
					tensSecond = [[UIImageView alloc] initWithFrame:rect];
					tensSecond.image	   = [UIImage imageNamed:@"num_0.png"];
					[self addSubview:tensSecond];
					[tensSecond release];
				}
					break;
				case 5: {
					unitSecond = [[UIImageView alloc] initWithFrame:rect];
					unitSecond.image		= [UIImage imageNamed:@"num_0.png"];
					[self addSubview:unitSecond];
					[unitSecond release];
				}
					break;
				default:
					break;
			}
		}
	}
	
	return self;
}


- (id)initWithFrame:(CGRect)frame Type:(WatchType)type {
    
    self = [super initWithFrame:frame];
    if (self) {
		styleType = StyleTypeCommon;
		refreshBlock = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(getAdditonTime:) 
													 name:NOTI_TIME_ADDITION
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(pauseTime) 
													 name:NOTI_TIME_PAUSE
												   object:nil];
		
		float width	 = 0;						// 每个数字的宽度
		float height = frame.size.height;		// 数字高度
		int distance = 2;						// 数字间距
		int originX  = 0;						// 固定显示部分的初始x偏移量
		watchType	 = type;
		
		if (WatchTypeNoDay == type) {
			width	= frame.size.width / 8;
			originX = width;
			
			hundredHour = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
			hundredHour.image		= [UIImage imageNamed:@"number_0.png"];
			hundredHour.contentMode = UIViewContentModeScaleAspectFit;
			[self addSubview:hundredHour];
			[hundredHour release];
		}
		else {
			width	= frame.size.width / 12;
			originX	= 4.5 * width;
			
            tensDay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
			tensDay.image	    = [UIImage imageNamed:@"number_0.png"];
			tensDay.contentMode = UIViewContentModeScaleAspectFit;
			[self addSubview:tensDay];
			[tensDay release];
            
			unitDay = [[UIImageView alloc] initWithFrame:CGRectMake(distance + width, 0, width, height)];
			unitDay.image	    = [UIImage imageNamed:@"number_0.png"];
			unitDay.contentMode = UIViewContentModeScaleAspectFit;
			[self addSubview:unitDay];
			[unitDay release];
			
			dayWrodLabel = [[UILabel alloc] initWithFrame:CGRectMake(distance + 2 * width + 4, 0, width * 2, height)];
			dayWrodLabel.text						= @"天";
			dayWrodLabel.font						= [UIFont boldSystemFontOfSize:18];
			dayWrodLabel.adjustsFontSizeToFitWidth	= YES;
			dayWrodLabel.backgroundColor			= [UIColor clearColor];
			dayWrodLabel.textColor					= [UIColor blackColor];
			[self addSubview:dayWrodLabel];
			[dayWrodLabel release];
		}
		
		tensHour = [[UIImageView alloc] initWithFrame:CGRectMake(originX + distance, 0, width, height)];
		tensHour.image		 = [UIImage imageNamed:@"number_0.png"];
		tensHour.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:tensHour];
		[tensHour release];
		
		unitHour = [[UIImageView alloc] initWithFrame:CGRectMake(distance + tensHour.frame.origin.x + tensHour.frame.size.width, 0, width, height)];
		unitHour.image		 = [UIImage imageNamed:@"number_0.png"];
		unitHour.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:unitHour];
		[unitHour release];
		
		UIImageView *separatorHM = [[UIImageView alloc] initWithFrame:CGRectMake(distance + unitHour.frame.origin.x + unitHour.frame.size.width, 0, width / 2, height)];
		separatorHM.image		= [UIImage imageNamed:@"time_Separator.png"];
		separatorHM.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:separatorHM];
		[separatorHM release];
		
		tensMinute = [[UIImageView alloc] initWithFrame:CGRectMake(distance + separatorHM.frame.origin.x + separatorHM.frame.size.width, 0, width, height)];
		tensMinute.image	   = [UIImage imageNamed:@"number_0.png"];
		tensMinute.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:tensMinute];
		[tensMinute release];
		
		unitMinute = [[UIImageView alloc] initWithFrame:CGRectMake(distance + tensMinute.frame.origin.x + tensMinute.frame.size.width, 0, width, height)];
		unitMinute.image	   = [UIImage imageNamed:@"number_0.png"];
		unitMinute.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:unitMinute];
		[unitMinute release];
		
		UIImageView *separatorMS = [[UIImageView alloc] initWithFrame:CGRectMake(distance + unitMinute.frame.origin.x + unitMinute.frame.size.width, 0, width / 2, height)];
		separatorMS.image		= [UIImage imageNamed:@"time_Separator.png"];
		separatorMS.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:separatorMS];
		[separatorMS release];
		
		tensSecond = [[UIImageView alloc] initWithFrame:CGRectMake(distance + separatorMS.frame.origin.x + separatorMS.frame.size.width, 0, width, height)];
		tensSecond.image	   = [UIImage imageNamed:@"number_0.png"];
		tensSecond.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:tensSecond];
		[tensSecond release];
		
		unitSecond = [[UIImageView alloc] initWithFrame:CGRectMake(distance + tensSecond.frame.origin.x + tensSecond.frame.size.width, 0, width, height)];
		unitSecond.image		= [UIImage imageNamed:@"number_0.png"];
		unitSecond.contentMode	= UIViewContentModeScaleAspectFit;
		[self addSubview:unitSecond];
		[unitSecond release];
    }
	
    return self;
}


- (void)getAdditonTime:(NSNotification *)noti {
	refreshBlock = YES;
	NSInteger addTime = [[noti object] intValue];
	
	currentTime += addTime;
	refreshBlock = NO;
}


- (void)pauseTime {
	refreshBlock = YES;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
	if (!newSuperview) {
		[self stopTimer];
	}
}


- (void)refreshTimeImage {
	if (!refreshBlock) {
		int hours	= currentTime / 3600;
		int minutes = currentTime % 3600 / 60;
		int seconds = currentTime % 3600 % 60;
		
		//NSLog(@"hours:%d,minute:%d,second:%d",hours,minutes,seconds);
		if (styleType != StyleTypeBlue) {
			if (WatchTypeNoDay == watchType) {
				hundredHour.image = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", hours / 100]];
				tensHour.image	  = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", hours / 10 % 10]];
				unitHour.image	  = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", hours % 10]];
			}
			else {
				int dayNum = hours / 24;
				//if (0 == dayNum) {
				//			// 为0时不显示
				//			unitDay.hidden	= YES;					
				//			dayWrodLabel.hidden = YES;
				//		}
				//		else {
				//			unitDay.hidden	= NO;
				//			dayWrodLabel.hidden	= NO;
				//			
				//		}
				tensDay.image   = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", dayNum / 10]];
				unitDay.image	= [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", dayNum % 10]];
				tensHour.image  = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", hours % 24 / 10]];
				unitHour.image  = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", hours % 24 % 10]];
			}
			
			tensMinute.image = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", minutes / 10]];
			unitMinute.image = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", minutes % 10]];
			tensSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", seconds / 10]];
			unitSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"number_%d.png", seconds % 10]];
		}
		else {
			tensHour.image	  = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", hours / 10 % 10]];
			unitHour.image	  = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", hours % 10]];
			tensMinute.image  = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", minutes / 10]];
			unitMinute.image  = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", minutes % 10]];
			tensSecond.image  = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", seconds / 10]];
			unitSecond.image  = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", seconds % 10]];
		}
	}
}


- (void)timeUp {
	currentTime ++;
	[self refreshTimeImage];
}


- (void)timeDown {
	currentTime --;
	[self refreshTimeImage];
}


#pragma mark -
#pragma mark Thread Methods

- (void)timeEnd {
	if ([delegate respondsToSelector:@selector(timeFired)]) {
		[delegate timeFired];
	}
}


- (void)threadForTimeDown {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    while (currentTime > 0) {
		NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
		if (!timeThread || [timeThread isCancelled] || [timeThread isFinished]) {
			return;
		}
        [NSThread sleepForTimeInterval:1];
		[self performSelectorOnMainThread:@selector(timeDown) withObject:nil waitUntilDone:YES];
		
		[loopPool drain];
    }
	
	[self performSelectorOnMainThread:@selector(timeEnd) withObject:nil waitUntilDone:YES];
	
   [pool drain];
}


- (void)threadForTimeUp {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while (currentTime < MAX_SECONDS - 1) {
		if ([timeThread isCancelled]) {
			return;
		}
		
        [NSThread sleepForTimeInterval:1];
		[self performSelectorOnMainThread:@selector(timeUp) withObject:nil waitUntilDone:YES];
    }
	
	[self performSelectorOnMainThread:@selector(timeEnd) withObject:nil waitUntilDone:YES];
	
    [pool release];
}


#pragma mark -
#pragma mark Public Methods

- (void)startTimeFromZero {
	currentTime = 0;
	
	[self timeUp];
	
	// 防止主线程中有能阻塞nstimer的方法，使用独立线程运行计时
	timeThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadForTimeUp) object:nil];
	[timeThread start];
}


- (void)startCountDownFromTime:(NSInteger)seconds {
	if (seconds >= MAX_SECONDS) {
		seconds = MAX_SECONDS - 1;
	}
	currentTime = seconds;

	[self timeDown];
	
	// 同上
	timeThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadForTimeDown) object:nil];
	[timeThread start];
}


- (void)stopTimer {
	[timeThread cancel];
	[timeThread release];
	timeThread = nil;
}

@end
