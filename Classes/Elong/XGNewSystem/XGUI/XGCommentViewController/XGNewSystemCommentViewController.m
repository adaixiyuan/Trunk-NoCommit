//
//  XGCommentViewController.m
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGNewSystemCommentViewController.h"
#import "XGFramework.h"
#import "XGTipView.h"
#define AFTERPINGLUNSUCINDETAIL @"afterPingLunSucInDetail"  //详情中评论后
@interface XGNewSystemCommentViewController ()
@property(nonatomic,assign)NSInteger recordScore;
@end

@implementation XGNewSystemCommentViewController

-(void)ReleaseMemory
{
    
}
-(void)dealloc
{
    
}
#pragma mark - 属性实现

#pragma mark - 生命周期
//生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.recordScore=5;
    [self StartSelected:5];
    self.hotelNameLabel.text =self.infoModel.HotelName;
}

#pragma mark - 自定义方法
-(IBAction)star1Action
{
    self.recordScore=1;
    [self StartSelected:1];
}
-(IBAction)star2Action
{
    self.recordScore=2;
    [self StartSelected:2];
}
-(IBAction)star3Action
{
    self.recordScore=3;
    [self StartSelected:3];
}
-(IBAction)star4Action
{
    self.recordScore=4;
    [self StartSelected:4];
}
-(IBAction)star5Action
{
    self.recordScore=5;
    [self StartSelected:5];
}
-(void)StartSelected:(int)index
{
    if (index<=0) {
        return;
    }
    self.disTipLabel.text=(index>=5?@"非常好":(index==4?@"较好":(index==3?@"一般":(index==2?@"较差":@"很差"))));
    [self setStartSelected:index>=1 star2:index>=2 star3:index>=3 star4:index>=4 star5:index>=5];
}
-(void)setStartSelected:(BOOL)star1 star2:(BOOL)star2 star3:(BOOL)star3 star4:(BOOL)star4 star5:(BOOL)star5
{
    [self.startImage1 setImage:[UIImage imageNamed:(star1?@"XGStar_A":@"XGStar_B")] forState:UIControlStateNormal];
    [self.startImage2 setImage:[UIImage imageNamed:(star2?@"XGStar_A":@"XGStar_B")] forState:UIControlStateNormal];
    [self.startImage3 setImage:[UIImage imageNamed:(star3?@"XGStar_A":@"XGStar_B")] forState:UIControlStateNormal];
    [self.startImage4 setImage:[UIImage imageNamed:(star4?@"XGStar_A":@"XGStar_B")] forState:UIControlStateNormal];
    [self.startImage5 setImage:[UIImage imageNamed:(star5?@"XGStar_A":@"XGStar_B")] forState:UIControlStateNormal];
    
}
#pragma mark - 基类方法


-(id)init
{
    self =[super initWithTitle:@"评价酒店" style:NavBarBtnStyleNormalBtn];
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(NSString *)viewName
{
    return @"业务界面.酒店点评";
}

- (IBAction)commitAction:(id)sender {
    if (self.infoModel==nil) {
        NSLog(@"ERROR __commitAction self.infoModel==nil");
        return;
    }
    
    __unsafe_unretained typeof(self) weakself= self;
    XGHttpRequest *request =[[XGHttpRequest alloc] init];
    NSString *url =[[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"comment"];
    NSDictionary *params =@{
                            @"CardNo": [NSNumber numberWithLongLong: [[[AccountManager instanse] cardNo] longLongValue]],

                            @"orderId":self.infoModel.OrderId,@"score":[NSNumber numberWithInt:self.recordScore]};
    [request evalForURL:url postBody:params RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        if (type!=XGRequestFinished) {
            return;
        }
        if ([Utils checkJsonIsError:returnValue]) {
            return;
        }
        //发出广播，提示评论成功
        [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_XGCommented object:weakself.infoModel];
        [[NSNotificationCenter defaultCenter]postNotificationName:Notifaction_XGHomeOrderViewControllerRefresh object:nil];
        
        if (weakself.isfromOrderDetail==YES) {  //是否从 详情进来
            [[NSNotificationCenter defaultCenter]postNotificationName:AFTERPINGLUNSUCINDETAIL object:nil];
        }
        
        XGTipView *tipView =[[XGTipView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [tipView layoutSubviews];
        tipView.alpha=0;
        [weakself.navigationController.view addSubview:tipView];
        
        [UIView animateWithDuration:.5 animations:^(){
            tipView.alpha=1;
        
        } completion:^(BOOL finished){
            [weakself performSelector:@selector(tipViewHide:) withObject:tipView afterDelay:2];
        
        }];
    }];
}
-(void)tipViewHide:(UIView *)xv
{
    [UIView animateWithDuration:0.5 animations:^(){
        xv.alpha =0;
    } completion:^(BOOL finished){
        [xv removeFromSuperview];
        [self back];
    }];
}
@end
