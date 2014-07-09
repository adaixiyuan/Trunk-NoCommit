//
//  ScalableView.h
//  ElongClient
//
//  Created by Wang Shuguang on 12-12-11.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScalableViewDelegate;
@interface ScalableView : UIView{
@private
    NSMutableArray *buttons;
    CGSize buttonSize;
    id delegate;
    int buttonSpace;
    int buttonCount;
    BOOL expand;
    UIImageView *lineView;
    float frameTime;
    int bounceSpace;
    int lastIndex;
}
@property (nonatomic,assign) id<ScalableViewDelegate> delegate;
@property (nonatomic,retain) NSArray *imageArray;
@property (nonatomic,retain) NSArray *hightlightedArray;
- (id)initWithFrame:(CGRect)frame images:(NSArray *)images highlightedImages:(NSArray *)hImages;
- (void) moveBack;
- (void) moveOut;
@end


@protocol ScalableViewDelegate <NSObject>
@optional
- (void) scalableView:(ScalableView *)ScalableView didSelectedAtIndex:(NSInteger)index;
- (void) scalableViewDidMoveout:(ScalableView *)ScalableView;
@end