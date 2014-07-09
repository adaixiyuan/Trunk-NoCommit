    //
//  HotelPhotoPreview.m
//  ElongClient
//
//  Created by bin xing on 11-2-12.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelPhotoPreview.h"
#import "HotelDetailController.h"
#import "HotelPhotoPreview.h"
#import "HotelPicture.h"


static int indexid;
static float ANIMATION_DURATION = 0.38;

@implementation HotelPhotoPreview
@synthesize delegate;
@synthesize textLabel;
@synthesize previewTable;
@synthesize currentIndex;
@synthesize totalcount;
@synthesize leftBtn,rightBtn;
@synthesize activityView;
@synthesize thumbBarBtn;
@synthesize originBarBtn;
@synthesize root;


- (id)init {
	if (self = [super initWithTopImagePath:nil andTitle:nil style:_NavOnlyBackBtnStyle_]) {
		ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
		self.originBarBtn = appDelegate.navigationController.visibleViewController.navigationItem.leftBarButtonItem;
		
		UIButton *thumbnailBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT - (480 - 316+13+3), 35, 35)];
		[thumbnailBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_thumb.png"] forState:UIControlStateNormal];
		[thumbnailBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_thumb_selected.png"] forState:UIControlStateHighlighted];
		[thumbnailBtn addTarget:self action:@selector(thumbnailBtnClick) forControlEvents:UIControlEventTouchUpInside];
		//[thumbnailBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
		
		UIBarButtonItem *newBarBtn = [[UIBarButtonItem alloc] initWithCustomView:thumbnailBtn];
		self.thumbBarBtn = newBarBtn;
		
		[newBarBtn release];
		[thumbnailBtn release];
	}
	
	return self;
}

-(void)addContentView:(int)idx{
	UIImage *image = [root.thumbImages safeObjectForKey:[NSNumber numberWithInt:idx]];
	if (image!=nil) {
		if ([activityView isAnimating]) {
			[activityView stopAnimating];
			[checkImgTimer invalidate];
		}
		currentImageView.image=image;
		
	}else {
		
		currentImageView.image=nil;
		if (![activityView isAnimating]) {
			[activityView startAnimating];
			checkImgTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkImg) userInfo:nil repeats:YES];	
		}
	}
}

-(void)checkImg{
	if([activityView isAnimating]) {
		[self addContentView:indexid];
	}
}
-(void)updateLabel{
	
	pageLabel.text=[NSString stringWithFormat:@"%i / %i",indexid+1,totalcount];
	[pageLabel sizeToFit];
	CGRect oldframe=pageLabel.frame;
	
	oldframe.origin.x=(320-oldframe.size.width)/2;
	oldframe.origin.y=(40-oldframe.size.height)/2;
	pageLabel.frame=oldframe;
}
-(void)preImage{
	indexid=indexid>0?indexid-1:0;
	if (indexid==0) {
		lbtn.hidden=YES;
	}else {
		lbtn.hidden=NO;
	}
	rbtn.hidden=NO;

	[self updateLabel];
	[self addContentView:indexid];
}
-(void)nextImage{
	
	indexid=indexid<(totalcount-1)?indexid+1:totalcount-1;
	
	if (indexid==totalcount-1) {
		rbtn.hidden=YES;
	}else {
		rbtn.hidden=NO;
	}
	lbtn.hidden=NO;
	[self updateLabel];
	[self addContentView:indexid];
}


-(void)pre{
	[self preImage];
	
}

-(void)next{
	
	[self nextImage];

}

-(void)initContentView:(int)idx{
	indexid=idx;
	pageLabel.text=[NSString stringWithFormat:@"%i / %i",indexid+1,totalcount];
	[pageLabel sizeToFit];
	CGRect oldframe=pageLabel.frame;
	oldframe.origin.x=(320-oldframe.size.width)/2;
	oldframe.origin.y=(40-oldframe.size.height)/2;
	pageLabel.frame=oldframe;
	checkImgTimer=[NSTimer timerWithTimeInterval:3 target:self selector:@selector(checkImg) userInfo:nil repeats:YES];
	[self addContentView:indexid];
	
	if (indexid==totalcount-1) {
		rbtn.hidden=YES;
	}else if(indexid==0) {
		lbtn.hidden=YES;
	}
}

-(void)addfooterview{
	UIImageView *footview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 376 * COEFFICIENT_Y, 320, 40)];
	footview.userInteractionEnabled=YES;
	[footview setImage:[UIImage imageNamed:@"bg_footer.png"]];
	footview.alpha=0.7;
	
	lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
	lbtn.frame =CGRectMake(80, 4, 32, 32);
	[lbtn setImage:[UIImage imageNamed:@"btn_whiteleftarrow.png"] forState:0];
	[lbtn addTarget:self action:@selector(pre) forControlEvents:UIControlEventTouchUpInside];
	[footview addSubview:lbtn];
	
	pageLabel=[[UILabel alloc] initWithFrame:CGRectZero];
	pageLabel.textColor=[UIColor whiteColor];
	pageLabel.backgroundColor=[UIColor clearColor];
	pageLabel.font=FONT_B16;
	
	[footview addSubview:pageLabel];
	[pageLabel release];
	
	rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
	rbtn.frame =CGRectMake(208, 4, 32, 32);
	[rbtn setImage:[UIImage imageNamed:@"btn_whiterightarrow.png"] forState:0];
	[rbtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
	[footview addSubview:rbtn];

	[self.view addSubview:footview];
	[footview release];
	
}

-(void)loadView{
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-20-44)];
	contentView.backgroundColor=[UIColor whiteColor];
	self.view=contentView;
	[contentView release];

	urlsArray = [[NSArray alloc] initWithArray:[[HotelDetailController hoteldetail] safeObjectForKey:@"PicUrls"]];
	totalcount = [urlsArray count];
	progressManager	= [[NSMutableArray alloc] initWithCapacity:2];
	queue = [[NSOperationQueue alloc] init];
	
	previewTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
	previewTable.delegate = self;
	previewTable.dataSource = self;
	previewTable.separatorColor = [UIColor clearColor];
	previewTable.pagingEnabled = YES;
	previewTable.showsVerticalScrollIndicator = NO;
	previewTable.showsHorizontalScrollIndicator = NO;
	CGAffineTransform transform = CGAffineTransformIdentity;
	previewTable.transform = CGAffineTransformRotate(transform, -3.1415926/2);
	[previewTable setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:previewTable];
	[previewTable release];
    
    previewTable.frame = CGRectMake(0,0, 320,SCREEN_HEIGHT-(480 - 320));
	
	leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, SCREEN_HEIGHT - (480 - (316+13+3)), 30, 30)];
	[leftBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_left.png"] forState:UIControlStateNormal];
	[leftBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_left_selected.png"] forState:UIControlStateHighlighted];
	[leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[leftBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];

	self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(210, SCREEN_HEIGHT - (480 - (316+13+3)), 70, 30)] autorelease];
	[self.textLabel setTextAlignment:UITextAlignmentCenter];
	[self.textLabel setFont:[UIFont systemFontOfSize:16]];
	
	rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, SCREEN_HEIGHT - (480 - (316+13+3)), 30, 30)];
	[rightBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_right.png"] forState:UIControlStateNormal];
	[rightBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_right_selected.png"] forState:UIControlStateHighlighted];
	[rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[rightBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];

	[self.view addSubview:leftBtn];
	[self.view addSubview:rightBtn];
	[self.view addSubview:self.textLabel];
	[leftBtn release];
	[rightBtn release];
	
	[self addfooterview];

}

- (void)thumbnailBtnClick {
	[delegate animationRemovePhotoPreview];
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.navigationController.visibleViewController.navigationItem.leftBarButtonItem.enabled = NO;
	
	[self performSelector:@selector(restoreNavBar) withObject:nil afterDelay:ANIMATION_DURATION];
}

-(void) leftBtnClick:(id)sender{
	if(self.currentIndex==0){
		[leftBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_left_gray.png"] forState:UIControlStateNormal];
		[leftBtn setEnabled:NO];
		return;
	}
	NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.currentIndex-1 inSection:0];
	[self.previewTable scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) rightBtnClick:(id)sender{
	if(self.currentIndex==totalcount-1){
		[rightBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_right_gray.png"] forState:UIControlStateNormal];
		[rightBtn setEnabled:NO];
		return;
	}
	NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.currentIndex+1 inSection:0];
	[self.previewTable scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}


- (void)changeNavBar {
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if ([appDelegate.navigationController.visibleViewController isKindOfClass:[HotelDetailController class]]) {
		// 防止快速切换时出现bug
		appDelegate.navigationController.visibleViewController.navigationItem.leftBarButtonItem = self.thumbBarBtn;
		appDelegate.navigationController.visibleViewController.navigationItem.leftBarButtonItem.enabled = YES;
	}
}


- (void)restoreNavBar {
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.navigationController.visibleViewController.navigationItem.leftBarButtonItem = self.originBarBtn;
	appDelegate.navigationController.visibleViewController.navigationItem.leftBarButtonItem.enabled = YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    [root.artWorkImages removeAllObjects];
	[progressManager removeAllObjects];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	SFRelease(lbtn);
	SFRelease(rbtn);
	SFRelease(urlsArray);
	SFRelease(progressManager);
	SFRelease(queue);
}


- (void)dealloc {
	[queue cancelAllOperations];
	[queue release];
	[progressManager release];

	[urlsArray release];
	[currentImageView release];
	[activityView release];
	
	self.originBarBtn = nil;
	self.thumbBarBtn = nil;
	self.textLabel = nil;
	
    [super dealloc];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat pageWidth = scrollView.frame.size.width;
	int currentPage = floor((previewTable.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
	if(self.currentIndex != currentPage){
		self.currentIndex = currentPage;
		self.textLabel.text=[NSString stringWithFormat:@"%i / %i",currentPage+1,totalcount];
		if(self.currentIndex == 0){
			[leftBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_left_gray.png"] forState:UIControlStateNormal];
			[leftBtn setEnabled:NO];
		}else if(self.currentIndex == totalcount-1){
			[rightBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_right_gray.png"] forState:UIControlStateNormal];
			[rightBtn setEnabled:NO];
		}else {
			[leftBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_left.png"] forState:UIControlStateNormal];
			[rightBtn setImage:[UIImage noCacheImageNamed:@"btn_hotel_right.png"] forState:UIControlStateNormal];
			[leftBtn setEnabled:YES];
			[rightBtn setEnabled:YES];
		}
		
		[delegate previewMorePage:self.currentIndex/16];
		
	}

}


#pragma mark -
#pragma mark Image DownLoad

- (void)requestImageWithURLPath:(NSString *)path AtIndexPath:(NSIndexPath *)indexPath {
	// 从url请求图片
	if (STRINGHASVALUE(path) && ![progressManager containsObject:indexPath]) {
		// 过滤重复请求
		ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:path keyString:nil indexPath:indexPath];
		[queue addOperation:downLoader];
		downLoader.delegate = self;
		downLoader.noDataImage	= [UIImage imageNamed:@"bg_nohotelpic.png"];
		[progressManager addObject:indexPath];
		[downLoader release];		
	}
}


- (void)setCellImageWithData:(id)celldata {
	UIImage *img		= [celldata safeObjectForKey:keyForImage]; 
	NSIndexPath *index	= [celldata safeObjectForKey:keyForPath];
	
    HotelListCell *cell = (HotelListCell *)[previewTable cellForRowAtIndexPath:index];
    [cell.hotelImageView endLoading];
	cell.hotelImageView.image = img;
}


- (void)requestOtherImageAtIndexPath:(NSIndexPath *)indexPath {
	// 请求非当前显示页面的图片
	UIImage *image = [root.artWorkImages safeObjectForKey:indexPath];
	if(![image isKindOfClass:[UIImage class]]){
		[self requestImageWithURLPath:[urlsArray safeObjectAtIndex:indexPath.row]
						  AtIndexPath:indexPath];
	}
}

#pragma mark -
#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return totalcount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell== nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		CGAffineTransform transform = CGAffineTransformIdentity;
		cell.transform = CGAffineTransformRotate(transform, 3.1415926/2);
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-(480 - 320))];
		[imageView setContentMode:UIViewContentModeScaleAspectFill];
		[imageView setClipsToBounds:YES];
		[cell.contentView addSubview:imageView];
		[imageView release];
	}
	
	if (indexPath.row != 0) {
		// 如果不是第一页，加载前一页图片
		NSIndexPath *preIndex = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
		[self requestOtherImageAtIndexPath:preIndex];

		if (preIndex.row != 0) {
			// 如果上页也不是第一页，再继续读取上页的上页图片
			NSIndexPath *beforeIndex = [NSIndexPath indexPathForRow:preIndex.row - 1 inSection:0];
			[self requestOtherImageAtIndexPath:beforeIndex];
		}
	}
	
	if (indexPath.row != totalcount - 1) {
		// 如果不是最后一页，加载后一页图片
		NSIndexPath *sufIndex = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
		[self requestOtherImageAtIndexPath:sufIndex];
		
		if (sufIndex.row != totalcount - 1) {
			// 如果下页也不是最后一页，再继续读取下页的下页图片
			NSIndexPath *afterIndex = [NSIndexPath indexPathForRow:sufIndex.row + 1 inSection:0];
			[self requestOtherImageAtIndexPath:afterIndex];
		}
	}
	
	UIImage *image = [root.artWorkImages safeObjectForKey:indexPath];
	UIImageView *imgView = (UIImageView *)[[cell.contentView subviews] safeObjectAtIndex:0];
	if(![image isKindOfClass:[UIImage class]]){
		[imgView setImage:nil];
		
		[imgView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
		[self requestImageWithURLPath:[urlsArray safeObjectAtIndex:indexPath.row]
						  AtIndexPath:indexPath];
	}
	else {
		[imgView endLoading];
		imgView.image = image;
	}
	
	return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 320;
}


#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo {
	UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
	NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
	
	[root.artWorkImages safeSetObject:image forKey:indexPath];
	
	NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:  
							  indexPath, keyForPath,   
							  image, keyForImage,  
							  nil];  
	
	[self performSelectorOnMainThread:@selector(setCellImageWithData:) withObject:celldata waitUntilDone:NO];
}

@end
