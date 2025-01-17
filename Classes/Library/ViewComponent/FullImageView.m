//
//  FullImageView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-3-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FullImageView.h"
#import "UIImageView+WebCache.h"

@implementation FullImageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame Images:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum {
    self = [super initWithFrame:frame];
    if (self) {
        fullScreen = NO;
        index = indexNum;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];     // 取消电池烂
        
        /*
         ErrorMessage = "<null>";
         ImageNameCn = "\U897f\U9910\U5385";
         ImagePath = "http://www.elongstatic.com/imageapp/hotels/hotelimages/0101/50101477/889eca66-d7f4-436d-a85d-34faaeeaca83.png";
         ImageSize = 7;
         ImageType = 1;
         IsError = 0;
         UploadImagePath = "http://www.elongstatic.com/imageapp/hotels/hotelimages/0101/50101477/019dfd1e-1b4a-4ef1-bf93-af5103353a02.jpg";
         */
        imagesURL = [[NSArray alloc] initWithArray:imageURLs];
        
        
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
        for (NSObject *obj in imagesURL) {
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)obj;
                [urlArray addObject:[dict objectForKey:@"ImagePath"]];
            }else{
                [urlArray addObject:obj];
            }
        }
        
        if (ARRAYHASVALUE(imagesURL)) {
            photoPageView =  [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) photoUrls:urlArray progress:YES];
            
            photoPageView.delegate = self;
            photoPageView.alpha = 0;
            [self addSubview:photoPageView];
            [photoPageView release];
            if (index > 0) {
                [photoPageView pageToIndex:index];
            }
            
            tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 40)];
            tipsLbl.textAlignment = UITextAlignmentCenter;
            tipsLbl.font = [UIFont boldSystemFontOfSize:18.0f];
            tipsLbl.textColor = [UIColor whiteColor];
            tipsLbl.backgroundColor = [UIColor clearColor];
            tipsLbl.text = [NSString stringWithFormat:@"1/%d",imagesURL.count];
            [self addSubview:tipsLbl];
            [tipsLbl release];
            if (index > 0) {
                tipsLbl.text = [NSString stringWithFormat:@"%d/%d",index + 1,imagesURL.count];
            }
            
            titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
            titleLbl.textAlignment = UITextAlignmentCenter;
            if (imagesURL.count) {
                if ([[imagesURL lastObject] isKindOfClass:[NSDictionary class]] || [[imagesURL lastObject] isKindOfClass:[NSMutableDictionary class]]) {
                    if ([[[imagesURL objectAtIndex:index] objectForKey:@"ImageNameCn"] isKindOfClass:[NSString class]]) {
                        titleLbl.text = [[imagesURL objectAtIndex:index] objectForKey:@"ImageNameCn"];
                    }
                }
            }
            
            
            titleLbl.font = [UIFont boldSystemFontOfSize:18.0f];
            titleLbl.textColor = [UIColor whiteColor];
            titleLbl.backgroundColor = [UIColor clearColor];
            [self addSubview:titleLbl];
            [titleLbl release];
        }
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.alpha = 0;
        [cancelBtn setImage:[UIImage noCacheImageNamed:@"photo_close.png"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 4, 60, 60);
        [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        [self setBackgroundDisAppear:YES];
    }
    
    return self;
}


- (void)dealloc {
    [imagesURL release];
    
    [super dealloc];
}


- (void)setBackgroundDisAppear:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             photoPageView.alpha = 1;
                             cancelBtn.alpha = 1;
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                         }
                         completion:^(BOOL finished) {
                             // todo
                         }];
    }
    else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}


- (void)cancelButtonClick:(id)sender {
    [photoPageView setGestureDisabled];
    self.userInteractionEnabled = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setBackgroundDisAppear:NO];
    
    if ([delegate respondsToSelector:@selector(fullImageView:didClosedAtIndex:)]) {
        [delegate fullImageView:self didClosedAtIndex:index];
    }
}

- (void)reloadData {
    [photoPageView reloadPhotosWith:imagesURL];
}


#pragma mark -
#pragma mark PhotoViewDelegate

- (void)photoView:(PhotoView *)photoView didPageToIndex:(NSInteger)indexNum {
    tipsLbl.text = [NSString stringWithFormat:@"%d/%d", indexNum + 1, imagesURL.count];
    index = indexNum;
    
    if (indexNum >= 0) {
        if (imagesURL.count) {
            if ([[imagesURL lastObject] isKindOfClass:[NSDictionary class]] || [[imagesURL lastObject] isKindOfClass:[NSMutableDictionary class]]) {
                if ([[[imagesURL objectAtIndex:indexNum] objectForKey:@"ImageNameCn"] isKindOfClass:[NSString class]]) {
                    titleLbl.text = [[imagesURL objectAtIndex:indexNum] objectForKey:@"ImageNameCn"];
                }
            }
        }
    }
}

// 取消单击取消
//- (void) photoView:(PhotoView *)photoView didSelectedAtIndex:(NSInteger)index {
//    [self cancelButtonClick:nil];
//}

@end
