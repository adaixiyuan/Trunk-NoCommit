//
//  HotelInfoWeb.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelInfoWeb.h"
#import "HotelDetailController.h"
#import "InterHotelDetailCtrl.h"

static const int freeWordTips[] = {
    @"行政楼层免费Wi-Fi",
    @"行政楼层免费WiFi",
    @"大堂区域免费Wi-Fi",
    @"大堂区域免费WiFi",
    @"公共区域免费Wi-Fi",
    @"公共区域免费WiFi",
    @"大堂免费Wi-Fi",
    @"大堂免费WiFi",
    @"免费Wi-Fi",
    @"免费 Wi-Fi",
    @"免费WiFi",
    @"免费宽带和WiFi",
    @"免费宽带和Wi-Fi",
    @"免费宽带上网",
    @"免费宽带",
    @"免费停车场",
    @"免费停车",
    @"免费地图",
    @"免费报纸",
    @"免费交通图",
    @"免费旅游交通图",
    @"免费上网",
    @"免费无线上网",
    @"免费提供停车位",
    @"免费洗护用品和吹风机",
    @"免费报纸",
    @"免费的有线和无线上网",
    @"免费的欧陆式早餐",
    @"免费有线高速上网",
    @"免费高速有线上网",
    @"免费拨号上网",
    @"免费室内通话",
    @"免费泊车",
    @"免费入住",
    @"免费早餐",
    @"免费提供",
    @"免费接机服务",
    @"免费24小时接机服务"
};

@implementation HotelInfoWeb

- (void)dealloc
{
    self.hotelDic=nil;
    [contentHtml release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scalesPageToFit = NO;
        firstLoadingHtml = YES;
        
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [resourcePath stringByAppendingPathComponent:@"hotelinfo.html"];
        contentHtml = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] copy];
        
        self.delegate = self;
    }
    return self;
}


- (void)reloadDataByType:(HotelInfoType)type {
    NSString *contentStr = nil;
    switch (type) {
        case HotelInfoTypeNative:
            self.hotelDic = [HotelDetailController hoteldetail];
            contentStr = [self getNativeHotelHtml];
            break;
        case HotelInfoTypeNativeFromGroupon:
            //selfself.hotelDic需要在外边赋值
            contentStr = [self getNativeHotelHtml];
            break;
        case HotelInfoTypeInterIntro:
            contentStr = [self getInterHotelIntro];
            break;
        case HotelInfoTypeInterAround:
            contentStr = [self getInterHotelAround];
            break;
        case HotelInfoTypeInterService:
            contentStr = [self getInterHotelService];
            break;
        case HotelInfoTypeInterOther:
            contentStr = [self getInterHotelOther];
            break;
        case HotelInfoTypeNativeFromXGHomeDetail:  //by lc
            contentStr = [self getNativeHotelHtml];
            break;
        default:
            break;
    }
    
    [self loadHTMLString:contentStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}


- (NSString *)getInterHotelIntro {
    self.hotelDic = [InterHotelDetailCtrl detail];
    NSMutableString *contentStr = [NSMutableString stringWithCapacity:0];
    
    // 酒店名称
    NSDictionary *BasedInfo = [self.hotelDic safeObjectForKey:@"BasedInfo"];
    [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_name.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",[BasedInfo safeObjectForKey:@"HotelName"]];
    
    if (DICTIONARYHASVALUE(BasedInfo)) {
        NSArray *ShortDescriptionList = [BasedInfo safeObjectForKey:@"ShortDescriptionList"];
        if (ARRAYHASVALUE(ShortDescriptionList)) {
            for (NSDictionary *dic in ShortDescriptionList) {
                NSString *tips = [self resetText:[dic safeObjectForKey:@"Description"]];
                if (tips.length != 0) {
                    if ([[dic safeObjectForKey:@"Title"] isEqualToString:@"酒店位置"]) {
                        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_address.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
                    }else if ([[dic safeObjectForKey:@"Title"] isEqualToString:@"客房"]){
                        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_room.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
                    }else if ([[dic safeObjectForKey:@"Title"] isEqualToString:@"休闲、SPA、高端服务设施"]){
                        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_wifi.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
                    }else if ([[dic safeObjectForKey:@"Title"] isEqualToString:@"餐饮"]){
                        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_dining.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
                    }else if ([[dic safeObjectForKey:@"Title"] isEqualToString:@"商务及其他服务设施"]){
                        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_business.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
                    }
                }
            }
        }
    }  
    
    NSString *html = [contentHtml stringByReplacingOccurrencesOfString:@"{{content}}" withString:contentStr];
    return html;
}


- (NSString *)getInterHotelAround {
    self.hotelDic = [InterHotelDetailCtrl detail];
    NSMutableString *contentStr = [NSMutableString stringWithCapacity:0];
    [contentStr appendFormat:@"<div class=\"body_content\">"  "</div>"];
    
    NSDictionary *AddedInfo = [self.hotelDic safeObjectForKey:@"AddedInfo"];
    if (DICTIONARYHASVALUE(AddedInfo)) {
        NSArray *AreaInfomation = [AddedInfo safeObjectForKey:@"AreaInfomation"];
        if (ARRAYHASVALUE(AreaInfomation)) {
            for (NSString *tip in AreaInfomation) {
                NSString *tips = [self resetText:tip];
                if (tips.length != 0) {
                    [contentStr appendFormat:@"<div class=\"body_content\">%@</div>", tips];
                }
            }
        }
    }
    
    NSString *html = [contentHtml stringByReplacingOccurrencesOfString:@"{{content}}" withString:contentStr];
    return html;
}


- (NSString *)getInterHotelService {
    self.hotelDic = [InterHotelDetailCtrl detail];
    NSMutableString *contentStr = [NSMutableString stringWithCapacity:0];
    [contentStr appendFormat:@"<div class=\"body_content\">"  "</div>"];
    
    NSDictionary *PropertyInfo = [self.hotelDic safeObjectForKey:@"PropertyInfo"];
    if (DICTIONARYHASVALUE(PropertyInfo)) {
        NSArray *Items = [PropertyInfo safeObjectForKey:@"Items"];
        if (ARRAYHASVALUE(Items)) {
            for (NSDictionary *dic in Items) {
                NSString *tips = [self resetText:[dic safeObjectForKey:@"Amenity"]];
                if (tips.length != 0) {
                    [contentStr appendFormat:@"<div class=\"body_content\">%@</div>", tips];
                }
            }
        }
    }
    
    NSString *html = [contentHtml stringByReplacingOccurrencesOfString:@"{{content}}" withString:contentStr];
    return html;
}


- (NSString *)getInterHotelOther {
    self.hotelDic = [InterHotelDetailCtrl detail];
    NSMutableString *contentStr = [NSMutableString stringWithCapacity:0];
    [contentStr appendFormat:@"<div class=\"body_content\">"  "</div>"];
    
    NSDictionary *AddedInfo = [self.hotelDic safeObjectForKey:@"AddedInfo"];
    if (DICTIONARYHASVALUE(AddedInfo)) {
        NSArray *RoomDeclarationInfo = [AddedInfo safeObjectForKey:@"RoomDeclarationInfo"];
        if (ARRAYHASVALUE(RoomDeclarationInfo)) {
            for (NSString *str in RoomDeclarationInfo) {
                NSString *tips = [self resetText:str];
                if (tips.length != 0) {
                    [contentStr appendFormat:@"<div class=\"body_content\">%@</div>", tips];
                }
            }
        }
    }
    
    NSString *html = [contentHtml stringByReplacingOccurrencesOfString:@"{{content}}" withString:contentStr];
    return html;
}


- (NSString *)getNativeHotelHtml {
    NSMutableString *contentStr = [NSMutableString stringWithCapacity:0];
    
    // 酒店名
    NSString *tips = [self.hotelDic safeObjectForKey:@"HotelName"];
    if (tips.length != 0) {
        //酒店名
        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_name.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    tips = [self.hotelDic safeObjectForKey:@"Phone"];
    if (tips.length != 0) {
        //酒店前台电话
        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_phone.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    tips = [self resetText:[TimeUtils displayDateWithJsonDate:[self.hotelDic safeObjectForKey:@"OpenDate"] formatter:@"yyyy年M月d日"]];
    if (tips.length != 0) {
        // 开业时间
        [contentStr appendFormat:@"<div class=\"body_section\">开业：%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_date.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    tips = [self resetText:[self.hotelDic safeObjectForKey:@"Address"]];
    if (tips.length != 0) {
        //酒店地址
        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"15\" src=\"hoteldetail_address.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    tips = [self resetText:[self.hotelDic safeObjectForKey:@"GeneralAmenities"]];
    
    if (tips.length != 0) {
        //设施服务
        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_facility.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    tips = [self resetText:[self.hotelDic safeObjectForKey:@"TrafficAndAroundInformations"]];
    if (tips.length != 0) {
        //交通状况
        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_traffic.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    tips = [self resetText:[self.hotelDic safeObjectForKey:@"FeatureInfo"]];
    
    if (tips.length != 0) {
        //特色介绍
        [contentStr appendFormat:@"<div class=\"body_section\">%@<img class=\"body_icon\" width=\"16\" heigh=\"16\" src=\"hoteldetail_special.png\" /></div><img src=\"dashed_half.png\" style=\"margin-left:0\" width=\"320\" height=\"1\" style=\"margin-top:-1;\" />",tips];
    }
    
    //我要纠错
    [contentStr appendString:@"<div style=\"margin-top:10px;margin-bottom:30px\"><a style=\"text-decoration:none;padding:8 10 8 10;color:#2377D4;font-size:18px;\" href=\"jiucuolajiucuolajiucuola\">我要纠错 &gt</a><div>"];
    
    NSString *html = [contentHtml stringByReplacingOccurrencesOfString:@"{{content}}" withString:contentStr];
    return html;
}


- (NSString *) resetText:(NSString *)text{
    if (!STRINGHASVALUE(text)) {
        return @"";
    }
    
    int count = sizeof(freeWordTips)/sizeof(freeWordTips[0]);
    NSString *result = text;
    for (int i = 0; i < count; i ++) {
        NSString *value = freeWordTips[i];
        NSRange range;
        range.length = result.length;
        range.location = 0;
        result = [result stringByReplacingOccurrencesOfString:value withString:[NSString stringWithFormat:@"<span>%@</span>",value] options:NSCaseInsensitiveSearch range:range];
    }
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    return result;
}


#pragma mark - webView delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webView endLoading];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (firstLoadingHtml) {
        // 只有第一次加载较慢需要加上一个loadingView
        [webView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
        firstLoadingHtml = NO;
    }
    
    NSString *url_Str = [[[request URL] absoluteString] lowercaseString];
	NSRange range = [url_Str rangeOfString:@"jiucuolajiucuolajiucuola"];
    //回调纠错页面
    if(range.length>0)
    {
        NSLog(@"纠错页面");
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HotelJiuCuo object:nil];
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView endLoading];
}


@end
