//
//  ScenicThumbnailPicVC.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicThumbnailPicVC.h"
#import "ThumbnailImage.h"
#import "UIImageView+WebCache.h"
#import "FullImageView.h"

//Image_Size
#define IMAGE_134x100 @"134_100"
#define IMAGE_300x225 @"300_225"
#define IMAGE_350x263 @"350_263"
#define IMAGE_448x228 @"448_228"
#define IMAGE_740x350 @"740_350"


//Space is 10 pixel (Vertical or Horizontal)
#define SPACE 10
#define IMAGE_WIDTH 145
#define IMAGE_HEIGHT 115


@interface ScenicThumbnailPicVC ()

@end

@implementation ScenicThumbnailPicVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *preURL = [self.baseURL stringByAppendingString:IMAGE_134x100];//choose target size
    
    UIImage *def_image = [UIImage imageNamed:@"XGhomeDefault.png"];
    int vertical_nums = 2;
    
    for (int i = 0; i < [self.images count]; i++) {
        //Frame
        CGRect frame = CGRectMake(SPACE+(i%vertical_nums)*IMAGE_WIDTH, SPACE+(i/2)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT);
        ThumbnailImage *imageView = [[ThumbnailImage alloc] initWithFrame:frame];
        NSString *imageURL = [preURL stringByAppendingFormat:@"/%@",[self.images objectAtIndex:i]];
        [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:def_image options:SDWebImageCacheMemoryOnly];
        imageView.tag_index = i;
        imageView.delegate = self;
        [self.view addSubview:imageView];
        [imageView release];
    }
    
    //pre organize
    [self organizeTheBigPicURLs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.completeUrls = nil;
    self.sizes = nil;
    self.images  = nil;
    self.baseURL = nil;

    [super dealloc];
}

-(void)organizeTheBigPicURLs{

    NSString *preURL = [self.baseURL stringByAppendingString:IMAGE_300x225];//choose target size
    NSMutableArray *add = [[NSMutableArray alloc] initWithCapacity:[self.images count]];
    for (NSString *sufURL in self.images) {
        [add addObject:[preURL stringByAppendingFormat:@"/%@",sufURL]];
    }
    
    self.completeUrls = add;
    [add release];
}

-(void)setExtInfoOfImageList:(NSArray *)extInfo ImageList:(NSArray *)imageList{
    
    if (!extInfo || [extInfo count] == 0) {
        return;
    }
    
    NSDictionary *dictionary = [extInfo objectAtIndex:0];
    
    self.baseURL = [dictionary objectForKey:@"imageBaseUrl"];

    self.sizes = [dictionary  objectForKey:@"sizeCodeList"];


    NSMutableArray *add = [[NSMutableArray alloc] initWithCapacity:[imageList count]];
    for (NSDictionary *dic in imageList) {
        NSString *path = [dic objectForKey:@"imagePath"];
        [add addObject:path];
    }
    self.images = (NSArray *)add;
    [add release];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark ----- ThumbnailImage delegate

-(void)selectImageIndex:(int)index{
    
    FullImageView *detailImage = [[FullImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:self.completeUrls AtIndex:index];
    //detailImage.delegate = self;
    detailImage.alpha = 0;

    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:detailImage];
    [detailImage release];
    [UIView animateWithDuration:0.3 animations:^{
        detailImage.alpha = 1;
    }];
}

@end
