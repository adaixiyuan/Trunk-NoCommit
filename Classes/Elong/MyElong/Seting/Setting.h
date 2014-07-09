//
//  Setting.h
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Setting : NSObject {
	
}


-(void)setDisplayPhotoIn2G:(BOOL)display;
-(BOOL)displayPhotoIn2G;
-(BOOL)displayHotelPic;
-(void)setHotelListCount:(int)count;
-(void)setFlightListCount:(int)count;
-(void)setDisplayHotelPic:(BOOL)display;
-(void)setMapPriority:(BOOL)animated;
-(void)setDepartCity:(NSString *)departCity;
-(void)setAccount:(NSString *)account;
-(void)setClassType:(NSString *)classtype;
-(int)defaultHotelListCount;
-(int)defaultFlightListCount;
-(BOOL)defaultDisplayHotelPic;
-(NSString *)defaultDepartCity;
-(NSString *)defaultAccount;
-(NSString *)defaultClassType;
-(NSString *)defaultPwd;
-(void)setPwd:(NSString *)pwd;
-(BOOL)isRemAccount;
-(BOOL)isRemPassword;
-(BOOL)isAutoLogin;
-(BOOL)getMapPriority;
-(void)setRemAccount:(BOOL)save;
-(void)setRemPassword:(BOOL)save;
-(void)setAutoLogin:(BOOL)animated;
-(void)clearPwd;
@end
