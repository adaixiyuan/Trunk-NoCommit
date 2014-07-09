//
//  InterHotelDetailMapCtrl.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelDetailMapCtrl.h"
#import "PriceAnnotation.h"
#import "InterHotelDetailCtrl.h"
#import "HotelMap.h"
#import "UIImageView+WebCache.h"

#define	MAP_MAX_ZOOM_SCALE 3
#define MAP_MIN_ZOOM_SCALE 1
#define MAP_TAP_MAX_ZOOM_SCALE 2

@interface InterHotelDetailMapCtrl ()

@property(nonatomic,assign) CLLocationCoordinate2D hotelCoordinate;        //酒店位置坐标
@property (nonatomic,assign) CLLocationCoordinate2D originalCoordinate;
@property (nonatomic,assign) BOOL isScaled;
@property (nonatomic,assign) BOOL detailMode;

@end

@implementation InterHotelDetailMapCtrl
@synthesize hotelCoordinate;
@synthesize isScaled;

- (void)dealloc
{
    //[marker release];
    [super dealloc];
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super initWithTopImagePath:@"" andTitle:@"酒店位置" style:_NavOnlyBackBtnStyle_];
    if(self){
        double lat = coordinate.latitude;
        double lng = coordinate.longitude;
        
        // 需要纠偏
        if([PublicMethods needSwitchWgs84ToGCJ_02Abroad]){
            [PublicMethods wgs84ToGCJ_02WithLatitude:&lat longitude:&lng];
        }
        self.originalCoordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        
        self.hotelCoordinate = CLLocationCoordinate2DMake(lat, lng);
                
        NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
        hotelName = @"";
        NSString *hotelAddress = @"";
        if(DICTIONARYHASVALUE(baseInfo)){
            hotelName = [baseInfo safeObjectForKey:@"HotelName"];
        }
        if(DICTIONARYHASVALUE(baseInfo)){
            hotelAddress = [baseInfo safeObjectForKey:@"HotelAddress"];
        }
       
           
        CGSize size = CGSizeMake(SCREEN_WIDTH - 50, 10000);
        newSize = [hotelAddress sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        newSize.height = newSize.height + 6;
        

        // 地址提示
        UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - newSize.height, SCREEN_WIDTH, newSize.height)];
        [self.view addSubview:addressView];
        [addressView release];
        addressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        addressTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, newSize.height)];
        addressTipsLbl.font = [UIFont systemFontOfSize:12.0f];
        addressTipsLbl.textColor = [UIColor whiteColor];
        addressTipsLbl.backgroundColor = [UIColor clearColor];
        addressTipsLbl.lineBreakMode = UILineBreakModeCharacterWrap;
        addressTipsLbl.numberOfLines = 0;
        [addressView addSubview:addressTipsLbl];
        [addressTipsLbl release];
        addressTipsLbl.text = [NSString stringWithFormat:@"   %@",hotelAddress];
        
        UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        copyButton.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, newSize.height);
        copyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        copyButton.backgroundColor = [UIColor grayColor];
        [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [copyButton setTitleColor:[UIColor colorWithWhite:136.0/255.0f alpha:1] forState:UIControlStateHighlighted];
        [copyButton setTitle:@" 复制" forState:UIControlStateNormal];
        [copyButton setImage:[UIImage noCacheImageNamed:@"map_address_copy.png"] forState:UIControlStateNormal];
        [addressView addSubview:copyButton];
        [copyButton addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 地图
        HotelMap *hotelMap = [[HotelMap alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - newSize.height) latitude:self.hotelCoordinate.latitude longitude:self.hotelCoordinate.longitude];
        hotelMap.showsUserLocation = YES;
        hotelMap.international = YES;
        [hotelMap setHotelTitle:hotelName];
        [hotelMap setHotelSubtitle:hotelAddress];
        [self.view addSubview:hotelMap];
        [hotelMap release];

        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"详细" Target:self Action:@selector(detailButtonPressed)];

        if (UMENG) {
             //国际酒店地图页面
            [MobClick event:Evnet_InterHotelMap];
        }
    }
    return self;
}

- (void) detailButtonPressed{
    if (self.detailMode){
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"详细" Target:self Action:@selector(detailButtonPressed)];
    }
    else{
       
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"地图" Target:self Action:@selector(detailButtonPressed)];
    }
    
    [PublicMethods showAvailableMemory];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.detailMode){
        self.detailMode = NO;
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        [mapScrollView removeFromSuperview];
    }
    else{
        self.detailMode = YES;
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        [self showMapDetail:self.originalCoordinate];
    }
    
    [UIView commitAnimations];
}

- (void) showMapDetail:(CLLocationCoordinate2D)coordinate{
    // 静态地图
    photoSize = CGSizeMake(SCREEN_WIDTH, MAINCONTENTHEIGHT - newSize.height);
    mapScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, photoSize.width, photoSize.height)];
    mapScrollView.delegate = self;
    mapScrollView.bouncesZoom = YES;
    mapScrollView.backgroundColor = [UIColor lightGrayColor];
    mapScrollView.showsVerticalScrollIndicator = NO;
    mapScrollView.showsHorizontalScrollIndicator = NO;
    mapScrollView.minimumZoomScale = MAP_MIN_ZOOM_SCALE;
    mapScrollView.maximumZoomScale = MAP_MAX_ZOOM_SCALE;
    mapScrollView.contentSize = CGSizeMake(SCREEN_HEIGHT, SCREEN_HEIGHT);
    mapScrollView.zoomScale = MAP_MIN_ZOOM_SCALE;
    [self.view addSubview:mapScrollView];
    [mapScrollView release];
    mapScrollView.contentOffset = CGPointMake((SCREEN_HEIGHT - photoSize.width)/2, (SCREEN_HEIGHT - photoSize.height)/2);
    
    mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT)];
    [mapScrollView addSubview:mapImageView];
    mapImageView.backgroundColor = [UIColor lightGrayColor];
    [mapImageView release];
    NSString *s = @"";
    if (hotelName.length > 0) {
        s = [hotelName substringToIndex:1];
    }
    NSString *mapUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=16&maptype=roadmap&size=%.fx%.f&scale=2&format=jpg&markers=color:red|label:%@|%f,%f&sensor=false&key=%@",coordinate.latitude,coordinate.longitude,SCREEN_HEIGHT,SCREEN_HEIGHT,s,coordinate.latitude,coordinate.longitude,GOOGLE_KEY];
    
    mapUrl = [mapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mapImageView setImageWithURL:[NSURL URLWithString:mapUrl] options:SDWebImageCacheMemoryOnly progress:YES];
    mapImageView.userInteractionEnabled = YES;
    // 双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [mapImageView addGestureRecognizer:doubleTap];
    [doubleTap release];
}

- (void)imgDoubleTap:(UIGestureRecognizer *)gestureRecognizer{
	UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
	
	UIScrollView *scrollView = (UIScrollView *)[imageView superview];
	
	CGPoint point = [gestureRecognizer locationOfTouch:0 inView:imageView];
	if(self.isScaled == YES){
		[self zoomToPointInRootView:point atScale:scrollView.minimumZoomScale imageView:imageView];
		self.isScaled = NO;
	}else{
		[self zoomToPointInRootView:point atScale:MAP_TAP_MAX_ZOOM_SCALE imageView:imageView];
		self.isScaled = YES;
	}
}


- (void)zoomToPointInRootView:(CGPoint)center atScale:(float)scale imageView:(UIImageView *)imageView{
	
	UIScrollView *scrollView = (UIScrollView *)[imageView superview];
    CGRect zoomRect;
	
    zoomRect.size.height = scrollView.frame.size.height / scale;
	
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
	
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
	
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
	
	
    [scrollView zoomToRect:zoomRect animated:YES];
	
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	if ([[scrollView subviews] count]>0) {
        UIImageView *imageView = (UIImageView *)[[scrollView subviews] safeObjectAtIndex:0];
        if (!imageView.image) {
            return nil;
        }else{
            return imageView;
        }
        return nil;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{	
	UIImageView *imgView = [[scrollView subviews] safeObjectAtIndex:0];
	if (imgView.image == nil) {
		return;
	}
	
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
	
	scrollView.contentSize = CGSizeMake(MAX(imgView.frame.size.width,SCREEN_HEIGHT),MAX(imgView.frame.size.height,SCREEN_HEIGHT));
    
}


- (void) copyButtonClick:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = addressTipsLbl.text;
    
    [PublicMethods showAlertTitle:nil Message:@"酒店地址已复制到剪贴板"];
    
    if (UMENG) {
        //国际酒店地图赋值地址
        [MobClick event:Event_InterCopyMapAddress];
    }
}


@end
