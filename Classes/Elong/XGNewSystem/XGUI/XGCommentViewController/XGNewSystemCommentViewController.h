//
//  XGNewSystemCommentViewController.h
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "XGHotelInfo.h"
#import "XGOrderModel.h"
@interface XGNewSystemCommentViewController : XGBaseViewController
@property(nonatomic,strong)IBOutlet UILabel *hotelNameLabel;
@property(nonatomic,strong)IBOutlet UIButton *startImage1;
@property(nonatomic,strong)IBOutlet UIButton *startImage2;
@property(nonatomic,strong)IBOutlet UIButton *startImage3;
@property(nonatomic,strong)IBOutlet UIButton *startImage4;
@property(nonatomic,strong)IBOutlet UIButton *startImage5;
@property(nonatomic,strong)IBOutlet UILabel *disTipLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)commitAction:(id)sender;
@property(nonatomic,strong)IBOutlet UIButton *commitButton;

@property(nonatomic,assign)BOOL isfromOrderDetail;  //从订单列表进来，从订单详情进来yes  默认从订单列表进来

-(IBAction)star1Action;
-(IBAction)star2Action;
-(IBAction)star3Action;
-(IBAction)star4Action;
-(IBAction)star5Action;

@property(nonatomic,strong) XGOrderModel *infoModel;


@end
