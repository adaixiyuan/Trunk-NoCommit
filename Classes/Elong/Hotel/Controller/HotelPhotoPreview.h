//
//  HotelPhotoPreview.h
//  ElongClient
//
//  Created by bin xing on 11-2-12.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HotelDefine.h"
#import "DPNav.h"
#import "ImageDownLoader.h"

@protocol HotelPhotoPreviewDelegate;

@class HotelPicture;
@interface HotelPhotoPreview : DPNav <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ImageDownDelegate>{
	UIImageView *currentImageView;
	UILabel *pageLabel;
	int totalcount;
	UIActivityIndicatorView *activityView;
	NSTimer *checkImgTimer;
	IBOutlet UIButton *lbtn;
	IBOutlet UIButton *rbtn;
	id<HotelPhotoPreviewDelegate> delegate;
	UILabel *textLabel;
	
	UITableView *previewTable;
	int currentIndex;
	UIButton *leftBtn;
	UIButton *rightBtn;
	
	NSMutableArray *progressManager;      // 存储请求图片进程
	NSArray *urlsArray;
	NSOperationQueue *queue;
}

@property (nonatomic,assign) id<HotelPhotoPreviewDelegate> delegate;
@property (nonatomic,assign) HotelPicture *root;
@property (nonatomic,retain) 	UIActivityIndicatorView *activityView;
@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,retain) UITableView *previewTable;
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int totalcount;
@property (nonatomic,assign) UIButton *leftBtn;
@property (nonatomic,assign) UIButton *rightBtn;
@property (nonatomic,retain) UIBarButtonItem *originBarBtn;     // 原始返回按钮
@property (nonatomic,retain) UIBarButtonItem *thumbBarBtn;		// 返回到缩略图的按钮

-(void)initContentView:(int)idx;

-(void) thumbnailBtnClick;
-(void) leftBtnClick:(id)sender;
-(void) rightBtnClick:(id)sender;
- (void)changeNavBar;			// navbar左键替换
- (void)restoreNavBar;			// navbar左键还原

@end


@protocol HotelPhotoPreviewDelegate

-(void) animationRemovePhotoPreview;
-(void) previewMorePage:(int)page;

@end