    //
//  Setting.m
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 DP. All rights reserved.
//

#import "Setting.h"

static NSString *const AUTO_LOGIN		= @"AUTO_LOGIN";

@interface Setting(){
@private
    int m_hotelListCount;
	int m_flightlistCount;
	BOOL m_displayHotelPic;
	BOOL remAccount;
	BOOL remPassword;
	BOOL autoLogin;						// 是否自动登录
	BOOL mapPriority;					// 周边查询页面是否优先显示地图模式
}
@property (nonatomic,copy) NSString *m_departCity;
@property (nonatomic,copy) NSString *m_account;
@property (nonatomic,copy) NSString *m_password;
@property (nonatomic,copy) NSString *m_defaultClassType;
@end

@implementation Setting

- (void) dealloc{
    self.m_departCity = nil;
    self.m_account = nil;
    self.m_password = nil;
    self.m_defaultClassType = nil;
    [super dealloc];
}


-(int)defaultHotelListCount{
	return m_hotelListCount;
}
-(int)defaultFlightListCount{
	return m_flightlistCount;
}
-(BOOL)defaultDisplayHotelPic{
	return m_displayHotelPic;
}
-(NSString *)defaultDepartCity{
	return self.m_departCity;
}
-(NSString *)defaultAccount{
	return self.m_account;
}
-(NSString *)defaultPwd{
	return self.m_password;
}
-(NSString *)defaultClassType{
	return self.m_defaultClassType;
}

-(BOOL)isRemAccount{
	return remAccount;
}
-(BOOL)isRemPassword{
	return remPassword;
}

-(BOOL)getMapPriority {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"MapPriority"]) {
		return [[defaults objectForKey:@"MapPriority"] boolValue];
	}
	else {
		return NO;
	}
}

-(void)setDisplayPhotoIn2G:(BOOL)display{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:display] forKey:@"DisplayPhotoIn2G"];
	[defaults synchronize];
}

-(BOOL)displayPhotoIn2G{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"DisplayPhotoIn2G"]) {
        return [[defaults objectForKey:@"DisplayPhotoIn2G"] boolValue];
    }else{
        return YES;
    }
}

-(BOOL)displayHotelPic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"DisplayHotelPic"]) {
        return [[defaults objectForKey:@"DisplayHotelPic"] boolValue];
    }else{
        return YES;
    }
}


-(void)setHotelListCount:(int)count{	
	m_hotelListCount=count;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:m_hotelListCount] forKey:@"HotelListCount"];
	[defaults synchronize];
}
-(void)setFlightListCount:(int)count{
	m_flightlistCount=count;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:m_flightlistCount] forKey:@"FlightlistCount"];
	[defaults synchronize];
}
-(void)setDisplayHotelPic:(BOOL)display{
	m_displayHotelPic=display;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:m_displayHotelPic] forKey:@"DisplayHotelPic"];

	[defaults synchronize];
	
}
-(void)setDepartCity:(NSString *)departCity{
	self.m_departCity=departCity;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.m_departCity forKey:@"DepartCity"];
	[defaults synchronize];
}

-(void)setRemAccount:(BOOL)save{
	remAccount=save;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:remAccount] forKey:@"RemAccount"];
	
	[defaults synchronize];
	
}

-(void)setRemPassword:(BOOL)save{
	remPassword=save;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:remPassword] forKey:@"RemPassword"];
	
	[defaults synchronize];
	
}


- (void)setAutoLogin:(BOOL)animated {
	autoLogin = animated;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:animated] forKey:AUTO_LOGIN];
	[defaults synchronize];
}

- (BOOL)isAutoLogin {
	return autoLogin;
}

-(void)setAccount:(NSString *)account{
	self.m_account=account;
    /*
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.m_account forKey:@"Account"];
	[defaults synchronize];
     */
    [[ElongKeychain sharedInstance] setObject:account forKey:KEYCHAIN_ACCOUNT];
    
}

-(void)setMapPriority:(BOOL)animated {
	mapPriority = animated;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:mapPriority] forKey:@"MapPriority"];
	[defaults synchronize];
}

-(void)setPwd:(NSString *)pwd{
	self.m_password=pwd;
    /*
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.m_password forKey:@"Password"];
	[defaults synchronize];
     */
    [[ElongKeychain sharedInstance] setObject:pwd forKey:KEYCHAIN_PASSWORD];
}

-(void)setClassType:(NSString *)classtype{
	self.m_defaultClassType=[classtype retain];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.m_defaultClassType forKey:@"ClassType"];
	[defaults synchronize];
}

- (void) clearPwd{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"Password"];
	[defaults synchronize];
    
    [[ElongKeychain sharedInstance] removeObjectForKey:KEYCHAIN_PASSWORD];
}

-(id)init{
	if (self=[super init]) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

		NSString *DepartCity = [defaults objectForKey:@"DepartCity"];
		NSString *Account = [defaults objectForKey:@"Account"];
		NSNumber *DisplayHotelPic = [defaults objectForKey:@"DisplayHotelPic"];
		NSNumber *HotelListCount = [defaults objectForKey:@"HotelListCount"];
		NSNumber *FlightlistCount = [defaults objectForKey:@"FlightlistCount"];
		NSString *FlightClassType = [defaults objectForKey:@"ClassType"];
		NSString *Password = [defaults objectForKey:@"Password"];
		NSNumber *IsRemAccount = [defaults objectForKey:@"RemAccount"];
		NSNumber *IsRemPassword = [defaults objectForKey:@"RemPassword"];
		NSNumber *isAutoLogin = [defaults objectForKey:AUTO_LOGIN];
        
		if (DepartCity==nil) {
			self.m_departCity=@"北京";
		}else {
			self.m_departCity=DepartCity;
		}
		
		if (FlightClassType==nil) {
			self.m_defaultClassType=@"不限";
		}else {
			self.m_defaultClassType=FlightClassType;
		}
		
		if (DisplayHotelPic==nil) {
			m_displayHotelPic=YES;
		}else {
			m_displayHotelPic=[DisplayHotelPic boolValue];
		}
		if (IsRemAccount==nil) {
			remAccount=NO;
		}else {
			remAccount=[IsRemAccount boolValue];
		}
		if (IsRemPassword==nil) {
			remPassword=NO;
		}else {
			remPassword=[IsRemPassword boolValue];
		}

		if (HotelListCount==nil) {
			m_hotelListCount=25;
		}else {
			m_hotelListCount=[HotelListCount intValue];
		}
		
		if (FlightlistCount==nil) {
			m_flightlistCount=51;
		}else {
			m_flightlistCount=[FlightlistCount intValue];
		}
		
        
        // 用户名密码转存到keychain by dawn 2014.3.24
		if (Account==nil||[Account length]==0) {
            // 本地数据取不到用户名，尝试读取keychain
            Account = [[ElongKeychain sharedInstance] objectForKey:KEYCHAIN_ACCOUNT];
            if (Account == nil) {
                self.m_account=@"";
            }else{
                self.m_account= Account;
            }
		}else {
            // 本地数据可以取到用户名
			self.m_account=Account;
            // 存入keychain
            [[ElongKeychain sharedInstance] setObject:self.m_account forKey:KEYCHAIN_ACCOUNT];
            // 移除本地数据
            [defaults removeObjectForKey:@"Account"];
		}
		
		if (Password==nil||[Password length]==0) {
            // 本地数据取不到密码
            Password = [[ElongKeychain sharedInstance] objectForKey:KEYCHAIN_PASSWORD];
            if (Password == nil) {
                self.m_password = @"";
            }else{
                self.m_password = Password;
            }
		}else {
            // 本地数据可以取到密码
            self.m_password = Password;
            // 存入keychain
            [[ElongKeychain sharedInstance] setObject:self.m_password forKey:KEYCHAIN_PASSWORD];
            // 移除本地数据
            [defaults removeObjectForKey:@"Password"];
		}
		
		if (!isAutoLogin) {
			autoLogin = NO;
		}
		else {
            autoLogin = [isAutoLogin boolValue];
		}

		[defaults synchronize];
		
	}
	return self;
}


@end
