//
//  HotelPictureThumbnails.h
//  ElongClient
//
//  Created by bin xing on 11-1-22.
//  Copyright 2011 DP. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "HotelDefine.h"
#import "ImageDownLoader.h"
#import "HotelPhotoPreview.h"

@protocol PictureThumbnailsDelegate;

@class HotelPicture;
@interface PictureThumbnails : UIView <ImageDownDelegate> {
	float hspace;
	float vspace;
	unsigned int nextindex;
	NSArray *m_path;
	int m_page;
	NSMutableDictionary *m_cellpos;
	
	BOOL isLoadedViews;						// 是否已经加载过子页面
	NSOperationQueue *queue;
	
	id<PictureThumbnailsDelegate> delegate;
	HotelPhotoPreview *hotelPhotoPreview;
}

@property (nonatomic,assign) id<PictureThumbnailsDelegate> delegate;
@property (nonatomic,retain) HotelPhotoPreview *hotelPhotoPreview;
@property (nonatomic,assign) HotelPicture *root;
 
- (id)init:(NSArray *)path page:(int)page;

- (void)loadingViews;							// 加载子页面


@end


@protocol PictureThumbnailsDelegate

-(void) animationPresentPhotoPreview:(int)tag;

@end
