//
//  PublicMethods.m
//  ElongClient
//
//  Created by Haibo Zhao on 11-8-12.
//  Copyright 2011年 elong. All rights reserved.
//

#import "PublicMethods.h"
#import "AccountManager.h"
#import "AlertTipView.h"
#import "FXLabel.h"
#import "LzssUncompress.h"
#import "ElongClientAppDelegate.h"
#import "HomeViewController.h"
#import "RoundCornerView.h"
#import "Utils.h"
#import "JPostHeader.h"
#import "JSONKit.h"
#import "ElongURL.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <netinet/in.h>
#import "KeychainItemWrapper.h"
#import "StringEncryption.h"
#import "NSString+URLEncoding.h"
#import "InterHotelSearcher.h"
#import "GListRequest.h"
#import "NavigationDelegate.h"
#import "NavigationAction.h"
#import "AlixPay.h"
#import "WebAppUtil.h"
#import "HotelCityUpdater.h"
#import "AttributedLabel.h"

static NSString *keychain_guid = nil;

static NSString *const sensitiveWord = @"发轮功,张三,李四,王五,SB,逼,傻逼,傻冒,王八,王八蛋,混蛋,你妈,你大爷,操你妈,你妈逼,先生,小姐,男士,女士,测试,小沈阳,丫蛋,男人,女人,骚,騒,搔,傻,逼,叉,瞎,屄,屁,性,骂,疯,臭,贱,溅,猪,狗,屎,粪,尿,死,肏,骗,偷,嫖,淫,呆,蠢,虐,疟,妖,腚,蛆,鳖,禽,兽,屁股,畸形,饭桶,脏话,可恶,吭叽,小怂,杂种,娘养,祖宗,畜生,姐卖,找抽,卧槽,携程,无赖,废话,废物,侮辱,精虫,龟头,残疾,晕菜,捣乱,三八,破鞋,崽子,混蛋,弱智,神经,神精,妓女,妓男,沙比,恶性,恶心,恶意,恶劣,笨蛋,他丫,她丫,它丫,丫的,给丫,删丫,山丫,扇丫,栅丫,抽丫,丑丫,手机,查询,妈的,犯人,垃圾,死鱼,智障,浑蛋,胆小,糙蛋,操蛋,肛门,是鸡,无赖,赖皮,磨几,沙比,智障,犯愣,色狼,娘们,疯子,流氓,色情,三陪,陪聊,烤鸡,下流,骗子,真贫,捣乱,磨牙,磨积,甭理,尸体,下流,机巴,鸡巴,鸡吧,机吧,找日,婆娘,娘腔,恐怖,穷鬼,捣乱,破驴,破罗,妈必,事妈,神经,脑积水,事儿妈,草泥马,杀了铅笔,1,2,3,4,5,6,7,8,9,10,J8,s.b,sb,sbbt,Sb＋Sb,sb＋bt,bt＋sb, saorao,SAORAO,Fuck,shit,0,\\*,\\/,\\.,\\(,\\),（,）,:,;,-,_,－,谢先生,谢小姐,蔡先生,蔡小姐,常先生,常小姐,陈先生,陈小姐,陈女士,崔先生,崔小姐,高先生,高小姐,高女士,郭先生,郭小姐,郭女士,黄先生,黄小姐,黄女士,刘先生,刘小姐,刘女士,李先生,李小姐,李女士,王先生,王小姐,王女士,朱先生,朱小姐,朱女士,周先生,周小姐,周女士,郑先生,郑小姐,郑女士,赵先生,赵小姐,赵女士,张先生,张小姐,张女士,章先生,章小姐,杨先生,杨小姐,杨女士,徐先生,徐小姐,徐女士,许先生,许小姐,许女士,贾先生,贾小姐,季先生,季小姐,康先生,康小姐,路先生,路小姐,马先生,马小姐,马女士,彭先生,彭小姐,秦先生,秦小姐,任先生,任小姐,孙先生,孙小姐,谭先生,谭小姐,吴先生,吴小姐,叶先生,叶小姐,应先生,应小姐,于先生,于小姐,白先生,白小姐,包先生,包小姐,毕先生,毕小姐,曹先生,曹小姐,成先生,成小姐,程先生,程小姐,戴先生,戴小姐,邓先生,邓小姐,丁先生,丁小姐,董先生,董小姐,窦先生,窦小姐,杜先生,杜小姐,段先生,段小姐,方先生,方小姐,范先生,范小姐,冯先生,冯小姐,顾先生,顾小姐,古先生,古小姐,关先生,关小姐,管先生,管小姐,韩先生,韩小姐,潘先生,潘小姐,钱先生,钱小姐,齐先生,齐小姐,沈先生,沈小姐,石先生,石小姐,史先生,史小姐,宋先生,宋小姐,苏先生,苏小姐,唐先生,唐小姐,test,ceshi, ,郝先生,郝小姐,何先生,何小姐,贺先生,贺小姐,侯先生,侯小姐,胡先生,胡小姐,华先生,华小姐,江先生,江小姐,姜先生,姜小姐,蒋先生,蒋小姐,焦先生,焦小姐,金先生,金小姐,孔先生,孔小姐,梁先生,梁小姐,林先生,林小姐,罗先生,罗小姐,孟先生,孟小姐,牛先生,牛小姐,";

@implementation PublicMethods

+ (NSNumber *)getIdTypeFromTypeName:(NSString *)name
{
    if ([name isEqualToString:@"身份证"])
    {
        return [NSNumber numberWithInt:0];
    }
    else if ([name isEqualToString:@"军官证"] || [name isEqualToString:@"军人证"])
    {
        return [NSNumber numberWithInt:1];
    }
    else if ([name isEqualToString:@"回乡证"])
    {
        return [NSNumber numberWithInt:2];
    }
    else if ([name isEqualToString:@"港澳通行证"])
    {
        return [NSNumber numberWithInt:3];
    }
    else if ([name isEqualToString:@"护照"])
    {
        return [NSNumber numberWithInt:4];
    }
    else if ([name isEqualToString:@"居留证"])
    {
        return [NSNumber numberWithInt:5];
    }
    else if ([name isEqualToString:@"其他证件"])
    {
        return [NSNumber numberWithInt:6];
    }
    else if ([name isEqualToString:@"台胞证"])
    {
        return [NSNumber numberWithInt:7];
    }
    
    return nil;
}

+ (NSString *)macaddress {
    if (IOSVersion_7) {
        NSString *guid = [self GetGUIDString];
        return guid;
    }else{
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1\n");
            return NULL;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            free(buf);
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
        
        if (!STRINGHASVALUE(outstring))
        {
            outstring = [self GetGUIDString];
        }
        
        return outstring;

    }
}


+ (NSString *)GetGUIDString
{
    if (STRINGHASVALUE(keychain_guid)) {
        return keychain_guid;
    }
    KeychainItemWrapper *wrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_GUID accessGroup:nil] autorelease];
    
    //从keychain里取出GUID
    keychain_guid = [[wrapper objectForKey:(id)kSecValueData] copy];
    if (STRINGHASVALUE(keychain_guid)) {
        return keychain_guid;
    }else{
        // 从文件读取
        keychain_guid = [[[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_KEYCHAIN_GUID] copy];
        if (STRINGHASVALUE(keychain_guid)) {
            return keychain_guid;
        }else{
            keychain_guid = [[self GUIDString] copy];
            [wrapper setObject:keychain_guid forKey:(id)kSecValueData];
            
            wrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_GUID accessGroup:nil] autorelease];
            keychain_guid = [[wrapper objectForKey:(id)kSecValueData] copy];
            if (STRINGHASVALUE(keychain_guid)) {
                return keychain_guid;
            }else{
                keychain_guid = [[self GUIDString] copy];
                [[ElongUserDefaults sharedInstance] setObject:keychain_guid forKey:USERDEFAULT_KEYCHAIN_GUID];
                return keychain_guid;
            }
        }
    }
}



+ (NSString*)GUIDString {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}


+ (UIImage *)getImageWithURL:(NSString *)urlPath {
	UIImage *newimage;
	if (![urlPath isEqual:[NSNull null]] && STRINGHASVALUE(urlPath) && [urlPath hasPrefix:@"http://"]) {
		NSURL *url			= [NSURL URLWithString:urlPath]; 
		newimage			= [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
		
		if (!newimage) {
			newimage = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
		}
	}
	else {
		newimage = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
	}
	
	return newimage;
}


+ (NSString *)getUserElongCardNO {
	NSString *cardNO = [[AccountManager instanse] cardNo];
	return cardNO ? cardNO : @"0";			// 非会员卡号返回“0”
}


+ (NSString *)getHHmmTimeFromMinutes:(NSInteger)minutes {
	NSInteger hour = minutes / 60;
	NSInteger min = minutes % 60;
	
	NSString *hourStr = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
	NSString *minStr = min < 10 ? [NSString stringWithFormat:@"0%d", min] : [NSString stringWithFormat:@"%d", min];
	
	return [NSString stringWithFormat:@"%@:%@", hourStr, minStr];
}


+ (NSDate *)getPreviousDateWithMonth:(NSInteger)month {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender	= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate			= [calender dateByAddingComponents:comps toDate:[NSDate date] options:0];
	
    [comps release];
    [calender release];
	
    return mDate;
}


+ (NSString *)descriptionFromDate:(NSDate *)date
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    NSString * yesterdayString = [[yesterday descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    
    NSString * dateString = [[date descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

// 计算时间差
+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late);
    
    if (cha/60<1) {
        timeString = [NSString stringWithFormat:@"%.1f", cha];
        timeString=[NSString stringWithFormat:@"%@秒", timeString];
        
    }
    if (cha/60>1&&cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%.1f", (cha*1.0)/60];
        timeString=[NSString stringWithFormat:@"%@分钟", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%.1f", (cha*1.0)/3600];
        timeString=[NSString stringWithFormat:@"%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%.1f", (cha*1.0)/86400];
        timeString=[NSString stringWithFormat:@"%@天", timeString];
        
    }
    [date release];
    return timeString;
}

// 判断是否同一天
+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate
                  second:(NSDate *)secondDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit =NSMonthCalendarUnit |NSYearCalendarUnit |NSDayCalendarUnit;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate];
    NSDateComponents *secondComponets = [calendar components: unit fromDate: secondDate];
    
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

+ (void)pushToMapWithDesLat:(double)latitude Lon:(double)longitude {
	if (0 == [[PositioningManager shared] myCoordinate].latitude && 0 == [[PositioningManager shared] myCoordinate].longitude) {
		[PublicMethods showAlertTitle:@"无法获取当前位置" Message:@"请稍候再试"];
		return;
	}
	
	NSString *theString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
						   [[PositioningManager shared] myCoordinate].latitude,[[PositioningManager shared] myCoordinate].longitude,
						   latitude, longitude];
	
	theString = [theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:theString];
	
	if (![[UIApplication sharedApplication] canOpenURL:url]) {
		[PublicMethods showAlertTitle:@"您未安装Map或已卸载" Message:@"请重新安装"];
	}
	else {
		[[UIApplication sharedApplication] newOpenURL:url];
	}
}


+ (void)pushToMapWithDestName:(NSString *)destination {
	if (0 == [[PositioningManager shared] myCoordinate].latitude && 0 == [[PositioningManager shared] myCoordinate].longitude) {
		[PublicMethods showAlertTitle:@"无法获取当前位置" Message:@"请稍候再试"];
		return;
	}
	if ([destination isEqual:[NSNull null]] || !STRINGHASVALUE(destination)) {
		[PublicMethods showAlertTitle:@"未获取酒店位置信息" Message:nil];
		return;
	}
	
	NSString *theString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
						   [[PositioningManager shared] myCoordinate].latitude,[[PositioningManager shared] myCoordinate].longitude,
						   destination];
	
	theString = [theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:theString];
	
	if (![[UIApplication sharedApplication] canOpenURL:url]) {
		[PublicMethods showAlertTitle:@"您未安装Google Map或已卸载" Message:@"请重新安装"];
	}
	else {
		[[UIApplication sharedApplication] newOpenURL:url];
	}
}

+ (void) openMapListToDestination:(CLLocationCoordinate2D)destination title:(NSString *)title{
    if (!title) {
        title = @"";
    }
    PositioningManager *poiManager = [PositioningManager shared];
    NSString *appname = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleNameKey];
    NSString *scheme = @"elongIPhone";
    NSMutableArray *navList = [NSMutableArray array];
    
    
    // 高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appname,scheme,destination.latitude,destination.longitude] forKey:@"Url"];
        [dict setObject:[NSNumber numberWithInt:AutoMapNavigation] forKey:@"MapType"];
        [dict setObject:@"高德地图" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    // 百度地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=%@&coord_type=gcj02",poiManager.myCoordinate.latitude,poiManager.myCoordinate.longitude,destination.latitude,destination.longitude,appname] forKey:@"Url"];
        [dict setObject:[NSNumber numberWithInt:BaiduMapNavigation] forKey:@"MapType"];
        [dict setObject:@"百度地图" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    // Google地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",poiManager.myCoordinate.latitude,poiManager.myCoordinate.longitude,destination.latitude,destination.longitude] forKey:@"Url"];
        [dict setObject:[NSNumber numberWithInt:GoogleMapNavigation] forKey:@"MapType"];
        [dict setObject:@"Google Maps" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    
    // 系统地图
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                     [[PositioningManager shared] myCoordinate].latitude,[[PositioningManager shared] myCoordinate].longitude,
                     title] forKey:@"Url"];
    [dict setObject:[NSNumber numberWithInt:AppleMapNavigation] forKey:@"MapType"];
    [dict setObject:@"苹果自带地图" forKey:@"Title"];
    [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
    [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
    [dict setObject:title forKey:@"Name"];
    [navList addObject:dict];
    
    [NavigationAction sharedInstance].navActions = navList;
    UIActionSheet *navActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:[NavigationAction sharedInstance] cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary *dict in navList) {
        [navActionSheet addButtonWithTitle:[dict objectForKey:@"Title"]];
    }
    [navActionSheet addButtonWithTitle:@"取消"];
    navActionSheet.cancelButtonIndex = navList.count;
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [navActionSheet showInView:appDelegate.window];
    [navActionSheet release];
}


+ (void)showAlertTitle:(NSString *)title Message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:_string(@"确定")  
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


+ (void)showAvailableMemory {
	vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) return;
	
	double availableNum = ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
	NSLog(@"<<%.f M can be used>>",availableNum);
}


+ (void)closeSesameInView:(UIView *)nowView {
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.window addSubview:appDelegate.startup.view];
	//appDelegate.startup.contentView = nowView;
    if (!IOSVersion_7){
        appDelegate.startup.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
	
	[appDelegate.startup animtadForClose];
}


+ (NSDictionary *)unCompressData:(NSData *)data {
    if (data.length > 0) {
        if (!IOSVersion_5) {
            LzssUncompress *uncompress = [[LzssUncompress alloc] init];
            NSString *string = [uncompress uncompress:data];
            [uncompress release];
            
            // 使用JOSNKIT框架解析
            NSDictionary *rootDic = [string JSONValue];
            
            return rootDic;
        }
        else {
            LzssUncompress *uncompress = [[LzssUncompress alloc] init];
            NSData *newData = [uncompress uncompressData:data];
            [uncompress release];
            
            // 使用系统自带的解析JOSN
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:&error];
            
            return dic;
        }
    }
    
    return nil;
}


+ (NSData *)getPassDateByType:(NSString *)type orderID:(NSString *)orderId cardNum:(NSString *)num lat:(NSString *)latitude lon:(NSString *)longitude {
    NSString *passURL = [NSString stringWithFormat:@"http://apiaff.elong.com/PassBook/%@.aspx?orderid=%@&cardno=%@&lat=%@&lon=%@",
                         type, orderId, num, latitude, longitude];
    NSData *passData = [NSData dataWithContentsOfURL:[NSURL URLWithString:passURL]];
    return passData;
}


+ (NSString *)getPassUrlByType:(NSString *)type orderID:(NSString *)orderId cardNum:(NSString *)num lat:(NSString *)latitude lon:(NSString *)longitude {
    NSString *passURL = [NSString stringWithFormat:@"http://apiaff.elong.com/PassBook/%@.aspx?orderid=%@&cardno=%@&lat=%@&lon=%@",
                         type, orderId, num, latitude, longitude];
    
    return passURL;
}

// 是否登录
+ (BOOL)  adjustIsLogin
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin)
    {
        if (appDelegate.isNonmemberFlow )
        {
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }
    
}



+ (BOOL)passHotelOn {
    return [ProcessSwitcher shared].hotelPassOn;
}


+ (BOOL)passGrouponOn {
    return [ProcessSwitcher shared].grouponPassOn;
}


+ (void)getLongVIPInfo {
    if ([[AccountManager instanse] isLogin]) {
        JPostHeader *postheader = [[JPostHeader alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
        HttpUtil *util = [[[HttpUtil alloc] init] autorelease];
        [util connectWithURLString:MYELONG_SEARCH Content:[postheader requesString:NO action:@"GetUseableCredits" params:dict] StartLoading:NO EndLoading:NO Delegate:[AccountManager instanse]];
        
        [dict release];
        [postheader release];
    }
}


+ (NSString *)getNormalTimeWithSeconds:(NSInteger)currentTime Format:(NSString *)format {
    int hours	= currentTime / 3600;
    int minutes = currentTime % 3600 / 60;
    int seconds = currentTime % 3600 % 60;
    int dayNum = hours / 24;
    if (dayNum > 0) {
        hours -= dayNum * 24;
    }
    
    NSMutableString *string = [NSMutableString stringWithCapacity:2];
    if (dayNum > 0 && [format rangeOfString:@"DD"].length > 0) {
        [string appendFormat:@"%d天", dayNum];
    }
    if (hours > 0 && [format rangeOfString:@"HH"].length > 0) {
        [string appendFormat:@"%d小时", hours];
    }
    if (minutes > 0 && [format rangeOfString:@"mm"].length > 0) {
        [string appendFormat:@"%d分", minutes];
    }
    if (seconds > 0 && [format rangeOfString:@"ss"].length > 0) {
        [string appendFormat:@"%d秒", seconds];
    }
    
    return string;
}

//检查当前网络连接是否正常
+ (BOOL)connectedToNetWork{
    
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    
    zeroAddress.sin_len = sizeof(zeroAddress);
    
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        
        printf("Error. Count not recover network reachability flags\n");
        
        return NO;
        
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? YES : NO;
    
}


// 拼装请求Url
+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service andParam:(NSString *)param
{
    if (business != nil && service != nil &&  param != nil)
    {
        NSString *body = [StringEncryption EncryptString:param byKey:NEW_KEY];
        body = [body URLEncodedString];
        
        // 组装url
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@?req=%@",[[ServiceConfig share] serverURL],business,service,body];
        
        return url;
    }
    
    return nil;
}


+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service
{
    if (business != nil && service != nil)
    {
        // 组装url
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@?",[[ServiceConfig share] serverURL], business, service];
        
        return url;
    }
    
    return nil;
}

// .net服务请求串拼接
+ (NSString *)requesString:(NSString *)actionName andIsCompress:(BOOL)iscompress andParam:(NSString *)param
{
    if (STRINGHASVALUE(actionName) && STRINGHASVALUE(param))
    {
        NSString *url = [NSString stringWithFormat:@"action=%@&version=1.2&compress=%@&req=%@",actionName,[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],param];
        
        return url;
    }
    
    return nil;
}



+ (void) wgs84ToGCJ_02WithLatitude:(double *)lat longitude:(double *)lon{
    const double a = 6378245.0f;
    const double ee = 0.00669342162296594323;
    
    double dLat = [PublicMethods transformLatX:*lon - 105.0 Y:*lat - 35.0];
    double dLon = [PublicMethods transformLonX:*lon - 105.0 Y:*lat - 35.0];
    double radLat = *lat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *lat = *lat + dLat;
    *lon = *lon + dLon;
}

+ (double)transformLatX:(double)x Y:(double)y{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double) transformLonX:(double)x Y:(double)y{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

+ (BOOL) needSwitchWgs84ToGCJ_02{
    // 特殊城市，香港，澳门
    FastPositioning *fastPositioning = [FastPositioning shared];
    if (!fastPositioning.specialCity && IOSVersion_6 && !fastPositioning.abroad) {
        // 在国内、非香港澳门、IOS6及其以上版本
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        NSString *cityName = [hotelsearcher cityName];
        
        NSArray *specialCity = [NSArray arrayWithObjects:@"香港",@"Hong Kong",@"澳门",@"Macau", nil];
        for (int i = 0; i < specialCity.count; i++) {
            NSRange range;
            range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
            if (range.length) {
                NSLog(@"国内酒店需要纠偏");
                return YES;
            }
        }
    }
    NSLog(@"国内酒店不需要需要纠偏");
    return NO;
}

+ (BOOL) needSwitchWgs84ToGCJ_02Abroad{
    FastPositioning *fastPositioning = [FastPositioning shared];
    if (!fastPositioning.specialCity && IOSVersion_6 && !fastPositioning.abroad) {
        // 在国内、非香港澳门、IOS6及其以上版本
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        NSString *cityName = searcher.cityDescription;
        
        NSArray *specialCity = [NSArray arrayWithObjects:@"香港",@"澳门", nil];
        for (int i = 0; i < specialCity.count; i++) {
            NSRange range;
            range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
            if (range.length) {
                NSLog(@"国际酒店需要纠偏");
                return YES;
            }
        }

    }
    NSLog(@"国际酒店不需要需要纠偏");
    return NO;
}

+ (BOOL) needSwitchWgs84ToGCJ_02Groupon{
    // 特殊城市，香港，澳门
    FastPositioning *fastPositioning = [FastPositioning shared];
    if (!fastPositioning.specialCity && IOSVersion_6 && !fastPositioning.abroad) {
        // 在国内、非香港澳门、IOS6及其以上版本
        GListRequest *listReq = [GListRequest shared];
        NSString *cityName = listReq.cityName;
        
        NSArray *specialCity = [NSArray arrayWithObjects:@"香港",@"澳门", nil];
        for (int i = 0; i < specialCity.count; i++) {
            NSRange range;
            range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
            if (range.length) {
                NSLog(@"国内团购需要纠偏");
                return YES;
            }
        }
    }
    NSLog(@"国内团购不需要需要纠偏");
    return NO;
}


+ (NSString *) getStar:(NSInteger)level{
    if (level < 3) {
        return  @"经济型";
    }else if(level >= 3 && level <= 5){
        if (level == 3) {
            return @"三星";
        }else if(level == 4){
            return @"四星";
        }else if(level == 5){
            return @"五星";
        }
    }else{
        float elongLevel = level/10.0f;
        if (elongLevel <= 3) {
            return @"舒适型";
        }else if(elongLevel > 3 && elongLevel < 4){
            return @"高档型";
        }else if(elongLevel >= 4){
            return @"豪华型";
        }
    }
    return @"";
}

//得到评论描述
+(NSString *) getCommentDespLogic:(int) goodComment badComment:(int) badComment comentPoint:(float) commentPoint
{
    return [NSString stringWithFormat:@"%.0f%% 好评",commentPoint*100];
    
//    //是否保留？？？
//    if (goodComment + badComment == 0) {
//        return @"暂无评论";
//    }
//    else if (goodComment == 0)
//    {
//        return [NSString stringWithFormat:@"%d条评论",badComment];
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%.0f%% 好评",commentPoint*100];
//    }
}

//得到评论描述
+(NSString *) getCommentDespOldLogic:(int) goodComment badComment:(int) badComment
{
    // 计算好评率 四舍五入
    NSInteger favRate = 0;
    if (goodComment + badComment == 0) {
        favRate = 0;
    }else{
        favRate = ceil(goodComment * 100/ (goodComment + badComment + 0.0f));
    }
    
    if (goodComment + badComment == 0) {
        return @"暂无评论";
    }
    else if (goodComment == 0) {
        return [NSString stringWithFormat:@"%d条评论",badComment];
    }else{
        return [NSString stringWithFormat:@"%d%% 好评",favRate];
    }
}

+ (NSString *) getHouseStar:(NSInteger)level{
    if (level < 3) {
        return  @"公寓";
    }else if(level >= 3 && level <= 5){
        if (level == 3) {
            return @"舒适公寓";
        }else if(level == 4){
            return @"高档公寓";
        }else if(level == 5){
            return @"豪华公寓";
        }
    }else{
        float elongLevel = level/10.0f;
        if (elongLevel <= 3) {
            return @"舒适公寓";
        }else if(elongLevel > 3 && elongLevel < 4){
            return @"高档公寓";
        }else if(elongLevel >= 4){
            return @"豪华公寓";
        }
    }
    return @"";
}

+ (NSString *) getHomeItemName:(NSInteger)tag{
    NSInteger name = @"";
    switch (tag) {
        case 1410:  //机票
            name = @"flight";
            break;
        case 1420:  // 火车票
            name =  @"ticket";
            break;
        case 1431:  // 个人中心
            name =  @"usercenter";
            break;
        case 1432:  // 电话
            name = @"callus";
            break;
        case 1433:  // 自定义模块
            name = @"add";
            break;
        case 1440:  // 航班动态
            name =  @"flightinfo";
            break;
        case 1450:  // 旅行清单
            name =  @"travelpackage";
            break;
        case 1460:  // 汇率换算
            name = @"exchangerate";
            break;
        case 1470:  // 用车
            name =  @"car";
            break;
        case 1480:  // 旅游指南
            name = @"travelguide";
            break;
        case 1490:  // 每日特惠
            name =  @"specialoffer";
            break;
        case 1200:  // 酒店
            name = @"hotel";
            break;
        case 1300:  // 团购
            name = @"groupbuy";
            break;
        default:
            name = @"other";
            break;
    }
    return name;
}

+ (NSInteger) getHomeItemType:(NSInteger)tag{
    NSInteger type = -1;
    switch (tag) {
        case 1410:  //机票
            type = 6;
            break;
        case 1420:  // 火车票
            type = 8;
            break;
        case 1431:  // 个人中心
            type = 11;
            break;
        case 1432:  // 电话
            type = 12;
            break;
        case 1433:  // 自定义模块
            type = 13;
            break;
        case 1440:  // 航班动态
            type = 1;
            break;
        case 1450:  // 旅行清单
            type = 2;
            break;
        case 1460:  // 汇率换算
            type = 3;
            break;
        case 1470:  // 用车
            type = 4;
            break;
        case 1480:  // 旅游指南
            type = 9;
            break;
        case 1490:  // 每日特惠
            type = 10;
            break;
        case 1200:  // 酒店
            type = 5;
            break;
        case 1300:  // 团购
            type = 7;
            break;
        default:
            type = -1;
            break;
    }
    return type;
}


+ (NSString *)getCityIDWithCity:(NSString *)cityName{
	NSString *plistPath = [HotelCityUpdater getCityListPlistName:@"hotelcity"];
	NSDictionary *dictionary  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	for (NSArray *keyArray in [dictionary allValues]) {
		for (NSArray *cityArray in keyArray) {
			if ([[cityArray safeObjectAtIndex:0] isEqualToString:cityName]) {
				return [cityArray lastObject];
			}
		}
	}
	return @"";
}

+ (BOOL) isHotCity:(NSString *)cityName{
    NSString *plistPath = [HotelCityUpdater getCityListPlistName:@"hotelcity"];
	NSDictionary *dictionary  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSArray *hotcitys = [dictionary objectForKey:@"热门"];
    
	for (NSArray *cityArray in hotcitys) {
        if ([[cityArray safeObjectAtIndex:0] isEqualToString:cityName]) {
            return YES;
        }
    }
	return NO;
}

+ (NSInteger) getMaxPriceLevel:(NSInteger)price{
    switch (price) {
        case -1:
            return 4;
        case 0:
            return 0;
        case 150:
            return 1;
        case 300:
            return 2;
        case 500:
            return 3;
        case GrouponMaxMaxPrice:
            return 4;
        default:
            return 4;
    }
}

+ (NSInteger) getMinPriceLevel:(NSInteger)price{
    switch (price) {
        case -1:
            return 0;
        case 0:
            return 0;
        case 150:
            return 1;
        case 300:
            return 2;
        case 500:
            return 3;
        case GrouponMaxMaxPrice:
            return 4;
        default:
            return 0;
    }
}

+ (NSInteger) getMinPriceByLevel:(NSInteger)level{
    switch (level) {
        case 0:
            return 0;
        case 1:
            return 150;
        case 2:
            return 300;
        case 3:
            return 500;
        case 4:
            return GrouponMaxMaxPrice;
        default:
            return -1;
    }
}

+ (NSInteger) getMaxPriceByLevel:(NSInteger)level{
    switch (level) {
        case 0:
            return 0;
        case 1:
            return 150;
        case 2:
            return 300;
        case 3:
            return 500;
        case 4:
            return GrouponMaxMaxPrice;
        default:
            return -1;
    }
}


+ (void)saveSearchKey:(NSString *)key forCity:(NSString *)city {    
    [self saveSearchKey:key type:nil propertiesId:nil lat:nil lng:nil forCity:city];
}

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSNumber *)pid lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city{
    NSMutableDictionary *hotelSearchKeywordDict = nil;
    NSObject* hotelSearchKeywordObj = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
    if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
        hotelSearchKeywordDict = [NSMutableDictionary dictionary];
    }else{
        hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
    }
    
    if (STRINGHASVALUE(key) && STRINGHASVALUE(city)) {
        NSMutableArray *hotelSearchKeywordArray = [NSMutableArray arrayWithArray:[hotelSearchKeywordDict objectForKey:city]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict safeSetObject:key forKey:@"Name"];
        if (type) {
            [dict setObject:type forKey:@"Type"];
        }
        if (pid) {
            [dict setObject:pid forKey:@"PropertiesId"];
        }
        if (lat) {
            [dict setObject:lat forKey:@"Lat"];
        }
        if (lng) {
            [dict setObject:lng forKey:@"Lng"];
        }
        
        if (![hotelSearchKeywordArray containsObject:dict]) {
            [hotelSearchKeywordArray insertObject:dict atIndex:0];
            
            while (hotelSearchKeywordArray.count > HOTEL_KEYWORDHISTORY_NUM) {
                [hotelSearchKeywordArray removeLastObject];
            }
            
            [hotelSearchKeywordDict setObject:hotelSearchKeywordArray forKey:city];
            [[ElongUserDefaults sharedInstance] setObject:hotelSearchKeywordDict forKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        }
    }
}

+ (NSArray *) allSearchKeysForCity:(NSString *)city{
    if (STRINGHASVALUE(city)) {
        NSMutableDictionary *hotelSearchKeywordDict = nil;
        NSObject* hotelSearchKeywordObj = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
            return [NSArray array];
        }else{
            hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
        }
        if ([hotelSearchKeywordDict objectForKey:city]) {
            return [hotelSearchKeywordDict objectForKey:city];
        }
    }
    return [NSArray array];
}

+ (void) clearSearchKeyforCity:(NSString *)city{
    if (STRINGHASVALUE(city)) {
        NSMutableDictionary *hotelSearchKeywordDict = nil;
        NSObject* hotelSearchKeywordObj = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
            return;
        }else{
            hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
        }
        if ([hotelSearchKeywordDict objectForKey:city]) {
            [hotelSearchKeywordDict removeObjectForKey:city];
        }
        [[ElongUserDefaults sharedInstance] setObject:hotelSearchKeywordDict forKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
    }
}

//下单后发送订单号以及坐标等信息给服务器
+(void)saveHotelOrderGpsWithOrderNo:(NSString *)orderNo HotelLat:(float)hotelLat HotelLon:(float)hotelLon{
    NSMutableDictionary *tmpDic  = [NSMutableDictionary dictionaryWithCapacity:1];
    [tmpDic safeSetObject:[PostHeader header] forKey:@"Header"];
    
    int orderNum = [orderNo intValue];
    [tmpDic safeSetObject:[NSNumber numberWithInt:orderNum] forKey:@"OrderNo"];
    
    NSDictionary *hotelGps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:hotelLat],@"Latitude",[NSNumber numberWithFloat:hotelLon],@"Longitude", nil];
    [tmpDic safeSetObject:hotelGps forKey:@"HotelGPS"];
    
    float userLat = [[PositioningManager shared] myCoordinate].latitude;
    float userLon = [[PositioningManager shared] myCoordinate].longitude;
    NSDictionary *userGps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:userLat],@"Latitude",[NSNumber numberWithFloat:userLon],@"Longitude", nil];
    [tmpDic safeSetObject:userGps forKey:@"UserGPS"];
    
    NSString *requestContent = [NSString stringWithFormat:@"action=SaveHotelOrderGPS&compress=%@&req=%@",@"true",[tmpDic JSONRepresentationWithURLEncoding]];
    
    HttpUtil *saveOrderUtil = [[HttpUtil alloc] init];
    [saveOrderUtil connectWithURLString:HOTELSEARCH Content:requestContent StartLoading:NO EndLoading:NO Delegate:nil];
    [saveOrderUtil release];
}


#pragma mark - 支付宝支付

//是否可以支付宝app支付
+(BOOL) couldPayByAlipayApp
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]])
    {
        return YES;
    }
    
    return NO;
}

//支付宝app支付
+(void) payByAlipayApp:(NSString *) alipayUrl
{
    NSString *appScheme = @"elongIPhone";
    //获取安全支付单例并调用安全支付接口
    AlixPay * alixpay = [AlixPay shared];
    int ret = [alixpay pay:alipayUrl applicationScheme:appScheme];
    if (ret == kSPErrorSignError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

//根据字体获得高度
+(float)labelHeightWithString:(NSString *)text Width:(int)width font:(UIFont *)font{
    CGSize fontSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    int height = fontSize.height<=21?21:fontSize.height+4;
    return height;
}

//屏蔽掉一行字符串中的空格、换行、回车
+(NSString *)dealWithStringForRemoveSpaces:(NSString *)aStr{
    NSString *result = [aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return result;
}

@end

#pragma mark -


@implementation NSObject (Public)

- (NSUInteger)safeCount
{
    if ([self isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)self count];
    }
    else if ([self isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)self count];
    }
    else
    {
        return 0;
    }
}


- (NSString *)JSONRepresentation {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self JSONString];
    }
    else if ([self isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self JSONString];
    }
    else if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self JSONString];
    }
    
    return nil;
}


- (NSString *)JSONRepresentationWithURLEncoding {
    CFStringRef cfResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																   (CFStringRef)[self JSONRepresentation],
																   NULL,
																   CFSTR("&=@;!'*#%-,:/()<>[]{}?+ "),
																   kCFStringEncodingUTF8);
	
    if (cfResult) {
        NSString *result = [NSString stringWithString:(NSString *)cfResult];
        CFRelease(cfResult);
        return result;
    }
	
    return @"";
}

@end


@implementation UIApplication (Public)

- (BOOL)newOpenURL:(NSURL*)url {
    if ([[ServiceConfig share] monkeySwitch]) {
        return NO;
    }
    
    return [self openURL:url];
}

@end


@implementation UIImage (Elong)

+ (UIImage *)noCacheImageNamed:(NSString *)name {
    if (!name || [name isEqualToString:@""]) {
        return nil;
    }
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	
	return image;
}


+ (UIImage *)stretchableImageWithPath:(NSString *)path {
	UIImage *stretchImg = [UIImage imageNamed:path];
	return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
										   topCapHeight:stretchImg.size.height / 2];
}


- (id)compressImageWithSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
	[self drawInRect:imageRect];
	self = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return self;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
@end


@implementation UIColor(Public)

+ (UIColor *)colorWithHexStr:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end


@implementation UIImageView (Elong)

+ (UIImageView *)roundCornerViewWithFrame:(CGRect)rect {
	UIImageView *backView = [[UIImageView alloc] initWithFrame:rect];
	backView.image					= [[UIImage imageNamed:@"white_boder.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:12];
	backView.userInteractionEnabled = YES;
	return [backView autorelease];
}


+ (UIImageView *)graySeparatorWithFrame:(CGRect)rect {
	UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
	separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
	separatorLine.clipsToBounds = YES;
	separatorLine.frame			= rect;
	
	return [separatorLine autorelease];
}


+ (UIImageView *)dashedHalfLineWithFrame:(CGRect)rect
{
	UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed_half.png"]];
	separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
	separatorLine.clipsToBounds = YES;
	separatorLine.frame			= rect;
	
	return [separatorLine autorelease];
}

+(UIImageView *)separatorWithFrame:(CGRect)rect{
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
	separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
	separatorLine.clipsToBounds = YES;
	separatorLine.frame			= CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height / [UIScreen mainScreen].scale);
	
	return [separatorLine autorelease];
}


+ (UIImageView *)verticalSeparatorWithFrame:(CGRect)rect {
	UIImageView *graySeparator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_separator.png"]];
	graySeparator.frame = rect;
	
	return [graySeparator autorelease];
}


+ (UIImageView *)bottomSeparatorWithFrame:(CGRect)rect {
	UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBar_separator.png"]];
	separator.frame = rect;
	
	return [separator autorelease];
}

@end


@implementation UIView (Public)

#define kTipImageTag  10086

+ (id)clearViewWithFrame:(CGRect)rect {
	UIView *clearView = [[UIView alloc] initWithFrame:rect];
	clearView.backgroundColor = [UIColor clearColor];
	return [clearView autorelease];
}


- (void)endLoading {
	for (UIActivityIndicatorView *aView in self.subviews) {
		if ([aView isKindOfClass:[UIActivityIndicatorView class]]) {
			[aView removeFromSuperview];
            aView = nil;
		}
	}
}


- (void)endUniformLoading {
    for (SmallLoadingView *aView in self.subviews) {
		if ([aView isMemberOfClass:[SmallLoadingView class]]) {
            [aView removeFromSuperview];
            aView = nil;
		}
	}
}


- (void)removeTipMessage {
	UIImageView *backView = (UIImageView *)[self viewWithTag:kTipImageTag];
	if (backView) {
		[backView removeFromSuperview];
	}
}


- (void)showTipMessage:(NSString *)tips {
	UIImageView *backView	= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//	backView.image			= [UIImage noCacheImageNamed:@"round_bg.png"];
	backView.tag			= kTipImageTag;
	
	UILabel *tipLabel			= [[UILabel alloc] initWithFrame:backView.frame];
	tipLabel.backgroundColor	= [UIColor clearColor];
	tipLabel.text				= tips;
	tipLabel.textAlignment		= UITextAlignmentCenter;
	tipLabel.font				= [UIFont boldSystemFontOfSize:16];
	
	[backView addSubview:tipLabel];
	backView.center	= CGPointMake(SCREEN_WIDTH / 2, MAINCONTENTHEIGHT / 2 - 20);
	[self insertSubview:backView atIndex:0];
	
	[backView release];
	[tipLabel release];
}


- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style {
	[self startLoadingByStyle:style AtPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
}


- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style AtPoint:(CGPoint)activityCenter {
    for (UIActivityIndicatorView *aView in self.subviews) {
        // 这里是对ios6的特殊处理
		if ([aView isKindOfClass:[UIActivityIndicatorView class]]) {
            [aView startAnimating];
			return;
		}
	}
	
	UIActivityIndicatorView *aiView	= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	aiView.center					= activityCenter;
	
	[aiView startAnimating];
	[self addSubview:aiView];
	[aiView release];
}


- (void)startUniformLoading {
    for (SmallLoadingView *aView in self.subviews) {
		if ([aView isMemberOfClass:[SmallLoadingView class]]) {
            // 已经有时就不再添加
			return;
		}
	}
    
    SmallLoadingView *smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (self.frame.size.height-50) / 2, 50, 50)];
    [self addSubview:smallLoading];
	[smallLoading startLoading];
    [smallLoading release];
}


- (UIImage *) imageByRenderingViewWithSize:(CGSize) size {
	CGFloat oldAlpha = self.alpha;
	
	self.alpha = 1;
	UIGraphicsBeginImageContext(size);
	self.layer.masksToBounds = NO;
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.alpha = oldAlpha;
	
	return resultingImage;
}


#define	TEXT_FIELD_ALERT_TAG		89898

- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect arrowStartPoint:(CGPoint)point {
	AlertTipView *alertTip = (AlertTipView *)[self viewWithTag:TEXT_FIELD_ALERT_TAG];
	if (alertTip) {
		[self removeAlert];
		alertTip = nil;
	}
	
	alertTip = [[AlertTipView alloc] initWithFrame:rect startPoint:point];
	alertTip.tipString = tipString;
	alertTip.stringColor = [UIColor redColor];
	alertTip.tag = TEXT_FIELD_ALERT_TAG;
	[self addSubview:alertTip];
	[alertTip release];
}


- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect {
	[self alertMessage:tipString InRect:rect arrowStartPoint:CGPointMake(self.bounds.size.width / 2, rect.origin.y)];
}


- (void)alertMessage:(NSString *)tipString {
	[self alertMessage:tipString InRect:CGRectMake(0, self.frame.size.height - 8, self.frame.size.width, 30)];
}


- (void)removeAlert {
	AlertTipView *alertTip = (AlertTipView *)[self viewWithTag:TEXT_FIELD_ALERT_TAG];
	[alertTip removeFromSuperview];
}

@end


@implementation UIViewController (Public)

- (void)addTopShadow {
	UIImageView *shaowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shadow.png"]];
	[shaowView setFrame:CGRectMake(0, 0, 320, 11)];

	[self.view addSubview:shaowView];
	[shaowView release];
}



@end


@implementation UIButton (Public)

+ (UIButton *)checkcodeButtonWithTarget:(id)target
                                 Action:(SEL)selector
                                  Frame:(CGRect)rect
{
    UIButton *checkcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkcodeBtn.frame = rect;
    checkcodeBtn.titleLabel.font = FONT_14;
	[checkcodeBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [checkcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkcodeBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"checkcode_btn.png"] forState:UIControlStateNormal];
    
    return checkcodeBtn;
}

// 返回黄底白字的18号大小的按钮
+ (UIButton *)yellowWhitebuttonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
	UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[commitButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
	[commitButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
	[commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[commitButton setTitle:title forState:UIControlStateNormal];
	[commitButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	commitButton.titleLabel.font	= FONT_B18;
	commitButton.frame				= rect;

	return commitButton;
}


+ (UIButton *)blueWhitebuttonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
	UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[commitButton setBackgroundImage:[[UIImage imageNamed:@"nonMember_login_btn_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
	[commitButton setBackgroundImage:[[UIImage imageNamed:@"nonMember_login_btn_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
	[commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[commitButton setTitle:title forState:UIControlStateNormal];
	[commitButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	commitButton.titleLabel.font	= FONT_B18;
	commitButton.frame				= rect;
	
	return commitButton;
}


+ (UIButton *)arrowButtonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect Orientation:(ArrowOrientation)Orientation {
	UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipButton.backgroundColor = [UIColor whiteColor];
	[tipButton setTitle:title forState:UIControlStateNormal];
	[tipButton setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
	[tipButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[tipButton setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
	tipButton.frame	= rect;
	
	UIImage *arrow = nil;
	int offX = 0;
	switch (Orientation) {
		case ArrowOrientationDown:
			arrow	= [UIImage imageNamed:@"ico_downarrow.png"];
			offX	= 8;
			break;
		case ArrowOrientationRight:
			arrow	= [UIImage imageNamed:@"ico_rightarrow.png"];
			offX	= 5;
			break;
		case PlusSign:
			arrow	= [UIImage imageNamed:@"addSign.png"];
			offX	= 0;
			break;

		default:
			break;
	}
	
	UIImageView *rightArrow = [[UIImageView alloc] initWithImage:arrow];
	rightArrow.frame = CGRectMake(rect.size.width - offX - arrow.size.width, rect.size.height/2 - arrow.size.height/2, arrow.size.width, arrow.size.height);
	[tipButton addSubview:rightArrow];
	[rightArrow release];
	
	return tipButton;
}


+ (UIButton *)uniformButtonWithTitle:(NSString *)title 
						   ImagePath:(NSString *)path 
							  Target:(id)target 
							  Action:(SEL)selector
							   Frame:(CGRect)rect
{
	UIButton *commitButton = [UIButton yellowWhitebuttonWithTitle:@"" 
														   Target:target
														   Action:selector
															Frame:rect];
	float contentLength = 0.f;		// 图片文字总长度
	int	distance = 10;				// 图片文字距离
    
    
    if (path == nil || [path isEqualToString:@""]) {
        distance = 0;
    }
	
	UIImage *icon = [UIImage noCacheImageNamed:path];
    
	contentLength += icon.size.width + distance;
	
	CGSize size = [title sizeWithFont:FONT_B18];
	contentLength += size.width;
   
	
	UIImageView *nextImage = [[UIImageView alloc] initWithImage:icon];
	nextImage.frame = CGRectMake((commitButton.frame.size.width - contentLength)/2,
								 (commitButton.frame.size.height - icon.size.height)/2,
								 icon.size.width,
								 icon.size.height);
	[commitButton addSubview:nextImage];
	[nextImage release];
    
    
    
    
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(nextImage.frame.origin.x + nextImage.frame.size.width + distance,
															   (commitButton.frame.size.height - size.height) / 2, 
															   size.width,
															   size.height)];
	label.text				= title;
	label.textColor			= [UIColor whiteColor];
	label.font				= FONT_B18;
	label.backgroundColor	= [UIColor clearColor];
	[commitButton addSubview:label];
	[label release];
	
	return commitButton;
}


+ (UIButton *)uniformBottomButtonWithTitle:(NSString *)title 
								 ImagePath:(NSString *)path 
									Target:(id)target 
									Action:(SEL)selector
									 Frame:(CGRect)rect
{
	UIButton *button = [UIButton uniformButtonWithTitle:title
											  ImagePath:path
												 Target:target
												 Action:selector
												  Frame:rect];
	
	[button setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn.png"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn_press.png"] forState:UIControlStateHighlighted];
	
	return button;
}


+ (UIButton *)uniformMoreButtonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
	UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
	morebutton.adjustsImageWhenHighlighted = NO;
	
	[morebutton setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forState:UIControlStateNormal];
	[morebutton setContentMode:UIViewContentModeScaleToFill];
	[morebutton setFrame:rect];
	[morebutton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    
    [morebutton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [morebutton setTitle:[NSString stringWithFormat:@"%@...",title] forState:UIControlStateNormal];
    [morebutton setTitleColor:[UIColor colorWithRed:52/255.0 green:52/255.0f blue:52/255.0f alpha:1] forState:UIControlStateNormal];
    [morebutton setTitleColor:[UIColor colorWithRed:52/255.0 green:52/255.0f blue:52/255.0f alpha:1] forState:UIControlStateHighlighted];
	
	return morebutton;
}

@end


@implementation UITextView (Public)

#define	TEXT_FIELD_ALERT_TAG		89898

- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect arrowStartPoint:(CGPoint)point {
	AlertTipView *alertTip = (AlertTipView *)[self viewWithTag:TEXT_FIELD_ALERT_TAG];
	if (alertTip) {
		[self removeAlert];
		alertTip = nil;
	}
	
	alertTip = [[AlertTipView alloc] initWithFrame:rect startPoint:point];
	alertTip.tipString = tipString;
	alertTip.stringColor = [UIColor redColor];
	alertTip.tag = TEXT_FIELD_ALERT_TAG;
	[self addSubview:alertTip];
	[alertTip release];
}


- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect {
	[self alertMessage:tipString InRect:rect arrowStartPoint:CGPointMake(self.bounds.size.width / 2, rect.origin.y)];
}


- (void)alertMessage:(NSString *)tipString {
	[self alertMessage:tipString InRect:CGRectMake(0, self.frame.size.height - 10, self.frame.size.width, 30)];
}


- (void)removeAlert {
	AlertTipView *alertTip = (AlertTipView *)[self viewWithTag:TEXT_FIELD_ALERT_TAG];
	[alertTip removeFromSuperview];
}

@end

@implementation UIBarButtonItem (Public)

+ (id)navBarLeftButtonItemWithTitle:(NSString *)title
                         Target:(id)target
                         Action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn.adjustsImageWhenDisabled = NO;
    btn.titleLabel.font = FONT_B15;
    btn.titleLabel.textAlignment = UITextAlignmentLeft;

    switch (title.length)
    {
        case 2:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 16);
            break;
        case 3:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
            break;
        default:
            break;
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_NAV_BIN_TITLE_DISABLE forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn release];	
    
    return [item autorelease];
}


+ (id)navBarRightButtonItemWithTitle:(NSString *)title
                          Target:(id)target
                          Action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn.adjustsImageWhenDisabled = NO;
    btn.titleLabel.font = FONT_B15;
    btn.titleLabel.textAlignment = UITextAlignmentRight;
    
    switch (title.length)
    {
        case 2:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
            break;
        case 3:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
            break;
        default:
            break;
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_NAV_BIN_TITLE_DISABLE forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn release];
    
    return [item autorelease];
}


+ (id)uniformWithTitle:(NSString *)title Style:(BarButtonStyle)style Target:(id)target Selector:(SEL)method {
    float width = 50;
    if (title.length >= 4) {
        width = 70;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, TABITEM_DEFALUT_HEIGHT)];

	[button.titleLabel setFont:FONT_B16];
	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    if (style == BarButtonStyleCancel) {
        [Utils setButton:button normalImage:@"white_btn_normal.png" pressedImage:@"white_btn_press.png"];
        [button setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    else {
        [Utils setButton:button normalImage:@"white_btn_press.png" pressedImage:@"white_btn_normal.png"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_NAV_TITLE forState:UIControlStateHighlighted];
    }
	
	UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[button release];
    
    return [buttonItem autorelease];
}


+ (id)navBarTwoButtonItemWithTarget:(id)target
                     leftButtonIcon:(NSString *)leftIconPath
                   leftButtonAction:(SEL)leftSelector
                          rightIcon:(NSString *)rightIconPath
                  rightButtonAction:(SEL)rightSelector
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    NSInteger offX = 3;
    // 左按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:target action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(offX, (buttonView.frame.size.height - NAVBAR_ITEM_HEIGHT) / 2, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT);
    [leftBtn setImage:[UIImage noCacheImageNamed:leftIconPath] forState:UIControlStateNormal];
    
    // 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(offX + NAVBAR_ITEM_WIDTH + 2, leftBtn.frame.origin.y, 35, NAVBAR_ITEM_HEIGHT);
    [rightBtn addTarget:target action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage noCacheImageNamed:rightIconPath] forState:UIControlStateNormal];
    
    [buttonView addSubview:leftBtn];
    [buttonView addSubview:rightBtn];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    return [buttonItem autorelease];
}

@end


@implementation UINavigationItem (Public)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if (IOSVersion_7)
    {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -12;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[spaceButtonItem]];
        }
        [spaceButtonItem release];
    }
    else
    {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}


- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if (IOSVersion_7)
    {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -12;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
        }
        else
        {
            [self setRightBarButtonItems:@[spaceButtonItem]];
        }
        [spaceButtonItem release];
    }
    else
    {
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}
#endif

@end


@implementation NSNumber (Public)

- (NSString *)roundNumberToString {
    if ([self isKindOfClass:[NSNumber class]]) {
        int num =  (int)round([self floatValue]);
        return [NSString stringWithFormat:@"%d",num];
    }
	else {
        return @"null";
    }
}


- (NSInteger)safeIntValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self intValue];
    }
    
    return 0;
}


- (CGFloat)safeFloatValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self floatValue];
    }
    
    return 0.0f;
}


- (CGFloat)safeDoubleValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self doubleValue];
    }
    
    return 0.0f;
}


- (BOOL)safeBoolValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self boolValue];
    }
    
    return FALSE;
}

@end


@implementation NSString (Elong)

- (id)JSONValue {
    return [self mutableObjectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
}

- (NSString *)stringByPattern:(NSString *)format {
	return [self stringByMatching:format];
}

- (NSString *)md5Coding
{
    const char *str = [self UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)stringByReplaceWithAsteriskToIndex:(NSInteger)length {
	return [NSString stringWithFormat:@"%@%@",[@"**********************************************" substringToIndex:length],
					 [self substringFromIndex:length]];
}

- (NSString *)stringByReplaceWithAsteriskFromIndex:(NSInteger)length {
	return [[self substringToIndex:length] stringByPaddingToLength:self.length withString:@"*" startingAtIndex:0];
}

- (NSString *)stringWithCreditFromat {
	NSMutableString *mString = [NSMutableString stringWithCapacity:2];
	for (int i = 0; i < self.length; i ++) {
		unichar character = [self characterAtIndex:i];
		if ((i + 1) % 4 == 0) {
			[mString appendFormat:@"%c   ",character];
		}
		else {
			[mString appendFormat:@"%c ", character];
		}
	}
	
	return mString;
}

// 手机号部分隐藏
- (NSString *)stringPhoneCodeHidden
{
    NSRange range = NSMakeRange(3, 4);
    if ([self length] < (range.location+range.length))
    {
        return self;
    }
    else
    {
        return  [self stringByReplacingCharactersInRange:range withString:@"****"];
    }
}

- (NSString *)stringByInsertingWithFormat:(NSString *)format perDigit:(NSInteger)digit {
	NSMutableString *mString = [NSMutableString stringWithCapacity:2];
	for (int i = 0, count = 0; i < self.length; i ++) {
		unichar character = [self characterAtIndex:i];
		if ((i + 1) % digit == 0) {
			// 除最后一位外，都加上分隔符
			[mString appendFormat:@"%c%@", character, format];
			count ++;
		}
		else {
			[mString appendFormat:@"%c", character];
		}
	}
	
	return mString;
}

- (NSString *)addHtmlPhoneMark {
	NSMutableString *htmlStr = [NSMutableString stringWithString:self];
	NSArray *phoneArray = [htmlStr componentsMatchedByRegex:REGULATION_PHONE];
	
	for (NSString *str in phoneArray) {
		[htmlStr replaceOccurrencesOfString:str
								 withString:[NSString stringWithFormat:@"<a href=\"tel:%@\" tel:%@>%@</a>", str, str, str] 
									options:NSCaseInsensitiveSearch 
									  range:NSMakeRange(0, htmlStr.length)];
	}
	
	return htmlStr;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
	
	NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
	NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
	NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
	NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
														   mutabilityOption:NSPropertyListImmutable 
																	 format:NULL
														   errorDescription:NULL];
	
	return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


- (NSString *)htmlStringWithFont:(NSString *)family textSize:(CGFloat)size textColor:(NSString *)color {
	return [NSString stringWithFormat:@"<html><style type=\"text/css\">body {font-family: \"%@\";font-size: %f;color: %@}</style><body>%@</body></html>",
			family, size, color, self];
}


- (NSString *)sensitiveWord
{
    if (STRINGHASVALUE(self))
    {
        NSString *regexStr = [self stringByAppendingString:@","];   // 加上逗号，匹配时变为绝对匹配
        
        if ([WebAppUtil isMatchRegex:sensitiveWord regexStr:regexStr])
        {
            return self;
        }
    }
    
    return nil;
}

@end

@implementation NSData (Elong)

- (NSString*)md5Coding
{
    unsigned char result[16];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
