//
//  ImageDownLoader.m
//  ElongClient
//  单线程异步读取图片时用
//
//  Created by haibo on 11-11-16.
//  Copyright 2011 elong. All rights reserved.
//

#import "ImageDownLoader.h"


@interface ImageDownLoader ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData	*imageData;
@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger imageIndex;

@end


NSString *const keyForImage = @"image";
NSString *const keyForIndex = @"index";
NSString *const keyForName	= @"name";
NSString *const keyForPath  = @"path";

@implementation ImageDownLoader

@synthesize connection;
@synthesize imageData;
@synthesize indexPath;
@synthesize delegate;
@synthesize keyName;
@synthesize urlPath;
@synthesize imageIndex;
@synthesize noDataImage;
@synthesize doDiskCache;


- (void)dealloc {
	[self cancelDownload];
	
	self.noDataImage = nil;
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		self.imageData = [NSMutableData dataWithCapacity:2];
        doDiskCache = NO;
	}
	
	return self;
}


- (id)initWithURLPath:(NSString *)pathString keyString:(NSString *)key indexPath:(NSIndexPath *)index {
	if (self = [super init]) {
		self.imageData = [NSMutableData dataWithCapacity:2];
		
        if (STRINGHASVALUE(pathString)) {
            pathString = [pathString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.urlPath = pathString;
        }
        else {
            self.urlPath = @"";
        }
		
		self.keyName	= key;
		self.indexPath	= index;
	}
	
	return self;
}


- (void)clearData {
	self.connection = nil;
	self.imageData	= nil;
	self.indexPath	= nil;	
	self.keyName	= nil;
	self.urlPath	= nil;
}


- (void)main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    UIImage *image = nil;
    if (STRINGHASVALUE(urlPath)) {
        if (doDiskCache) {
            // 使用缓存的情况先从缓存中取数据
           image = [[CacheManage manager] getHotelListImageByURL:urlPath];
        }
        
        if (!image) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPath]];
            if (doDiskCache) {
                [[CacheManage manager] setHotelListImage:data forURL:urlPath];
            }
            image = [UIImage imageWithData:data];
        }
        
        if (!image) {
            image = noDataImage;
        }
    }
    else {
        image = noDataImage;
    }
	
	if (!keyName) {
		keyName = @"";
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image, keyForImage,
						 indexPath, keyForPath,
						 keyName, keyForName,
						 NUMBER(imageIndex), keyForIndex, nil];
	
	if (![self isCancelled]) {
		[delegate imageDidLoad:dic];
	}
	
	[self clearData];
	
	[pool release];
}


#pragma mark -
#pragma mark Public Method

- (void)startDownloadWithURLPath:(NSString *)pathString 
               IndexOfImageArray:(NSInteger)index
			   PositionIndexPath:(NSIndexPath *)position
{
   
    self.imageIndex  = index;
	self.indexPath	 = position;
    
    [self startDownloadWithURLPath:pathString];
}


- (void)startDownloadWithURLPath:(NSString *)pathString
                       keyString:(NSString *)key
                       indexPath:(NSIndexPath *)index
{
    self.keyName	= key;
	self.indexPath	= index;
    
    [self startDownloadWithURLPath:pathString];
}


- (void)startDownloadWithURLPath:(NSString *)pathString
{
    NSString *urlStr = nil;
	if (STRINGHASVALUE(pathString)) {
        pathString = [pathString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        urlStr = pathString;
    }
    
    self.connection = [NSURLConnection connectionWithRequest:
                       [NSURLRequest requestWithURL:
                        [NSURL URLWithString:urlStr]] delegate:self];
}


- (void)cancelDownload {
	[connection cancel];
	
	[self clearData];
}


#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (!keyName) {
		keyName = @"";
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:noDataImage, keyForImage,
						 indexPath, keyForPath,
						 keyName, keyForName,
						 NUMBER(imageIndex), keyForIndex, nil];
    [delegate imageDidLoad:dic];
	
	[self clearData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)urlConnection {
    UIImage *image = [UIImage imageWithData:imageData];
	if (!image) {
		image = noDataImage;
	}
	
	if (!keyName) {
		keyName = @"";
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image, keyForImage,
																	indexPath, keyForPath,
																	keyName, keyForName,
                                                                    NUMBER(imageIndex), keyForIndex, nil];
    [delegate imageDidLoad:dic];
	
	[self clearData];
}


@end
