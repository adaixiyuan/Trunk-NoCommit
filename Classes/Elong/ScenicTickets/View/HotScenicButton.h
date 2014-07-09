//
//  HotScenicButton.h
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCenicButtonDelegate <NSObject>

- (void) finishClick:(UIButton *)button withIndex:(int ) tag;

@end

@interface HotScenicButton : UIButton
{
    UIImageView *leftVDashView;
    UIImageView *rightVDashView;
    UIImageView  *TopHDashView;
    UIImageView  *bottomHDashView;
}

typedef void (^clickBlock) (HotScenicButton *bt,int i) ;

@property  (nonatomic,assign) BOOL  noLeftShowVertical;
@property  (nonatomic,assign) BOOL  noRightShowVertical;
@property  (nonatomic,assign) BOOL   noTopShowHorizontal;
@property  (nonatomic,assign) BOOL   noBottomShowHorizontal;
@property  (nonatomic,copy) clickBlock myBlock;
@property  (nonatomic,retain) NSString  *bText;
@property  (nonatomic,assign) id <SCenicButtonDelegate> delegate;
@end

