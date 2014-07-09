//
//  FunctionUtils.m
//  ElongClient
//
//  Created by Janven on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FunctionUtils.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "FlightOrderDetail.h"
#import "PostHeader.h"

@implementation FunctionUtils

#pragma mark
#pragma mark 添加行程到日历

+(void)addScheduleToCalendarOn:(UIViewController *)_controller andDataModel:(NSObject *)object{
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.navDrawEnabled = YES;
    FlightOrderDetail *flight = (FlightOrderDetail *)object;
    [flight retain];
    //若多个航班只保存第一个
    PassengerTiketInfo *info_pt = [flight.PassengerTikets objectAtIndex:0];
    TicketInfo *info_t = [info_pt.Tickets objectAtIndex:0];
    AirLineInfo *info = [info_t.AirLineInfos objectAtIndex:0];
    
    if (IOSVersion_6) {
        
        __block UIViewController   *controller = (UIViewController *)_controller;
        
        if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusNotDetermined){
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                        EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
                        
                        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                        if (event) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                    
                                addController.event = [self createTheEventWithModel:info andEKEventStore:eventStore];
                                addController.eventStore = eventStore;
                                [eventStore release];
                                addController.editViewDelegate = (id<EKEventEditViewDelegate>)controller;
                                
                                if (IOSVersion_7) {
                                    addController.transitioningDelegate = [ModalAnimationContainer shared];
                                    addController.modalPresentationStyle = UIModalPresentationCustom;
                                }
                                if (IOSVersion_7) {
                                    [controller presentViewController:addController animated:YES completion:nil];
                                }else{
                                    [controller presentModalViewController:addController animated:YES];
                                }
                                
                                [addController release];
                                
                            });
                        }
                        else
                        {
                            [addController release];
                        }
                    });
                }
                else if (error)
                {
                    controller.view.userInteractionEnabled = YES;
                }
                else
                {
                    controller.view.userInteractionEnabled = YES;
                }
            }];
            
        }
        else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized){
            
            EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];

            EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
            EKEvent *event = [self createTheEventWithModel:info andEKEventStore:eventStore];
            addController.eventStore = eventStore;
            addController.event = event;
            addController.editViewDelegate = (id<EKEventEditViewDelegate>)controller;
            
            if (IOSVersion_7) {
                addController.transitioningDelegate = [ModalAnimationContainer shared];
                addController.modalPresentationStyle = UIModalPresentationCustom;
            }
            if (IOSVersion_7) {
                [controller presentViewController:addController animated:YES completion:nil];
            }else{
                [controller presentModalViewController:addController animated:YES];
            }
            [addController release];
            
        }
        else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开启日历权限"
                                                            message:@"请在设置中开启"
                                                           delegate:controller
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
	else{
        EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
        
        EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
        EKEvent *event = [self createTheEventWithModel:info andEKEventStore:eventStore];
        addController.eventStore = eventStore;
        addController.event = event;
        addController.editViewDelegate =(id<EKEventEditViewDelegate>) _controller;
        [_controller presentModalViewController:addController animated:YES];
        [addController release];
    }
}


+(EKEvent *)createTheEventWithModel:(AirLineInfo *)info andEKEventStore:(EKEventStore *)store{

    EKEvent *event = [EKEvent eventWithEventStore:store];
    
    NSString *title = [NSString stringWithFormat:@"%@ %@(%@)",info.AirCorpName,info.FlightNumber,info.Cabin];
    event.title     =  title;
    event.location  = [NSString stringWithFormat:@"%@->%@",info.DepartAirPort,info.ArrivalAirPort];
    
    NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
    
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-14400];
    [alarmsArray addObject:alarm];
    event.alarms = alarmsArray;
    [alarmsArray release];
    
    event.startDate = [TimeUtils parseJsonDate:info.DepartDate];
    event.endDate   = [TimeUtils parseJsonDate:info.ArrivalDate];
    event.notes     = [NSString stringWithFormat:@"航空公司：%@\n机       型：%@\n起飞时间：%@\n到达时间：%@\n起飞机场：%@\n到达机场：%@\n机       型：%@\n登       机：%@\n\n退票规定：\n%@\n改签规定：\n%@",
                       info.AirCorpName,
                       info.FlightNumber,
                       [TimeUtils displayDateWithJsonDate:info.DepartDate formatter:@"MM月dd日 HH:mm"],
                       [TimeUtils displayDateWithJsonDate:info.ArrivalDate formatter:@"MM月dd日 HH:mm"],
                       info.DepartAirPort,
                       info.ArrivalAirPort,
                       info.PlaneType,
                       info.DepartTerminal,
                       info.ReturnRegulate,
                       info.ChangeRegulate];

    return event;
}

#pragma mark
#pragma mark  截屏

+(UIImage *)captureViewOfScrollow:(UIScrollView *)scrollow
{
    CGSize size = scrollow.contentSize;
    if (size.height < SCREEN_HEIGHT) {
        size.height = SCREEN_HEIGHT;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    scrollow.layer.masksToBounds=NO;
	[scrollow.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark
#pragma mark  ShareContent-Setting

+(NSString *)getTheShareContentType:(ShareContent )type AndSource:(NSObject *)object{

    FlightOrderDetail *detail = (FlightOrderDetail *)object;
    [detail retain];
    PassengerTiketInfo *info = [detail.PassengerTikets objectAtIndex:0];

    NSString *message = nil;
    NSString *messageBody = nil;
    
    if ([info.Tickets count] == 1) {
        TicketInfo *t_info = [info.Tickets objectAtIndex:0];
        AirLineInfo *air = [t_info.AirLineInfos objectAtIndex:0];
        //单程
        switch (type) {
            case ShareContent_SMS:
                message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的机票，订单号：%@，%@ %@，起飞时间：%@，降落时间：%@。",air.DepartAirPort,air.ArrivalAirPort,
                           detail.OrderNo,air.AirCorpName,air.FlightNumber,
                           [TimeUtils displayDateWithJsonDate:air.DepartDate formatter:@"MM月dd日 HH:mm"],
                            [TimeUtils displayDateWithJsonDate:air.ArrivalDate formatter:@"MM月dd日 HH:mm"]];
                
                messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
                return messageBody;
                break;
            case ShareContent_Mail:
                message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的机票，既便捷又超值。订单号：%@，%@ %@，起飞时间：%@，降落时间：%@。",air.DepartAirPort,air.ArrivalAirPort,
                           detail.OrderNo,air.AirCorpName,air.FlightNumber,
                           [TimeUtils displayDateWithJsonDate:air.DepartDate formatter:@"MM月dd日 HH:mm"],
                           [TimeUtils displayDateWithJsonDate:air.ArrivalDate formatter:@"MM月dd日 HH:mm"]];
                
                messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
                
                return messageBody;
                
                break;
             case ShareContent_WeiBo:
                message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的机票，%@ %@,艺龙价仅售￥%@。",air.DepartAirPort,air.ArrivalAirPort,air.AirCorpName,air.FlightNumber,t_info.TiketFeeInfo.TicketPrice];
                
                messageBody  = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
                return messageBody;
                break;
            default:
                break;
        }
        
        
    }else if ([info.Tickets count] ==2){
        TicketInfo *ticket1 = [info.Tickets objectAtIndex:0];
        AirLineInfo *air1 = [ticket1.AirLineInfos objectAtIndex:0];
        
        TicketInfo*ticket2 = [info.Tickets objectAtIndex:1];
        AirLineInfo *air2 = [ticket2.AirLineInfos objectAtIndex:0];
        
        //往返
        switch (type) {
            case ShareContent_SMS:
                //
                message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了%@至%@的往返机票，订单号：%@，去程：%@ %@，起飞时间：%@，降落时间：%@， 返程：%@ %@，起飞时间：%@，降落时间：%@。",air1.DepartAirPort,air1.ArrivalAirPort,
                           detail.OrderNo,air1.AirCorpName,air1.FlightNumber,
                           [TimeUtils displayDateWithJsonDate:air1.DepartDate formatter:@"MM月dd日 HH:mm"],
                           [TimeUtils displayDateWithJsonDate:air1.ArrivalDate formatter:@"MM月dd日 HH:mm"],
                            air2.AirCorpName,air2.FlightNumber,
                           [TimeUtils displayDateWithJsonDate:air2.DepartDate formatter:@"MM月dd日 HH:mm"],
                           [TimeUtils displayDateWithJsonDate:air2.ArrivalDate formatter:@"MM月dd日 HH:mm"]];
                NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
                return messageBody;
                break;
            case ShareContent_Mail:
                message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的往返机票，既便捷又超值。订单号：%@，去程：%@ %@，起飞时间：%@，降落时间：%@， 返程：%@ %@，起飞时间：%@，降落时间：%@。",air1.DepartAirPort,air1.ArrivalAirPort,
                           detail.OrderNo,air1.AirCorpName,air1.FlightNumber,
                           [TimeUtils displayDateWithJsonDate:air1.DepartDate formatter:@"MM月dd日 HH:mm"],
                           [TimeUtils displayDateWithJsonDate:air1.ArrivalDate formatter:@"MM月dd日 HH:mm"],
                           air2.AirCorpName,air2.FlightNumber,
                           [TimeUtils displayDateWithJsonDate:air2.DepartDate formatter:@"MM月dd日 HH:mm"],
                           [TimeUtils displayDateWithJsonDate:air2.ArrivalDate formatter:@"MM月dd日 HH:mm"]];
                
                messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
                
                return messageBody;
                break;
            case ShareContent_WeiBo:
                message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的往返机票，去程：%@ %@,艺龙价仅售￥%@  返程：%@ %@,艺龙价仅售￥%@。",air1.DepartAirPort,air1.ArrivalAirPort,
                           air1.AirCorpName,air1.FlightNumber,ticket1.TiketFeeInfo.TicketPrice,air2.AirCorpName,air2.FlightNumber,ticket2.TiketFeeInfo.TicketPrice];
                 messageBody  = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
                return messageBody;
                break;
            default:
                break;
        }
    }
    return nil;
}

+(void)animationOfSaveToPhotosAlbum:(UIImageView *)view andViewController:(UIViewController *)vc{
    
    [view.layer removeAnimationForKey:@"marioJump"];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.5f;
    scaleAnimation.toValue = [NSNumber numberWithFloat:.001];
    
    CABasicAnimation *slideDownx = [CABasicAnimation animationWithKeyPath:@"position.x"];
    slideDownx.toValue = [NSNumber numberWithFloat: 280];
    slideDownx.duration = 0.5f;
    slideDownx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *slideDowny = [CABasicAnimation animationWithKeyPath:@"position.y"];
    slideDowny.toValue = [NSNumber numberWithFloat: MAINCONTENTHEIGHT-30];//+ rootScrollView.contentOffset.y]
    slideDowny.duration = 0.5f;
    slideDowny.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scaleAnimation, slideDownx,slideDowny, nil];
    group.duration = 0.5f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = NO;
    group.delegate = vc;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:group forKey:@"marioJump"];
    
}

+(NSDictionary *)getAlipayRequestDictionaryWithType:(NSString *)type AndSource:(FlightOrderDetail *)flight{

    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
        [mutDict safeSetObject:flight.OrderNo forKey:@"OrderId"];
        [mutDict safeSetObject:flight.OrderCode forKey:@"OrderCode"];
        [mutDict safeSetObject:[NSString stringWithFormat:@"%f",flight.PriceInfo.OrderPrice] forKey:@"TotalPrice"];
    if ([type isEqualToString:@"Client"]) {
        [mutDict safeSetObject:@"elongIPhone://" forKey:@"ReturnUrl"];
        [mutDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PayMethod"];
        NSString *guid = [NSString stringWithFormat:@"zsafe-%@",flight.OrderNo];
        [mutDict safeSetObject:guid forKey:@"Guid"];
    }else if([type isEqualToString:@"wap"]){
        [mutDict safeSetObject:@"elongIPhone://wappay/" forKey:@"ReturnUrl"];
        [mutDict safeSetObject:[NSNumber numberWithInt:2] forKey:@"PayMethod"];
        NSString *guid = [NSString stringWithFormat:@"zwap-%@",flight.OrderNo];
        [mutDict safeSetObject:guid forKey:@"Guid"];
    }
    return [mutDict autorelease];
}


@end
