//
//  FlightDataDefine.h
//  ElongClient
//
//  Created by dengfang on 11-2-17.
//  Copyright 2011 shoujimobile. All rights reserved.
//


#import "FlightData.h"
#import "Flight.h"

//===================define
#define DEFINE_SINGLE_TRIP		0	//单程
#define DEFINE_ROUND_TRIP		1	//往返
#define DEFINE_GO_TRIP			0	//去程
#define DEFINE_RETURN_TRIP		1	//返程
//-----
#define DEFINE_POST_TYPE_NOT_NEED	0	//不需要行程单
#define DEFINE_POST_TYPE_POST		1	//邮寄行程单
#define DEFINE_POST_TYPE_SELF_GET	2	//机场自取
//===================

//flightDictionary
#define KEY_SELECT_FLIGHT_TYPE				@"SelectFlightType"				//选择了乘机类型：单程=0 往返=1
#define KEY_CURRENT_FLIGHT_TYPE				@"CurrentFlightType"			//当前的乘机类型：单程=0 往返=1
#define KEY_CURRENT_FLIGHT_ARRAY_INDEX_1	@"CurrentFlightArrayIndex_1"	//去程：当前选择的index
#define KEY_CURRENT_FLIGHT_ARRAY_INDEX_2	@"CurrentFlightArrayIndex_2"	//返程：当前选择的index
#define KEY_SELECT_CLASS_TYPE				@"SelectClassType"				//选择了舱位类型
#define KEY_TERMINAL_1						@"Terminal_1"					//去程：起始航站楼
#define KEY_TRANS_TERMINAL_1                @"KEY_TRANS_TERMINAL_1"         //去程：中转航站楼
#define KEY_ARRIVE_TERMINAL_1				@"Arrive_Terminal_1"			//去程：终点航站楼
#define KEY_TERMINAL_2						@"Terminal_2"					//返程：起始航站楼
#define KEY_TRANS_TERMINAL_2                @"KEY_TRANS_TERMINAL_2"         //返程：中转航站楼
#define KEY_ARRIVE_TERMINAL_2				@"Arrive_Terminal_2"			//返程：终点航站楼
#define KEY_SHOPPINGORDERPARAMS             @"ShoppingOrderParams"          // 去程Shopping产品成单相关参数集合机票渠道来源分类
#define KEY_TICKETCHANNEL                   @"TicketChannel"                // 同上
#define KEY_SHOPPINGORDERPARAMS_RETURN      @"ShoppingOrderParams_RETURN"   // 返程Shopping产品成单相关参数集合机票渠道来源分类
#define KEY_TICKETCHANNEL_RETURN            @"TicketChannel_RETURN"         // 同上
#define KEY_TERMINAL						@"Terminal"
#define KEY_ARRIVE_TERMINAL					@"ArriveTerminal"
#define KEY_RETURN_REGULATE_1				@"ReturnRegulate_1"				//去程：退改签规定
#define KEY_CHANGE_REGULATE_1               @"CHANGE_REGULATE_1"
#define KEY_RETURN_REGULATE_t				@"ReturnRegulate_t"             //去程：中转退改签规定

#define KEY_DEPART_DATE						@"DepartDate"					//出发日期
#define KEY_RETURN_DATE						@"ReturnDate"					//返回日期
#define KEY_DEPART_CITY						@"DepartCity"					//出发城市
#define KEY_ARRIVE_CITY						@"ArrivalCity"					//到达城市
#define KEY_CONTACT_NAME					@"ContactName"					//联系人姓名
#define KEY_CONTACT_TEL						@"ContactTel"					//联系人电话
#define KEY_PLANE_PIC						@"PlanePhoto"					//机型图片
#define KEY_PLANE_PIC_URL					@"PhotoUrl"						//机型图片地址
#define KEY_PLANE_PIC_NAME					@"PlaneName"					//机型名称
#define KEY_PLANE_PIC_INFO					@"Description"					//机型描述
#define KEY_TICKET_GET_TYPE_MEMO			@"TicketGetTypeMemo"			//机场自取or邮寄行程单
#define KEY_ADDRESS_CONTENT					@"AddressContent"				//地址内容
#define KEY_ADDRESS_NAME					@"AddressName"					//机场自取
#define KEY_POSTCODE						@"Postcode"						//邮编
#define KEY_NAME							@"Name"							//姓名
#define KEY_PASSENGER_LIST					@"PassengerList"				//乘机人列表 array
#define KEY_ORDER_NO						@"OrderNo"						//订单号
#define KEY_ORDER_CODE                      @"OrderCode"                    //用于支付宝支付的号码
#define KEY_TICKET_GET_TYPE					@"TicketGetType"				//行程单类型
#define KEY_SELF_GET_ADDRESS_ID				@"SelfGetAddressID"				//自取地址ID
#define KEY_SALEPRICEDETAIL                 @"SalePricesDetail"             //仓位价格详细信息
#define KEY_IS51BOOK                        @"Is51Book"                     //是否51产品预订
#define KEY_INVOICETITLE                    @"InvoiceTitle"                 //发票抬头
#define KEY_ISSHAREDPRODUCT                 @"IsSharedProduct"              //是否是共享产品
#define KEY_ISONEHOUR                       @"IsOneHour"                    //是否1小时飞人


//flight
#define KEY_DEPART_TIME				@"DepartTime"				//出发时间
#define KEY_ARRIVE_TIME				@"ArriveTime"				//到达时间
#define KEY_AIR_PORT_CODE			@"AirPortCode"				//机场
#define KEY_ARRIVE_AIRPORT_CODE		@"ArriveAirportCode"		//到达机场代码			//add
#define KEY_ARRIVE_AIRPORT			@"ArriveAirport"			//到达机场
#define KEY_DEPART_AIRPORT_CODE		@"DepartAirportCode"		//出发机场代码			//add
#define KEY_DEPART_AIRPORT			@"DepartAirport"			//出发机场
#define KEY_AIR_CORP_CODE			@"AirCorpCode"				//航空公司代码			//add
#define KEY_AIR_CORP_NAME			@"AirCorpName"				//航空公司名称
#define KEY_FLIGHT_NUMBER			@"FlightNumber"				//如：MU5130
#define KEY_IS_ETICKET				@"IsEticket"				//是否电子票
#define KEY_TIME_OF_LAST_ISSUES		@"TimeOfLastIssued"			//最晚出票时间
#define KEY_OIL_TAX					@"OilTax"					//燃油附加税
#define KEY_AIR_TAX					@"AirTax"					//机场建设费
#define KEY_TAX                     @"Tax"                      // 包含机建和燃油费
#define KEY_AIRSEGMENTS             @"AirSegments"
#define KEY_ISTRANSITED             @"IsTransited"              // 是否中转
#define KEY_KILOMETERS				@"Kilometers"				//公里
#define KEY_STOPINFOS               @"StopInfos"
#define KEY_STOPS					@"Stops"                    //是否经停
#define KEY_STOPNUMBER              @"StopNumber"
#define KEY_PLANE_TYPE				@"PlaneType"				//机型
#define KEY_CLASS_TYPE				@"ClassType"				//舱位类型
#define KEY_TYPE_NAME				@"TypeName"					//舱位类型名称
#define KEY_SALEPRICE               @"SalePrice"                //价格
#define KEY_PRICE                   @"Price"
#define KEY_REMAINTICKETSTATE		@"RemainTicketState"        //票数
#define KEY_DISCOUNT				@"Discount"					//折扣
#define KEY_IS_PROMOTION			@"IsPromotion"				//是否促销
#define KEY_PROMOTION_ID			@"PromotionId"				//促销ID
#define KEY_FAREITEM_ID             @"FareItemId"               // 新的促销ID
#define KEY_CLASS_TAG				@"ClassTag"                 //舱位标示
#define KEY_FLIGHTCLASS             @"FlightClass"              // 同上（V2接口）
#define KEY_ISSUE_CITY_ID			@"IssueCityId"				//出票城市
#define KEY_DEFAULT_COUPON          @"DefaultCoupon"            // 机票返现金额
#define IS_CONTAIN_LEGISLATION      @"IsContainLegislation"     // 是否包含特惠机票
#define IS_LEGISLATION_PRICE        @"IsLegislationPirce"       // 是否是立减价格
#define ORIGINAL_PRICE              @"OriginalPrice"            // 机票原价
#define KEY_FLIGHT_TAXS             @"Taxs"                     // 税费信息
#define KEY_ADULT_OIL_TAX           @"AdultOilTax"
#define KEY_ADULT_AIR_TAX           @"AdultAirTax"
#define KEY_CHILD_OIL_TAX           @"ChildOilTax"
#define KEY_CHILD_AIR_TAX           @"ChildAirTax"
//#define KEY_ADULT_TOTAL_TAX         @"AdultTotalTax"
//#define KEY_CHILD_TOTAL_TAX         @"ChildTotalTax"
#define KEY_SALE_PRICES             @"SalePrices"
#define KEY_ADULT_PRICE             @"AdultPrice"
#define KEY_CHILD_PRICE             @"ChildPrice"
#define KEY_TICKETCOUNT             @"TicketCount"

//server
#define KEY_RETURN_REGULATE			@"ReturnRegulate"			//退票规定
#define KEY_CHANGE_REGULATE			@"ChangeRegulate"			//改签规定
#define KEY_CHANGE_SIGNRULE         @"SignRule"                 // 签转规定
#define KEY_SITES					@"Sites"					//存储机票价格，折扣等字典的数组
#define KEY_AIR_PORT_NAME			@"AirPortName"				//机场
#define KEY_TERMINAL				@"Terminal"					//航站楼
#define KEY_ARRIVE_TERMINAL			@"ArriveTerminal"			//到站航站楼
#define KEY_PLANE_TYPE_CODE			@"TypeCode"					//机型(用来提交服务器使用)
#define KEY_ISSUE_CITY_NAME			@"IssueCityName"			//出票城市
#define KEY_ISSUE_DATE				@"IssueDate"				//出票时间
#define KEY_CARD_NO					@"CardNo"					//登录账号
#define KEY_MEMO					@"Memo"						//
#define KEY_TOTAL_PRICE				@"TotalPrice"				//总价
#define KEY_CONTACTOR_NAME			@"ContactorName"			//联系人姓名
#define KEY_CONTACT_MOBILE			@"ContactMobile"			//联系人电话
#define KEY_DELIVERY_INFO			@"DeliveryInfo"				//邮寄信息
#define KEY_ADDRESSES				@"Addresses"				//邮寄地址
#define KEY_ADDRESS					@"Address"					//邮寄地址（提交订单时候用）
#define KEY_ID						@"Id"						//id
#define KEY_PHONE_NO				@"PhoneNo"					//电话号码
#define KEY_CREDIT_CARD				@"CreditCard"				//证件
#define KEY_ELONG_CARD_NO			@"ElongCardNo"				//elong卡号
#define KEY_CREDIT_CARD_TYPE		@"CreditCardType"			//证件类型
#define KEY_HOLDER_NAME				@"HolderName"				//持有人姓名
#define KEY_VERIFY_CODE				@"VerifyCode"				//验证码
#define KEY_CERTIFICATE_TYPE		@"CertificateType"			//证件类型
#define KEY_CERTIFICATE_NUMBER		@"CertificateNumber"		//证件号码
#define KEY_BIRTHDAY                @"Birthday"                 // 生日
#define KEY_PASSENGER_TYPE          @"PassengerType"            // 乘客类型
#define KEY_EXPIRE_YEAR				@"ExpireYear"				//到期年
#define KEY_EXPIRE_MONTH			@"ExpireMonth"				//到期月
#define KEY_FLIGHT_CLASS_LIST		@"FlightProducts"			//机票类列表
#define KEY_RESTRICTION				@"Restriction"				//限制
#define KEY_CUSTOMERS				@"Customers"				//乘机人信息
#define KEY_SELF_GET_TIME			@"SelfGetTime"				//自取时间
#define KEY_INVOICEINFO             @"InvoiceInfo"              //发票信息

// 保险
#define KEY_INSURANCE_ORDERS        @"InsuranceOrders"          // 保单信息
#define KEY_INSURANCE_NAME          @"Name"                     // 保险中文名称
#define KEY_INSURANCE_NAMEEN        @"NameEn"                   // 保险英文名称
#define KEY_INSURANCE_SEX           @"Sex"                      // 保险人性别
#define KEY_INSURANCE_BIRTHDAY      @"Birthday"                 // 保险人出生日期
#define KEY_INSURANCE_HOLDER        @"Holder"                   // InsuranceHolder
#define KEY_INSURANCE_PRODUCT       @"Product"                  // InsuranceProduct
#define KEY_INSURANCE_NUMBER        @"Number"                   // InsuranceNumber
#define KEY_INSURANCE_EFFECTIVETIME @"EffectiveTime"            // InsuranceEffectiveTime
#define KEY_INSURANCE_PRODUCTID     @"ProductId"                // Insurance ProductId.
#define KEY_INSURANCE_BASEPRICE     @"BasePrice"                // Insurance BasePrice.
#define KEY_INSURANCE_SALEPRICE     @"SalePrice"                // Insurance SalePrice.




