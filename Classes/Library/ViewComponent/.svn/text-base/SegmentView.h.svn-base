//
//  SegmentView.h
//  QuickHotel
//
//  Created by Dawn on 13-7-28.
//  Copyright (c) 2013年 Xu Wenchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentViewDelegate;
@interface SegmentView : UIView{
@private
    UIImageView *bgView;
    id delegate;
}
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) id<SegmentViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame cells:(NSArray *)cells;
-(void)changeTitleSet:(NSArray *)titles;       //改变选项卡的标题

@end


@protocol SegmentViewDelegate <NSObject>
@optional
- (void) segmentView:(UIView *)segmentView didSelectedIndex:(NSInteger) index;

@end