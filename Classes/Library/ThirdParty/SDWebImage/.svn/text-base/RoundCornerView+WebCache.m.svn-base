//
//  RoundCornerView+WebCache.m
//  ElongClient
//
//  Created by Dawn on 13-12-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RoundCornerView+WebCache.h"

@implementation RoundCornerView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    [self startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    self.image = nil;
    self.placeholder = placeholder;
    
    NSString *strUrl = [url absoluteString];
    if (STRINGHASVALUE(strUrl)){
        [manager downloadWithURL:url delegate:self options:options];
    }else{
        self.image = placeholder;
        [self endLoading];
    }
}


#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    [self startLoadingByStyle:UIActivityIndicatorViewStyleWhite];
    
    
    NSString *strUrl = [url absoluteString];
    if (STRINGHASVALUE(strUrl))
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }else{
        [self endLoading];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    @synchronized(self)
    {
        [self endLoading];
        [[SDWebImageManager sharedManager] cancelForDelegate:self];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    [self endLoading];
    self.image = image;
    [self setNeedsLayout];
}


- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    
   
}

- (void) webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info{
    if (image) {
        [self endLoading];
        self.image = image;
        [self setNeedsLayout];
        
        if ([info objectForKey:@"ImageFrom"]!=[NSNull null]) {
            if ([[info objectForKey:@"ImageFrom"] isEqualToString:@"MemCache"]) {
                return;
            }
            if ([[info objectForKey:@"ImageFrom"] isEqualToString:@"DiskCache"]) {
                return;
            }
        }
        
        self.alpha= 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1.0;
        }];
    }else{
        [self endLoading];
        self.image = self.placeholder;
        [self setNeedsLayout];
    }
}


- (void) webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error{
    [self endLoading];
    self.image = self.placeholder;
    [self setNeedsLayout];
}

@end