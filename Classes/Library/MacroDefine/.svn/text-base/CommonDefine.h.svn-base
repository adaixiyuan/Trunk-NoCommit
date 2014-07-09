/*
 *  CommonDefine.h
 *  ElongClient
 *
 *  Created by bin xing on 11-3-20.
 *  Copyright 2011 DP. All rights reserved.
 *
 */

#define USENEWNET       YES             // 控制是否使用新的网络框架
#define COEFFICIENT_Y   (SCREEN_4_INCH ? 1.183 : 1)     // 视图控件y轴偏移量系数
#define SCREEN_4_INCH   (SCREEN_HEIGHT == 568)     // 4寸Retina
#define SCREEN_SCALE    (1.0f/[UIScreen mainScreen].scale)

#define FONTBOLD1 [UIFont boldSystemFontOfSize:18]
#define FONT_B17 [UIFont boldSystemFontOfSize:17]
#define FONT_B16 [UIFont boldSystemFontOfSize:16]
#define FONT_B12 [UIFont boldSystemFontOfSize:12]
#define FONT_B13 [UIFont boldSystemFontOfSize:13]
#define FONT_B15 [UIFont boldSystemFontOfSize:15]
#define FONT_13 [UIFont systemFontOfSize:13]
#define FONT_16 [UIFont systemFontOfSize:16]
#define FONT_15 [UIFont systemFontOfSize:15]
#define FONT_14  [UIFont systemFontOfSize:14]
#define FONT_B14 [UIFont boldSystemFontOfSize:14]
#define FONT_12  [UIFont systemFontOfSize:12]
#define FONT_11  [UIFont systemFontOfSize:11]
#define FONT_10  [UIFont systemFontOfSize:10]
#define FONT_17  [UIFont systemFontOfSize:17]
#define FONT_18	 [UIFont systemFontOfSize:18]
#define FONT_B18 [UIFont boldSystemFontOfSize:18]
#define FONT_20  [UIFont systemFontOfSize:20]
#define FONT_B20 [UIFont boldSystemFontOfSize:20]

#define RGBCOLOR(r,g,b,a)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]    // 便利的RGB构造方法
#define COLOR_NAV_TITLE			[UIColor colorWithHexStr:@"#343434"]    // 导航栏标题颜色及导航栏按钮不可点击时的颜色
#define COLOR_GRADIENT_START	[UIColor colorWithRed:1 green:0.78 blue:0.18 alpha:1]
#define COLOR_GRADIENT_END		[UIColor colorWithRed:0.89 green:0.29 blue:0.11 alpha:1]
#define COLOR_CELL_LABEL        [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define COLOR_CELL_TITLE        [UIColor colorWithRed:93.0f/255.0f green:93.0f/255.0f blue:93.0f/255.0f alpha:1]
#define COLOR_NAV_BTN_TITLE     RGBCOLOR(210, 70, 36, 1)       //导航栏文字按钮文字颜色
#define COLOR_NAV_BIN_TITLE_H   RGBCOLOR(228, 144, 124, 1)
#define COLOR_NAV_BIN_TITLE_DISABLE RGBCOLOR(137, 137, 137, 1)

#define SCREEN_WIDTH			([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT			([[UIScreen mainScreen] bounds].size.height)
#define MAX_INFO_HEIGHT			MAINCONTENTHEIGHT - 86				// 有底部按钮时，信息页面最大高度
#define BOTTOM_BUTTON_WIDTH		280
#define BOTTOM_BUTTON_HEIGHT	46
#define HSC_CELL_HEGHT			49				// 酒店条件搜索界面cell高度
#define NAVBAR_BUTTON_WIDTH		50
#define BLACK_BANNER_HEIGHT     50
#define STATUS_BAR_HEIGHT		20
#define TABITEM_DEFALUT_HEIGHT	35
#define NAVIGATION_BAR_HEIGHT	44
#define SEGMENT_DEFAULT_HEIGHT	55
#define TABBAR_DEFALUT_HEIGHT	40
#define FOOTER_DEFALUT_HEIGHT	40
#define TWO_BUTTON_WIDTH        138             // 一行有2个按钮时，每个按钮的宽度
#define THREE_BUTTON_WIDTH      98              // 一行有3个按钮时，每个按钮的宽度
#define SHOW_WINDOWS_DEFAULT_DURATION 0.3f
#define NAVBAR_WORDBTN_WIDTH    70              // 顶栏纯文字按钮宽度
#define NAVBAR_ITEM_HEIGHT      34              // 顶栏按钮控件高度
#define NAVBAR_ITEM_WIDTH       36              // 顶栏按钮控件宽度
#define DefaultLeftEdgeSpace    12      //视图默认左边的间隔像素

#define MAINCONTENTHEIGHT	(SCREEN_HEIGHT - 20 - 44)
#define KEYBOARD_HEIGHT		216
#define EDGE_NAV_LEFTITEM   IOSVersion_7 ? UIEdgeInsetsMake(0, -12, 0, 12) : UIEdgeInsetsMake(0, -2, 0, 2)
#define EDGE_NAV_RIGHTITEM  IOSVersion_7 ? UIEdgeInsetsMake(0, 12, 0, -12) : UIEdgeInsetsMake(0, 2, 0, -2)

// 标准的顶部工具条大小
#define STANDARDTOPBARFRAME		CGRectMake(0, 0, 320, 55)

// 判断字符串是否有值
#define STRINGHASVALUE(str)		(str && [str isKindOfClass:[NSString class]] && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)

// 判断字典是否有值
#define DICTIONARYHASVALUE(dic)    (dic && [dic isKindOfClass:[NSDictionary class]] && [dic count] > 0)

// 判断数组是否有值
#define ARRAYHASVALUE(array)    (array && [array isKindOfClass:[NSArray class]] && [array count] > 0)

// 判断对象是否为null值
#define OBJECTISNULL(obj)       [obj isEqual:[NSNull null]]

// 判断字符串是否为数字
//#define STRINGISNUMBER(str)		([[NSPredicate predicateWithFormat:@"SELF MATCHES '\\\\d{1}'"] evaluateWithObject:str])
#define STRINGISNUMBER(str)		([[NSPredicate predicateWithFormat:@"SELF MATCHES '[0-9]+'"] evaluateWithObject:str])

// 判断手机号码是否正确
#define MOBILEPHONEISRIGHT(phoneStr) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '1\\\\d{10}'"] evaluateWithObject:phoneStr])

// 匹配电话号码的正则表达式
#define REGULATION_PHONE		@"((\\d{11})|(\\d{7,8})|(\\d{4}|\\d{3})-+(\\d{7,8})|(\\d{4}|\\d{3})-+(\\d{7,8}|\\d{4}|\\d{3})-+(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-+(\\d{4}|\\d{3}|\\d{2}|\\d{1}))"

// 检查字符串是否为有效的email地址
#define EMAILISRIGHT(emailStr) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$'"] evaluateWithObject:emailStr])

// 检查字符串是否为英文字符串
#define ENWORDISRIGHT(word) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^([a-zA-Z])'"] evaluateWithObject:word])

// 检查字符串是否为数字字符串
#define NUMBERISRIGHT(word) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^([0-9\\n]+)'"] evaluateWithObject:word])

// 检查字符串是否只包含英文和汉字
#define ENANDHANSRIGHT(word) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:word])

// 检查字符串是否为英文和数字组成的字符串
#define ENANDNUMISRIGHT(word) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z0-9\\\\s\\n]+$'"] evaluateWithObject:word])

// 判断系统版本是否大于x.x
#define IOSVersion_3_2			([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
#define IOSVersion_4			([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
#define IOSVersion_5			([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IOSVersion_6			([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOSVersion_61			([[[UIDevice currentDevice] systemVersion] floatValue] > 6.1)   // passbook 有问题版本
#define IOSVersion_7            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// 返回通用按钮按下效果图
#define COMMON_BUTTON_PRESSED_IMG	[UIImage stretchableImageWithPath:@"cell_bg.png"]
#define COMMON_BUTTON_PRESSED_TRANSPARENT   [UIImage stretchableImageWithPath:@"btn_pressed_ transparent.png"]

#define NUMBER(x)				[NSNumber numberWithInt:x]

#define SFRelease(obj)			[obj release]; obj = nil
//by lc
#define setFree(obj) { if (nil != (obj)) { [obj release]; obj = nil; } }

//alloc 初始化一个对象
#define newObject(obj)   [[obj alloc] init]

/** KeyWindow */
#define LC_KEYWINDOW ((UIView*)[UIApplication sharedApplication].keyWindow)

#define AppDelegateAccessor ((ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate])


#define _string(x)  NSLocalizedString(x, nil)
#define _string2int(x) [NSString stringWithFormat:@"%i",x]
#define kDefaultPageSize			0

// 常用TAG
#define kTableTag				3001
#define kArrowTag				3002
#define kCellLabelTag			3003
#define kSeparatorTag			3004
#define kRequest_More			3005
#define kDashedTag				3006
#define kBackBtnTag				3007

#define kNetTypeNativeHotel     3101
#define kNetTypeInterHotel      3102
#define kNetTypeFlight          3103
#define kNetTypeGroupon         3104
#define kNetTypeCheckPassword   3105

// 常用提示文字
#define FORMAT_FLIGHT_COUPON_TIP    @"您使用了￥%d消费券，该金额将在航班起飞后3日内预计返现至我的艺龙账户中。"
#define FORMAT_ALIPAY_TIP           @"请在30分钟内完成支付，如30分钟内还未付款成功，将取消本次预订。"

// 新api流程使用的aes加解密用的key        
#define NEW_KEY                     @"K9moRdNVAD9p1Shh"

// google账户key
#define GOOGLE_KEY                  @"AIzaSyDuaLngGYyfmGb50_iOIqwYD6Afv2HOnho"

// 常用通知名称
#define NOTI_FLIGHT_ORDER_DETAIL                @"NOTI_FLIGHT_ORDER_DETAIL"     // 机票确认页展示乘客详情
#define NOTI_TIME_ADDITION                      @"TIME_ADDITION_NOTI"
#define NOTI_TIME_PAUSE                         @"PAUSE_TIME_NOTI"
#define NOTI_KEYWORD_UPDATE                     @"KEYWORD_UPDATE_NOTI"
#define NOTI_INTERCITY_SUGGEST                  @"NOTI_INTERCITY_SUGGEST"
#define NOTI_INTERHOTEL_SUGGEST                 @"NOTI_INTERHOTEL_SUGGEST"
#define NOTI_HAD_LOGIN                          @"HAD_LOGIN_NOTI"
#define NOTI_CUSTOMKEYBOARD_DONE                @"NOTI_CUSTOMKEYBOARD_DONE"
#define NOTI_ADDFAVOR_SUCCESS                   @"NOTI_ADDFAVOR_SUCCESS"
#define NOTI_ADDGROUPONFAV_SUCCESS              @"NOTI_ADDGROUPONFAV_SUCCESS"
#define NOTI_LONGVIP                            @"NOTI_LONGVIP"
#define NOTI_CHECKBOX_CLICK                     @"NOTI_CHECKBOX_CLICK"
#define NOTI_HOTELPRICE_CHANGE                  @"NOTI_HOTELPRICE_CHANGE"
#define NOTI_CACHEFILE_MODITIME                 @"NOTI_CACHEFILE_MODITIME"
#define NOTI_HOTELCITY_TYPE                     @"NOTI_HOTELCITY_TYPE"
#define NOTI_GET_TOKEN                          @"NOTI_GET_TOKEN"
#define NOTI_CASHACCOUNT_OPEN                   @"NOTI_CASHACCOUNT_OPEN"                // 现金账户打开
#define NOTI_CASHACCOUNT_RECHARGE               @"NOTI_CASHACCOUNT_RECHARGE"            // 现金账户充值成功
#define NOTI_CASHACCOUNT_PASSERROR              @"NOTI_CASHACCOUNT_PASSERROR"           // 现金账户验密失败
#define NOTI_CASHACCOUNT_PASSCANCEL             @"NOTI_CASHACCOUNT_PASSCANCEL"          // 现金账户验密取消
#define NOTI_CASHACCOUNT_SETPASSWORDSUCCESS     @"NOTI_CASHACCOUNT_SETPASSWORDSUCCESS"  // 现金账户设置密码成功
#define NOTI_ORDER_MODIFY                       @"NOTI_ORDER_MODIFY"                    // 修改订单成功
#define NOTI_ORDER_REFRESH                      @"NOTI_ORDER_REFRESH"                   // 修改订单成功
#define NOTI_ALIPAY_SUCCESS                     @"NOTI_ALIPAY_SUCCESS"                  // 支付宝支付成功通知
#define NOTI_WAPALIPAY_SUCCESS                  @"NOTI_WAPALIPAY_SUCCESS"               // 支付宝Wap支付成功通知
#define NOTI_HOTEL_FEEDBACK                     @"NOTI_HOTEL_FEEDBACK"                  //酒店入住反馈
#define SWAPCELL_NOTIFICATION                   @"SWAPCELL_NOTIFICATION"
#define NOTI_CLOSE_CALENDAR                     @"NOTI_CLOSE_CALENDAR"                  //关闭日历
#define NOTI_SelectYear_CALENDAR                @"NOTI_SelectYear_CALENDAR"             //日历选择年
#define NOTI_WEIXIN_PAYSUCCESS                  @"NOTI_WEIXIN_PAYSUCCESS"               // 酒店微信支付成功
#define NOTI_ALIPAY_PAYSUCCESS                  @"NOTI_ALIPAY_PAYSUCCESS"               // 支付宝支付成功
#define NOTI_WEIXIN_OAUTHSUCCESS                @"NOTI_WEIXIN_OAUTHSUCCESS"             // 微信授权成功
#define NOTI_TuanOnlineAppoint                  @"NOTI_TuanOnlineAppoint"               // 团购在线预约
#define NOTI_HotelJiuCuo                        @"NOTI_HotelJiuCuo"                     // 酒店纠错
#define NOTI_HOTELSEARCH_KEYWORDCHANGE          @"NOTI_HOTELSEARCH_KEYWORDCHANGE"       // 酒店搜索关键词变更
#define NOTI_HOTELSEARCH_RESET                  @"NOTI_HOTELSEARCH_RESET"               // 酒店搜索重置搜索条件
#define NOTI_HOTELSEARCH_INTERKEYWORDCHANGE     @"NOTI_HOTELSEARCH_INTERKEYWORDCHANGE"  // 国际酒店搜索关键词变更
#define NOTI_HOTELFILTER_REGIONCHANGE           @"NOTI_HOTELFILTER_REGIONCHANGE"        // 国内酒店筛选区域改变
#define NOTI_RENTTAXI_LOGINSUCCESS              @"NOTI_RENTTAXI_LOGINSUCCESS"           // 租车登录成功回调
#define NOTI_SCENIC_LOGINSUCCESS                @"NOTI_SCENIC_LOGINSUCCESS"             // 门票登录成功回调
#define NOTI_RECEIVEREMOTENOTIFICATION          @"NOTI_RECEIVEREMOTENOTIFICATION"       // 收到推送消息

// UserDefault 格式规范：模块名_功能名
#define USERDEFAULT_DEBUG_MODULES                   @"DEBUG_MODULES"                // 记录debug模式下需要调试的模块
#define USERDEFAULT_HOTEL_SEARCHCITYNAME            @"HOTEL_SEARCHCITYNAME"         // 记录当前搜索的城市
#define USERDEFAULT_FLIGHT_DEPARTCITYNAME           @"FLIGHT_DEPARTCITYNAME"        // 记录机票搜索出发城市
#define USERDEFAULT_FLIGHT_ARRIVALCITYNAME          @"FLIGHT_ARRIVALCITYNAME"       // 记录机票搜索到达城市
#define USERDEFAULT_TRAIN_DEPARTCITYNAME            @"TRAIN_DEPARTCITYNAME"         // 记录火车票搜索出发城市
#define USERDEFAULT_TRAIN_ARRIVALCITYNAME           @"TRAIN_ARRIVALCITYNAME"        // 记录火车票搜索到达城市
#define USERDEFAULT_FLIGHTSTATUS_DEPARTCITYNAME     @"FLIGHTSTATUS_DEPARTCITYNAME"  // 记录航班动态搜索出发城市
#define USERDEFUALT_FLIGHTSTATUS_ARRIVALCITYNAME    @"FLIGHTSTATUS_ARRIVALCITYNAME" // 记录航班动态搜索到达城市
#define USERDEFUALT_HOTEL_SEARCHKEYWORD             @"HOTEL_SEARCHKEYWORD"          // 记录酒店搜索历史
#define USERDEFAULT_HOME_ADDNEWTIPS                 @"USERDEFAULT_HOME_ADDNEWTIPS_1"  // 首页new标识是否已阅 5.15：新增用车
#define USERDEFAULT_WEIXIN_OPENID                   @"WEIXIN_OPENID"                  // 微信授权码

// Keychain
#define KEYCHAIN_GUID                           @"GUID"         // 替代UDID
#define USERDEFAULT_KEYCHAIN_GUID               @"ELONG_GUID"   // 存入userdefault
#define KEYCHAIN_ACCOUNT                        @"Account"      // 用户名
#define KEYCHAIN_PASSWORD                       @"Password"     // 密码



#define USERDEFAULT_TAXI_PERSON @"taxicontectPerson"
#define USERDEFAULT_TAXI_TEL @"taxicontectTel"
// =======================================================================================================
// 公用请求字段
#define AMOUNT                      @"Amount"
#define ALLPAGECOUNT				@"AllPageCount"
#define ADDRESS_ADD_NOTIFICATION	@"Address_Add"
#define ARRIVE_DATE					@"ArriveDate"
#define APP_VALUE                   @"AppValue"
#define BIZSECTIONID_REQ			@"BizSectionID"
#define	CURPAGEINDEX				@"CurPageIndex"
#define CACHE_VERSION               @"Version"
#define CARD_NUMBER					@"CardNo"
#define CREATETIME					@"CreateTime"
#define CREDITCARD					@"CreditCard"
#define CREDITCARD_NUMBER			@"CreditCardNumber"
#define CREDITCARD_TYPE				@"CreditCardType"
#define CLICK_NOTIFICATION			@"Click"
#define CONTENT_REQ					@"Content"
#define CURRENCY					@"Currency"
#define COUPON                      @"Coupon"
#define CASHAMOUNT                  @"CashAmount"
#define CUSTOMERS                   @"Customers"
#define LOCATION_NAME               @"LocationName"
#define DISTINCTID_REQ				@"DistinctID"
#define EMAIL						@"Email"
#define END_TIME					@"EndTime"
#define HEADER                      @"Header"
#define HOTELID_REQ					@"HotelId"
#define HOLDER_NAME					@"HolderName"
#define HOTEL_STATE_CODE			@"HotelStateCode"
#define HOTEL_STATE_NAME			@"HotelStateName"
#define HOTEL_CITY_NAME				@"HotelCityName"
#define HOTEL_ORDER_CREATE_TIME		@"HotelOrderCreateTime"
#define ISSUCCESS					@"IsSuccess"
#define ISNEEDADDINFO_REQ			@"IsNeedAddinfo"
#define ISNOTNEEDCHECK_REQ			@"IsNotNeedCheck"
#define IMAGE_SIZE_TYPE             @"ImageSizeType"
#define IMAGE_TYPE                  @"ImageType"
#define LASTMINUTE_HOTEL_CNT		@"LastMinuteHotelCnt"
#define LEAVE_DATE					@"LeaveDate"
#define LBS_HOTEL_CNT				@"LbsHotelCnt"
#define MAP_SEARCH_RADIUS			@"MAP_SEARCH_RADIUS"
#define MEMBERID_REQ				@"MemberId"
#define MEMBERNAME_REQ				@"MemberName"
#define MOBILE						@"Mobile"
#define MINPRICE_REQ				@"MinPrice"
#define MAXPRICE_REQ				@"MaxPrice"
#define NEWSTAR_CODE				@"NewStarCode"
#define ORDERS						@"Orders"
#define k_orders                    @"orders"
#define ORDER_IDS					@"OrderIDs"
#define ORDERNO_REQ					@"OrderNo"
#define ORDERSTATUSINFOS			@"OrderStatusInfos"
#define PAGE_SIZE_					@"PageSize"
#define PAGE_INDEX					@"PageIndex"
#define PAYSTATUS					@"PayStatus"
#define PAYTYPE						@"PayType"
#define RECOMMENDTYPE_REQ			@"RecommendType"
#define SEARCH_TYPE					@"SearchType"
#define	SORTBY						@"SortBy"
#define SORTDIRECTION				@"SortDirection"
#define SORTTYPE_REQ				@"SortType"
#define STATE_CODE					@"StateCode"
#define CLIENTSTATUSDESC        @"ClientStatusDesc"
#define START_TIME					@"StartTime"
#define STARCODE_REQ				@"StarCode"
#define STATUS						@"Status"
#define STATENAME					@"StateName"
#define TOTALCOUNT					@"TotalCount"
#define USER_NAME					@"UserName"
#define ZOOMSCALE_NOTIFICATION		@"Zoom_Scroll"
#define GrouponPass                 @"GrouponCard"
#define HotelPass                   @"HotelCard"
#define Html_Hotel_Switch           @"HotelHtml5AliPaySwitch"
#define Html_Flight_Switch          @"FlightHtmlHtml5AliPaySwitch"
#define Html_Groupon_Switch         @"GroupOnHtml5AliPaySwitch"
#define IFLY_VoiceSearch            @"voiceSearch"
#define HTTPSORHTTP                 @"IosHttps"
#define SHOWC2CINHOTELSEARCH        @"showC2CInHotelSearch"
#define SHOWC2CORDER                @"showC2COrder"
#define Cache_Local_Switch          @"cacheLocalSwitch"
#define SERVERURL                   @"SERVERURL"
#define MONKEY_SWITCH               @"MONKEY_SWITCH"
#define HTTPS_SWITCH                @"HTTPS_SWITCH"
#define History_Cities              @"historycities"
#define U_R_L                       @"Url"

// 订单填写时缓存用户信息字段
#define NONMEMBER_PHONE                 @"nonmember_phone"
#define NONMEMBER_EMAIL                 @"nonmember_email"
#define NONMEMBER_CREDITCARD            @"nonmember_creditcard"
#define NONMEMBER_POSTADDRESS           @"nonmember_postaddress"
#define NONMEMBER_CHECKINPEPEOS         @"nonmember_checkinpepeos"
#define NONMEMBER_CHECKINTIME           @"nonmenber_checkintime"
#define NONMEMBER_HOTEL_ORDERS          @"nonmember_hotel_orders"
#define NONMEMBER_FLIGHT_ORDERS         @"nonmember_flight_orders"
#define NONMEMBER_GROUPON_ORDERS        @"nonmember_groupon_orders"
#define NONMEMBER_TRAIN_ORDERS          @"NONMEMBER_TRAIN_ORDERS"
#define NONMEMBER_ROOMNUM               @"nonmenber_roomnum"
#define HIDE_ORDER_LIST                 @"hide_order_list"
#define RECORD_TRAIN_PASSAGERS          @"RECORD_TRAIN_PASSAGERS"
#define RECORD_TRAIN_PASSAGERS_COUNT    @"RECORD_TRAIN_PASSAGERS_COUNT"
#define RECORD_TRAIN_RECORDTIME         @"RECORD_TRAIN_RECORDTIME"

// 国际酒店入住人信息缓存
#define INTERHOTEL_ROOMERS          @"InterHotel_roomers"
#define INTERHOTEL_ROOMER_TIME      @"InterHotel_roomer_time"

// 回传字段
#define BIZSECTIONID_RESP			@"BizSectionID"
#define BIZSECTIONLIST_RESP			@"BizSectionList"
#define BIZSECTIONNAME_RESP			@"BizSectionName"
#define	DISTRICTLIST_RESP			@"DistrictList"
#define DISTRICTID_RESP				@"DistrictID"
#define DISTRICTNAME_RESP			@"DistrictName"
#define HOTELDETAILINFOS_RESP		@"HotelDetailInfos"
#define STAR_RESP					@"Star"
#define SHOWTIME					@"ShowTime"
#define SUMPRICE					@"SumPrice"
#define NAME_RESP					@"Name"
#define IDTYPEENUM                  @"idTypeEnum"
#define IDTYPENAME                  @"IdTypeName"
#define IDNUMBER                    @"IdNumber"
#define IDTYPE                      @"IdType"
#define NEEDVOUCH					@"NeedVouch"
#define PRIORITY_SEARCH_HOTEL		@"priority search hotel"			// 优先搜索酒店名
#define PNRS_RESP					@"PNRs"
#define VOUCHSETOPTION				@"VouchSetOption"
#define	IS_VOER_DUE					@"IsOverdue"

#define GROUPONSEARCHHISTORIES      @"GrouponSearchKeywordArray"
#define IMAGE_PATH                  @"ImagePath"

// =======================================================================================================
// 酒店查询字段
#define DATANAME_HOTEL				@"DataName"
#define NAME_HOTEL                  @"Name"
#define THEMENAMECN_HOTEL           @"ThemeNameCn"
#define APIID_HOTEL                 @"ApiId"
#define MISID_HOTEL                 @"MisId"
#define THEMEID_HOTEL               @"ThemeId"
#define DATAID_HOTEL				@"DataID"
#define LOCATIONLIST_HOTEL			@"LocationList"
#define THEMELIST_HOTEL             @"ThemeList"
#define ADDITONINFOLIST_HOTEL		@"AdditionInfoList"
#define ARRIVE_TIME_RANGE			@"ArriveTimeRange"
#define TYPEID_HOTEL				@"TypeID"
#define TAGID_HOTEL					@"TagID"
#define TAGNAME_HOTEL				@"TagName"
#define AIRPORT_RAILWAY_TAG_INFOS	@"AirportRailwayTagInfos"
#define COMMERCIAL_HOTEL			@"Commercial"
#define DISTRICT_HOTEL				@"District"
#define HOTEL_LIST                  @"HotelList"
#define HOTELBRAND_HOTEL			@"HotelBrand"
#define CHAINHOTEL_HOTEL            @"ChainHotel"
#define HOTEL_ADDRESS				@"HotelAddress"
#define HOLDING_TIME_OPTIONS        @"HoldingTimeOptions"
#define GUEST_NAME					@"GuestName"
#define GHHOTEL_ROOM_INFOLIST       @"GHHotelRoomInfoList"
#define AIRPORT_RAILWAY				@"Airport/Railway"
#define ROOMS                       @"Rooms"
#define	ROOMTYPEID					@"RoomTypeId"
#define SHotelID                    @"SHotelID"
#define ROOMTYPENAME				@"RoomTypeName"
#define	RATEPLANID					@"RatePlanId"
#define	VOUCHSET					@"VouchSet"
#define SUBWAY_STATION				@"Subway Station"
#define SUBWAYSTATION_TAG_INFOS		@"SubwayStationTagInfos"
#define HOTELFACILITYS              @"HotelFacilitys"
#define PICURL_HOTEL				@"PicUrl"
#define HOTEL_IMAGE_ITEMS           @"HotelImageItems"
#define AREA_LIMITED_NONE			@"区域不限"
#define BRAND_LIMITED_NONE			@"品牌不限"
#define THEME_LIMITED_NONE          @"主题不限"
#define THEME_APARTMENT             @"公寓"
#define FACILITY_LIMITED_NONE       @"设施不限"
#define STAR_LIMITED_NONE			@"星级不限"
#define PRICE_LIMITED_NONE			@"价格不限"
#define ORDER_LIMITED_NONE			@"默认排序"
#define PAYINHOTEL_TYPE				@"前台自付"
#define HAVE_COUPON_STR				@"可使用消费券"
#define NO_VOUCH_STR				@"免担保"
#define STAR_LIMITED_FIVE			@"五星 / 豪华"
#define STAR_LIMITED_FOUR			@"四星 / 高档"
#define STAR_LIMITED_THREE			@"三星 / 舒适"
#define STAR_LIMITED_OTHER			@"经济 / 客栈"
#define ORDER_FILL_ALERT			@"关闭界面将丢失填写数据,\n是否确认？"
#define LOADINGTIPSTRING            @"正在加载，请稍候"
#define CANT_TEL_TIP				@"当前设备不支持通话功能"
#define MAX_HOTEL_COUNT				100			// 酒店列表最大容量
#define HOTEL_PAGESIZE				15			// 每页酒店请求数

// =======================================================================================================
// 机票常用字段
#define ARRIVAL_TIME				@"ArrivalTime"
#define ARRIVE_AIRPORT				@"ArriveAirport"
#define AIRCORP_NAME				@"AirCorpName"
#define BOOKER_INFO					@"BookerInfo"
#define DELIVERY_ADDRESS			@"DeliveryAddress"
#define DELIVERY_PERSON				@"DeliveryPerson"
#define DELIVERY_PHONE				@"DeliveryPhone"
#define DELIVERY_POSTCODE			@"DeliveryPostcode"
#define DEPART_TIME					@"DepartTime"
#define DEPART_AIRREPORT			@"DepartAirport"
#define FLIGHT_NUMBER				@"FlightNumber"
#define FLIGHTS						@"Flights"
#define LEGISLATION_PRICE           @"LegislationPrice"

// =======================================================================================================
// 列车查询常用字段
#define Resq_Header					@"Header"
#define TRAIN_DEPARTURE_STATION		@"StartStation"
#define TRAIN_ARRIVAL_STATION		@"EndStation"
#define TRAIN_STATION_NAME			@"StationName"
#define TRAIN_SEARCH_ARRIVE_TIME	@"SearchStationArriveTime"
#define TRAIN_SEARCH_START_TIME		@"SearchStationStartTime"
#define TRAIN_SEARCH_STATION		@"SearchStation"
#define TRAIN_TYPE					@"Type"
#define TRAIN_STYPE					@"SType"
#define TRAIN_START_TIME			@"StartTime"
#define TRAIN_END_TIME				@"EndTime"
#define TRAIN_MIN_START_TIME		@"MinStartTime"
#define TRAIN_MAX_START_TIME		@"MaxStartTime"
#define TRAIN_MIN_END_TIME			@"MinEndTime"
#define TRAIN_MAX_END_TIME			@"MaxEndTime"
#define ZERO						@"0"
#define TRAIN_DEFAULT_START_TIME	@"00:00"
#define TRAIN_DEFAULT_MORNING_TIME	@"06:00"
#define TRAIN_DEFAULT_AFTERNOON_TIME @"12:00"
#define TRAIN_DEFAULT_NIGHT_TIME	@"18:00"
#define TRAIN_DEFAULT_END_TIME		@"23:59"
#define TRAIN_COSTTIME				@"CostTime"
#define TRAIN_COSTDAYS				@"CostDays"
#define TRAIN_DISTANCE				@"Distance"
#define TRAIN_NAME					@"TrainName"
#define HARD_SEAT					@"HardSeat"
#define SOFT_SEAT					@"SoftSeat"
#define HARD_SLEEP					@"HardSleep"
#define SOFT_SLEEP					@"SoftSleep"
#define SEAT_A						@"SeatA"
#define SEAT_B						@"SeatB"
#define SEAT_SUPER					@"SeatSuper"
#define GJRW						@"GJRW"
#define LOW_PRICEINFO				@"LowPriceInfo"

#define NOTRAIN_TIP					@"未找到匹配车次"
#define NOSTOPFLIGHT_TIP            @"未能获取经停信息"
#define STRING_NOLIMIT				@"不限"
#define STRING_MORNING				@"06:00-12:00"
#define STRING_AFTERNOON			@"12:00-18:00"
#define STRING_NIGHT				@"18:00-06:00"
#define ALL_TRAIN					@"全部"
#define G_TRAIN						@"高铁（G）"
#define D_TRAIN						@"动车（D）"
#define Z_TRAIN						@"直达（Z）"
#define T_TRAIN						@"特快（T）"
#define K_TRAIN						@"快速（K）"
#define OTHER_TRAIN					@"其它"
#define TRAIN_START					@"始发"
#define TRAIN_END					@"终到"
#define TRAIN_SERVER_NUM            @"4006899617"
#define TRAIN_SERVER_NUM_TIPS       @"400-689-9617"

// =======================================================================================================
// 团购常用字段
#define ADDRESS_GROUPON				@"Address"
#define ALLGROUPONCNT_GROUPON		@"AllGrouponCnt"
#define AREAID_GROUPON				@"AreaID"
#define AREANAME_GROUPON			@"AreaName"
#define BOOKINGNUMS_GROUPON			@"BookingNums"
#define CITYS_GROUPON				@"CityList"
#define CITYNAME_GROUPON			@"CityName"
#define CITYID_GROUPON				@"CityID"
#define CONTENTS_GROUPON			@"Contents"
#define	DESCRIPTION_GROUPON			@"Description"
#define DETAILINFO_GROUPON			@"DetailInfo"
#define PRODUCTDETAIL_GROUPON       @"ProductDetail"
#define STARTAVAILABLEDATE_GROUPON  @"StartAvailableDate"
#define ENDAVAILABLEDATE_GROUPON    @"EndAvailableDate"
#define NOTAPPLICABLEDATE_GROUPON   @"NotApplicableDate"
#define STORES_GROUPON              @"Stores"
#define GIFTS_GROUPON               @"Gifts"
#define DISCOUNT_GROUPON			@"Discount"
#define EXPRESSFEE_GROUPON			@"ExpressFee"
#define EFFECTSTARTTIME_GROUPON		@"EffectStartTime"
#define EFFECTENDTIME_GROUPON		@"EffectEndTime"
#define GROUPONCOUNT_GROUPON		@"GrouponCnt"
#define GROUPONID_GROUPON			@"GrouponID"
#define	GROUPONLIST_GROUPON			@"GrouponList"
#define GROUPONORDERSTATUS			@"GrouponOrderStatus"
#define GROUPONPAYSTATUS			@"GrouponPayStatus"
#define HOTELNAME_GROUPON			@"HotelName"
#define INVOICE_GROUPON				@"Invoice"
#define INVOICETITLE_GROUPON		@"InvoiceTitle"
#define ISINVOICE_GROUPON			@"IsInvoice"
#define ISSEARCHREFUND              @"IsSearchRefund"
#define LEFTTIME_GROUPON			@"LeftTime"
#define ORDERREQ_GROUPON			@"OrderReq"
#define ORDERID_GROUPON				@"OrderID"
#define ORDERSTATUS_GROUPON			@"OrderStatus"
#define PAYSTATUS					@"PayStatus"
#define	PHOTOURL_GROUPON			@"PhotoUrl"
#define PHOTOURLS_GROUPON			@"PhotoUrls"
#define ORIGINALPHOTOURLS_GROUPON   @"OriginalPhotoUrls"
#define PRODID_GROUPON				@"ProdId"
#define PRODNAME_GROUPON			@"ProdName"
#define PRODTYPE_GROUPON			@"ProdType"
#define PAYMETHOD                   @"PayMethod"
#define QSTATUS_GROUPON				@"QStatus"
#define QUANS_GROUPON				@"Quans"
#define QUANCODE_GROUPON			@"QuanCode"
#define QUANID_GROUPON				@"QuanID"
#define QUANID_GROUPONS             @"QuanIDs"
#define ISALLOWREFUND               @"IsAllowRefund"
#define ISALLOWCONTINUEPAY  @"IsAllowContinuePay"
#define SALEPRICE_GROUPON			@"SalePrice"
#define SHOWPRICE_GROUPON			@"ShowPrice"
#define SALENUMS_GROUPON			@"SaleNums"
#define MOBILEPRODUCTTYPE_GROUPON   @"MobileProductType"
#define TIME_GROUPON				@"Time"
#define TITLE_GROUPON				@"Title"
#define TOTALPRICE_GROUPON			@"TotalPrice"
#define TYPE_GROUPON				@"Type"
#define VALUE_GROUPON				@"Value"
#define NONMEMBER_GROUPONCARDNO		@"192928"
#define MAX_PAGESIZE_GROUPON		20
#define MAX_ONEPAGE_GROUPON         60
#define MAX_PAGESIZE_HOTEL          25
#define MAX_GROUPON_COUNT			60
#define FILTER_TYPE_DIS				0
#define FILTER_TYPE_BIZ				1
#define FILTER_TYPE_POI             2

#define SELFACTIONSHEET             1001
#define DPNAVSHEET                  1002

// 记录酒店城市列表上次选择
#define kHotelLastSelectedCityKey @"HotelLastSelectedCityKey"

//calender define
// COLOR
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define CELLBGCOLOR                 RGBACOLOR(0,0,0,.1)
#define GREENCOLOR                  RGBACOLOR(3, 145, 217, 1)
#define DEEPGREENCOLOR              RGBACOLOR(2,101,151,1)
#define PRICECOLOR                  RGBACOLOR(255, 89, 54, 1)
#define ORANGECOLOR                 RGBACOLOR(255,136,17,1)
#define DEEPORANGECOLOR             RGBACOLOR(178,95,12,1)
#define GRAYCOLOR                   RGBACOLOR(250,250,250,1)
#define DEEPGRAYCOLOR               RGBACOLOR(175,175,175,1)
#define LEFTSIDEBAR_WIDTH           220
#define TAXICELLCOLOR               RGBACOLOR(57,57,57,1)

// 默认值
#define DEFAULTPOSTCODEVALUE        @"100000"
//团购最大价格
#define GrouponMaxMaxPrice 9999999

// crash文件信息
#define kSystemLaunchTimeKey                        @"systemLaunchTime"
#define	kCrashInfoFile							    @"crashinfo.dat"
#define	kCrashInfoArchiverKey						@"arrayCrashInfo"
#define	kCrashStepFile							    @"crashStep.dat"
#define	kCrashStepArchiverKey						@"arrayCrashStep"

// 酒店关键词搜索历史记录数量
#define HOTEL_KEYWORDHISTORY_NUM    3


//=================================================================================================
// 枚举
typedef enum{
    CellTypeTop = -1,
    CellTypeMiddle = 0,
    CellTypeBottom = 1
}CellType;
