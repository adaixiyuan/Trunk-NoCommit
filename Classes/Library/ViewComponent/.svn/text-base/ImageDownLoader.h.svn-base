//
//  ImageDownLoader.h
//  ElongClient
//  单线程异步读取图片时用
//
//  Created by haibo on 11-11-16.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const keyForImage;
UIKIT_EXTERN NSString *const keyForIndex;
UIKIT_EXTERN NSString *const keyForPath;
UIKIT_EXTERN NSString *const keyForName;

@protocol ImageDownDelegate;

@interface ImageDownLoader : NSOperation <NSURLConnectionDataDelegate> {
	
}

@property (nonatomic, assign) id <ImageDownDelegate> delegate;
@property (nonatomic, assign) BOOL doDiskCache;             // 是否调用本地缓存
@property (nonatomic, retain) UIImage *noDataImage;			// 没有图片时替代显示的本地图片

- (id)initWithURLPath:(NSString *)pathString keyString:(NSString *)key indexPath:(NSIndexPath *)index;

- (void)startDownloadWithURLPath:(NSString *)pathString 
               IndexOfImageArray:(NSInteger)index               // 图片在数组中得位置
			   PositionIndexPath:(NSIndexPath *)position;       // 图片得显示位置

- (void)startDownloadWithURLPath:(NSString *)pathString keyString:(NSString *)key indexPath:(NSIndexPath *)index;	// 用指定字符串作为key开始下载

- (void)startDownloadWithURLPath:(NSString *)pathString;        // 下载url对应的图片

- (void)cancelDownload;

@end


@protocol ImageDownDelegate 

- (void)imageDidLoad:(NSDictionary *)imageInfo;

@end