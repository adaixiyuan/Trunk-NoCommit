//
//  HotelPicture.h
//  ElongClient
//
//  Created by bin xing on 11-1-22.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "PictureThumbnails.h"
#import "HotelPhotoPreview.h"

@class CustomPageController;

@interface HotelPicture:UIView <UIScrollViewDelegate,PictureThumbnailsDelegate,HotelPhotoPreviewDelegate> {
	UIScrollView *mainView;
	CustomPageController *pageControl;
	CGSize containerSize;
	UIView *m_tipView;
	UILabel *numberLabel;
	NSArray	 *controllers;
	
	NSInteger currentPage;
	NSInteger lastPage;
	HotelPhotoPreview *hpp;
	
	BOOL disThumb;				// 是否处于显示缩略图状态
}

@property (nonatomic, retain) HotelPhotoPreview *hpp;
@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, retain) NSMutableDictionary *thumbImages;		// 与按钮对应的缩略图数组
@property (nonatomic, retain) NSMutableDictionary *artWorkImages;	// 与缩略图对应的原图数组

-(void)clear;
-(void)FillPicture:(NSArray *)path;
- (void)resetNavBar;					// 根据当前状态改变navbar的按钮

@end
