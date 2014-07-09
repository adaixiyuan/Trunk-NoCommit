//
//  UMengEventUserCenter.h
//  ElongClient
//
//  Created by Dawn on 14-3-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#ifndef ElongClient_UMengEventUserCenter_h
#define ElongClient_UMengEventUserCenter_h

/* 个人中心(UEvent_UserCenter_) */
// 个人中心登录(UEvent_UserCenter_Login_)
#define UEvent_UserCenter_Login_Login                       @"UEvent_UserCenter_Login_Login"                        // 个人中心-用户登录-点击正常登录
#define UEvent_UserCenter_Login_Register                    @"UEvent_UserCenter_Login_Register"                     // 个人中心-用户登录-点击免费注册
#define UEvent_UserCenter_Login_ForgetPwd                   @"UEvent_UserCenter_Login_ForgetPwd"                    // 个人中心-用户登录-点击找回密码
#define UEvent_UserCenter_Login_Nomember                    @"UEvent_UserCenter_Login_Nomember"                     // 个人中心-用户登录-点击非会员预订
#define UEvent_UserCenter_Login_Weixin                      @"UEvent_UserCenter_Login_Weixin"                       // 个人中心-用户登录-点击合作账号登录
// 个人中心首页(UEvent_UserCenter_Home_)
#define UEvent_UserCenter_Home_Setting                      @"UEvent_UserCenter_Home_Setting"                       // 个人中心-首页-点击设置
#define UEvent_UserCenter_Home_UserInfo                     @"UEvent_UserCenter_Home_UserInfo"                      // 个人中心-首页-点击会员编辑
#define UEvent_UserCenter_Home_VIP                          @"UEvent_UserCenter_Home_VIP"                           // 个人中心-首页-点击龙萃礼遇
#define UEvent_UserCenter_Home_Coupon                       @"UEvent_UserCenter_Home_Coupon"                        // 个人中心-首页-点击查看消费券
#define UEvent_UserCenter_Home_CA                           @"UEvent_UserCenter_Home_CA"                            // 个人中心-首页-点击现金账户
#define UEvent_UserCenter_Home_InnerHotelOrders             @"UEvent_UserCenter_Home_InnerHotelOrders"              // 个人中心-首页-点击国内酒店订单
#define UEvent_UserCenter_Home_InternationalHotelOrders     @"UEvent_UserCenter_Home_InternationalHotelOrders"      // 个人中心-首页-点击国际酒店订单
#define UEvent_UserCenter_Home_GrouponOrders                @"UEvent_UserCenter_Home_GrouponOrders"                 // 个人中心-首页-点击团购订单
#define UEvent_UserCenter_Home_FlightOrders                 @"UEvent_UserCenter_Home_FlightOrders"                  // 个人中心-首页-点击机票订单
#define UEvent_UserCenter_Home_TrainOrders                  @"UEvent_UserCenter_Home_TrainOrders"                   // 个人中心-首页-点击火车票订单
#define UEvent_UserCenter_Home_CarOrders                    @"UEvent_UserCenter_Home_CarOrders"                     // 个人中心-首页-点击打车订单
#define UEvent_UserCenter_Home_RentOrders                   @"UEvent_UserCenter_Home_RentOrders"                    // 个人中心-首页-点击租车订单
#define UEvent_UserCenter_Home_CommonInfo                   @"UEvent_UserCenter_Home_CommonInfo"                    // 个人中心-首页-点击常用信息设置
#define UEvent_UserCenter_Home_Passengers                   @"UEvent_UserCenter_Home_Passengers"                    // 个人中心-首页-点击常旅客信息
#define UEvent_UserCenter_Home_PassengerEdit                @"UEvent_UserCenter_Home_PassengerEdit"                 // 个人中心-首页-编辑常用旅客信息
#define UEvent_UserCenter_Home_PassengerAdd                 @"UEvent_UserCenter_Home_PassengerAdd"                  // 个人中心-首页-添加常用旅客信息
#define UEvent_UserCenter_Home_CreditCards                  @"UEvent_UserCenter_Home_CreditCards"                   // 个人中心-首页-点击常信用卡信息
#define UEvent_UserCenter_Home_CreditCardEdit               @"UEvent_UserCenter_Home_CreditCardEdit"                // 个人中心-首页-编辑常信用卡信息
#define UEvent_UserCenter_Home_CreditCardAdd                @"UEvent_UserCenter_Home_CreditCardAdd"                 // 个人中心-首页-添加常信用卡信息
#define UEvent_UserCenter_Home_Addresses                    @"UEvent_UserCenter_Home_Addresses"                     // 个人中心-首页-点击常地址信息
#define UEvent_UserCenter_Home_AddressEdit                  @"UEvent_UserCenter_Home_AddressEdit"                   // 个人中心-首页-编辑常地址信息
#define UEvent_UserCenter_Home_AddressAdd                   @"UEvent_UserCenter_Home_AddressAdd"                    // 个人中心-首页-添加常地址信息
#define UEvent_UserCenter_Home_HotelFavList                 @"UEvent_UserCenter_Home_HotelFavList"                  // 个人中心-首页-点击收藏酒店信息
#define UEvent_UserCenter_Home_GrouponFavList               @"UEvent_UserCenter_Home_GrouponFavList"                // 个人中心-首页-点击收藏团购信息
#define UEvent_UserCenter_Home_HotelComment                 @"UEvent_UserCenter_Home_HotelComment"                  // 个人中心-首页-点击酒店点评信息
#define UEvent_UserCenter_Home_Logout                       @"UEvent_UserCenter_Home_Logout"                        // 个人中心-首页-点击注销
#define UEvent_UserCenter_Home_Messages                     @"UEvent_UserCenter_Home_Messages"                      // 个人中心-首页-点击消息
#define UEvent_UserCenter_Home_Activities                   @"UEvent_UserCenter_Home_Activities"                    // 个人中心-首页-点击活动
#define UEvent_UserCenter_Home_Feedback                     @"UEvent_UserCenter_Home_Feedback"                      // 个人中心-首页-点击反馈
// 个人中心现金账户(UEvent_UserCenter_CA_)
#define UEvent_UserCenter_CA_RemainingDetail                @"UEvent_UserCenter_CA_RemainingDetail"                 // 个人中心-现金账户-点击余额详情
#define UEvent_UserCenter_CA_Recharge                       @"UEvent_UserCenter_CA_Recharge"                        // 个人中心-现金账户-点击礼品卡充值
#define UEvent_UserCenter_CA_Cash                           @"UEvent_UserCenter_CA_Cash"                            // 个人中心-现金账户-点击提现
#define UEvent_UserCenter_CA_GiftCard                       @"UEvent_UserCenter_CA_GiftCard"                        // 个人中心-现金账户-点击礼品卡是什么
#define UEvent_UserCenter_CA_ResetPwd                       @"UEvent_UserCenter_CA_ResetPwd"                        // 个人中心-现金账户-点击充值支付密码
#define UEvent_UserCenter_CA_ResetPwdAction                 @"UEvent_UserCenter_CA_ResetPwdAction"                  // 个人中心-现金账户-礼品卡充值页面点击充值按钮
// 个人中心国际酒店订单列表(UEvent_UserCenter_InterOrder_)
#define UEvent_UserCenter_InterOrder_FilterConfirm          @"UEvent_UserCenter_InterOrder_FilterConfirm"           // 个人中心-国际酒店订单-已确认
#define UEvent_UserCenter_InterOrder_FilterCancel           @"UEvent_UserCenter_InterOrder_FilterCancel"            // 个人中心-国际酒店订单-已取消
#define UEvent_UserCenter_InterOrder_DetailEnter            @"UEvent_UserCenter_InterOrder_DetailEnter"             // 个人中心-国际酒店订单-订单详情
#define UEvent_UserCenter_InterOrder_Rebook                 @"UEvent_UserCenter_InterOrder_Rebook"                  // 个人中心-国际酒店订单-再次预订
#define UEvent_UserCenter_InterOrder_Repay                  @"UEvent_UserCenter_InterOrder_Repay"                   // 个人中心-国际酒店订单-再次支付
#define UEvent_UserCenter_InterOrder_Confirmation           @"UEvent_UserCenter_InterOrder_Confirmation"            // 个人中心-国际酒店订单-查看确认函
// 个人中心国内酒店订单列表(UEvent_UserCenter_InnerOrder_)
#define UEvent_UserCenter_InnerOrder_Edit                   @"UEvent_UserCenter_InnerOrder_Edit"                    // 个人中心-国内酒店订单-编辑
#define UEvent_UserCenter_InnerOrder_FilterProcessing       @"UEvent_UserCenter_InnerOrder_FilterProcessing"        // 个人中心-国内酒店订单-处理中
#define UEvent_UserCenter_InnerOrder_FilterConfirm          @"UEvent_UserCenter_InnerOrder_FilterConfirm"           // 个人中心-国内酒店订单-确认
#define UEvent_UserCenter_InnerOrder_FilterCheckIn          @"UEvent_UserCenter_InnerOrder_FilterCheckIn"           // 个人中心-国内酒店订单-入住
#define UEvent_UserCenter_InnerOrder_FilterCancel           @"UEvent_UserCenter_InnerOrder_FilterCancel"            // 个人中心-国内酒店订单-取消
#define UEvent_UserCenter_InnerOrder_DetailEnter            @"UEvent_UserCenter_InnerOrder_DetailEnter"             // 个人中心-国内酒店订单-点击具体订单
#define UEvent_UserCenter_InnerOrder_GoHotel                @"UEvent_UserCenter_InnerOrder_GoHotel"                 // 个人中心-国内酒店订单-带我去酒店
#define UEvent_UserCenter_InnerOrder_Feedback               @"UEvent_UserCenter_InnerOrder_Feedback"                // 个人中心-国内酒店订单-入住反馈
#define UEvent_UserCenter_InnerOrder_Rebook                 @"UEvent_UserCenter_InnerOrder_Rebook"                  // 个人中心-国内酒店订单-再次预定
#define UEvent_UserCenter_InnerOrder_Repay                  @"UEvent_UserCenter_InnerOrder_Repay"                   // 个人中心-国内酒店订单-再次支付
#define UEvent_UserCenter_InnerOrder_Share                  @"UEvent_UserCenter_InnerOrder_Share"                   // 个人中心-国内酒店订单-分享
#define UEvent_UserCenter_InnerOrder_Passbook               @"UEvent_UserCenter_InnerOrder_Passbook"                // 个人中心-国内酒店订单-Passbook
#define UEvent_UserCenter_InnerOrder_Cancel                 @"UEvent_UserCenter_InnerOrder_Cancel"                  // 个人中心-国内酒店订单-取消
// 个人中心团购订单列表(UEvent_UserCenter_GrouponOrder_)
#define UEvent_UserCenter_GrouponOrder_FilterHavepay        @"UEvent_UserCenter_GrouponOrder_FilterHavepay"         // 个人中心-团购订单-已支付
#define UEvent_UserCenter_GrouponOrder_FilterHavenotpay     @"UEvent_UserCenter_GrouponOrder_FilterHavenotpay"      // 个人中心-团购订单-未支付
#define UEvent_UserCenter_GrouponOrder_FilterCancel         @"UEvent_UserCenter_GrouponOrder_FilterCancel"          // 个人中心-团购订单-已取消
#define UEvent_UserCenter_GrouponOrder_DetailEnter          @"UEvent_UserCenter_GrouponOrder_DetailEnter"           // 个人中心-团购订单-点击进入某个具体订单
#define UEvent_UserCenter_GrouponOrder_Share                @"UEvent_UserCenter_GrouponOrder_Share"                 // 个人中心-团购订单-分享
#define UEvent_UserCenter_GrouponOrder_Passbook             @"UEvent_UserCenter_GrouponOrder_Passbook"              // 个人中心-团购订单-Passbook
#define UEvent_UserCenter_GrouponOrder_Cancel               @"UEvent_UserCenter_GrouponOrder_Cancel"                // 个人中心-团购订单-取消
#define UEvent_UserCenter_GrouponOrder_CancelDetail         @"UEvent_UserCenter_GrouponOrder_CancelDetail"          // 个人中心-团购订单-取消具体券
// 个人中心机票订单列表(UEvent_UserCenter_FlightOrder_)
#define UEvent_UserCenter_FlightOrder_DetailEnter           @"UEvent_UserCenter_FlightOrder_DetailEnter"            // 个人中心-机票订单-订单详情
// 个人中心火车票订单列表(UEvent_UserCenter_TrainOrder_)
#define UEvent_UserCenter_TrainOrder_DetailEnter            @"UEvent_UserCenter_TrainOrder_DetailEnter"             // 个人中心-火车票订单-订单详情
// 个人中心打车订单列表(UEvent_UserCenter_CarOrder_)
#define UEvent_UserCenter_CarOrder_DetailEnter              @"UEvent_UserCenter_CarOrder_DetailEnter"               // 个人中心-打车订单-订单详情
#define UEvent_UserCenter_CarOrder_CallService              @"UEvent_UserCenter_CarOrder_CallService"               // 个人中心-打车订单-呼叫供应商
#define UEvent_UserCenter_CarOrder_CallDriver               @"UEvent_UserCenter_CarOrder_CallDriver"                // 个人中心-打车订单-呼叫司机
// 个人中心设置页面(UEvent_UserCenter_Setting_)
#define UEvent_UserCenter_Setting_ClearCache                @"UEvent_UserCenter_Setting_ClearCache"                 // 个人中心-设置页面-清除缓存
#endif
