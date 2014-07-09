//
//  HomeAdView.h
//  Home
//
//  Created by Dawn on 13-12-7.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeAdView : UIView<UIScrollViewDelegate>{
    BOOL beginDrag;
}
@property (nonatomic,readonly) NSInteger currentPage;
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,assign) float timeInterval;
@property (nonatomic,assign) float animationInterval;
@property (nonatomic,assign) BOOL pause;
- (id)initWithFrame:(CGRect)frame;
- (void) loadAdsWithUrls:(NSArray *)urls defaultImage:(UIImage *)image;
- (void) startAutoPage;
- (void) stopAutoPage;
@end
