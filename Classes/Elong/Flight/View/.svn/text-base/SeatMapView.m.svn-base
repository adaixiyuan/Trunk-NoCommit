//
//  SeatMapView.m
//  ElongClient
//
//  Created by bruce on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SeatMapView.h"

@implementation SeatMapView
{
    UIScrollView *zoomedView;
    UIView *miniMap;
    UIImageView *miniMapImageView;
    UIView *miniMapIndicator;
    NSInteger viewRatio;
}

-(SeatMapView *)initWithView:(UIScrollView *)viewToMap withRatio:(NSInteger)ratio andItemContainer:(UIView *)itemContainer
{
    self = [super initWithFrame:viewToMap.frame];
    
    if (self)
    {
        zoomedView = viewToMap;
        viewRatio = ratio;
        [self setBackgroundColor:RGBACOLOR(245, 245, 245, 1.0)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewToMap.size.width, viewToMap.size.height)];
        self.scrollView.contentSize = CGSizeMake(viewToMap.contentSize.width, viewToMap.contentSize.height);
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 3;
        [self.scrollView setBounces:NO];
        [self.scrollView addSubview:viewToMap];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesture.numberOfTapsRequired=1;
        tapGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdAction:)];
        longGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:longGesture];
        
        [self addSubview:self.scrollView];
        
        miniMap = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewToMap.frame.size.width/viewRatio, viewToMap.frame.size.height/viewRatio)];
        miniMap.clipsToBounds = YES;
        miniMapImageView = [[UIImageView alloc]initWithImage:[self captureScreen:viewToMap]];
        
//        miniMapImageView = [[UIImageView alloc]initWithImage:[self captureScreen:itemContainer]];
        miniMapImageView.frame = CGRectMake(0, 0, miniMap.frame.size.width, miniMap.frame.size.height);
        [miniMapImageView setBackgroundColor:RGBACOLOR(57, 57, 57, 1.0)];
//        [miniMapImageView setAlpha:0.6];
        [miniMap addSubview:miniMapImageView];
        self.scrollView.zoomScale = 1;
        [miniMap setBackgroundColor:RGBACOLOR(237, 237, 237, 1.0)];
        [miniMap setHidden:YES];
        [miniMap setAlpha:0.5];
        [self addSubview:miniMap];
        
        
        miniMapIndicator = [[UIView alloc]initWithFrame:CGRectMake(
                                                                  self.scrollView.contentOffset.x/viewRatio/self.scrollView.zoomScale/2,
                                                                  self.scrollView.contentOffset.y/viewRatio/self.scrollView.zoomScale/2,
                                                                  miniMap.frame.size.width/self.scrollView.zoomScale/2,
                                                                  miniMap.frame.size.height/self.scrollView.zoomScale/2)];
        
        [miniMapIndicator setBackgroundColor:[UIColor clearColor]];
//        [miniMapIndicator setAlpha:0.8];
        [miniMap addSubview:miniMapIndicator];
        
        //
        UIImageView *imageViewBox = [[UIImageView alloc] initWithFrame:miniMapIndicator.bounds];
        [imageViewBox setImage:[UIImage imageNamed:@"ico_seat_Marquee.png"]];
        [miniMapIndicator addSubview:imageViewBox];
        
        UIButton *miniMapSelectorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        miniMapSelectorBtn.frame = CGRectMake(0, 0, miniMap.frame.size.width, miniMap.frame.size.height);
        [miniMapSelectorBtn addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents: UIControlEventTouchDragInside | UIControlEventTouchDown];
        
        miniMapSelectorBtn.clipsToBounds = YES;
        [miniMap addSubview:miniMapSelectorBtn];
        
        //
        
    }
    return self;
}


- (void)dragBegan:(UIControl *)c withEvent:ev
{
    UITouch *touch = [[ev allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:miniMap];
    //NSLog(@"Touch x : %f y : %f", touchPoint.x, touchPoint.y);
    if(touchPoint.x<0)
    {
        touchPoint.x=0;
    }
    if(touchPoint.y<0)
    {
        touchPoint.y=0;
    }
    
    if(touchPoint.y + miniMap.frame.size.height/self.scrollView.zoomScale > miniMap.frame.size.height)
    {
        touchPoint.y = miniMap.frame.size.height - miniMap.frame.size.height/self.scrollView.zoomScale;
    }
    
    if(touchPoint.x + miniMap.frame.size.width/self.scrollView.zoomScale > miniMap.frame.size.width)
    {
        touchPoint.x = miniMap.frame.size.width - miniMap.frame.size.width/self.scrollView.zoomScale;
    }
    
    miniMapIndicator.frame = CGRectMake(touchPoint.x, touchPoint.y, miniMap.frame.size.width/self.scrollView.zoomScale, miniMap.frame.size.height/self.scrollView.zoomScale);
    
    [self.scrollView setContentOffset:CGPointMake(touchPoint.x*viewRatio*self.scrollView.zoomScale, touchPoint.y*viewRatio*self.scrollView.zoomScale) animated:NO];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self performSelector:@selector(updateMiniMe) withObject:nil afterDelay:0.1];
}

- (void)holdAction:(UILongPressGestureRecognizer *)holdRecognizer
{
    if (holdRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Holding...");
    }
    else if (holdRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Released...");
        [self updateMiniMe];
    }
}

- (void)updateMiniMe
{
    miniMapImageView.image = [self captureScreen:zoomedView];
}


-(UIImage*)captureScreen:(UIView*) viewToCapture
{
    CGRect rect = [viewToCapture bounds];
//    CGRect rect = CGRectMake(viewToCapture.frame.size.width*0.2, viewToCapture.frame.size.height*0.2, viewToCapture.frame.size.width*0.6, viewToCapture.frame.size.height*0.6);
    
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
//    [self drawViewHierarchyInRect:viewToCapture.bounds afterScreenUpdates:YES];
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setMiniMapShowStatus:(BOOL)isShow
{
    [miniMap setHidden:!isShow];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(seatMapView:willBeginDragging:)])
    {
        [self.delegate seatMapView:self willBeginDragging:self.scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    miniMapIndicator.frame =
    CGRectMake(self.scrollView.contentOffset.x/viewRatio/self.scrollView.zoomScale,
               self.scrollView.contentOffset.y/viewRatio/self.scrollView.zoomScale,
               miniMapIndicator.frame.size.width,
               miniMapIndicator.frame.size.height);
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(seatMapView:didScroll:)])
    {
        [self.delegate seatMapView:self didScroll:self.scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(seatMapView:didEndDragging:)])
    {
        [self.delegate seatMapView:self didEndDragging:self.scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(seatMapView:willBeginDecelerating:)])
    {
        [self.delegate seatMapView:self willBeginDecelerating:self.scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(seatMapView:didEndDecelerating:)])
    {
        [self.delegate seatMapView:self didEndDecelerating:self.scrollView];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"scrollViewDidEndZooming!!!!");
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(seatMapView:didEndZooming:atScale:)])
    {
        [self.delegate seatMapView:self didEndZooming:self.scrollView atScale:scale];
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomedView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    miniMapIndicator.frame = CGRectMake(miniMapIndicator.frame.origin.x
                                       , miniMapIndicator.frame.origin.y,
                                       miniMap.frame.size.width/self.scrollView.zoomScale,
                                       miniMap.frame.size.height/self.scrollView.zoomScale);
}

@end
