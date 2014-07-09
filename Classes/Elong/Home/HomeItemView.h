//
//  HomeItemView.h
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeItem.h"
#import "HomeAdView.h"

@class HomeItemView;
@protocol HomeItemViewDelegate <NSObject,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@optional
- (void) homeItemViewWillBeginEdit:(HomeItemView *)itemView;
- (void) homeItemViewWillBeginDelete:(HomeItemView *)itemView;
- (void) homeItemViewWillEndEdit:(HomeItemView *)itemView;
- (void) homeItemViewBeginMove:(HomeItemView *)itemView;
- (void) homeItemViewMoved:(HomeItemView *)itemView offset:(CGPoint)offset position:(CGPoint)position;
- (void) homeItemViewEndMove:(HomeItemView *)itemView;
- (void) homeItemViewAction:(HomeItemView *)itemView;
@end

@interface HomeItemView : UIView<HomeItemViewDelegate>{
@private
    float scrollHeight;
}
@property (nonatomic,assign) id<HomeItemViewDelegate> delegate;
@property (nonatomic,retain) HomeItem *item;
@property (nonatomic,retain) NSArray *subitems;
@property (nonatomic,retain) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic,retain) UITapGestureRecognizer *singleTap;
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,assign) HomeAdView *adView;

- (id)initWithDataSource:(HomeItem *)item;
- (void) beginEditFromLeft:(BOOL)left;
- (void) endEdit;
- (void) refresh;
- (void) reloadItems;
@end


