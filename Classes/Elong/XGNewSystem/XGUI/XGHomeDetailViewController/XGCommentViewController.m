//
//  XGCommentViewController.m
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGCommentViewController.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
@interface XGCommentViewController ()

@end

@implementation XGCommentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!reviewView) {
        reviewView = [[HotelReview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        [reviewView searchHotelCommentsWithId:[NSString stringWithFormat:@"%@", [self.hotelDic safeObjectForKey:RespHD_HotelId_S]]];
    }
    
    [self.view addSubview:reviewView];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) preLoad{
    if (!reviewView) {
        reviewView = [[HotelReview alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        [reviewView searchHotelCommentsWithId:[NSString stringWithFormat:@"%@", [self.hotelDic safeObjectForKey:RespHD_HotelId_S]]];
    }
}


-(void)dealloc{

}

@end
