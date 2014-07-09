//
//  HotelPictureThumbnails.m
//  ElongClient
//
//  Created by bin xing on 11-1-22.
//  Copyright 2011 DP. All rights reserved.
//
#define  PICCOLS 4
#define  PICROWS 4
#define  PICCELL 75
#define  FOOTHEIGHT 20.0
#define  VIEWWIDTH 320
#define  VIEWHEIGHT 300

#import "PictureThumbnails.h"
#import "HotelPhotoPreview.h"
#import "HotelPicture.h"

@implementation PictureThumbnails
@synthesize delegate;
@synthesize hotelPhotoPreview;
@synthesize root;

- (id)init:(NSArray *)path page:(int)page {
	if (self=[super init]) {
		
		m_path	= [[NSArray alloc] initWithArray:path];
		isLoadedViews = NO;
		
		m_page	= page;
		m_cellpos = [[NSMutableDictionary alloc] initWithCapacity:2];
		queue = [[NSOperationQueue alloc] init];
		
		nextindex = 0;
		hspace = 4;
		vspace = 4;
		
		[root.thumbImages removeAllObjects];
	}
	
	return self;
}


- (void)loadingViews {
	if (!isLoadedViews) {
		[self performSelector:@selector(tableMake)];
		
		isLoadedViews = YES;
	}
}


-(void)buttonPress:(id)sender{
	UIButton *btn=sender;
//	ElongClientAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//	[delegate.navigationController pushViewController:hpp animated:YES];
	[delegate animationPresentPhotoPreview:btn.tag];
}

-(void)_setCellImage:( id )celldata  
{  
	UIImage *newimage=[celldata safeObjectForKey:@"image"]; 
	NSArray *subviews = self.subviews;
	
	int index = [[celldata safeObjectForKey:@"indexPath"] indexAtPosition:0];
	if ([subviews count] > index) {
		RoundCornerView *imgView = (RoundCornerView *)[self.subviews safeObjectAtIndex:index];
		[imgView endLoading];
		UIImage *thumbImage = [newimage compressImageWithSize:CGSizeMake(PICCELL, PICCELL)];
		imgView.image = thumbImage;
		imgView.userInteractionEnabled = YES;
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.exclusiveTouch = YES;
		
		btn.tag = index + 16 * m_page;
		
		btn.frame =CGRectMake(0, 0, PICCELL, PICCELL);
		
		[btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
		[root.thumbImages safeSetObject:newimage forKey:[NSNumber numberWithInt:btn.tag]];
		[self.hotelPhotoPreview.previewTable reloadData];
		[imgView addSubview:btn];
	}
}  


-(void)tableMake{
	int x=hspace;
	int y=vspace;
	int index = 0;
	
	while (index < [m_path count]) {
		
		RoundCornerView *imgview = [[RoundCornerView alloc] initWithFrame:CGRectMake(x, y, PICCELL, PICCELL)];
        imgview.imageRadius = 2.0f;
		if(index<[m_path count]){
			[imgview startLoadingByStyle:UIActivityIndicatorViewStyleGray];
		}
		[self addSubview:imgview];
		
		[m_cellpos safeSetObject:[NSValue valueWithCGRect:CGRectMake(x, y,PICCELL,PICCELL)] forKey:[NSNumber numberWithInt:index]];
		index ++ ;
		[imgview release];
		if (index<PICCOLS||index%PICCOLS!=0) {
			x=x+PICCELL+hspace;
		}else {
			x=hspace;
			y=y+PICCELL+vspace;
		}
	}
	
	for (int i=0; i<[m_path count]; i++) {
		//[self performSelectorInBackground:@selector(getNetImage:) withObject:[NSNumber numberWithInt:i]];
		ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:[m_path safeObjectAtIndex:i] 
																	 keyString:nil
																	 indexPath:[NSIndexPath indexPathWithIndex:i]];
		[queue addOperation:downLoader];
		downLoader.delegate		= self;
		downLoader.noDataImage	= [UIImage imageNamed:@"bg_nohotelpic.png"];
		[downLoader release];
	}
}

-(BOOL)pointInside:(CGPoint)point rect:(CGRect)rect{
	return (point.x >rect.origin.x && 
			point.x<rect.origin.x+rect.size.width && 
			point.y > rect.origin.y && 
			point.y<rect.origin.y+rect.size.height);

}


#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo {
	UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
	NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
	
	NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:  
							  indexPath, @"indexPath",   
							  image, @"image",  
							  nil];  
	
	[self performSelectorOnMainThread:@selector(_setCellImage:) withObject:celldata waitUntilDone:NO];
}


- (void)dealloc {
	[queue cancelAllOperations];
	[queue release];
	
	[m_path release];
	[m_cellpos release];
	[hotelPhotoPreview release];
    [super dealloc];
}


@end
