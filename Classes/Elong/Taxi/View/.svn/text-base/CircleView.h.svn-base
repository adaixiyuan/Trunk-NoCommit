//
//  CircleView.h
//  CircleProgressView
//
//  Created by nieyun on 14-1-26.
//  Copyright (c) 2014年 changjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleViewDelegate;

@interface CircleView : UIView{
    
}
@property (nonatomic,assign) id<CircleViewDelegate> delegate;
@property (nonatomic,assign) BOOL pause;
- (void) startAnimation:(float)duration andTimeFlow:(float)time;
- (void) stopAnimation;
@end


@protocol CircleViewDelegate <NSObject>
@optional
- (void) circleView:(CircleView *)circleView process:(float)process;

@end