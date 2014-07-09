//
//  XGMotionView.m
//  CRMotionViewDemo
//
//  Created by 李程 on 14-6-11.
//  Copyright (c) 2014年 Christian Roman. All rights reserved.
//


//static const CGFloat CRMotionViewRotationMinimumTreshold = 0.1f;
static const CGFloat CRMotionGyroUpdateInterval = 1 / 100;
static const CGFloat CRMotionViewRotationFactor = 4.0f;

//@import CoreMotion;

#import <CoreMotion/CoreMotion.h>

#import "XGMotionView.h"
#import <objc/runtime.h>

@interface XGMotionView()


@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat motionRate;
@property (nonatomic, assign) NSInteger minimumXOffset;
@property (nonatomic, assign) NSInteger maximumXOffset;

@property(nonatomic,strong)UILabel *tipsLabel;

@end


@implementation XGMotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        [self commonInit];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        [self commonInit];
        [self setImage:image];
    }
    return self;
}


- (void)commonInit
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_viewFrame];
    [_scrollView setUserInteractionEnabled:NO];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeZero];
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_viewFrame];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_scrollView addSubview:_imageView];
    
    _minimumXOffset = 0;
    
//    [self startMonitoring];
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = image;
    
//    float defaultwidth = _viewFrame.size.width;  //_viewFrame.size.height
    
//    CGFloat height = _viewFrame.size.width / _image.size.width * _image.size.height;
    [_imageView setFrame:CGRectMake(0, 0, _image.size.width, _image.size.height)];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_imageView setImage:_image];
    
    _scrollView.contentSize = CGSizeMake(_image.size.width, _image.size.height);
    _scrollView.contentOffset = CGPointMake(0, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2);
    
    _motionRate = _image.size.height / _viewFrame.size.height * CRMotionViewRotationFactor;
    _maximumXOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
}


#pragma mark - Core Motion

- (void)startMonitoring
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval;
    }
    
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            
            NSLog(@" motion...");
            
            float rate_y = accelerometerData.acceleration.y;
            
            if (rate_y>0) {
                
            }else if (rate_y==0){
                
            }else if(rate_y<0){
                
                rate_y+=1;
                
                rate_y = 1-rate_y;
                
                int upDistance = (int)_maximumXOffset/2*rate_y;
                
                //NSLog(@"rate_y==%d",(-upDistance));
                
                rate_y = -upDistance;
            }
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [_scrollView setContentOffset:CGPointMake(0, -rate_y) animated:NO];
                             }
                             completion:nil];

            
        });
    }];

    
}

-(void)startMotion{
    
    [self startMonitoring];
    
}

-(void)stopMotion{
    if (self.motionManager) {
        [self.motionManager stopAccelerometerUpdates];
    }
}

-(void)dealloc{
    NSLog(@"重力感应释放...");
}


@end
