//
//  CountlyEvent.h
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#ifndef ElongClient_CountlyEvent_h
#define ElongClient_CountlyEvent_h


// countly keys
#define COUNTLY_EVENT_SHOW                      @"show"
#define COUNTLY_EVENT_CLICK                     @"click"

// countly 业务线
//hotel/groupon/flight/ticket/EAN
#define COUNTLY_CH_HOME                         @"home"
#define COUNTLY_CH_HOTEL                        @"hotel"
#define COUNTLY_CH_GROUPON                      @"groupon"
#define COUNTLY_CH_FLIGHT                       @"flight"
#define COUNTLY_CH_TICKET                       @"ticket"

// countly pages
#define COUNTLY_PAGE_HOMEPAGE                   @"homePage"
#define COUNTLY_PAGE_HOTELSEARCHPAGE            @"hotelSearchPage"
#define COUNTLY_PAGE_HOTELLISTPAGE              @"hotelListPage"
#define COUNTLY_PAGE_HOTELDETAILPAGE            @"hotelDetailPage"
#define COUNTLY_PAGE_HOTELFILLINORDERPAGE       @"hotelFillinOrderPage"
#define COUNTLY_PAGE_CREDITPAYPAGE              @"creditPayPage"
#define COUNTLY_PAGE_ACTIVATEPAGE               @"activatePage"
#define COUNTLY_PAGE_LOGINPAGE                  @"loginPage"
#define COUNTLY_PAGE_REGISTERPAGE               @"registerPage"
#define COUNTLY_PAGE_ORDERCONFIRMEDPAGE         @"orderConfirmedPage"
#define COUNTLY_PAGE_PAYMENTCONFIRMEDPAGE       @"paymentConfirmedPage"
#define COUNTLY_PAGE_HOTELMAPPAGE               @"hotelMapPage"
#define COUNTLY_PAGE_HOTELFILTERCHOICEPAGE      @"hotelFilterChoicePage"
#define COUNTLY_PAGE_HOTELDETAILDISCRIBEPAGE    @"hotelDetailDiscribePage"

// countly action
#define COUNTLY_ACTION_ACTIVATE                 @"activate"
#define COUNTLY_ACTION_LOGIN                    @"login"
#define COUNTLY_ACTION_SEARCH                   @"search"
#define COUNTLY_ACTION_FILTER                   @"filter"


// countly clickSpot
#define COUNTLY_CLICKSPOT_BLOCK                 @"block"
#define COUNTLY_CLICKSPOT_ADBANNER              @"adbanner"
#define COUNTLY_CLICKSPOT_NEARBY                @"nearby"
#define COUNTLY_CLICKSPOT_SEARCH                @"search"
#define COUNTLY_CLICKSPOT_FILTER                @"filter"
#define COUNTLY_CLICKSPOT_HOTELITEM             @"hotelItem"
#define COUNTLY_CLICKSPOT_MYCOLLECTION          @"mycollection"
#define COUNTLY_CLICKSPOT_LM                    @"spectial"
#define COUNTLY_CLICKSPOT_CURRENTLOCATION       @"currentlocation"
#define COUNTLY_CLICKSPOT_DESTINATION           @"destination"
#define COUNTLY_CLICKSPOT_LOADMORE              @"loadmore"
#define COUNTLY_CLICKSPOT_STORE                 @"store"
#define COUNTLY_CLICKSPOT_PHONENUMBER           @"phonenumber"
#define COUNTLY_CLICKSPOT_HOTELDETAIL           @"hoteldetail"
#define COUNTLY_CLICKSPOT_CORRECT               @"correct"
#define COUNTLY_CLICKSPOT_COMMENT               @"comment"
#define COUNTLY_CLICKSPOT_IMAGE                 @"image"
#define COUNTLY_CLICKSPOT_HOTELLOCATION         @"hotellocation"
#define COUNTLY_CLICKSPOT_CHECKINTIME           @"checkintime"
#define COUNTLY_CLICKSPOT_CHECKOUTTIME          @"checkouttime"
#define COUNTLY_CLICKSPOT_BOOKHOTEL             @"bookhotel"
#define COUNTLY_CLICKSPOT_ROOMDETAIL            @"roomdetail"
#define COUNTLY_CLICKSPOT_HOTELSHARE            @"hotelshare"
#define COUNTLY_CLICKSPOT_NEXTSTEP              @"nextstep"
#define COUNTLY_CLICKSPOT_SUBMIT                @"submit"
#define COUNTLY_CLICKSPOT_LOGIN                 @"login"
#define COUNTLY_CLICKSPOT_NONMEMBERBOOK         @"nonmemberbook"
#define COUNTLY_CLICKSPOT_LOGINSET              @"loginset"
#define COUNTLY_CLICKSPOT_REGISTER              @"register"
#define COUNTLY_CLICKSPOT_RETRIEVEPASSWORD      @"retrievepassword"
#define COUNTLY_CLICKSPOT_COACCOUTLOGIN         @"coaccoutlogin"
#define COUNTLY_CLICKSPOT_CITY                  @"city"
#define COUNTLY_CLICKSPOT_DATE                  @"date"
#define COUNTLY_CLICKSPOT_ENTRYBAR              @"entrybar"
#define COUNTLY_CLICKSPOT_DOMESTIC              @"domestic"
#define COUNTLY_CLICKSPOT_INTERNATIONAL         @"international"
#define COUNTLY_CLICKSPOT_MYCOLLECTION          @"mycollection"
#define COUNTLY_CLICKSPOT_BACK                  @"back"
#define COUNTLY_CLICKSPOT_SEARCHBAR             @"searchbar"
#define COUNTLY_CLICKSPOT_PRICEANDSTAR          @"priceandstar"
#define COUNTLY_CLICKSPOT_SORT                  @"sort"
#define COUNTLY_CLICKSPOT_MAP                   @"map"
#define COUNTLY_CLICKSPOT_LIST                  @"list"
#define COUNTLY_CLICKSPOT_HOTELITEM             @"hotelItem"
#define COUNTLY_CLICKSPOT_AREA                  @"area"
#define COUNTLY_CLICKSPOT_BRAND                 @"brand"
#define COUNTLY_CLICKSPOT_PAYTYPE               @"paytype"
#define COUNTLY_CLICKSPOT_PROMOTION             @"promotion"
#define COUNTLY_CLICKSPOT_SERVICE               @"service"
#define COUNTLY_CLICKSPOT_ACCOMMODATION         @"accommodation"
#define COUNTLY_CLICKSPOT_RESET                 @"reset"
#define COUNTLY_CLICKSPOT_CONFIRM               @"confirm"
#define COUNTLY_CLICKSPOT_ROOMNUMBER            @"roomnumber"
#define COUNTLY_CLICKSPOT_TIMERESERVE           @"timereserve"
#define COUNTLY_CLICKSPOT_CONTACTS              @"contacts"
#define COUNTLY_CLICKSPOT_SPECIALNEEDS          @"specialneeds"
#define COUNTLY_CLICKSPOT_INVOICE               @"invoice"
#define COUNTLY_CLICKSPOT_PREPAYRULE            @"prepayrule"
#define COUNTLY_CLICKSPOT_VOUCHRULE             @"vouchrule"
#define COUNTLY_CLICKSPOT_BACKHOME              @"backhome"
#define COUNTLY_CLICKSPOT_USECOUPON             @"usecoupon"
#define COUNTLY_CLICKSPOT_HOWTOGETCASHBACK      @"howtogetcashback"
#define COUNTLY_CLICKSPOT_WITHDRAW              @"withdraw"
#define COUNTLY_CLICKSPOT_CALLUS                @"callus"
#define COUNTLY_CLICKSPOT_REGISTERANDLOGIN      @"registerandlogin"
#define COUNTLY_CLICKSPOT_CREDITCARD            @"creditcard"
#define COUNTLY_CLICKSPOT_WECHAT                @"wechat"
#define COUNTLY_CLICKSPOT_ALIPAYCLIENT          @"alipayclient"
#define COUNTLY_CLICKSPOT_ALIPAYWEB             @"alipayweb"

#endif
