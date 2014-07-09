//
//  JAccount.h
//  ElongClient
//
//  Created by bin xing on 11-1-26.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "LoginRegisterPostManager.h"

@interface JAccount : NSObject {
	NSMutableDictionary *contents;
}

@property (nonatomic, assign) BOOL isSevenDayMember;        // 是否是7天会员

-(void)clearData;
-(void)buildPostData:(NSDictionary *)dictionary;
-(id)init:(NSDictionary *)dictionary;
-(NSString *)cardNo;
-(NSString *)name;
-(NSString *)sex;
-(NSString *)email;
-(NSString *)password;
-(NSString *)phoneNo;
-(NSString *)DragonVIP;

-(void)setName:(NSString *)name;
-(void)setSex:(NSString *)sex;
-(void)setEmail:(NSString *)email;
-(void)setPassword:(NSString *)password;
-(void)setPhoneNo:(NSString *)phoneNo;
-(void)setDragon_VIP:(NSString *)phoneNo;
-(BOOL)isLogin;
-(NSString *)requesString:(BOOL)iscompress;
-(NSDictionary *)contents;
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
