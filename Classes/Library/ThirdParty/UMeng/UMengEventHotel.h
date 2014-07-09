//
//  UMengEventHotel.h
//  ElongClient
//
//  Created by Dawn on 14-3-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#ifndef ElongClient_UMengEventHotel_h
#define ElongClient_UMengEventHotel_h

/* 酒店模块(UEvent_Hotel_) */
// 搜索页(UEvent_Hotel_Search_)
#define UEvent_Hotel_Search_SearchAround                    @"UEvent_Hotel_Search_SearchAround"                     // 酒店-搜索页-查找附近酒店
#define UEvent_Hotel_Search_CityChoice                      @"UEvent_Hotel_Search_CityChoice"                       // 酒店-搜索页-点击城市选项
#define UEvent_Hotel_Search_DateChoice                      @"UEvent_Hotel_Search_DateChoice"                       // 酒店-搜索页-选择日期
#define UEvent_Hotel_Search_Keyword                         @"UEvent_Hotel_Search_Keyword"                          // 酒店-搜索页-选择酒店关键词
#define UEvent_Hotel_Search_Guarantee                       @"UEvent_Hotel_Search_Guarantee"                        // 酒店-搜索页-点击艺龙消费者保障计划
#define UEvent_Hotel_Search_FavList                         @"UEvent_Hotel_Search_FavList"                          // 酒店-搜索页-点击我的收藏
#define UEvent_Hotel_Search_Search                          @"UEvent_Hotel_Search_Search"                           // 酒店-搜索页-点击搜索
// 酒店列表页(UEvent_Hotel_List_)
#define UEvent_Hotel_List_FavList                           @"UEvent_Hotel_List_FavList"                            // 酒店-列表页-点击我的收藏
#define UEvent_Hotel_List_Keyword                           @"UEvent_Hotel_List_Keyword"                            // 酒店-列表页-关键词搜索
#define UEvent_Hotel_List_LastMinute                        @"UEvent_Hotel_List_LastMinute"                         // 酒店-列表页-今日特价
#define UEvent_Hotel_List_SortEnter                         @"UEvent_Hotel_List_SortEnter"                          // 酒店-列表页-点击排序
#define UEvent_Hotel_List_FilterEnter                       @"UEvent_Hotel_List_FilterEnter"                        // 酒店-列表页-点击筛选
#define UEvent_Hotel_List_MapEnter                          @"UEvent_Hotel_List_MapEnter"                           // 酒店-列表页-点击地图
#define UEvent_Hotel_List_FilterAction                      @"UEvent_Hotel_List_FilterAction"                       // 酒店-列表页-筛选页面点击确定
#define UEvent_Hotel_List_FilterReset                       @"UEvent_Hotel_List_FilterReset"                        // 酒店-列表页-筛选页面点击重置
#define UEvent_Hotel_List_SortNearby                        @"UEvent_Hotel_List_SortNearby"                         // 酒店-列表页-排序页面点击离我最近
#define UEvent_Hotel_List_SortPriceLow2High                 @"UEvent_Hotel_List_SortPriceLow2High"                  // 酒店-列表页-排序页面点击价格从低到高
#define UEvent_Hotel_List_SortPriceHigh2Low                 @"UEvent_Hotel_List_SortPriceHigh2Low"                  // 酒店-列表页-排序页面点击价格从高到低
#define UEvent_Hotel_List_SortStarLow2High                  @"UEvent_Hotel_List_SortStarLow2High"                   // 酒店-列表页-排序页面点击星级从低到高
#define UEvent_Hotel_List_SortStarHigh2Low                  @"UEvent_Hotel_List_SortStarHigh2Low"                   // 酒店-列表页-排序页面点击星级从高到低
#define UEvent_Hotel_List_DetailEnter                       @"UEvent_Hotel_List_DetailEnter"                        // 酒店-列表页-进入酒店详情
// 酒店列表地图模式(UEvent_Hotel_ListMap_)
#define UEvent_Hotel_ListMap_Keyword                        @"UEvent_Hotel_ListMap_Keyword"                         // 酒店-列表地图-关键词搜索
#define UEvent_Hotel_ListMap_More                           @"UEvent_Hotel_ListMap_More"                            // 酒店-列表地图-点击显示更多
#define UEvent_Hotel_ListMap_LongPress                      @"UEvent_Hotel_ListMap_LongPress"                       // 酒店-列表地图-长按选择位置搜索
#define UEvent_Hotel_ListMap_Position                       @"UEvent_Hotel_ListMap_Position"                        // 酒店-列表地图-点击当前位置
#define UEvent_Hotel_ListMap_Destination                    @"UEvent_Hotel_ListMap_Destination"                     // 酒店-列表地图-点击目的地
#define UEvent_Hotel_ListMap_DetailEnter                    @"UEvent_Hotel_ListMap_DetailEnter"                     // 酒店-列表地图-进入酒店详情
// 酒店详情页(UEvent_Hotel_Detail_)
#define UEvent_Hotel_Detail_HotelInfo                       @"UEvent_Hotel_Detail_HotelInfo"                        // 酒店-酒店详情-点击酒店介绍
#define UEvent_Hotel_Detail_Fav                             @"UEvent_Hotel_Detail_Fav"                              // 酒店-酒店详情-点击收藏
#define UEvent_Hotel_Detail_Phone                           @"UEvent_Hotel_Detail_Phone"                            // 酒店-酒店详情-点击右上角电话按钮
#define UEvent_Hotel_Detail_HotelInfoPhone                  @"UEvent_Hotel_Detail_HotelInfoPhone"                   // 酒店-酒店详情-点击酒店介绍内的电话按钮
#define UEvent_Hotel_Detail_Comment                         @"UEvent_Hotel_Detail_Comment"                          // 酒店-酒店详情-点击评论
#define UEvent_Hotel_Detail_CommentGood                     @"UEvent_Hotel_Detail_CommentGood"                      // 酒店-酒店详情-点击好评
#define UEvent_Hotel_Detail_CommentBad                      @"UEvent_Hotel_Detail_CommentBad"                       // 酒店-酒店详情-点击差评
#define UEvent_Hotel_Detail_Map                             @"UEvent_Hotel_Detail_Map"                              // 酒店-酒店详情-点击酒店地图
#define UEvent_Hotel_Detail_MapBank                         @"UEvent_Hotel_Detail_MapBank"                          // 酒店-酒店详情-地图点击银行
#define UEvent_Hotel_Detail_MapScenery                      @"UEvent_Hotel_Detail_MapScenery"                       // 酒店-酒店详情-地图点击景点
#define UEvent_Hotel_Detail_MapFood                         @"UEvent_Hotel_Detail_MapFood"                          // 酒店-酒店详情-地图点击美食
#define UEvent_Hotel_Detail_MapShopping                     @"UEvent_Hotel_Detail_MapShopping"                      // 酒店-酒店详情-地图点击购物
#define UEvent_Hotel_Detail_MapEntertainment                @"UEvent_Hotel_Detail_MapEntertainment"                 // 酒店-酒店详情-地图点击娱乐
#define UEvent_Hotel_Detail_MapDrive                        @"UEvent_Hotel_Detail_MapDrive"                         // 酒店-酒店详情-地图点击驾车
#define UEvent_Hotel_Detail_MapWalk                         @"UEvent_Hotel_Detail_MapWalk"                          // 酒店-酒店详情-地图点击步行
#define UEvent_Hotel_Detail_Date                            @"UEvent_Hotel_Detail_Date"                             // 酒店-酒店详情-点击修改日期
#define UEvent_Hotel_Detail_RoomDetail                      @"UEvent_Hotel_Detail_RoomDetail"                       // 酒店-酒店详情-点击房型具体信息
#define UEvent_Hotel_Detail_Share                           @"UEvent_Hotel_Detail_Share"                            // 酒店-酒店详情-点击分享
#define UEvent_Hotel_Detail_RoomBooking                     @"UEvent_Hotel_Detail_RoomBooking"                      // 酒店-酒店详情-点击房型具体信息中的预订按钮
#define UEvent_Hotel_Detail_Booking                         @"UEvent_Hotel_Detail_Booking"                          // 酒店-酒店详情-点击酒店详情页的预订按钮
#define UEvent_Hotel_Detail_Photo                           @"UEvent_Hotel_Detail_Photo"                            // 酒店-酒店详情-点击酒店图片按钮
// 酒店图片页面(UEvent_Hotel_Photo_)
#define UEvent_Hotel_Photo_Streetscape                      @"UEvent_Hotel_Photo_Streetscape"                       // 酒店-酒店图片-点击街景
// 酒店地图页面(UEvent_Hotel_Map_)
#define UEvent_Hotel_Map_Streetscape                        @"UEvent_Hotel_Map_Streetscape"                         // 酒店-酒店地图-点击街景
// 酒店预订过程中登录页面(UEvent_Hotel_Login_)
#define UEvent_Hotel_Login_Login                            @"UEvent_Hotel_Login_Login"                             // 酒店-用户登录-点击正常登录
#define UEvent_Hotel_Login_Register                         @"UEvent_Hotel_Login_Register"                          // 酒店-用户登录-点击免费注册
#define UEvent_Hotel_Login_ForgetPwd                        @"UEvent_Hotel_Login_ForgetPwd"                         // 酒店-用户登录-点击找回密码
#define UEvent_Hotel_Login_Nomember                         @"UEvent_Hotel_Login_Nomember"                          // 酒店-用户登录-点击非会员预订
#define UEvent_Hotel_Login_Weixin                           @"UEvent_Hotel_Login_Weixin"                            // 酒店-用户登录-点击合作账号登录
// 订单填写页(UEvent_Hotel_FillOrder_)
#define UEvent_Hotel_FillOrder_RoomNum                      @"UEvent_Hotel_FillOrder_RoomNum"                       // 酒店-订单填写-选择房间数量
#define UEvent_Hotel_FillOrder_RoomerEdit                   @"UEvent_Hotel_FillOrder_RoomerEdit"                    // 酒店-订单填写-输入入住人
#define UEvent_Hotel_FillOrder_RoomerSelect                 @"UEvent_Hotel_FillOrder_RoomerSelect"                  // 酒店-订单填写-选择常用入住人
#define UEvent_Hotel_FillOrder_RoomerSelectAction           @"UEvent_Hotel_FillOrder_RoomerSelectAction"            // 酒店-订单填写-选择常用入住人确定
#define UEvent_Hotel_FillOrder_RoomerAdd                    @"UEvent_Hotel_FillOrder_RoomerAdd"                     // 酒店-订单填写-在选择入住人页面点击新增常用入住人
#define UEvent_Hotel_FillOrder_AddressBook                  @"UEvent_Hotel_FillOrder_AddressBook"                   // 酒店-订单填写-点击调用系统通讯录
#define UEvent_Hotel_FillOrder_NeedInvoice                  @"UEvent_Hotel_FillOrder_NeedInvoice"                   // 酒店-订单填写-点击需要发票
#define UEvent_Hotel_FillOrder_CancelCoupon                 @"UEvent_Hotel_FillOrder_CancelCoupon"                  // 酒店-订单填写-点击取消使用消费券返现
#define UEvent_Hotel_FillOrder_BackRule                     @"UEvent_Hotel_FillOrder_BackRule"                      // 酒店-订单填写-点击返现规则
#define UEvent_Hotel_FillOrder_PrepayRule                   @"UEvent_Hotel_FillOrder_PrepayRule"                    // 酒店-订单填写-点击预付规则
#define UEvent_Hotel_FillOrder_GuaranteeRule                @"UEvent_Hotel_FillOrder_GuaranteeRule"                 // 酒店-订单填写-点击担保规则
#define UEvent_Hotel_FillOrder_GuaranteeCreditCard          @"UEvent_Hotel_FillOrder_GuaranteeCreditCard"           // 酒店-订单填写-信用卡担保
#define UEvent_Hotel_FillOrder_GuaranteeWeixin              @"UEvent_Hotel_FillOrder_GuaranteeWeixin"               // 酒店-订单填写-微信担保
#define UEvent_Hotel_FillOrder_GuaranteeAlipayApp           @"UEvent_Hotel_FillOrder_GuaranteeAlipayApp"            // 酒店-订单填写-支付宝客户端担保
#define UEvent_Hotel_FillOrder_GuaranteeAlipayWap           @"UEvent_Hotel_FillOrder_GuaranteeAlipayWap"            // 酒店-订单填写-支付宝Wap担保
#define UEvent_Hotel_FillOrder_PrepayCreditCard             @"UEvent_Hotel_FillOrder_PrepayCreditCard"              // 酒店-订单填写-信用卡预付
#define UEvent_Hotel_FillOrder_PrepayWeixin                 @"UEvent_Hotel_FillOrder_PrepayWeixin"                  // 酒店-订单填写-微信预付
#define UEvent_Hotel_FillOrder_PrepayAlipayApp              @"UEvent_Hotel_FillOrder_PrepayAlipayApp"               // 酒店-订单填写-支付宝客户端担保
#define UEvent_Hotel_FillOrder_PrepayAlipayWap              @"UEvent_Hotel_FillOrder_PrepayAlipayWap"               // 酒店-订单填写-支付宝Wap担保
// 信用卡模块(UEvent_Hotel_CreditCard_)
#define UEvent_Hotel_CreditCard_GuaranteeRule               @"UEvent_Hotel_CreditCard_GuaranteeRule"                // 酒店-信用卡-点击担保说明
#define UEvent_Hotel_CreditCard_Outdate                     @"UEvent_Hotel_CreditCard_Outdate"                      // 酒店-信用卡-点击编辑过期信用卡
#define UEvent_Hotel_CreditCard_Other                       @"UEvent_Hotel_CreditCard_Other"                        // 酒店-信用卡-点击使用其他信用卡
#define UEvent_Hotel_CreditCard_SaveNew                     @"UEvent_Hotel_CreditCard_SaveNew"                      // 酒店-信用卡-新增信用卡页面点击保存
#define UEvent_Hotel_CreditCard_UseCA                       @"UEvent_Hotel_CreditCard_UseCA"                        // 酒店-信用卡-使用CA
#define UEvent_Hotel_CreditCard_ResetCA                     @"UEvent_Hotel_CreditCard_ResetCA"                      // 酒店-信用卡-重置CA密码
// 订单成功页(UEvent_Hotel_OrderSuccess_)
#define UEvent_Hotel_OrderSuccess_BackRule                  @"UEvent_Hotel_OrderSuccess_BackRule"                   // 酒店-订单成功页-点击返现规则
#define UEvent_Hotel_OrderSuccess_Orders                    @"UEvent_Hotel_OrderSuccess_Orders"                     // 酒店-订单成功页-点击查看订单
#define UEvent_Hotel_OrderSuccess_GoHotel                   @"UEvent_Hotel_OrderSuccess_GoHotel"                    // 酒店-订单成功页-点击带我去酒店
#define UEvent_Hotel_OrderSuccess_Passbook                  @"UEvent_Hotel_OrderSuccess_Passbook"                   // 酒店-订单成功页-点击添加passbook
#define UEvent_Hotel_OrderSuccess_Share                     @"UEvent_Hotel_OrderSuccess_Share"                      // 酒店-订单成功页-点击分享
#define UEvent_Hotel_OrderSuccess_Guarantee                 @"UEvent_Hotel_OrderSuccess_Guarantee"                  // 酒店-订单成功页-来自担保
#define UEvent_Hotel_OrderSuccess_Prepay                    @"UEvent_Hotel_OrderSuccess_Prepay"                     // 酒店-订单成功页-来自预付
// 订单处理日志(UEvent_Hotel_OrderLog_)
#define UEvent_Hotel_OrderLog_Agree                         @"UEvent_Hotel_OrderLog_Agree"                          // 酒店-订单处理日志-同意安排
#define UEvent_Hotel_OrderLog_Feedback                      @"UEvent_Hotel_OrderLog_Feedback"                       // 酒店-订单处理日志-意见反馈

#endif
