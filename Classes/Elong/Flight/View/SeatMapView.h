//
//  SeatMapView.h
//  ElongClient
//
//  Created by bruce on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeatMapView;

@protocol SeatMapViewDelegate <NSObject>

@optional
- (void)seatMapView:(SeatMapView *)seatMapView willBeginDragging:(UIScrollView *)scrollView;
- (void)seatMapView:(SeatMapView *)seatMapView didScroll:(UIScrollView *)scrollView;
- (void)seatMapView:(SeatMapView *)seatMapView didEndDragging:(UIScrollView *)scrollView;
- (void)seatMapView:(SeatMapView *)seatMapView willBeginDecelerating:(UIScrollView *)scrollView;
- (void)seatMapView:(SeatMapView *)seatMapView didEndDecelerating:(UIScrollView *)scrollView;
- (void)seatMapView:(SeatMapView *)seatMapView didEndZooming:(UIScrollView *)scrollView atScale:(CGFloat)scale;

@end

@interface SeatMapView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) id<SeatMapViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIView *itemContainer;

-(SeatMapView *)initWithView:(UIView *)viewToMap withRatio:(NSInteger)ratio andItemContainer:(UIView *)itemContainer;

- (void)setMiniMapShowStatus:(BOOL)isShow;

@end
