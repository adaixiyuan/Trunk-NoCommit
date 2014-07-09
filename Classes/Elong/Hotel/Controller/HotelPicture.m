//
//  HotelPicture.m
//  ElongClient
//
//  Created by bin xing on 11-1-22.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelPicture.h"
#import "CustomPageController.h"
#import "FullImageView.h"

#define kPageImageNumber	(SCREEN_4_INCH ? 20 : 16) 
#define kSubViewTag			6902


@implementation HotelPicture
@synthesize hpp;
@synthesize numberLabel;
@synthesize thumbImages;
@synthesize artWorkImages;


- (void)dealloc {
	self.thumbImages	= nil;
	self.artWorkImages	= nil;
    self.hpp.delegate = nil;
	self.hpp			= nil;
	
	[numberLabel	release];
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		
		self.thumbImages	= [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
		self.artWorkImages	= [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease]; 
		
		disThumb = YES;
	}
	
	return self;
}


-(void)clear{
	for (UIView *v in [mainView subviews]) {
		[v removeFromSuperview];
		v=nil;
		[v release];
	}
	
	NSArray	 *subview =[self subviews];
	for (UIView *v in subview) {
		[v removeFromSuperview];
		v=nil;
		[v release];
	}
}


- (void)FillPicture:(NSArray *)path {
	if (path==nil||[path count]==0||[path isEqual:[NSNull null]]) {
		m_tipView = [Utils addView:@"该酒店目前没有图片"];
		CGRect oldframe=m_tipView.frame;
		oldframe.origin.y=(SCREEN_HEIGHT - 44 - 20 -m_tipView.frame.size.height)/2-40;
		m_tipView.frame=oldframe;
		[self addSubview:m_tipView];
		return ;
	}
	
	int totalcount = [path count];
	
	// 图片数label
	numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 11, self.frame.size.width - 12, 14)];
	numberLabel.textAlignment	= UITextAlignmentRight;
	numberLabel.textColor		= [UIColor grayColor];
	numberLabel.font			= FONT_14;
	numberLabel.text			= [NSString stringWithFormat:@"共 %d 张", totalcount];
	[self addSubview:numberLabel];
		
	// 图片显示区
	mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 25, self.frame.size.width, SCREEN_HEIGHT - 160)];
	mainView.directionalLockEnabled = YES;
	mainView.pagingEnabled = YES;
	mainView.backgroundColor = [UIColor clearColor];
	mainView.showsVerticalScrollIndicator = NO;
	mainView.showsHorizontalScrollIndicator = NO;
	mainView.delegate = self;
	
	// 页数显示
	pageControl = [[CustomPageController alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT-20-44-30-40, self.frame.size.width, 20)
												selectedImage:[UIImage imageNamed:@"pageCtr_highlighted.png"]
												  normalImage:[UIImage imageNamed:@"pageCtr_normal.png"]];
	pageControl.hidesForSinglePage		= YES;
	pageControl.userInteractionEnabled	= NO;
	
	int pagecount = totalcount / kPageImageNumber;
	
	if (totalcount % kPageImageNumber!=0) {
		pagecount=pagecount+1;
	}
	
	for (int i=0 ; i<pagecount; i++) {
		int len;
		
		if ([path count] <= kPageImageNumber) {
			// 不足一页
			len = [path count];
		}
		else {
			if (i == pagecount-1) {
				// 最后一页
				len = totalcount % kPageImageNumber == 0 ? kPageImageNumber : totalcount % kPageImageNumber;
			}
			else {
				len = kPageImageNumber;
			}
		}
		
		PictureThumbnails *pt= [[PictureThumbnails alloc] init:[path objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(i*kPageImageNumber,len)]] page:i];
		pt.root = self;
		pt.delegate = self;
		pt.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
		pt.tag = i + kSubViewTag;
		if (0 == i) {
			// 默认加载第一个页面的图
			if(self.hpp == nil || self.hpp == NULL){
				self.hpp = [[[HotelPhotoPreview alloc] init] autorelease];
				self.hpp.delegate = self;
				hpp.root = self;
				[self.hpp.view setFrame:CGRectMake(320, 0, 320, SCREEN_HEIGHT - (480 - 373))];
				[self addSubview:self.hpp.view];
			}
			pt.hotelPhotoPreview = self.hpp;
			[pt loadingViews];
		}
	
		[mainView addSubview:pt];
		[pt release];
	}
	containerSize = CGSizeMake(self.frame.size.width*pagecount,  mainView.frame.size.height);
	[mainView setContentSize:containerSize];
	pageControl.numberOfPages = pagecount;
	pageControl.currentPage   = 0;
	[self addSubview:mainView];
	[self addSubview:pageControl];
	
	[mainView release];
	[pageControl release];
}


#pragma mark -
#pragma mark UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat pageWidth = scrollView.frame.size.width;
	currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (currentPage != lastPage) {
		pageControl.currentPage = currentPage;
		if (currentPage > lastPage) {
			// 翻到下一页时加载下一页的图片
			PictureThumbnails *pt = (PictureThumbnails *)[mainView viewWithTag:currentPage + kSubViewTag];
			[pt loadingViews];
		
		}
		
		lastPage = currentPage;
	}
}

#pragma mark PictureThumbnailsDelegate methods
-(void) animationPresentPhotoPreview:(int)tag{
    FullImageView *detailImage = [[FullImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:[[HotelDetailController hoteldetail] safeObjectForKey:@"PicUrls"] AtIndex:tag];
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:detailImage];
    [detailImage release];
}


#pragma mark HotelPhotoPreviewDelegate methods
- (void)animationRemovePhotoPreview {
	[UIView beginAnimations:@"animationRemovePhotoView" context:nil];
	//[UIView setAnimationCurve:UIViewAnimationTransitionFlipFromLeft];
	[UIView setAnimationDuration:0.38];
	[mainView setFrame:CGRectMake(0, 25, 320, SCREEN_HEIGHT - (480 - 373))];
	[pageControl setFrame:CGRectMake(0,SCREEN_HEIGHT - (480 - 346), 320, 20)];
	[numberLabel setFrame:CGRectMake(5, 11, 320-12, 14)];
	[self.hpp.view setFrame:CGRectMake(320, 0, 320, SCREEN_HEIGHT - (480 - 373))];
	[UIView commitAnimations];
	
	disThumb = YES; 
}


-(void) previewMorePage:(int)page{
	[mainView scrollRectToVisible:CGRectMake(page*320, 25, 320, 373) animated:NO];
	[self.hpp.previewTable reloadData];
}


- (void)resetNavBar {
	if (!disThumb) {
		[hpp changeNavBar];
	}
}

@end
