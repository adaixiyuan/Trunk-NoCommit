//
//  HomeAdView.m
//  Home
//
//  Created by Dawn on 13-12-7.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeAdView.h"
#import "UIImageView+WebCache.h"
#import "GrayPageControl.h"

@interface HomeAdView()
@property (nonatomic,retain) UIScrollView *contentView;
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,retain) NSArray *imageUrls;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,retain) UIImage *defaultImage;
@end

@implementation HomeAdView
- (void) dealloc{
    self.pageControl = nil;
    self.contentView = nil;
    self.imageArray = nil;
    self.imageUrls = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.defaultImage = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // bg color
        self.backgroundColor = [UIColor clearColor];
        
        // content view
        self.contentView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        self.contentView.delegate = self;
        self.contentView.pagingEnabled = YES;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.contentView];
        
        // pagecontrol
        if (IOSVersion_6) {
            self.pageControl = [[[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - 20,frame.size.width,20)] autorelease];
            self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:231.0f/255.0f green:53.0/255.0f blue:53.0/255.0f alpha:1.0f];
            self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193.0/255.0f green:193.0/255.0f blue:193.0/255.0f alpha:1.0f];
        }else{
            self.pageControl = [[[GrayPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - 20,frame.size.width,20)] autorelease];
        }
        
        [self addSubview:self.pageControl];
        self.pageControl.hidden = YES;
    }
    return self;
}

- (void) loadAdsWithUrls:(NSArray *)urls defaultImage:(UIImage *)image{
    
    // 初始化数据
    if (urls == nil || urls.count==0) {
        return;
    }
    self.defaultImage = image;
    self.pageControl.currentPage = 0;
    self.pageIndex = 1;
    self.count = urls.count;
    // 如果当前图片数量等于2则填充为3
    if (self.count == 2) {
        self.imageUrls = [NSArray arrayWithObjects:[urls objectAtIndex:0],[urls objectAtIndex:1],[urls objectAtIndex:0],[urls objectAtIndex:1], nil];
    }else{
        self.imageUrls = urls;
    }
    // 设置pagecontrol的容量
    self.pageControl.numberOfPages = self.count;
    
    // 如果存在之前的图片，移除
    if (self.imageArray) {
        for (UIImageView *view in self.imageArray) {
            [view removeFromSuperview];
        }
        [self.imageArray removeAllObjects];
    }else{
        self.imageArray = [NSMutableArray array];
    }
    
    for (int i = 0; i < MIN(self.imageUrls.count, 3); i++) {
        UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [self.imageArray addObject:adImageView];
        adImageView.clipsToBounds = YES;
        [adImageView release];
        [self.contentView addSubview:adImageView];
        adImageView.contentMode = UIViewContentModeScaleAspectFill;
        adImageView.userInteractionEnabled = NO;
      
        NSString *imageUrl = [self.imageUrls objectAtIndex:i];
        if (imageUrl && ![imageUrl isEqualToString:@""]) {
            if ([imageUrl rangeOfString:@"local:"].length > 0) {
                adImageView.image = [UIImage imageWithContentsOfFile:[imageUrl substringFromIndex:6]];
            }else{
                [adImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.defaultImage options:SDWebImageRetryFailed];
            }
        }else{
            adImageView.image = self.defaultImage;
        }
    }
    self.contentView.contentSize = CGSizeMake(MIN(self.imageUrls.count, 3) * self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [self.contentView setContentOffset:CGPointMake(0, 0)];
    
    if (self.count>1) {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (NSInteger) currentPage{
    return self.pageControl.currentPage;
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    beginDrag = YES;
    [self stopAutoPage];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    beginDrag = NO;
    [self startAutoPage];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{

	NSInteger tpage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    
	if (tpage == 0) {
        if (self.pageIndex - 1 >= 0) {
            self.pageIndex--;
        }else {
            self.pageIndex = self.imageUrls.count - 1;
        }
    }
    if (tpage == 2) {
        if (self.pageIndex + 1 < self.imageUrls.count) {
            self.pageIndex++;
        }else {
            self.pageIndex = 0;
        }
    }
    
    
	if (tpage == 0 || tpage == 2) {
        if (self.imageUrls.count >= 3) {
            if (tpage == 2) {
				[self pageDown];
            }else {
				[self pageUp];
            }
        }
	}
    
    
    if (self.pageControl.currentPage != self.pageIndex){
        int index = self.pageIndex;
        if (self.pageIndex >= self.pageControl.numberOfPages) {
            index = self.pageIndex - self.pageControl.numberOfPages;
        }
        self.pageControl.currentPage = index;
    }
}

- (void) viewPageNext{
    if (beginDrag) {
        return;
    }
    NSInteger tpage = floor((self.contentView.contentOffset.x - self.contentView.frame.size.width / 2) / self.contentView.frame.size.width) + 1;
    NSInteger page = self.pageIndex;
	if (tpage == 0) {
        if (self.pageIndex - 1 >= 0) {
            page = self.pageIndex - 1;
        }else {
            page = self.imageUrls.count - 1;
        }
    }
    if (tpage == 2) {
        if (self.pageIndex + 1 < self.imageUrls.count) {
            page = self.pageIndex + 1;
        }else {
            page = 0;
        }
    }

    if (self.pageControl.currentPage != page){
        int index = page;
        if (page >= self.pageControl.numberOfPages) {
            index = page - self.pageControl.numberOfPages;
        }
        self.pageControl.currentPage = index;
    }
}

-(void) pageDown{
	NSInteger tpage = self.pageIndex + 1;
	
	for (int i = 0; i < 3 - 1; i++) {
		[self.imageArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
	}
    
	for (int i = 0; i < 3; i++) {
		NSInteger x = self.bounds.size.width * i;
		NSInteger y = 0;
        
        UIImageView *imageView = (UIImageView *)[self.imageArray objectAtIndex:i];
		imageView.frame = CGRectMake(x, y, self.bounds.size.width, self.bounds.size.height);
	}
	
	UIImageView *imageView = [self.imageArray objectAtIndex:2];
   
    if (tpage < self.imageUrls.count) {
         NSString *imageUrl = [self.imageUrls objectAtIndex:tpage];
        if ([imageUrl rangeOfString:@"local:"].length > 0) {
            imageView.image = [UIImage imageWithContentsOfFile:[imageUrl substringFromIndex:6]];
        }else{
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.defaultImage options:SDWebImageRetryFailed];
        }
		
	}else {
        NSString *imageUrl = [self.imageUrls objectAtIndex:tpage - self.count];
        if ([imageUrl rangeOfString:@"local:"].length > 0) {
            imageView.image = [UIImage imageWithContentsOfFile:[imageUrl substringFromIndex:6]];
        }else{
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.defaultImage options:SDWebImageRetryFailed];
        }
	}
	[self.contentView setContentOffset:CGPointMake(self.contentView.contentOffset.x - self.contentView.frame.size.width, 0)];
	
}
-(void) pageUp{
    NSInteger tpage = self.pageIndex - 1;
	for (int i = 3 - 1; i > 0; i--) {
		[self.imageArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
	}
	
    for (int i = 0; i < 3; i++) {
		NSInteger x = self.bounds.size.width * i;
		NSInteger y = 0;
        
        UIImageView *imageView = (UIImageView *)[self.imageArray objectAtIndex:i];
		imageView.frame = CGRectMake(x, y, self.bounds.size.width, self.bounds.size.height);
	}
    
    UIImageView *imageView = [self.imageArray objectAtIndex:0];
	if (tpage >= 0) {
        NSString *imageUrl = [self.imageUrls objectAtIndex:tpage];
        if ([imageUrl rangeOfString:@"local:"].length > 0) {
            imageView.image = [UIImage imageWithContentsOfFile:[imageUrl substringFromIndex:6]];
        }else {
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.defaultImage options:SDWebImageRetryFailed];
        }
	}else {
        NSString *imageUrl = [self.imageUrls objectAtIndex:tpage + self.count];
        if ([imageUrl rangeOfString:@"local:"].length > 0) {
            imageView.image = [UIImage imageWithContentsOfFile:[imageUrl substringFromIndex:6]];
        }else{
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.defaultImage options:SDWebImageRetryFailed];
        }
	}
	[self.contentView setContentOffset:CGPointMake(self.contentView.contentOffset.x + self.contentView.frame.size.width, 0)];
    
   
}

-(void) pageToIndex:(NSInteger)index{
    if (self.imageUrls.count <= 1) {
        return;
    }
	if (index != self.pageIndex) {
		//对于过长的情况，进行处理
        float contentWidth = (index - self.pageIndex) * self.contentView.frame.size.width + self.contentView.contentOffset.x;
        float contentHeight = 0;
        if (self.animationInterval <= 0.0f) {
            self.animationInterval = 0.3f;
        }
        // 调整动画速度
        self.animationInterval = 0.8;
        
        self.contentView.delegate = nil;
        
        [UIView animateWithDuration:self.animationInterval delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveLinear animations:^{
            [self.contentView setContentOffset:CGPointMake((int)contentWidth, contentHeight)];
            
        } completion:^(BOOL finished) {
            if (!beginDrag) {
                [self scrollViewDidScroll:self.contentView];
                self.contentView.delegate = self;
            }
        }];
        
        if (!beginDrag) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(viewPageNext) withObject:nil afterDelay:self.animationInterval/2];
        }else{
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    }
}

- (void) startAutoPage{
    if (self.imageUrls.count <= 1) {
        return;
    }
    if (self.timer) {
        [self.timer invalidate];
    }
    if (self.timeInterval <= 0) {
        self.timeInterval = 5.0f;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerWork) userInfo:nil repeats:YES];
    
}

- (void)timerWork{
    if (self.imageUrls.count <= 1) {
        return;
    }
    if (self.pause) {
        return;
    }
    [self pageToIndex:self.pageIndex + 1];
}

- (void) stopAutoPage{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
