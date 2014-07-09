//
//  InterHotelOrderHistoryDetail.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderHistoryDetail.h"
#import "InterHotelOrderDetailCell.h"
#import "TimeUtils.h"
#import "InterOrderConfirmationLetterRequest.h"
#import "OrderHistoryPostManager.h"
#import "ElongURL.h"
#import "InterHotelPostManager.h"
#import "InterHotelSearcher.h"
#import "InterHotelDetailCtrl.h"
#import "PublicMethods.h"
#import "MobClick.h"
#import "DefineHotelResp.h"

#define PassAlertTag    89301

@interface InterHotelOrderHistoryDetail ()
@property (nonatomic,retain) NSArray *titleArray;
@property (nonatomic,retain) PKPass *pass;
@property(nonatomic,retain) BaseBottomBar *bottomBar;

@end

@implementation InterHotelOrderHistoryDetail
@synthesize titleArray;
@synthesize orderDetail = _orderDetail;
@synthesize bottomBar;
@synthesize delegate;
@synthesize pass;

- (void) dealloc{
    self.titleArray = nil;
    self.orderDetail = nil;
    self.pass = nil;
    if (confirmHttpUtil) {
        [confirmHttpUtil cancel];
        CFRelease(confirmHttpUtil);
    }
    if (cancelHttpUtil) {
        [cancelHttpUtil cancel];
        CFRelease(cancelHttpUtil);
    }
    
    if (passUtil) {
        [passUtil cancel];
        SFRelease(passUtil);
    }
    
    [super dealloc];
}

- (id) initWithCancel:(BOOL) cancel{
    if (self = [super initWithTopImagePath:@"" andTitle:@"订单详情" style:_NavNormalBtnStyle_]){
        if (cancel) {
            UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"取消订单" Target:self Action:@selector(cancelorder)];
            self.navigationItem.rightBarButtonItem = cancelBarItem;
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.titleArray = [NSArray arrayWithObjects:@"订  单 号：",@"订单状态：",@"预订日期：",@"订单总额：",@"酒店名称：",@"酒店地址：",@"付款方式：",@"入住日期：",@"离店日期：",@"入住房型：",@"入  住 人：",@"邮    箱：", nil];
    
    [self addOrderDetailList];
    
   
    if (UMENG) {
        //国际酒店订单详情页面
        [MobClick event:Event_InterOrderDetail];
    }
}

- (void) setOrderDetail:(NSDictionary *)orderDetail{
    [_orderDetail release];
    _orderDetail = orderDetail;
    [_orderDetail retain];
    [self addBottomBar];
}

-(void)addBottomBar{
    BOOL haveConfirm = NO;
    if ([self.orderDetail safeObjectForKey:@"OrderStatus"]!=[NSNull null]) {
        if ([[self.orderDetail safeObjectForKey:@"OrderStatus"] isEqualToString:@"已确认"]) {
            // 有确认函
            haveConfirm = YES;
        }
    }
    
    if(!bottomBar){
        bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
        bottomBar.delegate = self;
        
        // 再次预订
        BaseBottomBarItem *againBookBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"再次预订"
                                                                             titleFont:[UIFont systemFontOfSize:12.0f]
                                                                                 image:@"hotelOrder_AgainBook_N.png"
                                                                       highligtedImage:@"hotelOrder_AgainBook_N.png"];
        //确认函
        BaseBottomBarItem *confirmFileBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"确认函"
                                                                              titleFont:[UIFont systemFontOfSize:12.0f]
                                                                                  image:@"orderDetail_ConfirmFile_N.png"
                                                                        highligtedImage:@"orderDetail_ConfirmFile_H.png"];
        
            //Passbook
         BaseBottomBarItem *saveOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"Passbook"
                                                              titleFont:[UIFont systemFontOfSize:12.0f]
                                                                  image:@"addToPassBook.png"
                                                        highligtedImage:@"addToPassBook.png"];

        againBookBarItem.autoReverse = YES;
        againBookBarItem.allowRepeat = YES;
        
        confirmFileBarItem.autoReverse = YES;
        confirmFileBarItem.allowRepeat = YES;
        
        saveOrderBarItem.autoReverse = YES;
        saveOrderBarItem.allowRepeat = YES;
        
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:1];
        [items addObject:againBookBarItem];
        
        if(haveConfirm){
            [items addObject:confirmFileBarItem];
        }
        
        //暂时隐藏PassBook
        BOOL isShowPass = NO;
        if(isShowPass){
            [items addObject:saveOrderBarItem];
        }
        bottomBar.baseBottomBarItems = items;
        
        [self.view addSubview:bottomBar];
        
        [againBookBarItem release];
        [confirmFileBarItem release];
        [saveOrderBarItem release];
        [bottomBar release];
        
        [self.view sendSubviewToBack:orderDetailList];
    }
}


- (void) addOrderDetailList{
    orderDetailList  = [[UITableView alloc] initWithFrame:CGRectMake(0,  0, SCREEN_WIDTH, MAINCONTENTHEIGHT-44) style:UITableViewStylePlain];
    orderDetailList.delegate = self;
    orderDetailList.dataSource = self;
    orderDetailList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:orderDetailList];
    [orderDetailList release];
    
    UIView *headerEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4)];
    [headerEmptyView setBackgroundColor:[UIColor clearColor]];
    orderDetailList.tableHeaderView = headerEmptyView;
    [headerEmptyView release];
}

#pragma mark -
#pragma mark Actions
- (void) clickConfirmBtn:(id)sender{
    NSString *number = [NSString stringWithFormat:@"%lld",[[self.orderDetail safeObjectForKey:@"OrderNumber"] longLongValue]];
    InterOrderConfirmationLetterRequest *request = [OrderHistoryPostManager getInterOrderConfirmationLetterRequest];
    request.orderNumber = number;
    
    if (confirmHttpUtil) {
        [confirmHttpUtil cancel];
        CFRelease(confirmHttpUtil);
    }
    confirmHttpUtil = [[HttpUtil alloc] init];
    [confirmHttpUtil connectWithURLString:INTER_SEARCH
                                  Content:[request request]
                             StartLoading:YES
                               EndLoading:YES
                                 Delegate:self];

}

- (void)back:(id)sender
{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)clickBookAgainBtn:(id)sender
{
    NSString *hotelId = @"";
    if(DICTIONARYHASVALUE(self.orderDetail)){
        hotelId = [self.orderDetail safeObjectForKey:@"HotelID"];
    }
    NSString *arriveDateStr = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"yyyy-MM-dd"];
    NSString *departDateStr = [TimeUtils displayDateWithNSDate:[NSDate dateWithTimeInterval:24*3600 sinceDate:[NSDate date]] formatter:@"yyyy-MM-dd"];

    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [infoDict safeSetObject:hotelId forKey:HOTELID_REQ];
    [infoDict safeSetObject:arriveDateStr forKey:Req_ArriveDate];
    [infoDict safeSetObject:departDateStr forKey:Req_DepartureDate];
    
    InterHotelDetailCtrl *interDetail = [[InterHotelDetailCtrl alloc] initWithDataDic:infoDict];
    [self.navigationController pushViewController:interDetail animated:YES];
    [interDetail release];
    
    
}

- (void) clickPassBtn:(id)sender{
//    NSString *orderID = [source safeObjectForKey:@"OrderNo"];
//    NSString *cardNum = [[AccountManager instanse] cardNo];
//    NSString *url = [PublicMethods getPassUrlByType:HotelPass orderID:orderID cardNum:cardNum lat:@"0" lon:@"0"];
    
    if (passUtil) {
        [passUtil cancel];
        SFRelease(passUtil);
    }
    passUtil = [[HttpUtil alloc] init];
    [passUtil connectWithURLString:@"" Content:nil Delegate:self];
}

// 取消订单

-(void)cancelorder{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消该订单?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (PassAlertTag == alertView.tag) {
        if (buttonIndex != 0) {
            // 前往更新passbook
            PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:pass];
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
    }else if (1 == buttonIndex) {
        NSString *number = [NSString stringWithFormat:@"%lld",[[self.orderDetail safeObjectForKey:@"OrderNumber"] longLongValue]];
        InterOrderDetailRequest *detailRequest = [OrderHistoryPostManager getInterOrderOrderDetailRequest];
        detailRequest.orderNumber = number;
        
        if (cancelHttpUtil) {
            [cancelHttpUtil cancel];
            CFRelease(cancelHttpUtil);
        }
        cancelHttpUtil = [[HttpUtil alloc] init];
        [cancelHttpUtil connectWithURLString:INTER_SEARCH
                                     Content:[detailRequest cancelRequest]
                                StartLoading:YES
                                  EndLoading:YES
                                    Delegate:self];
        
        if(UMENG){
            //国际酒店订单详情页面点击取消
            [MobClick event:Event_InterOrderDetail_Cancel];
        }
    }
}

#pragma mark -
#pragma mark PrivateMethods

- (NSString *) orderDetailName:(NSInteger)index{
    return [titleArray safeObjectAtIndex:index];
}

- (NSString *)orderDetailValue:(NSInteger)index{
    switch (index) {
        case 0:{
            return [NSString stringWithFormat:@"%lld",[[self.orderDetail safeObjectForKey:@"OrderNumber"] longLongValue]];
        }
        case 1:{
            if ([self.orderDetail safeObjectForKey:@"OrderStatus"]!=[NSNull null]) {
                if ([[self.orderDetail safeObjectForKey:@"OrderStatus"] isEqualToString:@"已确认"]) {
                   
                }
                return [self.orderDetail safeObjectForKey:@"OrderStatus"];
            }
            return @"";
        }
        case 2:{
            if ([self.orderDetail safeObjectForKey:@"OrderTime"]!=[NSNull null]) {
                return [TimeUtils displayDateWithJsonDate:[self.orderDetail safeObjectForKey:@"OrderTime"] formatter:@"yyyy-MM-dd"];
            }
            return @"";
            //
        }
        case 3:{
            return [NSString stringWithFormat:@"%@%.2f",@"¥",[[self.orderDetail safeObjectForKey:@"TotalMoney"] floatValue]];
        }
        case 4:{
            if ([self.orderDetail safeObjectForKey:@"HotelName"]!=[NSNull null]) {
                return [self.orderDetail safeObjectForKey:@"HotelName"];
            }
            return @"";
        }
        case 5:{
            if ([self.orderDetail safeObjectForKey:@"HotelAddress"]!=[NSNull null]) {
                return [self.orderDetail safeObjectForKey:@"HotelAddress"];
            }
            return @"";
        }
        case 6:{
            if([self.orderDetail safeObjectForKey:@"PayWay"]!=[NSNull null]){
                return [self.orderDetail safeObjectForKey:@"PayWay"];
            }
            return @"";
        }
        case 7:{
            if ([self.orderDetail safeObjectForKey:@"InDate"]!=[NSNull null]) {
                return [self.orderDetail safeObjectForKey:@"InDate"];
            }
            return @"";
        }
        case 8:{
            if ([self.orderDetail safeObjectForKey:@"OutDate"]!=[NSNull null]) {
                return [self.orderDetail safeObjectForKey:@"OutDate"];
            }
            return @"";
        }
        case 9:{
            if ([self.orderDetail safeObjectForKey:@"RoomType"]!=[NSNull null] && [self.orderDetail safeObjectForKey:@"BedType"]!=[NSNull null]) {
                return [NSString stringWithFormat:@"%@ %@",[self.orderDetail safeObjectForKey:@"RoomType"], [self.orderDetail safeObjectForKey:@"BedType"]];
            }else if ([self.orderDetail safeObjectForKey:@"RoomType"]!=[NSNull null]){
                return [self.orderDetail safeObjectForKey:@"RoomType"];
            }
            return @"";
        }
        case 10:{
            NSArray *persons = [self.orderDetail safeObjectForKey:@"CheckInHotelPersons"];
            return [persons componentsJoinedByString:@";"];
        }
        case 11:{
            if ([self.orderDetail safeObjectForKey:@"ContactPersonMail"]!=[NSNull null]) {
                return [self.orderDetail safeObjectForKey:@"ContactPersonMail"];
            }
            return @"";
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - BaseBottomBar delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if(index==0){
        [self clickBookAgainBtn:nil];
        UMENG_EVENT(UEvent_UserCenter_InterOrder_Rebook)
    }else if(index==1){
        [self clickConfirmBtn:nil];
        UMENG_EVENT(UEvent_UserCenter_InterOrder_Confirmation)
    }else{
        [self clickPassBtn:nil];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.titleArray) {
        return self.titleArray.count;
    }else{
        return 0;
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *value = [self orderDetailValue:indexPath.row];
    if (!STRINGHASVALUE(value)) {
        return 0;
    }
    
    CGSize newSize = [value sizeWithFont:FONT_15 constrainedToSize:CGSizeMake(SCREEN_WIDTH-115, 1000)];
    int height = newSize.height>32?newSize.height+12:32;
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InterHotelOrderDetailCell";
    InterHotelOrderDetailCell *cell = (InterHotelOrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[InterHotelOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;       //当cellHeight为0时不显示
    }
    
    cell.valueLbl.textColor = [UIColor blackColor];
    if(indexPath.row==3){
        //价格
        cell.valueLbl.textColor = RGBACOLOR(250, 33, 0, 1);
    }

    [cell setLineHidden:NO];
    
    [cell setName:[self orderDetailName:indexPath.row]];
    [cell setValue:[self orderDetailValue:indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark HttpUtil
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
    if (confirmHttpUtil == util) {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:root];
        
        NSArray *keys = [data allKeys];
        NSUInteger count = [data count];
        NSUInteger i;
        for (i = 0; i < count; i++)
        {
            id key = [keys safeObjectAtIndex: i];
            id value = [data safeObjectForKey: key];
            if ([value isEqual:[NSNull null]]) {
                [data removeObjectForKey:key];
            }
        }
        
        InterHotelOrderConfirmationLetterController *controller = [[[InterHotelOrderConfirmationLetterController alloc] initWithNibName:nil bundle:nil] autorelease];
        
        controller.orderNumber = [[data safeObjectForKey:@"OrderNumber"] stringValue];
        controller.hotelName = [data safeObjectForKey:@"HotelName"];
        controller.hotelAddress = [data safeObjectForKey:@"HotelAddress"];
        controller.hotelTelephoneNumber = [data safeObjectForKey:@"HotelTel"] == nil ? @"无" : [data safeObjectForKey:@"HotelTel"];
        controller.checkInDate = [data safeObjectForKey:@"InDate"];
        controller.checkOutDate = [data safeObjectForKey:@"OutDate"];
        controller.orderDetails = [data safeObjectForKey:@""];
        controller.roomType = [data safeObjectForKey:@"RoomType"];
        controller.bedType = [[data safeObjectForKey:@"BedType"] length] == 0 ? @"不详" : [data safeObjectForKey:@"BedType"];
        controller.roomDetails = [[data safeObjectForKey:@"AddValues"] length] == 0 ? @"无" : [data safeObjectForKey:@"AddValues"];
        controller.guestsList = [data safeObjectForKey:@"CheckInHotelPersons"];
        controller.price = [NSString stringWithFormat:@"¥ %.2f", [[[data safeObjectForKey:@"CostInfo"] safeObjectForKey:@"NightlyMoney"] floatValue]];
        controller.tax = [NSString stringWithFormat:@"¥ %.2f", [[[data safeObjectForKey:@"CostInfo"] safeObjectForKey:@"SurChargeMoney"] floatValue]];
        controller.total = [NSString stringWithFormat:@"¥ %.2f", [[[data safeObjectForKey:@"CostInfo"] safeObjectForKey:@"TotalMoney"] floatValue]];
        controller.payer = [[data safeObjectForKey:@"ChargeInfo"] safeObjectForKey:@"HolderName"];
        controller.cardNumber = [[data safeObjectForKey:@"ChargeInfo"] safeObjectForKey:@"CreditCardNo"];
        controller.additionalInfomation = [data safeObjectForKey:@"CancelPolicy"];
        controller.starLevel = [data safeObjectForKey:@"StarLevel"];
        controller.specialRequirements = [[data safeObjectForKey:@"SpecialInfo"] length] == 0 ? @"无" : [data safeObjectForKey:@"SpecialInfo"];
        
        NSTimeInterval time0 = [[TimeUtils NSStringToNSDate:[data safeObjectForKey:@"InDate"] formatter:@"yyyy/MM/dd"] timeIntervalSince1970];
        NSTimeInterval time1 = [[TimeUtils NSStringToNSDate:[data safeObjectForKey:@"OutDate"] formatter:@"yyyy/MM/dd"] timeIntervalSince1970];
        
        int days = (time1 -time0)/(24*3600);
        
        controller.orderDetails = [NSString stringWithFormat:@"%d晚/Night(s),%@间/Room(s)", days, [data safeObjectForKey:@"RoomNum"]];
        controller.orderDetailController = self;
        
        if (IOSVersion_7) {
            controller.transitioningDelegate = [ModalAnimationContainer shared];
            controller.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [self presentModalViewController:controller animated:YES];
        }
    }
    else if(cancelHttpUtil == util){
        self.navigationItem.rightBarButtonItem = nil;
        if ([delegate respondsToSelector:@selector(interHotelOrderDetailCanceled:)]) {
            [delegate interHotelOrderDetailCanceled:[NSString stringWithFormat:@"%lld",[[self.orderDetail safeObjectForKey:@"OrderNumber"] longLongValue]]];
        }
        [Utils alert:@"已取消订单"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(passUtil == util){
        if (!responseData) {
            [PublicMethods showAlertTitle:@"Pass文件生成失败" Message:nil];
            return;
        }
        NSError *error = nil;

        self.pass = [[[PKPass alloc] initWithData:responseData error:&error] autorelease];
        
        PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
        
        if ([passLibrary containsPass:pass]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passbook已存在该酒店订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            alert.tag = PassAlertTag;
            [alert show];
            [alert release];
        }else{
            PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:pass];
            if (addPassVC) {
                addPassVC.delegate = self;
                [self presentViewController:addPassVC animated:YES completion:^{}];
                [addPassVC release];
            }
            else {
                [PublicMethods showAlertTitle:@"非常抱歉，该订单无法生成Passbook" Message:nil];
            }
        }
    }
}

#pragma mark -
#pragma mark PKAddPassesViewControllerDelegate

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
    if ([passLibrary containsPass:pass]) {
        [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
    }
}

@end
