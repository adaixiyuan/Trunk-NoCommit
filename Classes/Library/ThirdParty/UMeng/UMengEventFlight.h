//
//  UMengEventFlight.h
//  ElongClient
//
//  Created by Dawn on 14-3-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#ifndef ElongClient_UMengEventFlight_h
#define ElongClient_UMengEventFlight_h

/* 机票模块(UEvent_Flight_) */
// 机票查询页(UEvent_Flight_Search_)
#define UEvent_Flight_Search_DepartureCityChoice            @"UEvent_Flight_Search_DepartureCityChoice"             // 机票-搜索页-选择出发城市
#define UEvent_Flight_Search_ArrivalCityChoice              @"UEvent_Flight_Search_ArrivalCityChoice"               // 机票-搜索页-选择到达城市
#define UEvent_Flight_Search_SwitchCity                     @"UEvent_Flight_Search_SwitchCity"                      // 机票-搜索页-切换城市
#define UEvent_Flight_Search_DepartureDateChoice            @"UEvent_Flight_Search_DepartureDateChoice"             // 机票-搜索页-选择出发日期
#define UEvent_Flight_Search_BackDateChoice                 @"UEvent_Flight_Search_BackDateChoice"                  // 机票-搜索页-选择返程日期
#define UEvent_Flight_Search_SpaceChoice                    @"UEvent_Flight_Search_SpaceChoice"                     // 机票-搜索页-选择舱位
#define UEvent_Flight_Search_RoundTrip                      @"UEvent_Flight_Search_RoundTrip"                       // 机票-搜索页-点击往返
#define UEvent_Flight_Search_Search                         @"UEvent_Flight_Search_Search"                          // 机票-搜索页-点击查询
// 机票列表页面(UEvent_Flight_List_)
#define UEvent_Flight_List_BeforeDay                        @"UEvent_Flight_List_BeforeDay"                         // 机票-列表页-点击前一天
#define UEvent_Flight_List_AfterDay                         @"UEvent_Flight_List_AfterDay"                          // 机票-列表页-点击后一天
#define UEvent_Flight_List_SortTime                         @"UEvent_Flight_List_SortTime"                          // 机票-列表页-点击事件排序
#define UEvent_Flight_List_SortPrice                        @"UEvent_Flight_List_SortPrice"                         // 机票-列表页-点击价格排序
#define UEvent_Flight_List_FilterAction                     @"UEvent_Flight_List_FilterAction"                      // 机票-列表页-筛选确认
#define UEvent_Flight_List_FilterReset                      @"UEvent_Flight_List_FilterReset"                       // 机票-列表页-筛选重置
#define UEvent_Flight_List_DetailEnter                      @"UEvent_Flight_List_DetailEnter"                       // 机票-列表页-点击某个具体航班
// 航班详情页(UEvent_Flight_Detail_)
#define UEvent_Flight_Detail_Rule                           @"UEvent_Flight_Detail_Rule"                            // 机票-详情页-点击退改签规定
#define UEvent_Flight_Detail_RuleBooking                    @"UEvent_Flight_Detail_RuleBooking"                     // 机票-详情页-退改签规则点击预订
#define UEvent_Flight_Detail_Booking                        @"UEvent_Flight_Detail_Booking"                         // 机票-详情页-点击预订
// 机票预订过程中登录页面(UEvent_Flight_Login_)
#define UEvent_Flight_Login_Login                           @"UEvent_Flight_Login_Login"                            // 机票-用户登录-点击正常登录
#define UEvent_Flight_Login_Register                        @"UEvent_Flight_Login_Register"                         // 机票-用户登录-点击免费注册
#define UEvent_Flight_Login_ForgetPwd                       @"UEvent_Flight_Login_ForgetPwd"                        // 机票-用户登录-点击找回密码
#define UEvent_Flight_Login_Nomember                        @"UEvent_Flight_Login_Nomember"                         // 机票-用户登录-点击非会员预订
#define UEvent_Flight_Login_Weixin                          @"UEvent_Flight_Login_Weixin"                           // 机票-用户登录-点击合作账号登录
// 机票订单填写页(UEvent_Flight_FillOrder_)
#define UEvent_Flight_FillOrder_PersonSelect                @"UEvent_Flight_FillOrder_PersonSelect"                 // 机票-订单填写-添加乘机人
#define UEvent_Flight_FillOrder_PersonAdd                   @"UEvent_Flight_FillOrder_PersonAdd"                    // 机票-订单填写-新增乘机人
#define UEvent_Flight_FillOrder_PersonEdit                  @"UEvent_Flight_FillOrder_PersonEdit"                   // 机票-订单填写-编辑乘机人
#define UEvent_Flight_FillOrder_PersonSelectAction          @"UEvent_Flight_FillOrder_PersonSelectAction"           // 机票-订单填写-选择乘机人确定
#define UEvent_Flight_FillOrder_AddressBook                 @"UEvent_Flight_FillOrder_AddressBook"                  // 机票-订单填写-点击调用通讯录
#define UEvent_Flight_FillOrder_NeedInvoice                 @"UEvent_Flight_FillOrder_NeedInvoice"                  // 机票-订单填写-点击需要发票
#define UEvent_Flight_FillOrder_InsuranceTips               @"UEvent_Flight_FillOrder_InsuranceTips"                // 机票-订单填写-保险说明
#define UEvent_Flight_FillOrder_PriceDetail                 @"UEvent_Flight_FillOrder_PriceDetail"                  // 机票-订单填写-价格详情
#define UEvent_Flight_FillOrder_Pay                         @"UEvent_Flight_FillOrder_Pay"                          // 机票-订单填写-支付
// 机票订单确认页(UEvent_Flight_Confirm_)
#define UEvent_Flight_Confirm_Pay                           @"UEvent_Flight_Confirm_Pay"                            // 机票-订单确认-支付
// 机票支付方式选择(UEvent_Flight_Paytype_)
#define UEvent_Flight_Paytype_PrepayCreditCard              @"UEvent_Flight_Paytype_PrepayCreditCard"               // 机票-支付方式选择-信用卡支付
#define UEvent_Flight_Paytype_PrepayDepositCard             @"UEvent_Flight_Paytype_PrepayDepositCard"              // 机票-支付方式选择-储蓄卡支付
#define UEvent_Flight_Paytype_PrepayAlipayApp               @"UEvent_Flight_Paytype_PrepayAlipayApp"                // 机票-支付方式选择-支付宝客户端支付
#define UEvent_Flight_Paytype_PrepayAlipayWap               @"UEvent_Flight_Paytype_PrepayAlipayWap"                // 机票-支付方式选择-支付宝Wap支付
#define UEvent_Flight_Paytype_UseCA                         @"UEvent_Flight_Paytype_UseCA"                          // 机票-支付方式选择-使用CA
#define UEvent_Flight_Paytype_ResetCA                       @"UEvent_Flight_Paytype_ResetCA"                        // 机票-支付方式选择-重置CA密码
// 机票订单成功(UEvent_Flight_OrderSuccess)
#define UEvent_Flight_OrderSuccess                          @"UEvent_Flight_OrderSuccess"                           // 机票-机票订单支付成功
#define UEvent_Flight_OrderSuccess_Orders                   @"UEvent_Flight_OrderSuccess_Orders"                    // 机票-订单成功页-查看订单
#define UEvent_Flight_OrderSuccess_Share                    @"UEvent_Flight_OrderSuccess_Share"                     // 机票-订单成功页-分享


#endif
