//
//  XGOrderDetailViewController.m
//  ElongClient
//
//  Created by 李程 on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGOrderDetailViewController.h"
#import "BaseBottomBar.h"
#import "AccountManager.h"
#import "ShareTools.h"
#import "HotelOrderDetailRequest.h"
#import "XGHomeOrderDetailSource.h"
#import "NSString+URLEncoding.h"
#import "XGApplication.h"
#import "XGApplication+Common.h"
#import "XGHttpRequest.h"
#import "StringEncryption.h"
#import "XGFramework.h"
#import "XGNewSystemCommentViewController.h"
#import "XGFramework.h"
#define TelPhone_ActionSheetTag 1002

#define AFTERPINGLUNSUCINDETAIL @"afterPingLunSucInDetail"  //详情中评论后


@interface XGOrderDetailViewController ()<BaseBottomBarDelegate,HotelOrderDetailRequestDelegate,PKAddPassesViewControllerDelegate>
{
//    HttpUtil *_passbookUtil;
}
@property(nonatomic,strong)HotelOrderDetailRequest *orderDetailRequest;

@property(nonatomic,strong)PKPass *pkPass;
@property(nonatomic,strong)UITableView *detailTable;
@property(nonatomic,strong)UIButton *footerButton;
@property(nonatomic,strong)UILabel *labelStatus;
@property(nonatomic,assign)BOOL isNeedRefreshList;
@end

@implementation XGOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super initWithTitle:@"订单" style:NavBarBtnStyleOnlyBackBtn];
    
    if (self) {
        
//        _passbookUtil = [[HttpUtil alloc] init];
        _orderDetailRequest = [[HotelOrderDetailRequest alloc] initWithDelegate:self];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)back{
    
    if (self.isNeedRefreshList) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Notifaction_XGHomeOrderViewControllerRefresh object:nil];
        
    }
    
    NSLog(@"back....");
    [super back];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterPingLunSucInDetail) name:@"afterPingLunSucInDetail" object:nil];
    
    NSString *orderId= self.orderModel.OrderId;
    
    NSString *oderTitle = @"订单";
    
    if (STRINGHASVALUE(orderId)) {
        oderTitle = [NSString stringWithFormat:@"%@%@",oderTitle,orderId];
    }
    
    [self addTopImageAndTitle:nil andTitle:oderTitle];
    
    self.detailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT-44) style:UITableViewStylePlain];
    self.detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.detailTable];
    
    self.dataSource = [[XGHomeOrderDetailSource  alloc] initWithOrder:self.orderModel table:self.detailTable];      //初始化
    self.dataSource.myparentViewController = self;
    
    [self buildTableHeaderViewUI];      //构建顶部UI
    [self buildTableFooterViewUI];      //构建底部UI
    [self buildBottomBar];      //构建BottomBar

}


#pragma mark - Private Methods
//构建BaseBottomBar
-(void)buildBottomBar{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    //分享订单
    BaseBottomBarItem *shareOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"分享订单"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"hotelOrder_shareOrder_N.png"
                                                                    highligtedImage:@"hotelOrder_shareOrder_H.png"];
    
    BaseBottomBarItem  *saveOrderBarItem;
    if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
        //Passbook
        saveOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"Passbook"
                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                              image:@"addToPassBook.png"
                                                    highligtedImage:@"addToPassBook.png"];
    }else{
        // 订单保存
        saveOrderBarItem= [[BaseBottomBarItem alloc] initWithTitle:@"保存订单"
                                                         titleFont:[UIFont systemFontOfSize:12.0f]
                                                             image:@"orderDetail_SaveOrder_N.png"
                                                   highligtedImage:@"orderDetail_SaveOrder_H.png"];
    }
    
    shareOrderBarItem.autoReverse = YES;
    shareOrderBarItem.allowRepeat = YES;
    
    saveOrderBarItem.autoReverse = YES;
    saveOrderBarItem.allowRepeat = YES;
    
    NSArray *items = [NSArray arrayWithObjects:shareOrderBarItem,saveOrderBarItem, nil];
    bottomBar.baseBottomBarItems = items;
    [self.view addSubview:bottomBar];
}



//构建_detailTable的顶部UI
-(void)buildTableHeaderViewUI{
    self.detailTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.detailTable.tableHeaderView.clipsToBounds = YES;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"订单状态：";
    [self.detailTable.tableHeaderView addSubview:titleLabel];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 220, 30)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = RGBACOLOR(254, 75, 32, 1);
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self.detailTable.tableHeaderView addSubview:contentLabel];
    
    //订单状态
    NSString *orderStatus = @"";
    orderStatus = STRINGHASVALUE(self.orderModel.StateName)?self.orderModel.StateName:@"暂无状态";
    contentLabel.text = orderStatus;
    self.labelStatus = contentLabel;

}


//构建底部UI
-(void)buildTableFooterViewUI{
    self.detailTable.tableFooterView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    //    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //下面的按钮字典
    if (self.orderModel.BelowButton!=nil) {
        NSString *desc = self.orderModel.BelowButton.Desc;
        NSNumber *tagnum = self.orderModel.BelowButton.Type;
        if (STRINGHASVALUE(desc)&&tagnum!=nil) {
            
            self.footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.footerButton.tag = [tagnum intValue];
            self.footerButton.frame = CGRectMake(20, 15, 280, 40);
            [self.footerButton addTarget:self action:@selector(clickModifyOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            //设置againPayBtn的背景图
            [self.footerButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
            [self.footerButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
            //设置字体颜色
            [self.footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [self.footerButton setTitle:desc forState:UIControlStateNormal];
            [_detailTable.tableFooterView addSubview:self.footerButton];
        }
    }
//    UIButton *modifyOrderBtn = [self customizableButtonWithTitle:@"修改订单" targer:self action:@selector(clickModifyOrderBtn:) frame:CGRectMake(20, 15, 280, 30)];
}
-(void)clickModifyOrderBtn:(UIButton *)sender{
    
    int status = sender.tag;
    //现在的 1联系酒店   2带我去酒店    3 取消    4 再次预定     5点评酒店
    NSLog(@"status==%d",status);
    //第一个版本就五中状态
    
    switch (status) {
        case 1:  //1联系酒店  ok
        {
            [self clickTelHotelBtn];
        }
            break;
        case 2:   //2带我去酒店  ok
        {
            [self clickGoHotelBtn];
        }
            break;
        case 3:  //3 取消   ok  查接口
        {
            [self clickCancelOrderBtn];
        }
            break;
        case 4:   //4 再次预定  不要了
        {
            
        }
            break;
        case 5:  //5点评酒店  ok
        {
            [self clickCommentHotelBtn];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark 点评酒店
-(void)clickCommentHotelBtn{
    XGNewSystemCommentViewController *c =[[XGNewSystemCommentViewController alloc] init];
    c.isfromOrderDetail = YES;
    c.infoModel =self.orderModel;
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark -
#pragma mark -  取消
//点击取消订单按钮
-(void)clickCancelOrderBtn{
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
		// 非会员流程只能打电话取消
		[self calltel400];
	}
	else {
        //***注释   预付的情况下，取消订单在C2C就不存在，想取消在国内酒店里面取消,   现付的时候走我们的取消订单
        __unsafe_unretained typeof(self) weakself = self;
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"您确定要取消该订单?" message:nil cancelButtonTitle:@"否" otherButtonTitles:@"是" buttonBlock:^(NSInteger flag) {
            
            if (flag==0) {  //取消
                
            }else if(flag==1){  // 确定
                
                XGOrderModel *orderModel = weakself.orderModel;
                
                if ([orderModel.Payment intValue]==0) {  //现付  只有现付 又取消按钮
                    [weakself excuteCancelOrderC2C];
                }
            }
            
        }];
        [alter show];
    }
}


#pragma mark - 执行C2C的取消订单操作
//执行自己的取消订单操作
-(void)excuteCancelOrderC2C{
    
    NSDictionary *dict =@{
                          @"CardNo":self.orderModel.CardNo,
                          @"orderId":self.orderModel.OrderNo
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    NSString *reqbody=[dict JSONString];
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"cancelOrder"];
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    __unsafe_unretained typeof(self) viewself = self;
    NSLog(@"请求url=====%@",url);
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        NSDictionary *result =returnValue;
        NSLog(@"取消结果result===%@",result);
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        NSLog(@"====成功===");
        //取消成功，广播
        [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_XGCancelOrderSucess object:viewself.orderModel.OrderNo];
        
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消成功" cancelButtonTitle:@"确定" otherButtonTitles:nil buttonBlock:^(NSInteger myflag) {
            
            [viewself refreshOrderDetailC2C:viewself.orderModel];
        }];
        
        [alter show];
        //by郭忍东
        [viewself.footerButton removeFromSuperview];
        
    }];
}

#pragma mark -- 取消订单冲刷界面
//执行取消订单冲刷界面
-(void)refreshOrderDetailC2C:(XGOrderModel *)orderModel{
    
    NSDictionary *dict =@{
                          @"CardNo":orderModel.CardNo,
                          @"orderId":orderModel.OrderNo
                          };
    
    NSLog(@"冲刷接口....dict==%@",dict);
    NSString *reqbody=[dict JSONString];
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"orderDetail"];
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    __unsafe_unretained typeof(self) weakself = self;
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        NSDictionary *result =returnValue;
        NSLog(@"result===%@",result);
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        
        NSDictionary *orderDetailDict=[result safeObjectForKey:@"OrderDetail"];
        XGOrderModel *orderDetailModel = [[XGOrderModel alloc]init];
        [orderDetailModel convertObjectFromGievnDictionary:orderDetailDict relySelf:YES];
        weakself.orderModel = orderDetailModel;
        
        NSString *orderStatus = @"";
        orderStatus = STRINGHASVALUE(weakself.orderModel.StateName)?weakself.orderModel.StateName:@"暂无状态";
        weakself.labelStatus.text = orderStatus;
        
        weakself.isNeedRefreshList = YES;
        NSLog(@"===取消订单的结果%@",result);
    }];
    
}

#pragma mark 再详情中评论成功后出冲刷界面
-(void)afterPingLunSucInDetail{

    [self.footerButton removeFromSuperview];
    
    [self refreshOrderDetailC2C:self.orderModel];  //冲刷界面
    
}



#pragma mark -
#pragma mark -  带我去酒店

//带我去酒店
-(void)clickGoHotelBtn{
    XGOrderModel  *order = self.orderModel;
    double longitude  =[order.Longitude doubleValue];
    double latitude  =[order.Latitude doubleValue];
    
    if (latitude != 0 || longitude != 0) {
        if (IOSVersion_6 && ![[ServiceConfig share] monkeySwitch]) {
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:order.HotelName];
        }else{
            // 酒店有坐标时用酒店坐标导航
            [PublicMethods pushToMapWithDesLat:latitude Lon:longitude];
        }
    }
    else {
        // 酒店没有坐标时用酒店地址导航
        [PublicMethods pushToMapWithDestName:order.HotelAddress];
    }
}


#pragma mark -
#pragma mark -  联系酒店

//联系酒店
-(void)clickTelHotelBtn{
    
    XGOrderModel *order = self.orderModel;
    if (STRINGHASVALUE(order.HotelPhone))
    {
        UIActionSheet *menu =[[UIActionSheet alloc] initWithTitle:@"前台电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:order.HotelPhone,nil];
        menu.delegate = self;
        menu.actionSheetStyle=UIBarStyleBlackTranslucent;
        menu.tag = TelPhone_ActionSheetTag;
        [menu showInView:self.view];
    }
}


#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == TelPhone_ActionSheetTag){
        if (buttonIndex == 0) {
            XGOrderModel *order = self.orderModel;
            NSString *telText = order.HotelPhone;
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+-)*\\d+" options:0 error:&error];
            NSString *tel = nil;
            
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:telText options:0 range:NSMakeRange(0, [telText length])];
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                tel = [telText substringWithRange:resultRange];
                
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]]) {
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }
            else {
                [PublicMethods showAlertTitle:@"电话格式错误" Message:nil];
            }
        }
    }
}


#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if(index==0){
        //分享
        [self shareOrderInfo];
    }else{
        //Add Passbook 或 保存
        if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
            
            [_orderDetailRequest startRequestWIthAddOrderToPassbook:self.orderModel.jsonDict];  //delete
            
        }else{
            [self saveOrderToPhotosAlbum];  //保存订单到相册
        }
    }
}


//保存到照片库
-(void)saveOrderToPhotosAlbum{
    self.view.userInteractionEnabled = NO;
    //获取屏幕截图
    UIImage *captureImg = [self screenshotOnCurrentView];
    
    //将截图装入ImgView进行动画
    UIImageView *animationImgView = [[UIImageView alloc] initWithImage:captureImg];
    animationImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-64);
    [self.view addSubview:animationImgView];
    [self performSelector:@selector(startAnimationsWithImgView:) withObject:animationImgView afterDelay:0.3];
    
    //保存图片到相册
    UIImageWriteToSavedPhotosAlbum(captureImg,
                                   self,
                                   @selector(imageSavedToPhotosAlbum:
                                             didFinishSavingWithError:
                                             contextInfo:),
                                   nil);
}


//屏幕截图
-(UIImage *)screenshotOnCurrentView
{
    CGRect originFrame = self.detailTable.frame;        //原大小
    //此处重新设置_detailTable,是为了刷新table得到所有数据
    CGRect tableFrame = self.detailTable.frame;
    tableFrame.size.height = self.detailTable.contentSize.height;
    self.detailTable.frame = tableFrame;
    
    CGSize size = self.detailTable.contentSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    self.detailTable.layer.masksToBounds=NO;        //防止截图被截掉
	[self.detailTable.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    self.detailTable.layer.masksToBounds = YES;
    self.detailTable.layer.frame = originFrame;     //重置回原来大小
    return newImage;
}

//保存订单到图片库时进行动画
-(void)startAnimationsWithImgView:(UIImageView *)imgView{
    [imgView.layer removeAnimationForKey:@"marioJump"];     //先移除这个动画序列
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = .5;
    scaleAnimation.toValue = [NSNumber numberWithFloat:.1];
    
    CABasicAnimation *slideDownx = [CABasicAnimation animationWithKeyPath:@"position.x"];
    slideDownx.toValue = [NSNumber numberWithFloat: 280];
    slideDownx.duration = .5f;
    slideDownx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *slideDowny = [CABasicAnimation animationWithKeyPath:@"position.y"];
    slideDowny.toValue = [NSNumber numberWithFloat: SCREEN_HEIGHT-44];
    slideDowny.duration = .5f;
    slideDowny.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scaleAnimation, slideDownx,slideDowny, nil];
    group.duration = .5;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = NO;
    //    group.delegate = self;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    
    [imgView.layer addAnimation:group forKey:@"marioJump"];     //添加动画序列
    [imgView performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];        //隐藏
    [imgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];     //动画执行0.5s，延迟0.5s将imgView移除视图
}

//自定义类型的Button适用于 去支付，修改订单，入住反馈和 再次预订等
-(UIButton *)customizableButtonWithTitle:(NSString *)title
                                  targer:(id)target
                                  action:(SEL)action
                                   frame:(CGRect)frame{
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpBtn.frame = frame;
    [tmpBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置againPayBtn的背景图
    [tmpBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [tmpBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    //设置字体颜色
    [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tmpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [tmpBtn setTitle:title forState:UIControlStateNormal];
    
    return tmpBtn;
}



#pragma mark - SavePhotosAblum Delegate
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message;
    NSString *title;
    if (!error){
        title = nil;
        message = NSLocalizedString(@"订单已经保存到相册", @"");
    } else {
        title = NSLocalizedString(@"保存失败", @"");
        message = [error description];
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"知道了", @"")
                                          otherButtonTitles:nil];
    [alert show];
    self.view.userInteractionEnabled = YES;
}


//分享订单
-(void)shareOrderInfo{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage = [self screenshotOnCurrentView];
    NSDictionary *hotel = self.orderModel.jsonDict;
    NSString *hotelId = [hotel safeObjectForKey:@"HotelId"];
    shareTools.hotelId = hotelId;
	
	shareTools.weiBoContent = [self weiboContent];
	shareTools.msgContent = [self smsContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订酒店成功！";
	shareTools.mailContent = [self mailContent];
	
	[shareTools  showItems];
}

//分享的微博内容
-(NSString *) weiboContent{
//    NSString *currency = [_currentOrder safeObjectForKey:@"Currency"];  //货币符号
//    NSString *currencyMark = currency;
//    if ([currency isEqualToString:@"HKD"]) {
//        currencyMark = @"HK$";
//    }
//    else if ([currency isEqualToString:@"RMB"]) {
//        currencyMark = @"¥";
//    }
    
    NSString * currencyMark = @"¥";
    
	NSString *price_str = [NSString stringWithFormat:@"%@%.f",currencyMark,[self.orderModel.SumPrice doubleValue]];
	
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，既便捷又超值。%@ ,地址：%@，艺龙价仅售%@。",self.orderModel.HotelName,
						 self.orderModel.HotelAddress,price_str];
	NSString *content = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
}


//分享的短信内容
-(NSString *) smsContent{
    
    NSString *arriveString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.ArriveDate longLongValue]];
    NSString *arriveDateStr = [TimeUtils displayDateWithJsonDate:arriveString formatter:@"MM月dd日"]; //到店日期
    
    NSString *departString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.LeaveDate longLongValue]];
    NSString *departDateStr = [TimeUtils displayDateWithJsonDate:departString formatter:@"MM月dd日"];      //离店日期
    

    
	NSString *date_str = [NSString stringWithFormat:@"%@至%@",arriveDateStr,departDateStr];
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，订单号：%@，%@ ,地址：%@ 日期：%@。",self.orderModel.OrderId,self.orderModel.HotelName,
						 self.orderModel.HotelAddress,date_str];
	
	NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	return messageBody;
}

//分享的邮件内容
-(NSString *) mailContent{
    
    NSString *arriveString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.ArriveDate longLongValue]];
    NSString *arriveDateStr = [TimeUtils displayDateWithJsonDate:arriveString formatter:@"MM月dd日"]; //到店日期
    
    NSString *departString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.LeaveDate longLongValue]];
    NSString *departDateStr = [TimeUtils displayDateWithJsonDate:departString formatter:@"MM月dd日"];      //离店日期
    
    NSString *date_str = [NSString stringWithFormat:@"%@至%@",arriveDateStr,departDateStr];
    
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，既便捷又超值。订单号：%@，%@ ,地址：%@ 日期：%@。",self.orderModel.OrderId,self.orderModel.HotelName,
						 self.orderModel.HotelAddress,date_str];
	
	NSString *messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
	return messageBody;
}


//执行呢增加passbook结果
-(void)executeAddPassbookResultData:(NSData *)resultData{
    NSError *error = nil;
    if(self.pkPass){
        self.pkPass = nil;
    }
    self.pkPass = [[PKPass alloc] initWithData:resultData error:&error];
    PKPassLibrary *passLibrary = [[PKPassLibrary alloc] init];
    
    __unsafe_unretained typeof(self) weakself = self;
    
    if ([passLibrary containsPass:self.pkPass]) {
        
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"Passbook已存在该酒店订单" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"查看" buttonBlock:^(NSInteger myflag) {
            
            if (myflag==0) {  //取消
                
            }else if(myflag==1){  // 确定
                // 前往更新passbook
                PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:weakself.pkPass];
                [weakself presentViewController:addPassVC animated:YES completion:^{}];
            }
        }];
        [alter show];
        
    }else{
        PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:self.pkPass];
        if (addPassVC) {
            addPassVC.delegate = self;
            [self presentViewController:addPassVC animated:YES completion:^{}];
        }
        else {
            [PublicMethods showAlertTitle:@"非常抱歉，该订单无法生成Passbook" Message:nil];
        }
    }
}


//点击酒店电话
-(void)clickOrderDetailCell_TelPhoneBtn{
    if (STRINGHASVALUE(self.orderModel.HotelPhone))
    {
        NSString *hotelPhoneString = self.orderModel.HotelPhone;
        NSArray *hotelPhones = [hotelPhoneString componentsSeparatedByString:@"、"];
        UIActionSheet *menu =[[UIActionSheet alloc] initWithTitle:@"前台电话" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil,nil];
        for(NSString *hotelPhone in hotelPhones){
            [menu addButtonWithTitle:hotelPhone];
        }
        [menu addButtonWithTitle:@"取消"];
        menu.cancelButtonIndex = hotelPhones.count;
        
        menu.delegate = self;
        menu.tag = TelPhone_ActionSheetTag;
        menu.actionSheetStyle=UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        
    }
}



#pragma mark - PKAddPassbook Delegate
-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    PKPassLibrary *passLibrary = [[PKPassLibrary alloc] init];
    if ([passLibrary containsPass:self.pkPass]) {
        [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
    }
}



@end
