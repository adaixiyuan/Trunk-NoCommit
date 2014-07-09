//
//  HotelCommentViewController.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelCommentViewController.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"

@interface HotelCommentViewController ()

@end

@implementation HotelCommentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    
    if (!reviewView) {
        reviewView = [[HotelReview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        [reviewView searchHotelCommentsWithId:[NSString stringWithFormat:@"%@", [[HotelPostManager hoteldetailer] getObject:RespHD_HotelId_S]]];
    }
    
    [self.view addSubview:reviewView];
    [reviewView release];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (UMENG) {
        // 酒店评论页面
        [MobClick event:Event_HotelComment];
    }
}

- (void) preLoad{
    if (!reviewView) {
        reviewView = [[HotelReview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        [reviewView searchHotelCommentsWithId:[NSString stringWithFormat:@"%@", [[HotelPostManager hoteldetailer] getObject:RespHD_HotelId_S]]];
    }
}
@end
