
//
//
//  StreetViewViewController.m
//  SOSOStreetViewMapAPI
//
//  Created by lv wei on 13-3-26.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "StreetscapeViewController.h"
#import <CoreText/CoreText.h>

@interface StreetscapeViewController (){
    EAGLContext* _context;
    
    int _index;
    double _x;
    double _y;
    NSTimer* _timer;
    BOOL _bAdded;
}

@property(nonatomic, retain)NSMutableArray *myOverlays;
@property (nonatomic, assign) CLLocationCoordinate2D position;
@property (nonatomic, retain) NSString *hotelName;
@property(nonatomic,retain) QStreetView* streetView;
@property(nonatomic,retain) QReverseGeocoder* reverseGeocoder;

@end

@implementation StreetscapeViewController

- (void)dealloc{
    self.reverseGeocoder.delegate = nil;
    self.reverseGeocoder = nil;
    self.streetView.delegate = nil;
    self.streetView = nil;
    self.hotelName = nil;
    self.myOverlays = nil;
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (id) initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D hotelName:(NSString *)hotelName{
    if (self = [super initWithTitle:@"酒店街景" style:NavBarBtnStyleOnlyBackBtn]) {
        self.position = coordinate2D;
        self.hotelName = hotelName;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.myOverlays = [NSMutableArray array];
    _index = -1;
    
    // reverseGeocoder
    QReverseGeocoder *reverseGeocoder = [[QReverseGeocoder alloc] initWithCoordinate:self.position];
    reverseGeocoder.delegate = self;
    self.reverseGeocoder = reverseGeocoder;
    reverseGeocoder.radius = 1000;
    [reverseGeocoder start];
    [reverseGeocoder release];
    
    // street view
    QStreetView* streetView = [[QStreetView alloc] initWithFrame:self.view.bounds];
    streetView.delegate = self;
    streetView.isSupportMotionManager = YES;
    self.streetView = streetView;
    [self.view addSubview:_streetView];
    [streetView release];
    
    [self.streetView startLoadingByStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
	return YES;
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)reverseGeocoder:(QReverseGeocoder *)geocoder didFindPlacemark:(QPlaceMark *)placeMark{
    NSLog(@"reverseGeocoder!");
    [self.streetView showStreetView:placeMark];
    _x = placeMark.coordinate.longitude;
    _y = placeMark.coordinate.latitude;
    _index = -1;
    
    [self.streetView endLoading];
}

- (void)reverseGeocoder:(QReverseGeocoder *)geocoder didFailWithError:(QErrorCode)error{
    //  NSLog(@"streetView  request fail! = %d",error);
    [self.streetView endLoading];
}

- (void)delayAddOverlay {
    _x = self.streetView.streetViewInfo.longitude;
    _y =self.streetView.streetViewInfo.latitude;
    [self setPoiOverlay:_x currY:_y];
    _bAdded = YES;
}

- (void)streetView:(QStreetView *)streetview streetViewInfo:(QStreetViewInfo *)streetViewInfo{
    switch (streetViewInfo.streetViewInfoType) {
        case QStreetViewInfoInit:
        case QStreetViewInfoSceneChange:{
            if (!_bAdded) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayAddOverlay) object:nil];
                [self performSelector:@selector(delayAddOverlay) withObject:nil afterDelay:2.0f];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)streetView:(QStreetView *)streetview didSelectStreetViewOverlay:(QStreetViewOverlay*)streetViewOverlay{
    // NSLog(@"location = (%f,%f)",streetViewOverlay.longitude,streetViewOverlay.latitude);
}
- (void)streetView:(QStreetView *)streetview didSelectStreetViewOverlay:(QStreetViewOverlay *)streetViewOverlay clickPosition:(CGPoint)postion streetViewOverlayFrame:(CGRect)frame{
    //NSLog(@"overlayframe =%@,location=%@",NSStringFromCGRect(frame),NSStringFromCGPoint(postion));
}

- (void)streetView:(QStreetView *)streetview streetViewShowState:(QStreetViewShowState)streetViewShowState{
    switch (streetViewShowState) {
        case QStreetViewShowThumbMap: {
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)isRetina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        return [UIScreen mainScreen].scale >= 2.0;
    }
    return NO;
}

- (void)createPoiNameTexutre:(NSString*)name bitmapData:(void**)bitmapData bitmapDataLength:(NSUInteger*)bitmapDataLength
                 bitmapWidth:(NSUInteger*)bitmapWidth bitmapHeight:(NSUInteger*)bitmapHeight{
    NSString *text = name;
    
    UIImage *uiImage = [UIImage imageNamed:@"marker_centre.png"];
    if (uiImage == nil){
        return;
    }
    
    CGImageRef image = uiImage.CGImage;
    CGFloat imageWidth = CGImageGetWidth(image);
    CGFloat imageHeight = CGImageGetHeight(image);
    
    CGFloat fontSize = 16.0f;
    CGFloat titleHeight = 26.0f;
    CGFloat blank = 3.0f;
    CGFloat enterButtonSize = 12.0f;
    
    if ([self isRetina]){
        fontSize *= 2.0f;
        titleHeight *= 2.0f;
        blank *= 2.0f;
        enterButtonSize *= 2.0f;
    }
    
    UIFont *uiFont = [UIFont boldSystemFontOfSize:fontSize];
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)uiFont.fontName, uiFont.pointSize, NULL);
    
    NSMutableAttributedString* attributedString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    [attributedString addAttribute:(NSString *)kCTFontAttributeName
                             value:(id)ctFont
                             range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                             value:(id)[UIColor whiteColor].CGColor
                             range:NSMakeRange(0, [attributedString length])];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(
                                                               framesetter,
                                                               CFRangeMake(0, 0), NULL,
                                                               CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX), NULL);
    size.width = roundf(size.width + 0.5f);
    size.height = roundf(size.height + 0.5f);
    
    int POTWidth = blank + size.width + blank + enterButtonSize + blank;
    int POTHeight = titleHeight + imageHeight + blank;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	int nLen = POTHeight * POTWidth * 4;
    char *data = (char*)calloc(1, nLen);
    CGContextRef bmpContext = CGBitmapContextCreate(data, POTWidth, POTHeight, 8, 4 * POTWidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
	CGColorSpaceRelease(colorSpace);
    
    {
        UIGraphicsPushContext(bmpContext);
        
        CGContextSaveGState(bmpContext);
        
        CGContextScaleCTM(bmpContext, 1.0, -1.0);
        CGContextTranslateCTM(bmpContext, 0.0, -POTHeight);
        
        CGRect textRect = CGRectMake(0, 0, POTWidth, titleHeight);
        [[[UIImage imageNamed:@"toast-for-sv.png"] stretchableImageWithLeftCapWidth:27 topCapHeight:13] drawInRect:textRect];
        
        //[[UIImage imageNamed:@"bubble_icon_enter.png"] drawInRect:CGRectMake(POTWidth-enterButtonSize-blank, (titleHeight-enterButtonSize)/2.0f, enterButtonSize, enterButtonSize)];
        
        [uiImage drawInRect:CGRectMake((POTWidth - imageWidth)/2.0f, titleHeight + blank, imageWidth, imageHeight)];
        
        CGContextRestoreGState(bmpContext);
        
        UIGraphicsPopContext();
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, CGRectMake(blank, POTHeight-(titleHeight+size.height)/2, size.width, size.height));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CTFrameDraw(frame, bmpContext);
        CGPathRelease(path);
        CFRelease(frame);
    }
    
	CGContextRelease(bmpContext);
    
    CFRelease(framesetter);
    CFRelease(ctFont);
    
    *bitmapData = data;
    *bitmapDataLength = nLen;
    *bitmapWidth = POTWidth;
    *bitmapHeight = POTHeight;
}

- (void)setPoiOverlay:(double)currX currY:(double)currY{
    
    QStreetViewOverlay *overlay = [[QStreetViewOverlay alloc] init];
    overlay.supportScaleEffect = YES;
    void *pBitmapData = NULL;
    NSUInteger bitmapDataLength = 0;
    NSUInteger bitmapWidth = 0;
    NSUInteger bitmapHeight = 0;
    
    [self createPoiNameTexutre:self.hotelName bitmapData:&pBitmapData
              bitmapDataLength:&bitmapDataLength bitmapWidth:&bitmapWidth
                  bitmapHeight:&bitmapHeight];
    
    QVisibleLevel visibleLevel = QVisibleLevelFirst;
    overlay.longitude = self.position.longitude;
    overlay.latitude = self.position.latitude;
    overlay.height = 2;
    overlay.visibleLevel = visibleLevel;
    
    //考虑到内存占用，使用浅拷贝的方式
    [overlay setBitmapDataWithNoCopy:pBitmapData bitmapDataLength:bitmapDataLength bitmapWidth:bitmapWidth bitmapHeight:bitmapHeight];
    [_streetView addStreetViewOverlay:overlay];
    [self.myOverlays addObject:overlay];
    
    if (pBitmapData) {
        free(pBitmapData);
        pBitmapData = NULL;
    }
    
    //重置Overlay中的BITMAP相关数据
    [overlay releaseBitmapData:NO];
    [overlay release];
}


@end

